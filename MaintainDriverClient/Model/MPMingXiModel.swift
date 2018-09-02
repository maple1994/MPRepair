//
//  MPMingXiModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 明细模型
struct MPMingXiModel: Codable {
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
}
