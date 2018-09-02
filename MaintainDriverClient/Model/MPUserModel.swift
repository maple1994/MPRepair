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
    var userIcon: UIImage {
        if let icon = _userIcon {
            return icon
        }
        return #imageLiteral(resourceName: "person")
    }
    var _userIcon: UIImage?
    
    // MARK: - Method
    private init() {
        if readLocalData() {
            
        }else {
            userID = 0
            token = "0"
        }
    }
    
    /// 登录成功
    func loginSucc() {
        serilization()
        NotificationCenter.default.post(name: MP_LOGIN_NOTIFICATION, object: nil)
    }
    
    /// 退出登录
    func loginOut() {
        // 清除数据
        removeUserInfo()
        if let slideVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? SlideMenuController {
            slideVC.mainViewController?.dismiss(animated: false, completion: nil)
        }
        // 切换根控制器
        (UIApplication.shared.delegate as? AppDelegate)?.setHomeVCToRootVC(true)
    }
    
    /// 刷新token
    func refreshToken() {
        MPNetword.requestJson(target: .refreshToken, success: { (json) in
            let data = json["data"] as AnyObject
            if let token = data["token"] as? String,
                let expire = data["expire"] as? String {
                self.token = token
                self.expire = expire
                // 序列化
                self.serilization()
            }
        }) { (err) in
            // TODO: - 刷新Token失败
            MPTipsView.showMsg("刷新Token失败")
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

// MARK: - IO
extension MPUserModel {
    /// 序列化
    fileprivate func serilization() {
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
        _userIcon = nil
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







