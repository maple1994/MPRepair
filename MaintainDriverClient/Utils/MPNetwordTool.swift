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
    static func getAccountInfo(method: Int, succ: @escaping ([MPMingXiModel]) -> Void, fail: (() -> Void)?) {
       
        MPNetword.requestJson(target: .getAccountInfo(method: method), success: { (json) in
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
    static func getOrderInfo(id: Int, succ: @escaping (MPOrderModel) -> Void, fail: (() -> Void)?) {
        MPNetword.requestJson(target: .getOrderInfo(id: id), success: { (json) in
            let dic = json["data"] as? [String: Any]
            if let model = MPOrderModel.toModel(dic) {
                succ(model)
            }else {
                fail?()
            }
        }) { (_) in
            fail?()
        }
    }
    
    /// 查询提交图片的类别名称信息
    static func getPicName() {
        MPNetword.requestJson(target: .getPicName, success: { (json) in
            if let dic = json["data"] as? [String: Any] {
                self.loadPicNameFrom(json: dic)
                // 存储到本地
                if let str = dic.toJSONString() {
                    UserDefaults.standard.set(str, forKey: "MP_LOCAL_PIC_NAME_KEY")
                }
            }
        })
    }
    
    /// 查询年检检查项信息
    static func getYearCheckInfo(succ: @escaping ([MPComboItemModel]) -> Void, fail: (() -> Void)?) {
        MPNetword.requestJson(target: .getYearCheckItemInfo, success: { (json) in
            if let arr = json["data"] as? [Any] {
                var itemArr = [MPComboItemModel]()
                for dic in arr {
                    if let item = MPComboItemModel.toModel(dic) {
                        itemArr.append(item)
                    }
                }
                succ(itemArr)
            }else {
                fail?()
            }
        }) { (_) in
            fail?()
        }
    }
    
    /// 从userDefault中加载图片的类别名称
    static func loadPicNameFromUserDefault() {
        let jsonStr = UserDefaults.standard.object(forKey: "MP_LOCAL_PIC_NAME_KEY") as? String
        guard let str = jsonStr else {
            return
        }
        guard let data = str.data(using: .utf8) else {
            return
        }
        do {
            let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            loadPicNameFrom(json: dic)
        }catch {
        }
    }
    
    /// 设置提交图片的类别名称信息
    static func loadPicNameFrom(json: [String: Any]?) {
        if let dic = json {
            if
                let str1 = dic["get_confirm"] as? String,
                let str2 = dic["get_car"] as? String,
                let str3 = dic["survey_upload"] as? String,
                let str4 = dic["return_confirm"] as? String,
                let str5 = dic["return_car"] as? String {
                get_confirm = str1
                get_car = str2
                survey_upload = str3
                return_confirm = str4
                return_car = str5
            }
        }
    }
}










