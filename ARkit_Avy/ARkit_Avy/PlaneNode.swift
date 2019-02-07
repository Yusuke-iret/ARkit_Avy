//
//  PlaneNode.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/04.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import SceneKit
import ARKit

class PlaneNode: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        // 平面のジオメトリを作る
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        // 緑で塗りは半透明（ワイヤーフレームはsceneViewで設定、白色）
        plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.2)
        plane.widthSegmentCount = 10
        plane.heightSegmentCount = 10
        // ノードのgeometryプロパティに設定する
        geometry = plane
        //オクルージュ
        self.renderingOrder = -1
        
        // 向きはX軸回りで90度回転
        rotation = SCNVector4(1, 0, 0, -0.5 * Float.pi)
        // 位置決めする
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
    
    // 位置とサイズを更新する
    func update(anchor: ARPlaneAnchor) {
        // ダウンキャストする
        let plane = geometry as! SCNPlane
        // アンカーから平面の幅、高さを更新する
        plane.width = CGFloat(anchor.extent.x)
        plane.height = CGFloat(anchor.extent.z)
        // 座標を更新する
        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
}
