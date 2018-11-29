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
    /// 获取账户明细信息 0-提现，1：收入
    case getAccountInfo(method: Int)
    /// 明细操作信息-提现 via- alipay, weixin
    case tiXian(money: Double, via: String, aliAccunt: String, aliUserName: String)
    /// 查询订单列表信息，type-order：可以接的单，driver：已接订单
    /// finish: 0表示所有，1表示未完成，2表示已完成, 当type=driver的时候必填
    case getOrderList(type: String, finish: Int)
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
    case yearCheckFail(id: Int, number: Int, image1: UIImage, note1: String, number_item: Int, itemIDArr: [Int], priceArr: [Double])
    /// 到达还车
    case arriveHuanChe(id: Int)
    /// 确认还车
    case confirmReturn(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?)
    /// 查询订单信息
    case getOrderInfo(id: Int)
    /// 查询提交图片的类别名称信息
    case getPicName
    /// 查询年检检查项信息
    case getYearCheckItemInfo
    /// 获取用户协议链接
    case getUserAgreement
    /// 查询资格信息
    case getOrderCertification
    /// 进行资格认证
    case askOrderCertification
    /// 查询绑定的支付宝账号
    case getAlipayBindedAccount
    /// 获取绑定的支付宝账号信息
    case getAlipayBindedAccountInfo
    /// 修改绑定的支付宝账号
    case updateAlipayAccount(alipayID: String, authCode: String)
    /// 查询余额
    case getBalance
    /// 司机扣费标准
    case getDriverCancelRuler
    /// 完善司机资料
    case completeDriverInfo(name: String, idCard: String, pic_idcard_front: UIImage, pic_idcard_back: UIImage, pic_driver: UIImage, pic_user: UIImage, pic_drive_front: UIImage, pic_drive_back:  UIImage)
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
        case .login:
            return "api/login/login/"
        case .register:
            return "api/login/register_driver/"
        case .sendCode:
            return "api/login/message/"
        case .resetPwd:
            return "api/login/reset_driver/"
        case .refreshToken:
            return "api/login/refresh/"
        case .getUserInfo:
            return "api/user/user/"
        case .updateUserInfo:
            return "api/user/user/"
        case .getAccountInfo, .tiXian:
            return "api/driver/account/"
        case .getOrderList, .getOrderInfo:
            return "api/driver/order/"
        case .grab:
            return "api/driver/order_grab/"
        case .cancelOrder:
            return "api/driver/order_cancel/"
        case .quChe:
            return "api/driver/order_get/"
        case .startYearCheck:
            return "api/driver/order_survey/"
        case .yearCheckSucc:
            return "api/driver/order_success/"
        case .yearCheckFail:
            return "api/driver/order_fail/"
        case .arriveHuanChe:
            return "api/driver/order_arrive/"
        case .confirmReturn:
            return "api/driver/order_return/"
        case .getPicName:
            return "api/driver/picname/"
        case .getYearCheckItemInfo:
            return "api/driver/surveyitem/"
        case .getUserAgreement:
            return "api/system/useragreement/"
        case .getOrderCertification,
             .askOrderCertification:
            return "api/driver/order_certification/"
        case .getAlipayBindedAccount,
             .updateAlipayAccount:
            return "api/driver/account_alipay/"
        case .getAlipayBindedAccountInfo:
            return "api/driver/account_alipayinfo/"
        case .getBalance:
            return "api/driver/balance/"
        case .getDriverCancelRuler:
            return "api/driver/order_cancelinfo/"
        case .completeDriverInfo:
            return "api/driver/driver_info/"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .refreshToken,
             .getUserInfo,
            .getAccountInfo,
            .getOrderList,
            .getOrderInfo,
            .getPicName,
            .getYearCheckItemInfo,
            .getUserAgreement,
            .getOrderCertification,
            .getAlipayBindedAccount,
            .getBalance,
            .getDriverCancelRuler,
            .getAlipayBindedAccountInfo:
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
        case .getPicName, .getDriverCancelRuler:
            return .requestParameters(parameters: defaultParam, encoding: URLEncoding.default)
        case let .getAccountInfo(method):
            var param = defaultParam
            param["method"] = method
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .tiXian(money, via, account, user):
            var param = defaultParam
            param["money"] = money
            param["via"] = via
            param["alipay_account"] = account
            param["name"] = user
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .getOrderList(type1, finish):
            var param = defaultParam
            param["type"] = type1
            if type1 == "driver" {
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
            setup(param: &param, picArr: picArr, typeArr: typeArr, note: note)
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .startYearCheck(id):
            var param = defaultParam
            param["id"] = id
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .yearCheckSucc(id, number, picArr, typeArr, note):
            var param = defaultParam
            param["id"] = id
            param["number"] = number
            setup(param: &param, picArr: picArr, typeArr: typeArr, note: note)
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .yearCheckFail(id, number, image1, note1, number_item, itemIDArr, priceArr):
            var param = defaultParam
            param["id"] = id
            param["number"] = number
            param["pic1"] = image1.base64 ?? ""
            param["type1"] = "survey_fail_upload"
            param["note1"] = note1
            param["number_item"] = number_item
            for (index, ID) in itemIDArr.enumerated() {
                param["item_id\(index + 1)"] = ID
                param["price\(index + 1)"] = priceArr[index]
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
            setup(param: &param, picArr: picArr, typeArr: typeArr, note: note)
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .getOrderInfo(id):
            var param = defaultParam
            param["id"] = id
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .getYearCheckItemInfo:
            return .requestParameters(parameters: defaultParam, encoding: URLEncoding.default)
        case .getOrderCertification,
             .getUserInfo,
            .askOrderCertification,
            .getAlipayBindedAccountInfo,
            .getAlipayBindedAccount,
            .getBalance:
            // 这里只传UserID
            var param = defaultParam
            param["id"] = MPUserModel.shared.userID
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .updateAlipayAccount(alipayID, authCode):
            var param = defaultParam
            param["auth_code"] = authCode
            param["alipay_id"] = alipayID
            param["id"] = MPUserModel.shared.userID
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case let .completeDriverInfo(name, idCard, pic_idcard_front, pic_idcard_back, pic_driver, pic_user, pic_drive_front, pic_drive_back):
            var param = defaultParam
            param["id"] = MPUserModel.shared.userID
            param["name"] = name
            param["IDcard"] = idCard
            param["pic_idcard_front"] = pic_idcard_front.base64 ?? ""
            param["pic_idcard_back"] = pic_idcard_back.base64 ?? ""
            param["pic_driver"] = pic_driver.base64 ?? ""
            param["pic_user"] = pic_user.base64 ?? ""
            param["pic_drive_front"] = pic_drive_front.base64 ?? ""
            param["pic_drive_back"] = pic_drive_back.base64 ?? ""
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
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
                "app_type": "driver",
                "version": mp_version
            ]
            return param
        }else {
            return [String: Any]()
        }
    }
    
    /// 设置picArr，typeArr，note三件套
    func setup(param: inout [String: Any], picArr: [UIImage]?, typeArr: [Any]?, note: [String]?) {
        if let arr1 = picArr {
            for (index, img) in arr1.enumerated() {
                if let base = img.base64 {
                    param["pic\(index + 1)"] = base
                }
            }
        }
        if let arr1 = typeArr {
            for (index, type1) in arr1.enumerated() {
                param["type\(index + 1)"] = type1
            }
        }
        if let arr1 = note {
            for (index, note1) in arr1.enumerated() {
                param["note\(index + 1)"] = note1
            }
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
    #if DEBUG
    static let provider = MoyaProvider<MPApiType>(plugins: [MPNetwordActivityPlugin(), NetworkLoggerPlugin(verbose: true)])
    #else
    static let provider = MoyaProvider<MPApiType>(plugins: [MPNetwordActivityPlugin()])
    #endif
    
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
                            }else {
                                failure?(MoyaError.statusCode(moyaResponse))
                            }
                        }else {
                            failure?(MoyaError.statusCode(moyaResponse))
                        }
                    } catch {
                        failure?(MoyaError.jsonMapping(moyaResponse))
                    }
                case let .failure(error):
                    failure?(error)
                }
            }
        }
        request(target: target, success: success, failure: failure)
    }
}




