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
        switch target {
        case MPApiType.updateUserInfo(name: _, pic: _):
            loadingHud = MPTipsView.showLoadingView("上传中...")
        case MPApiType.login:
            loadingHud = MPTipsView.showLoadingView("登录中...")
        default:
            break
        }
    }
    
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            guard let json = try? response.mapJSON() as AnyObject,
            let code = json["code"] as? Int else {
                return
            }
            switch code {
//            case 100:
//                if let msg = json["msg"] as? String {
//                    MPPrint("100-\(target)-\(msg)")
//                }
            case 200:
                if let msg = json["msg"] as? String {
                    switch target {
                    case MPApiType.tiXian:
                        MPDialogView.showDialog(msg)
                    default:
                        MPTipsView.showMsg(msg)
                    }
                    MPPrint("200-\(target)-\(msg)")
                }
            case 300:
                if let msg = json["msg"] as? String {
                    MPTipsView.showMsg(msg)
                    MPPrint("300-\(target)-\(msg)")
                }
                if MPUserModel.shared.isLogin {                
                    MPUserModel.shared.loginOut()
                }
            default:
                break
            }
        case let .failure(err):
            MPPrint(err)
        }
        switch target {
        case MPApiType.updateUserInfo(name: _, pic: _):
            loadingHud?.hide(animated: true)
        case MPApiType.getUserInfo:
            loadingHud?.hide(animated: true)
        default:
            break
        }
//        loadingHud?.hide(animated: true, afterDelay: 5)
    }
    
    /// Called to modify a result before completion.
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        loadingHud?.hide(animated: true)
        return result
    }
}
