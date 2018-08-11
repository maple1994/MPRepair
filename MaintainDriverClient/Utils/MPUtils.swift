//
//  MPUtils.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 无图片高度的图片Cell高度
let mp_noTitlePicH: CGFloat = 130

/// 工具类
class MPUtils {
    static let screenH: CGFloat = UIScreen.main.bounds.height
    static let screenW: CGFloat = UIScreen.main.bounds.width
    
    class func createLine(_ lineColor: UIColor = UIColor.colorWithHexString("#E0E0E0")) -> UIView {
        let line = UIView()
        line.backgroundColor = lineColor
        return line
    }
}



