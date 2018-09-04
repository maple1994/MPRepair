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
    /// finish: 0表示所有，1表示未完成，2表示已完成, 当type=driver的时候必填
    case checkOrderList(type: String, finish: Int)
    /// 抢单
    case grab(id: Int)
    /// 取消订单
    case cancelOrder(id: Int)
    /// 确认取车
    case quChe(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?)
    /// 开始年检
    case startYearCheck(id: Int)
    /// 年检已过
    case yearCheckSucc(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?)
    /// 年检未过
    case yearCheckFail(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?)
    /// 到达还车
    case arriveHuanChe(id: Int)
    /// 确认还车
    case confirmReturn(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?)
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
        case .checkOrderList(type: _, finish: _):
            return "api/driver/order/"
        case .grab(id: _):
            return "api/driver/order_grab/"
        case .cancelOrder(id: _):
            return "api/driver/order_cancel/"
        case .quChe(id: _, number: _, picArr: _, typeArr: _, note: _):
            return "api/driver/order_get/"
        case .startYearCheck(id: _):
            return "api/driver/order_survey/"
        case .yearCheckSucc:
            return "api/driver/order_success/"
        case .yearCheckFail(id: _, number: _, picArr: _, typeArr: _, note: _):
            return "api/driver/order_fail/"
        case .arriveHuanChe(id: _):
            return "api/driver/order_arrive/"
        case .confirmReturn(id: _, number: _, picArr: _, typeArr: _, note: _):
            return "api/driver/order_return/"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .refreshToken,
             .getUserInfo,
            .getAccountInfo,
            .checkOrderList(type: _, finish: _):
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
                if let base64 = pic1.base64 {
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
        case let .checkOrderList(type, finish):
            var param = defaultParam
            param["type"] = type
            if type == "driver" {
                param["finish"] = finish
            }
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .grab(id):
            var param = defaultParam
            param["id"] = id
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .cancelOrder(id):
            var param = defaultParam
            param["id"] = id
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .quChe(id, number, picArr, typeArr, note):
            var param = defaultParam
            param["id"] = id
            param["number"] = number
            if let arr1 = picArr {
                for (index, img) in arr1.enumerated() {
                    if let base = img.base64 {
                        param["pic\(index + 1)"] = base
                    }
                }
            }
            if let arr1 = typeArr {
                for (index, type) in arr1.enumerated() {
                    param["type\(index + 1)"] = type
                }
            }
            if let arr1 = note {
                for (index, note1) in arr1.enumerated() {
                    param["note\(index + 1)"] = note1
                }
            }
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .startYearCheck(id):
            var param = defaultParam
            param["id"] = id
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .yearCheckSucc(id, number, picArr, typeArr, note):
            var param = defaultParam
            param["id"] = id
            param["number"] = number
            if let arr1 = picArr {
                for (index, img) in arr1.enumerated() {
                    if let base = img.base64 {
                        param["pic\(index + 1)"] = base
                    }
                }
            }
            if let arr1 = typeArr {
                for (index, type) in arr1.enumerated() {
                    param["type\(index + 1)"] = type
                }
            }
            if let arr1 = note {
                for (index, note1) in arr1.enumerated() {
                    param["note\(index + 1)"] = note1
                }
            }
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .yearCheckFail(id, number, picArr, typeArr, note):
            var param = defaultParam
            param["id"] = id
            param["number"] = number
            if let arr1 = picArr {
                for (index, img) in arr1.enumerated() {
                    if let base = img.base64 {
                        param["pic\(index + 1)"] = base
                    }
                }
            }
            if let arr1 = typeArr {
                for (index, type) in arr1.enumerated() {
                    param["type\(index + 1)"] = type
                }
            }
            if let arr1 = note {
                for (index, note1) in arr1.enumerated() {
                    param["note\(index + 1)"] = note1
                }
            }
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .arriveHuanChe(id):
            var param = defaultParam
            param["id"] = id
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .confirmReturn(id, number, picArr, typeArr, note):
            var param = defaultParam
            param["id"] = id
            param["number"] = number
            if let arr1 = picArr {
                for (index, img) in arr1.enumerated() {
                    if let base = img.base64 {
                        param["pic\(index + 1)"] = base
                    }
                }
            }
            if let arr1 = typeArr {
                for (index, type) in arr1.enumerated() {
                    param["type\(index + 1)"] = type
                }
            }
            if let arr1 = note {
                for (index, note1) in arr1.enumerated() {
                    param["note\(index + 1)"] = note1
                }
            }
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
    static let provider = MoyaProvider<MPApiType>(plugins: [MPNetwordActivityPlugin(), NetworkLoggerPlugin(verbose: true)])
    /// 请求队列，当token过期时，请求入队
    static var requestQueue: Queue<MPRequestType> = Queue<MPRequestType>()
    
    /// 发送网络请求
    static func requestJson(
        target: MPApiType,
        success: ((AnyObject) -> Void)?,
        failure: ((MoyaError) -> Void)? = nil
        ) {
        func request(target: MPApiType,
                     success: ((AnyObject) -> Void)?,
                     failure: ((MoyaError) -> Void)? = nil) {
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
        if MPUserModel.shared.checkIsExpire(target: target) {
            MPPrint("\(target)-Token过期")
            requestQueue.enqueue {
                request(target: target, success: success, failure: failure)
            }
            return
        }
        request(target: target, success: success, failure: failure)
    }
    
    static func requestResponse(
        target: MPApiType,
        success: ((Response) -> Void)?,
        failure: ((MoyaError) -> Void)? = nil
        ) {
        func request(target: MPApiType,
                     success: ((Response) -> Void)?,
                     failure: ((MoyaError) -> Void)? = nil) {
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
        if MPUserModel.shared.checkIsExpire(target: target) {
            MPPrint("Token过期")
            requestQueue.enqueue {
                request(target: target, success: success, failure: failure)
            }
            return
        }
        request(target: target, success: success, failure: failure)
    }
}

struct Queue<Element> {
    
    private var elements: [Element] = []
    
    init() { }
    
    // MARK: - Getters
    
    var count: Int {
        return elements.count
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var peek: Element? {
        return elements.first
    }
    
    // MARK: - Enqueue & Dequeue
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    @discardableResult
    mutating func dequeue() -> Element? {
        return isEmpty ? nil : elements.removeFirst()
    }
    
    mutating func removeAll() {
        elements.removeAll()
    }
}




