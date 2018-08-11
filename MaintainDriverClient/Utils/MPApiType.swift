//
//  MPApiManager.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/10.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Moya

// https://www.jianshu.com/p/38fbc22a1e2b
/// 网络请求类
let MPProvider = MoyaProvider<MPApiType>()

enum MPApiType {
    case login
}

extension MPApiType: TargetType {
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .login:
            return ""
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
        return .requestPlain
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
