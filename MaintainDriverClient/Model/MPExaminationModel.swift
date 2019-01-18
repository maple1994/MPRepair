//
//  MPExaminationModel.swift
//  MaintainDriverClient
//
//  Created by Maple on 2019/1/18.
//  Copyright © 2019年 Maple. All rights reserved.
//

import UIKit

/*
 'start_time':'1999-12-31 12:34:56',
 'end_time':'2019-12-31 12:34:56',
 'question_list':[{
 'content':'123',
 'is_multiple':False,
 'item_list':[{
 'id':12,
 'content':'321'
 }]
 }]
 */
/// 试题模型
class MPExaminationModel {
    /// 题目
    var content: String = ""
    /// 是否多选
    var is_multiple: Bool = false
    /// 选项列表
    var item_list: [MPExaminationItemModel] = [MPExaminationItemModel]()
    
    class func toModel(_ dic1: Any?) -> MPExaminationModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        let model = MPExaminationModel()
        model.content = toString(dic["content"])
        model.is_multiple = toBool(dic["is_multiple"])
        var list = [MPExaminationItemModel]()
        if let arr = dic["item_list"] as? [[String: Any]] {
            for data in arr {
                if let item = MPExaminationItemModel.toModel(data) {
                    list.append(item)
                }
            }
        }
        model.item_list = list
        return model
    }
}

class MPExaminationItemModel {
    var id: Int = 0
    var content: String = ""
    class func toModel(_ dic1: Any?) -> MPExaminationItemModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        let model = MPExaminationItemModel()
        model.id = toInt(dic["id"])
        model.content = toString(dic["content"])
        return model
    }
}
