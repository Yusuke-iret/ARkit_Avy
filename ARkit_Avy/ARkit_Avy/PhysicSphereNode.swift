//
//  PhysicSphereNode.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/01/29.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import SceneKit
import ARKit

class PhysicSphereNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        // ジオメトリを作る
        let sphere = SCNSphere(radius: 0.1)
        // 塗り
        sphere.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.8)
        // ノードのgeometryプロパティに設定する
        geometry = sphere
        // 物理ボディを設定する
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: bodyShape)
        physicsBody?.friction = 2.0  // 摩擦
        physicsBody?.restitution = 0.2  // 反発力
        // 衝突する相手を決める（CategoryはCategory.swiftで定義している）
        physicsBody?.categoryBitMask = Category.boxCategory  // 自身のカテゴリ
        physicsBody?.collisionBitMask = Category.all // 衝突相手
    }
}
