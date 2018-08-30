//
//  MPConstant.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/13.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 版本号
let mp_version: Double = 1.0
/// 保存用户json的URL
let mp_path_url: URL = URL(string: NSHomeDirectory() + "/Documents/userInfo.json")!

/// 垂直space
let mp_vSpace: CGFloat = 10
/// 水平space
let mp_hSpace: CGFloat = 15
/// 无图片高度的图片Cell高度
let mp_noTitlePicH: CGFloat = mp_picW * 0.63
/// 有图片高度的图片Cell高度
var mp_hasTitlePicH: CGFloat {
    return mp_noTitlePicH + 20
}
/// 图片Cell的宽度
let mp_picW: CGFloat = (mp_screenW - 3 * mp_hSpace) * 0.5
/// 屏幕高
let mp_screenH: CGFloat = UIScreen.main.bounds.height
/// 屏幕宽
let mp_screenW: CGFloat = UIScreen.main.bounds.width
