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

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fpsなどを表示する
        sceneView.showsStatistics = true
        // ワールド座標軸を表示する
        sceneView.debugOptions = .showWorldOrigin
        
        // シーンを作る
        let scene = SCNScene()
        sceneView.scene = scene
        // ジオメトリ
        let earth = SCNSphere(radius: 0.2)
        // テクスチャ
        earth.firstMaterial?.diffuse.contents = UIImage(named: "earth_1024")
        // ノード
        let earthNode = SCNNode(geometry: earth)
        // アニメーション
        let action = SCNAction.rotateBy(x: 0, y: .pi*2, z: 0, duration: 10)
        earthNode.runAction(SCNAction.repeatForever(action))
        // 位置決め
        earthNode.position = SCNVector3(0.2, 0.3, -0.2)
        // シーンに追加
        sceneView.scene.rootNode.addChildNode(earthNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // セッションのコンフィグを作る
        let configuration = ARWorldTrackingConfiguration()
        // セッションを開始
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // セッションを停止
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
