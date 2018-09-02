//
//  MPApiManager.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/10.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Moya
import Result
import SwiftHash

enum MPApiType {
    /// 注册
    case login(phone: String, pwd: String)
    /// 注册，手机电话，密码，验证码
    case register(phone: String, pwd: String, code: String)
    /// 发送验证码
    /// 司机端注册-MPMsgCodeKey.register_driver
    /// 司机端重置密码-MPMsgCodeKey.reset_driver
    case sendCode(phone: String, type: String)
    /// 重置密码，手机电话，密码，验证码
    case resetPwd(phone: String, pwd: String, code: String)
    /// 刷新token
    case refreshToken
    /// 查询用户数据
    case getUserInfo
    /// 修改用户信息
    case updateUserInfo(name: String?, pic: UIImage?)
    /// 获取账户明细信息
    case getAccountInfo
    /// 明细操作信息-提现 via- alipay, weixin
    case tiXian(money: Double, via: String)
    /// 查询订单列表信息，type-order：可以接的单，driver：已接订单
    case checkOrderList(type: String)
}

// https://www.jianshu.com/p/38fbc22a1e2b
extension MPApiType: TargetType {
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "http://www.nolasthope.cn/")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .login(phone: _, pwd: _):
            return "api/login/login/"
        case .register(phone: _, pwd: _, code: _):
            return "api/login/register_driver/"
        case .sendCode(phone: _, type: _):
            return "api/login/message/"
        case .resetPwd(phone: _, pwd: _, code: _):
            return "api/login/reset_driver/"
        case .refreshToken:
            return "api/login/refresh/"
        case .getUserInfo:
            return "api/user/user/"
        case .updateUserInfo(name: _, pic: _):
            return "api/user/user/"
        case .getAccountInfo, .tiXian(money: _, via: _):
            return "api/driver/account/"
        case .checkOrderList(type: _):
            return "api/driver/order/"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .refreshToken,
             .getUserInfo,
            .getAccountInfo,
            .checkOrderList(type: _):
            return .get
        default:
            return .post
        }
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    /// 请求任务事件（这里附带上参数）
    var task: Task {
        switch self {
        case let .login(phone, pwd):
            let param: [String: String] = [
                "phone": phone,
                "password": pwd
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .register(phone, pwd, code):
            let param: [String: String] = [
                "phone": phone,
                "password": pwd,
                "message": code
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .sendCode(phone, type):
            let param: [String: String] = [
                "phone": phone,
                "type": type
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .resetPwd(phone, pwd, code):
            let param: [String: String] = [
                "phone": phone,
                "password": pwd,
                "message": code
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .getUserInfo:
            var param = defaultParam
            param["id"] = MPUserModel.shared.userID
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .refreshToken:
            return .requestParameters(parameters: defaultParam, encoding: URLEncoding.default)
        case let .updateUserInfo(name, pic):
            var param = defaultParam
            param["id"] = MPUserModel.shared.userID
            param["phone"] = MPUserModel.shared.phone
            if let name1 = name {
                param["name"] = name1
            }
            if let pic1 = pic {
                if let base64 = UIImageJPEGRepresentation(pic1, 1)?.base64EncodedString(){
                    param["pic"] = base64
                }
            }
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .getAccountInfo:
            return .requestParameters(parameters: defaultParam, encoding: URLEncoding.default)
        case let .tiXian(money, via):
            var param = defaultParam
            param["money"] = money
            param["via"] = via
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .checkOrderList(type):
            var param = defaultParam
            param["type"] = type
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
//        default:
//            return .requestPlain
        }
    }
    
    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        return .none
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? {
        return nil
    }
    
    var defaultParam: [String: Any] {
        let stamp: String = "\(Date().timeIntervalSince1970)"
        let sign: String = MD5(MPUserModel.shared.token + stamp)
        if MPUserModel.shared.userID != 0 &&
            MPUserModel.shared.token != "0" {
            let param: [String: Any] = [
                "user_id": MPUserModel.shared.userID,
                "timestamp": stamp,
                "sign": sign,
                "system": "ios",
                "version": mp_version
            ]
            return param
        }else {
            return [String: Any]()
        }
    }
}


/// 短信验证码的类型
struct MPMsgCodeKey {
    /// 司机注册
    static let register_driver = "register_driver"
    /// 司机重置密码
    static let reset_driver = "reset_driver"
}

/// 网络请求工具
struct MPNetword {
    // 单例
    static let provider = MoyaProvider<MPApiType>(plugins: [MPNetwordActivityPlugin(), NetworkLoggerPlugin(verbose: true)])
    
    /// 发送网络请求
    static func requestJson(
        target: MPApiType,
        success: ((AnyObject) -> Void)?,
        failure: ((MoyaError) -> Void)? = nil
        ) {
        if MPUserModel.shared.checkIsExpire(target: target) {
            MPPrint("Token过期")
            return
        }
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let json = try moyaResponse.mapJSON() as AnyObject
                    if let code = json["code"] as? Int {
                        if code == 100 {
                            success?(json)
                        }
                    }
                } catch {
                    failure?(MoyaError.jsonMapping(moyaResponse))
                }
            case let .failure(error):
                failure?(error)
            }
        }
    }
    
    static func requestResponse(
        target: MPApiType,
        success: ((Response) -> Void)?,
        failure: ((MoyaError) -> Void)? = nil
        ) {
        if MPUserModel.shared.checkIsExpire(target: target) {
            MPPrint("Token过期")
            return
        }
        provider.request(target) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let json = try moyaResponse.mapJSON() as AnyObject
                    if let code = json["code"] as? Int {
                        if code == 100 {
                            success?(moyaResponse)
                        }
                    }
                } catch {
                    failure?(MoyaError.jsonMapping(moyaResponse))
                }
            case let .failure(error):
                failure?(error)
            }
        }
    }
}




