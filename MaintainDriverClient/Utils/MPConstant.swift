//
//  MPConstant.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/13.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

typealias MPCallback = (() -> Void)?
typealias MPRequestType = () -> Void

/// 版本号
let mp_version: Double = 1.0
/// 保存用户json的URL
let mp_path_url: URL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/userInfo.json")
/// 登录成功通知
let MP_LOGIN_NOTIFICATION = NSNotification.Name.init("MP_LOGIN_NOTIFICATION")
/// 用户信息修改通知
let MP_USERINFO_UPDATE_NOTIFICATION = NSNotification.Name.init("MP_USERINFO_UPDATE_NOTIFICATION")
/// 启动App刷新Token成功通知
let MP_APP_LAUNCH_REFRESH_TOKEN_NOTIFICATION = NSNotification.Name.init("MP_APP_LAUNCH_REFRESH_TOKEN_NOTIFICATION")
/// 刷新Token成功的通知
let MP_APP_REFRESH_TOKEN_SUCC_NOTIFICATION = NSNotification.Name.init("MP_APP_REFRESH_TOKEN_SUCC_NOTIFICATION")


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
