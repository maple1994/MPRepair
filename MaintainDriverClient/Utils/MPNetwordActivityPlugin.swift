//
//  MPNetwordActivityPlugin.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/29.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Result
import Moya

class MPNetwordActivityPlugin: PluginType {
    var loadingHud: MBProgressHUD?
    
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType) {
//        loadingHud = MPTipsView.showLoadingView()
    }
    
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
//        loadingHud?.hide(animated: true, afterDelay: 5)
    }
    
    /// Called to modify a result before completion.
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}
