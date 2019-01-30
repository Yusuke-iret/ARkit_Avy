//
//  Ship.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/01/28.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import SceneKit
import ARKit

class BoxNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        // ジオメトリを作る
        //let Plane = SCNPlane(width: 0.1, height: 0.1)
        let box = SCNBox(width: 0.1, height: 0.05, length: 0.1, chamferRadius: 0.01)
        //let Pyramid = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        //let Sphere = SCNSphere(radius: 0.1)
        //let Cylinder = SCNCylinder(radius: 1, height: 1)
        
        // 塗り
        box.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        // ノードのgeometryプロパティに設定する
        geometry = box
    }
}
