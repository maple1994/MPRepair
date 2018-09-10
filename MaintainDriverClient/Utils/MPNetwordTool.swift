//
//  MPNetwordTool.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/10.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 网络请求工具
struct MPNetwordTool {
    
    /// 获取账户明细信息
    ///
    static func getAccountInfo(succ: @escaping ([MPMingXiModel]) -> Void, fail: (() -> Void)?) {
        MPNetword.requestJson(target: .getAccountInfo, success: { (json) in
            guard let data = json["data"] as? [[String: Any]] else {
                fail?()
                return
            }
            var modelArr = [MPMingXiModel]()
            for dic in data {
                if let model: MPMingXiModel = MPMingXiModel.toModel(dic) {
                    modelArr.append(model)
                }
            }
            succ(modelArr)
        }) { (_) in
            fail?()
        }
    }
    
    /// 查询订单列表信息
    ///
    /// - Parameters:
    ///   - type: order：可以接的单，driver：已接订单
    ///   - finish: 0表示所有，1表示未完成，2表示已完成, 当type=driver的时候必填
    static func getOrderList(type: String, finish: Int, succ: @escaping ([MPOrderModel]) -> Void, fail: (() -> Void)?) {
        MPNetword.requestJson(target: .getOrderList(type: type, finish: finish), success: { (json) in
            guard let data = json["data"] as? [[String: Any]] else {
                fail?()
                return
            }
            var arr = [MPOrderModel]()
            for dic in data {
                if let model = MPOrderModel.toModel(dic) {
                    arr.append(model)
                }
            }
            succ(arr)
        }) { (_) in
            fail?()
        }
    }
    
    /// 查询订单信息
    ///
    /// - Parameters:
    ///   - id: 订单id
    static func getOrderInfo(id: Int, succ: (MPOrderModel) -> Void, fail: (() -> Void)?) {
        MPNetword.requestJson(target: .getOrderInfo(id: id), success: { (json) in
            
        }) { (_) in
            
        }
    }
    
    /// 查询提交图片的类别名称信息
    static func getPicName() {
        
    }
}
