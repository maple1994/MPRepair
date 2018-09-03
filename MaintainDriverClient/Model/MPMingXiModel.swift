//
//  MPMingXiModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 明细模型
class MPMingXiModel: Codable {
    /// 订单ID
    var id: Int = 0
    /// 创建时间
    var create_time: String = ""
    /// 修改时间
    var update_time: String = ""
    /// 时间
    var order_time: String = ""
    /// 出发地点
    var start_address: String = ""
    /// 到达地点
    var end_address: String = ""
    /// 行为0：提现，1收入
    var method: Int = 1
    /// 提现途径 alipay,weixin
    var via: String = "alipay"
    /// 费用
    var cost: Double = 0
    /// 年检订单,查看年检信息,如果是提现的话，这里为空
    //    var survey
    
    class func toModel(_ dic1: Any?) -> MPMingXiModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        if toInt(dic["id"]) == 0 {
            return nil
        }
        let model = MPMingXiModel()
        model.id = toInt(dic["id"])
        model.create_time = toString(dic["create_time"])
        model.update_time = toString(dic["update_time"])
        model.order_time = toString(dic["order_time"])
        model.start_address = toString(dic["start_address"])
        model.end_address = toString(dic["end_address"])
        model.method = toInt(dic["method"])
        model.via = toString(dic["via"])
        model.cost = toDouble(dic["cost"])
        return model
    }
}
