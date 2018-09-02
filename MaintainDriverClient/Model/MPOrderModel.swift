//
//  MPOrderModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 订单模型
struct MPOrderModel: Codable {
    /// 订单ID
    var id: Int = 0
    /// 创建时间
    var create_time: String = ""
    /// 修改时间
    var update_time: String = ""
    /// 联系人
    var name: String = ""
    /// 联系人电话
    var phone: String = ""
    /// 车主名字
    var car_name: String = ""
    /// 品牌型号
    var car_brand: String = ""
    /// 车牌
    var car_code: String = ""
    /// 车辆类型
    var car_type: String = "小型蓝牌，七座以下"
    /// 年检站
    var surveystation: MPSurveyStationModel?
    /// 交接地点经度
    var order_longitude: Double = 0
    /// 交接地点纬度
    var order_latitude: Double = 0
    /// 交接地点
    var order_address: String = ""
    /// 预约日期
    var subscribe_time: String = ""
    /// 是否自驾
    var is_self: Bool = false
    /// 套餐对象
//    combo
    /// 套餐项列表
//    surveycomboitem_set
    /// 基础费用
    var base_price: Double = 0
    /// 套餐费用
    var combo_price: Double = 0
    /// 年检费用
    var survey_price: Double = 0
    /// 总计费用
    var total_price: Double = 0
    /// 状态
    var state: Int = 0
    /// 年检是否成功
    var is_success: Bool = false
    /// 接单用户id
    var drive_user_id: Int = 0
    /// 下单时间
    var order_time: String = ""
    /// 接单时间
    var receive_time: String = ""
    /// 取车时间
    var get_time: String = ""
    /// 到达年检时间
    var arrive_survey_time: String = ""
    /// 年检结束时间
    var survey_time: String = ""
    /// 到达还车时间
    var arrive_return_time: String = ""
    /// 还车时间
    var return_time: String = ""
    /// 确认时间
    var confirm_time: String = ""
    /// 取消时间
    var cancel_time: String = ""
    /// 图片备注对象列表
//    pic_list
    
    /// 是否选中
    var isSelected: Bool = false
}

/// 年检站点
struct MPSurveyStationModel: Codable {
    var id: Int = 0
    var create_time: String = ""
    var update_time: String = ""
    var name: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var price: Double = 0
}

/// 订单状态
enum MPOrderState: Int {
    /// 等待支付
    case waitPay = 0
    /// 等待接单
    case waitJieDan = 1
    /// 等待取车
    case waitQuChe = 2
    /// 等待年检
    case waitNianJian = 3
    /// 正在年检
    case nianJianing = 4
    /// 年检结束
    case nianJianOver = 5
    /// 到达还车
    case daoDaHuanChe = 6
    /// 已还车
    case yiHuanChe = 7
    /// 已完成
    case completed = 8
    /// 已取消
    case cancel = 9
}







