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

// MARK: - 通知
/// 登录成功通知
let MP_LOGIN_NOTIFICATION = NSNotification.Name.init("MP_LOGIN_NOTIFICATION")
/// 用户信息修改通知
let MP_USERINFO_UPDATE_NOTIFICATION = NSNotification.Name.init("MP_USERINFO_UPDATE_NOTIFICATION")
/// 启动App刷新Token成功通知
let MP_APP_LAUNCH_REFRESH_TOKEN_NOTIFICATION = NSNotification.Name.init("MP_APP_LAUNCH_REFRESH_TOKEN_NOTIFICATION")
/// 刷新Token成功的通知
let MP_APP_REFRESH_TOKEN_SUCC_NOTIFICATION = NSNotification.Name.init("MP_APP_REFRESH_TOKEN_SUCC_NOTIFICATION")
/// 抢单成功的通知
let MP_STEAL_ORDER_SUCC_NOTIFICATION = NSNotification.Name.init("MP_STEAL_ORDER_SUCC_NOTIFICATION")

// MARK: - 提交图片的类别名称信息
/// 取车图片-检车确认
var get_confirm = "取车图片-检车确认"
/// 取车图片-车身拍照
var get_car = "取车图片-车身拍照"
/// 年检已过-上传照片
var survey_upload = "年检已过-上传照片"
/// 还车图片-检车确认
var return_confirm = "还车图片-检车确认"
/// 还车图片-车身拍照
var return_car = "还车图片-车身拍照"











