//
//  MPOrderModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 订单模型
class MPOrderModel {
    /// 订单编号
    var order_code = ""
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
    var combo: MPComboModel?
    /// 套餐项列表
    var surveycomboitem_set: [MPComboItemModel] = [MPComboItemModel]()
    /// 基础费用
    var base_price: Double = 0
    /// 套餐费用
    var combo_price: Double = 0
    /// 年检费用
    var survey_price: Double = 0
    /// 总计费用
    var total_price: Double = 0
    /// 状态
    var state: MPOrderState = MPOrderState.waitQuChe
    /// 年检状态
    var survey_state: MPSurveyState = MPSurveyState.normal
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
    /// 接单用户id
    var driver_user_id: Int = 0
    /// 接单用户头像url
    var driver_user_pic_url: String = ""
    /// 接单用户名称
    var driver_user_name: String = ""
    /// 接单用户联系电话
    var drive_user_phone: String = ""
    /// 取车图片-检车确认
    var get_confirm: MPServerPhotoModel?
    /// 取车图片-车身拍照
    var get_car: MPServerPhotoModel?
    /// 年检已过-上传照片
    var survey_upload: MPServerPhotoModel?
    /// 还车图片-检车确认
    var return_confirm: MPServerPhotoModel?
    /// 还车图片-车身拍照
    var return_car: MPServerPhotoModel?
    /// 失败信息对象
    var failure_object: MPYearCheckFailureModel?
    
    /// 是否选中
    var isSelected: Bool = false
    
    class func toModel(_ dic1: Any?) -> MPOrderModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        if toInt(dic["id"]) == 0 {
            return nil
        }
        let model = MPOrderModel()
        model.order_code = toString(dic["order_code"])
        model.id = toInt(dic["id"])
        model.create_time = toString(dic["create_time"])
        model.update_time = toString(dic["update_time"])
        model.name = toString(dic["name"])
        model.phone = toString(dic["phone"])
        model.car_name = toString(dic["car_name"])
        model.car_type = toString(dic["car_type"])
        model.car_brand = toString(dic["car_brand"])
        model.car_code = toString(dic["car_code"])
        model.surveystation = MPSurveyStationModel.toModel(dic["surveystation"])
        model.order_longitude = toDouble(dic["order_longitude"])
        model.order_latitude = toDouble(dic["order_latitude"])
        model.order_address = toString(dic["order_address"])
        model.get_time = toString(dic["get_time"])
        model.subscribe_time = toString(dic["subscribe_time"])
        model.is_self = toBool(dic["is_self"])
        model.combo = MPComboModel.toModel(dic["combo"])
        if let arr = dic["surveycomboitem_set"] as? [Any] {
            var itemArr = [MPComboItemModel]()
            for dic in arr {
                if let item = MPComboItemModel.toModel(dic) {
                    itemArr.append(item)
                }
            }
            model.surveycomboitem_set = itemArr
        }
        model.base_price = toDouble(dic["base_price"])
        model.combo_price = toDouble(dic["combo_price"])
        model.survey_price = toDouble(dic["survey_price"])
        model.total_price = toDouble(dic["total_price"])
        model.state = MPOrderState.init(rawValue: toInt(dic["state"])) ?? MPOrderState.waitJieDan
        model.driver_user_id = toInt(dic["driver_user_id"])
        model.driver_user_pic_url = toString(dic["driver_user_pic_url"])
        model.driver_user_name = toString(dic["driver_user_name"])
        model.order_time = toString(dic["order_time"])
        model.receive_time = toString(dic["receive_time"])
        model.arrive_survey_time = toString(dic["arrive_survey_time"])
        model.survey_time = toString(dic["survey_time"])
        model.arrive_return_time = toString(dic["arrive_return_time"])
        model.return_time = toString(dic["return_time"])
        model.confirm_time = toString(dic["confirm_time"])
        model.cancel_time = toString(dic["cancel_time"])
        model.drive_user_id = toInt(dic["drive_user_id"])
        model.driver_user_pic_url = toString(dic["drive_user_pic_url"])
        model.driver_user_name = toString(dic["drive_user_name"])
        model.drive_user_phone = toString(dic["drive_user_phone"])
        model.is_success = toBool(dic["is_success"])
        model.survey_state = MPSurveyState.init(rawValue: toInt(dic["survey_state"])) ?? MPSurveyState.normal
        model.get_confirm = MPServerPhotoModel.toModel(dic["get_confirm"])
        model.get_car = MPServerPhotoModel.toModel(dic["get_car"])
        model.survey_upload = MPServerPhotoModel.toModel(dic["survey_upload"])
        model.return_confirm = MPServerPhotoModel.toModel(dic["return_confirm"])
        model.return_car = MPServerPhotoModel.toModel(dic["return_car"])
        model.failure_object = MPYearCheckFailureModel.toModel(dic["failure_object"])
        return model
    }
}

/// 年检站点
class MPSurveyStationModel {
    var id: Int = 0
    var create_time: String = ""
    var update_time: String = ""
    var name: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var address: String = ""
    var price: Double = 0
    
    class func toModel(_ dic1: Any?) -> MPSurveyStationModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        if toInt(dic["id"]) == 0 {
            return nil
        }
        let model = MPSurveyStationModel()
        model.id = toInt(dic["id"])
        model.create_time = toString(dic["create_time"])
        model.update_time = toString(dic["update_time"])
        model.name = toString(dic["name"])
        model.longitude = toDouble(dic["longitude"])
        model.latitude = toDouble(dic["latitude"])
        model.price = toDouble(dic["price"])
        return model
    }
}

/// 套餐对象
class MPComboModel {
    var id: Int = 0
    var create_time: String = ""
    var update_time: String = ""
    var name: String = ""
    var detail: String = ""
    var comboitem_set: [MPComboItemModel] = [MPComboItemModel]()
    
    class func toModel(_ dic1: Any?) -> MPComboModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        if toInt(dic["id"]) == 0 {
            return nil
        }
        let model = MPComboModel()
        model.id = toInt(dic["id"])
        model.create_time = toString(dic["create_time"])
        model.update_time = toString(dic["update_time"])
        model.name = toString(dic["name"])
        model.detail = toString(dic["detail"])
        if let set = dic["comboitem_set"] as? [String: Any] {
            var arr = [MPComboItemModel]()
            for tmp in set {
                if let model = MPComboItemModel.toModel(tmp) {
                    arr.append(model)
                }
            }
            model.comboitem_set = arr
        }
        return model
    }
}

/// 套餐子Item
class MPComboItemModel {
    var id: Int = 0
    var create_time: String = ""
    var update_time: String = ""
    var name: String = ""
    var detail: String = ""
    var price: Double = 0
    /// 是否选中
    var isSelected: Bool = false
    lazy var photoArr: [MPPhotoModel] = {
        var arr = [MPPhotoModel]()
        let item1 = MPPhotoModel()
        let item2 = MPPhotoModel()
        arr.append(item1)
        arr.append(item2)
        return arr
    }()
    
    class func toModel(_ dic1: Any?) -> MPComboItemModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        if toInt(dic["id"]) == 0 {
            return nil
        }
        let model = MPComboItemModel()
        model.id = toInt(dic["id"])
        model.create_time = toString(dic["create_time"])
        model.update_time = toString(dic["update_time"])
        model.name = toString(dic["name"])
        model.detail = toString(dic["detail"])
//        model.price = toDouble(dic["price"])
        return model
    }
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
    /// 年检成功
    case nianJianSucc = 5
    /// 到达还车
    case daoDaHuanChe = 6
    /// 已还车
    case yiHuanChe = 7
    /// 已完成
    case completed = 8
}

/// 年检状态
enum MPSurveyState: Int {
    /// 还没有开始或是正在进行
    case normal = 0
    /// 成功
    case success = 1
    /// 不成功
    case failure = 2
    /// 复查
    case recheck = 3
}









