//
//  NodeMaker.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/04.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import SceneKit
import ARKit

// コーン
class ConeNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        let cone = SCNCone(topRadius: 0.02, bottomRadius: 0.05, height: 0.05)
        cone.firstMaterial?.diffuse.contents = UIColor.lightGray // 塗り
        geometry = cone
        let h = self.boundingBox.max.y
        self.position = SCNVector3(0, h/2.0, 0)
    }
}
// ドーナツ
class TorusNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        let torus = SCNTorus(ringRadius: 0.05, pipeRadius: 0.02)
        torus.firstMaterial?.diffuse.contents = UIColor.blue // 塗り
        geometry = torus
        let h = self.boundingBox.max.y
        self.position = SCNVector3(0, h/2.0, 0)
    }
}
// 三角すい
class PyramidNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        let pyramid = SCNPyramid(width: 0.05, height: 0.05, length: 0.05)
        pyramid.firstMaterial?.diffuse.contents = UIColor.orange // 塗り
        geometry = pyramid
        let h = self.boundingBox.max.y
        self.position = SCNVector3(0, h/2.0, 0)
    }
}

// 箱
class BoxNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.brown // 塗り
        geometry = box
        let h = self.boundingBox.max.y
        self.position = SCNVector3(0, h/2.0, 0)
    }
}
