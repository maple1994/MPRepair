//
//  MPUserModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/29.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

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
    }
    // MARK: - Property
    static let shared = MPUserModel()
    
    var userID: Int = 0
    var userName: String = ""
    var phone: String = ""
    var token: String = "0"
    var expire: String = ""
    var picUrl: String = ""
    var point: Int = 0
    /// 是否过审
    var isPass: Bool = false
    /// 是否登录
    var isLogin: Bool {
        return token != "0"
    }
    fileprivate weak var timer: Timer?
    
    // MARK: - Method
    private init() {
        if readLocalData() {
            
        }else {
            userID = 0
            token = "0"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(MPUserModel.refreshTokenSucc), name: MP_APP_REFRESH_TOKEN_SUCC_NOTIFICATION, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func refreshTokenSucc() {
        startTimer()
        while !MPNetword.requestQueue.isEmpty {
            let block = MPNetword.requestQueue.dequeue()
            block?()
        }
    }
    
    /// 登录成功
    func loginSucc() {
        serilization()
        startTimer()
        NotificationCenter.default.post(name: MP_LOGIN_NOTIFICATION, object: nil)
    }
    
    /// 退出登录
    func loginOut() {
        // 停止定时器
        stopTimer()
        // 清除数据
        removeUserInfo()
        if let slideVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? SlideMenuController {
            slideVC.mainViewController?.dismiss(animated: false, completion: nil)
        }
        // 切换根控制器
        (UIApplication.shared.delegate as? AppDelegate)?.setHomeVCToRootVC(true)
    }
    
    func checkIsExpire(target: MPApiType) -> Bool {
        // MARK: - 不需要判断token枚举在这里添加
        switch target {
        case .login,
            .register,
            .sendCode,
            .resetPwd,
            .getUserAgreement,
            .askOrderCertification,
            .refreshToken:
            return false
        default:
            break
        }
        guard let date = expire.toDate(format: "yyyy-MM-dd HH:mm:ss") else {
            return true
        }
        let today = Date()
        let delta = date.timeIntervalSince(today)
        if delta <= 0 {
            return true
        }
        return false
    }
    
    /// 刷新token
    func refreshToken(succ: MPCallback = nil) {
        MPNetword.requestJson(target: .refreshToken, success: { (json) in
            let data = json["data"] as AnyObject
            if let token = data["token"] as? String,
                let expire = data["expire"] as? String {
                self.token = token
                self.expire = expire
                // 序列化
                self.serilization()
                succ?()
                NotificationCenter.default.post(name: MP_APP_REFRESH_TOKEN_SUCC_NOTIFICATION, object: nil)
            }
        }) { (err) in
//            MPTipsView.showMsg("刷新Token失败")
        }
    }
    
    /// 获取用户数据
    func getUserInfo(succ: (()->Void)?, fail: (()->Void)?) {
        MPNetword.requestJson(target: .getUserInfo, success: { (json) in
            let dic = json["data"] as AnyObject
            guard
                let phone = dic["phone"] as? String,
                let name = dic["name"] as? String,
                let picUrl = dic["pic_url"] as? String,
                let point = dic["point"] as? Int,
                let isPass = dic["is_pass"] as? Bool
                else {
                    fail?()
                    return
            }
            self.phone = phone
            self.userName = name
            self.picUrl = picUrl
            self.point = point
            self.isPass = isPass
            succ?()
        }) { (err) in
            fail?()
        }
    }
}

// MARK: - Timer
extension MPUserModel {
    func startTimer() {
        stopTimer()
        let timer = Timer(timeInterval: 60, target: self, selector: #selector(MPUserModel.refreshAction), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    /// 每分钟都去检测Token的有效期，当token小于10分钟就过期时
    /// 刷新Token
    @objc func refreshAction() {
        guard let date = expire.toDate(format: "yyyy-MM-dd HH:mm:ss") else {
            return
        }
        let today = Date()
        let delta = date.timeIntervalSince(today)
        if delta <= 600 {
            refreshToken()
        }
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
    fileprivate func removeUserInfo() {
        // 清空数据
        userID = 0
        userName = ""
        phone = ""
        token = "0"
        expire = ""
        picUrl = ""
        point = 0
        isPass = false
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
            return true
        }
        return false
    }
}







