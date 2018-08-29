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
}

// https://www.jianshu.com/p/38fbc22a1e2b
/// 网络请求类
let mp_provider = MoyaProvider<MPApiType>(plugins: [MPNetwordActivityPlugin(), NetworkLoggerPlugin(verbose: true)])

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
            return "api/login/register/"
        case .sendCode(phone: _, type: _):
            return "api/login/message/"
        case .resetPwd(phone: _, pwd: _, code: _):
            return "api/login/reset_driver/"
        case .refreshToken:
            return "api/login/refresh/"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .refreshToken:
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
        case .login(let phone, let pwd):
            let param: [String: String] = [
                "phone": phone,
                "password": pwd
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .register(let phone, let pwd, let code):
            let param: [String: String] = [
                "phone": phone,
                "password": pwd,
                "message": code
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .sendCode(let phone, let type):
            let param: [String: String] = [
                "phone": phone,
                "type": type
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .resetPwd(let phone, let pwd, let code):
            let param: [String: String] = [
                "phone": phone,
                "password": pwd,
                "message": code
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        default:
            return .requestPlain
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
}


/// 短信验证码的类型
struct MPMsgCodeKey {
    /// 司机注册
    static let register_driver = "register_driver"
    /// 司机重置密码
    static let reset_driver = "reset_driver"
}




