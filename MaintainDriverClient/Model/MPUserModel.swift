//
//  MPUserModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/29.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 用户模型
class MPUserModel: Codable {
    // MARK: - Property
    static let shared = MPUserModel()
    
    var userID: Int = 0
    var userName: String = ""
    var phone: String = ""
    var token: String = ""
    var expire: String = ""
    var picUrl: String = ""
    var point: Int = 0
    /// 是否过审
    var isPass: Bool = false
    /// 是否登录
    var isLogin: Bool {
        return token != "0"
    }
    
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
    }
    
    /// 退出登录
    func loginOut() {
        // TODO: - 注销
    }
    
    /// 序列化
    fileprivate func serilization() {
        if let data = self.toJSONString()?.data(using: .utf8) {
            do {
                try data.write(to: mp_path_url)
            }catch {
                print("写入失败")
            }
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







