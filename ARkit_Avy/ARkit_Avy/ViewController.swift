//
//  ViewController.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/01/22.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var nodes:Array<SCNNode>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self// デリゲートになる
        sceneView.scene = SCNScene()// シーンを作る
        // ワイヤーフレーム、物理ボディシェイプの表示
        sceneView.debugOptions = [.showWireframe, .showPhysicsShapes]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration() // コンフィグを作る
        configuration.planeDetection = [.horizontal, .vertical] // 平面の検出を有効化する（水平面／垂直面）
        sceneView.session.run(configuration)// セッションを開始する
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()// セッションを止める
    }
    
    // シーンビューsceneViewをタップした
    @IBAction func tapSceneView(_ sender: UITapGestureRecognizer) {
        // タップしたARの座標
        let tapLoc = sender.location(in: sceneView)
        // タップ座標のヒットテスト
        let results = sceneView.hitTest(tapLoc, types: .existingPlaneUsingExtent)
        // 検知平面をタップしていたらヒットデータをresultに入れる
        guard let result = results.first else {
            return
        }
        // 検出した平面のアンカーを取得する
        if let anchor = result.anchor as? ARPlaneAnchor {
            // 水平面でない場合は処理をキャンセルする
            if anchor.alignment == .vertical {
                return
            }
        }
        // ノードを作る（物理ボディ）
        let boxNode = PhysicBoxNode()
        let earthNode = PhysicEarthNode()
        let pyramidNode = PhysicPyramidNode()
        let sphereNode = PhysicSphereNode()
        nodes = [boxNode, earthNode, pyramidNode, sphereNode]
        // 追加するノードをランダムに選ぶ
        let index = Int(arc4random())%(nodes.count)
        let node = nodes[index]
        // タップされた座標から位置決めする
        let pos = result.worldTransform.columns.3
        let y = pos.y + 0.2 // 0.2m上から落とす
        node.position = SCNVector3(pos.x, y, pos.z)
        // ノードを追加する
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    // MARK: - ARSCNViewDelegate
    // ノードが追加された
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 平面アンカーではないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        // アンカーが示す位置に平面ノードを追加する（物理ボディ）
        node.addChildNode(PhysicPlaneNode(anchor: planeAnchor))
    }
    
    // ノードが更新された
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 平面アンカーではないときは中断する
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        // PhysicPlaneNodeではないときは中断する
        guard let planeNode = node.childNodes.first as? PhysicPlaneNode else {
            return
        }
        // ノードの位置とサイズを更新する
        planeNode.update(anchor: planeAnchor)
    }
    
    // セッションをリスタートする
    @IBAction func restart(_ sender: Any) {
        // 追加したノードをすべて取り除く
        for node in sceneView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
        // 現在のコンフィグ
        let configuration = sceneView.session.configuration
        // リセット後にセッションを開始する
        let runOptions:ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration!, options: runOptions)
    }
}
