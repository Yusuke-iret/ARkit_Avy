//
//  PhysicEarthNode.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/01/29.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import SceneKit
import ARKit

class PhysicEarthNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        // ジオメトリを作る
        let earth = SCNSphere(radius: 0.05) // 球体
        // テクスチャ
        earth.firstMaterial?.diffuse.contents = UIImage(named: "earth_1024") // 衛星写真
        // ノードのgeometryプロパティに設定する
        geometry = earth
        // 物理ボディを設定する
        let bodyShape = SCNPhysicsShape(geometry: geometry!, options: [:])
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: bodyShape)
        physicsBody?.friction = 1.0 // 摩擦
        physicsBody?.rollingFriction = 1.0  // 回転時の摩擦
        physicsBody?.restitution = 0.5  // 反発力
        // 衝突する相手を決める（CategoryはCategory.swiftで定義している）
        physicsBody?.categoryBitMask = Category.earthCategory  // 自身のカテゴリ
        physicsBody?.collisionBitMask = Category.all // 衝突相手
    }
}
