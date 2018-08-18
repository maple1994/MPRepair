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

// https://www.jianshu.com/p/38fbc22a1e2b
/// 网络请求类
let mp_Provider = MoyaProvider<MPApiType>(plugins: [MPNetwordActivityPlugin(), NetworkLoggerPlugin(verbose: true)])

class MPNetwordActivityPlugin: PluginType {
    var loadingHud: MBProgressHUD?
    
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType) {
        loadingHud = MPTipsView.showLoadingView()
    }
    
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        loadingHud?.hide(animated: true, afterDelay: 5)
    }
    
    /// Called to modify a result before completion.
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}

enum MPApiType {
    case login
    case test(idList: String)
}

extension MPApiType: TargetType {
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "www.nolasthope.cn")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .login:
            return ""
        case .test:
            return "hqw1/api/index.php"
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    /// 请求任务事件（这里附带上参数）
    var task: Task {
        switch self {
        case .test(let idList):
            let param: [String: String] = [
                "a" : "RefreshStockList",
                "c" : "UserSelectStock",
                "Token" : "b745884bfbe45272f237ba417fe1f78e",
                "UserID" : "275125",
                "StockIDList" : idList,
                "apiv" : "w11"
            ]
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
    
    
}
