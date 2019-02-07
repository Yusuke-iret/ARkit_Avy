//
//  Category.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/01/30.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

// 衝突カテゴリ
struct Category {
    static let planeCategory = 0b1
    static let boxCategory =  0b10
    static let earthCategory =  0b100
    static let pyramidCatgory = 0b1000
    static let sphereCatgory = 0b10000
    static let all = 0b111
}
