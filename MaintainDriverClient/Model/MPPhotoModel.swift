//
//  MPPhotoModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 图片Cell模型
class MPPhotoModel {
    /// 图片
    var image: UIImage?
    /// 标题
    var title: String?
}

/// 服务器返回的图片模型
struct MPServerPhotoModel {
    /// 名字
    var name: String = ""
    /// 图片列表
    var obj_list: [MPServerPhotoItemModel] = [MPServerPhotoItemModel]()
    
    static func toModel(_ dic1: Any?) -> MPServerPhotoModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        var model = MPServerPhotoModel()
        model.name = toString(dic["name"])
        if let arr = dic["obj_list"] as? [Any] {
            var itemArr = [MPServerPhotoItemModel]()
            for tmp in arr {
                if let item = MPServerPhotoItemModel.toModel(tmp) {
                    itemArr.append(item)
                }
            }
            model.obj_list = itemArr
        }
        return model
    }
}

struct MPServerPhotoItemModel {
    /// 备注
    var note: String = ""
    /// 图片url
    var pic_url: String = ""
    
    static func toModel(_ dic1: Any?) -> MPServerPhotoItemModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        var model = MPServerPhotoItemModel()
        model.note = toString(dic["note"])
        model.pic_url = toString(dic["pic_url"])
        return model
    }
}

/// 年检失败模型
struct MPYearCheckFailureModel {
    /// 补充项
    var name: String = ""
    /// 总计费用
    var price: Double = 0
    /// 失败详情
    var failureitem_list: [MPYearCheckFailureItemModel] = [MPYearCheckFailureItemModel]()
    
    static func toModel(_ dic1: Any?) -> MPYearCheckFailureModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        var model = MPYearCheckFailureModel()
        model.name = toString(dic["name"])
        model.price = toDouble(dic["price"])
        if let arr = dic["failureitem_list"] as? [Any] {
            var itemArr = [MPYearCheckFailureItemModel]()
            for tmp in arr {
                if let model = MPYearCheckFailureItemModel.toModel(tmp) {
                    itemArr.append(model)
                }
            }
            model.failureitem_list = itemArr
        }
        return model
    }
}

/// 年检失败子模型
struct MPYearCheckFailureItemModel {
    /// 名称
    var name: String = ""
    /// 费用
    var price: Double = 0
    /// 图片对象列表
    var failurepic_list: [MPServerPhotoItemModel] = [MPServerPhotoItemModel]()
    
    static func toModel(_ dic1: Any?) -> MPYearCheckFailureItemModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        var model = MPYearCheckFailureItemModel()
        model.name = toString(dic["name"])
        model.price = toDouble(dic["price"])
        if let arr = dic["failurepic_list"] as? [Any] {
            var itemArr = [MPServerPhotoItemModel]()
            for tmp in arr {
                if let item = MPServerPhotoItemModel.toModel(tmp) {
                    itemArr.append(item)
                }
            }
            model.failurepic_list = itemArr
        }
        return model
    }
}








