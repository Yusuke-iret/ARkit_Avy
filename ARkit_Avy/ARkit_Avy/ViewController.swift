//
//  ViewController.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/04.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity  // マルチピアコネクトセッションを利用するために必要

class ViewController: UIViewController, ARSCNViewDelegate {
    
    // 利用できるノードクラス
    static let models = [ "Cone":ConeNode.self, "Torus":TorusNode.self, "Pyramid":PyramidNode.self, "Box":BoxNode.self]
    static let modelNames =  Array(models.keys)
    // 乱数でmodelsのキーを選ぶ
    static var modelName:String {
        let index = Int(arc4random_uniform(UInt32(modelNames.count)))
        return modelNames[index]
    }
    // プロパティ
    let myPeerID = MCPeerID(displayName: UIDevice.current.name) // 自分のピアID
    var myModel = ViewController.modelName // 乱数で決める
    var mapProvider: MCPeerID? // マップの送信者
    let serviceType = "ar-multi-sample"
    var mcSession: MCSession!
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    var serviceBrowser: MCNearbyServiceBrowser!

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var myHostName: UILabel!
    @IBOutlet weak var mappingStatusLabel: UILabel!
    @IBOutlet weak var sendMapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートになる
        sceneView.delegate = self  // ARSCNViewDelegateのデリゲート
        sceneView.session.delegate = self // ARSessionDelegateのデリゲート
        // シーンを作る
        sceneView.scene = SCNScene()
        sceneView.debugOptions = .showWireframe
        // 角丸ビューにする
        sessionInfoView.layer.cornerRadius = 5.0
        sessionInfoView.layer.masksToBounds = true
        // 角丸ボタンにする
        sendMapButton.layer.cornerRadius = 10.0
        sendMapButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // セッションコンフィグの設定と開始
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
        // マルチピアセットアップ
        multipeerSetup()
    }
    
    // マルチピアコネクトセッションのセットアップとスタート
    func multipeerSetup( ) {
        myHostName.text = myPeerID.displayName // 自分のピアID名をラベルに表示しておく
        // MCSession（Multipeer Connect Session）
        mcSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self // デリゲートになる
        
        // MCNearbyServiceAdvertiser
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: self.serviceType)
        serviceAdvertiser.delegate = self // デリゲートになる
        serviceAdvertiser.startAdvertisingPeer() // セッション相手募集の告知スタート
        
        // MCNearbyServiceBrowser
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: self.serviceType)
        serviceBrowser.delegate = self // デリゲートになる
        serviceBrowser.startBrowsingForPeers()  // 招待や退席の見張りスタート
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // 画面タップでアンカーを追加する
    @IBAction func tapSceneView(_ sender: UITapGestureRecognizer) {
        // 検知平面とタップ座標のヒットテスト
        let results = sceneView.hitTest(sender.location(in: sceneView),
                                        types: [.existingPlaneUsingExtent])
        // 検知平面をタップしていたら最前面のヒットデータをresultに入れる
        guard let result = results.first else { return }
        let tf = result.worldTransform // ヒットした地点のワールドトランスフォーム
        // アンカーを追加する
        let anchor = ARAnchor(name: myModel, transform: tf)
        sceneView.session.add(anchor: anchor)
        // 追加したアンカーをマップにアーカイブする
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true)
            else { print("エンコードできないアンカー"); return}
        self.sendToAllPeers(data)
    }
    
    // アンカーが追加されたらコンテンツを追加する（平面検知、画面タップで追加、マップ構築で追加）
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 検知平面を可視化する平面ノードを追加する
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node.addChildNode(PlaneNode(anchor: planeAnchor))
            return
        }
        // 追加されたアンカーのnameに入れて置いたキーを取り出す
        if let key = anchor.name, let nodeClass = ViewController.models[key]{
            // ノードクラスからノードを作る
            node.addChildNode(nodeClass.init())
        }
    }
    
    // ノードが更新された
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return  } // 平面アンカーではないときは中断
        guard let planeNode = node.childNodes.first as? PlaneNode else { return  } // PlaneNodeではないときは中断
        planeNode.update(anchor: planeAnchor) // 平面ノードの位置とサイズを更新する
    }
    
    // ワールドマップをアーカイブする
    @IBAction func shareSession(_ button: UIButton) {
        // 現在のワールドマップを取得する
        sceneView.session.getCurrentWorldMap { worldMap, error in
            // マップ
            guard let map = worldMap
                else { print("WorldMap Error"); return }
            // データをアーカイブする
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("エンコードできないマップ") }
            // アーカイブデータを配信する
            self.sendToAllPeers(data)
        }
    }
    
    // マップデータを配信する
    func sendToAllPeers(_ data: Data) {
        do {
            try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
            print("データ配信エラー") // tryが失敗したときに実行される
        }
    }
}
