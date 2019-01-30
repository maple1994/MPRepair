//
//  MPUserModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/29.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum MPProfileState: Int, Codable {
    /// 未提交
    case unsubmit = 0
    /// 正在审核
    case checking = 1
    /// 审核成功
    case checkSucc = 2
    /// 审核失败
    case checkFailed = 3
}

enum MPQuestionnaireState: Int, Codable {
    /// 未考试
    case unsubmit = 0
    /// 考试通过
    case pass = 1
    /// 考试不通过
    case failed = 2
}

enum MPInsuranceState: Int, Codable {
    /// 未购买
    case unpay = 0
    /// 处理中
    case handling = 1
    /// 已购买
    case payed = 2
    /// 快过期
    case willExpire = 3
    /// 过期
    case expired = 4
}


/// 用户模型
class MPUserModel: Codable {
    // 只对以下属性执行序列化
    enum CodingKeys: String, CodingKey {
        case userID
        case userName
        case phone
        case token
        case expire
        case picUrl
        case point
        case isPass
        case score
        case is_driverinfo
        case is_question
        case is_insurance
        case insurance_time
    }
    // MARK: - Property
    static let shared = MPUserModel()
    /// 用户ID
    var userID: Int = 0
    /// 用户名
    var userName: String = ""
    /// 手机号码
    var phone: String = ""
    /// token
    var token: String = "0"
    /// 过期时间字符串
    var expire: String = ""
    /// 头像url
    var picUrl: String = ""
    /// 积分
    var point: Int = 0
    /// 是否过审
    var isPass: Bool = false
    /// 司机评分
    var score: Int = 0
    /// 是否填写了司机信息 0：未提交，1：正在审核，2：审核成功，3：审核失败
    var is_driverinfo: MPProfileState = MPProfileState.unsubmit
    /// 0：未考试，1：考试通过，2：考试不通过
    var is_question: MPQuestionnaireState = MPQuestionnaireState.unsubmit
    /// 0：未购买，1：处理中，2：已购买，3：快过期 4：过期
    var is_insurance: MPInsuranceState = MPInsuranceState.unpay
    /// 保险到期时间
    var insurance_time: String = ""
    /// 是否登录
    var isLogin: Bool {
        return token != "0"
    }
    /// 账户余额
    var balance: Double?
    
    // MARK: - Method
    private init() {
        if readLocalData() {
            
        }else {
            userID = 0
            token = "0"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func refreshTokenSucc() {
        MPOrderSocketManager.shared.reconnect()
        MPListenSocketManager.shared.reconnect()
    }
    
    /// 刷新用户信息
    func refreshUserInfo() {
        if !isLogin {
            return
        }
        getUserInfo(succ: {
            /// 序列化
            self.serilization()
        }) {
            
        }
    }
    
    /// 登录成功
    func loginSucc() {
        serilization()
        NotificationCenter.default.post(name: MP_LOGIN_NOTIFICATION, object: nil)
    }
    
    /// 退出登录
    func loginOut() {
        // 断开链接
        MPListenSocketManager.shared.disconnet()
        MPOrderSocketManager.shared.disconnet()
        // 清除数据
        removeUserInfo()
        if let slideVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? SlideMenuController {
            slideVC.mainViewController?.dismiss(animated: false, completion: nil)
        }
        // 切换根控制器
        (UIApplication.shared.delegate as? AppDelegate)?.setHomeVCToRootVC(true)
    }
    
    /// 刷新token
    func refreshToken(succ: MPCallback = nil) {
        if !isLogin {
            return 
        }
        MPNetword.requestJson(target: .refreshToken, success: { (json) in
            let data = json["data"] as AnyObject
            if let token = data["token"] as? String,
                let expire = data["expire"] as? String {
                self.token = token
                self.expire = expire
                // 序列化
                self.serilization()
                succ?()
            }
        }) { (err) in
        }
    }
    
    /// 获取用户数据
    func getUserInfo(succ: (()->Void)?, fail: (()->Void)?) {
        MPNetword.requestJson(target: .getUserInfo, success: { (json) in
            let dic = json["data"] as? [String: Any]
            guard
                let phone = dic?["phone"] as? String,
                let name = dic?["name"] as? String,
                let picUrl = dic?["pic_url"] as? String,
                let point = dic?["point"] as? Int,
                let isPass = dic?["is_pass"] as? Bool,
                let score = dic?["score"] as? Int
                else {
                    fail?()
                    return
            }
            // 保存刷新时间
            let now: Int = (Int)(Date().timeIntervalSinceReferenceDate)
            UserDefaults.standard.set(now, forKey: "MP_USER_REFRESH_TIME")
            self.phone = phone
            self.userName = name
            self.picUrl = picUrl
            self.point = point
            self.isPass = isPass
            let rawValue = toInt(dic?["is_driverinfo"])
            self.is_driverinfo = MPProfileState(rawValue: rawValue) ?? MPProfileState.unsubmit
            let rawValue2 = toInt(dic?["is_question"])
            let rawValue3 = toInt(dic?["is_insurance"])
            self.is_question = MPQuestionnaireState(rawValue: rawValue2) ?? MPQuestionnaireState.unsubmit
            self.is_insurance = MPInsuranceState(rawValue: rawValue3) ?? MPInsuranceState.unpay
            self.insurance_time = toString(dic?["insurance_time"])
            self.score = score
            succ?()
        }) { (err) in
            fail?()
        }
    }
    
    /// 设置用户评分的显示
    fileprivate func setupStartView() {
        guard let leftVC = UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController else {
            return
        }
        guard let menuVC = leftVC.leftViewController as? MPLeftMenuViewController else {
            return
        }
        menuVC.setupStartView(score)
    }
}

// MARK: - IO
extension MPUserModel {
    /// 序列化
    func serilization() {
        if let data = self.toJSONString()?.data(using: .utf8) {
            do {
                try data.write(to: mp_path_url)
            }catch {
                MPPrint("写入失败")
            }
        }
    }
    
    /// 清除数据
    func removeUserInfo() {
        // 清空数据
        userID = 0
        userName = ""
        phone = ""
        token = "0"
        expire = ""
        picUrl = ""
        point = 0
        isPass = false
        score = 0
        is_driverinfo = .unsubmit
        is_question = .unsubmit
        is_insurance = .unpay
        insurance_time = ""
        do {
            try FileManager.default.removeItem(at: mp_path_url)
        }catch {
            MPPrint("文件不存在")
        }
    }
    
    /// 读取本地用户数据
    fileprivate func readLocalData() -> Bool {
        guard let data = try? Data.init(contentsOf: mp_path_url) else {
            return false
        }
        guard let jsonStr = String.init(data: data, encoding: .utf8) else {
            return false
        }
        if let model: MPUserModel = MPUserModel.deserialize(from: jsonStr) {
            userID = model.userID
            userName = model.userName
            phone = model.phone
            token = model.token
            expire = model.expire
            picUrl = model.picUrl
            point = model.point
            isPass = model.isPass
            is_driverinfo = model.is_driverinfo
            score = model.score
            is_question = model.is_question
            is_insurance = model.is_insurance
            insurance_time = model.insurance_time
            return true
        }
        return false
    }
}







