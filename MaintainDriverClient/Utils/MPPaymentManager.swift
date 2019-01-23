//
//  MPPaymentManager.swift
//  MaintainDriverClient
//
//  Created by Maple on 2019/1/23.
//  Copyright © 2019年 Maple. All rights reserved.
//

import UIKit

protocol MPPaymentManagerDelegate: class {
    func paySucc()
    func payFailed(_ err: String?)
}

class MPPaymentManager: NSObject {
    weak var delegate: MPPaymentManagerDelegate?
    static let shared = MPPaymentManager()
    private override init() {
    }
    
    /// 支付宝支付
    func alipy(_ param: String) {
        AlipaySDK.defaultService()?.payOrder(param, fromScheme: "commayidriverclient", callback: { (dic) in
            self.alipayHandle(openUrl: dic)
        })
    }
    
    /// 微信支付
    func wechat(_ paramStr: String) {
        guard let param = paramStr.toJson() else {
            return
        }
        let stamp = toString(param["timestamp"]).toInt() ?? 0
        let req = PayReq()
        req.openID = wechatAppID
        req.partnerId = toString(param["partnerid"])
        req.prepayId = toString(param["prepayid"])
        req.package = toString(param["package"])
        req.nonceStr = toString(param["noncestr"])
        req.timeStamp = UInt32(stamp)
        req.sign = toString(param["sign"])
        WXApi.send(req)
    }
    
    func alipayHandle(openUrl result: [AnyHashable: Any]?) {
        let status = toInt(result?["resultStatus"])
        if status == 9000 {
            // 支付成功
            delegate?.paySucc()
        }else {
            // 支付失败
            delegate?.payFailed(nil)
        }
    }
}

extension MPPaymentManager: WXApiDelegate {
    /*! @brief 发送一个sendReq后，收到微信的回应
     *
     * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
     * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
     * @param resp具体的回应内容，是自动释放的
     */
    func onReq(_ req: BaseReq!) {
        
    }
    
    /*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
     *
     * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
     * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
     * @param req 具体请求内容，是自动释放的
     */
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 {
            // 支付成功
            delegate?.paySucc()
        }else {
            delegate?.payFailed(resp.errStr)
        }
    }
}
