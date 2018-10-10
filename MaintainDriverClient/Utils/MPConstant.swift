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
/// 阿里SDK PID
let aliPID = "2088131567240416"
/// 阿里SDK AppID
let aliAppID = "2018090661231519"
/// 版本号
let mp_version: Double = 1.0
/// 保存用户json的URL
let mp_path_url: URL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/userInfo.json")
/// 存取用户账号的Key
let MP_USER_ACCOUNT_KEY = "MP_USER_ACCOUNT_KEY"
/// 存取用户密码的Key
let MP_USER_PWD_KEY = "MP_USER_PWD_KEY"
/// 存取支付宝账号的Key
let MP_ALIPAY_ACCOUNT_KEY = "MP_ALIPAY_ACCOUNT_KEY"

// MARK: - 布局常量
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
/// 刷新订单列表的通知
let MP_refresh_ORDER_LIST_SUCC_NOTIFICATION = NSNotification.Name.init("MP_refresh_ORDER_LIST_SUCC_NOTIFICATION")
/// 授权回调通知
let MP_ALIPAY_RESULT_NOTIFICATION = NSNotification.Name.init("MP_ALIPAY_RESULT_NOTIFICATION")
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











