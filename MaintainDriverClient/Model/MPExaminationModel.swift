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
    /// 行高
    var rowHeight: CGFloat {
        if _rowHeight == 0 || itemListHeight == 0 {
            let wid = mp_screenW - 30
            let txtH = content.size(UIFont.mpSmallFont, width: wid).height
            _rowHeight += txtH + 10 + 10
            _rowHeight += itemListHeight
            // 线高
            _rowHeight += 1
        }
        return _rowHeight
    }
    var itemListHeight: CGFloat {
        if _itemListHeight == 0 {
            _itemListHeight = 0
            for item in item_list {
                _itemListHeight += item.itemH
            }
        }
        return _itemListHeight
    }
    fileprivate var _itemListHeight: CGFloat = 0
    fileprivate var _rowHeight: CGFloat = 0
    
    class func toModel(_ dic1: Any?) -> MPExaminationModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        let model = MPExaminationModel()
        model.content = toString(dic["content"])
        model.is_multiple = toBool(dic["is_multiple"])
        var list = [MPExaminationItemModel]()
        if let arr = dic["item_list"] as? [[String: Any]] {
            for (index, data) in arr.enumerated() {
                if let item = MPExaminationItemModel.toModel(data) {
                    let num = getNum(index) + " "
                    item.content = num + item.content
                    list.append(item)
                }
            }
        }
        model.item_list = list
        return model
    }
    
    fileprivate class func getNum(_ index: Int) -> String {
        let arr: [String] = [
            "A","B","C","D","E","F","G","H",
            "I","J","K","L","M","N","O","P",
            "Q","R","S","T","U","V","W","X",
            "Y","Z"
        ]
        return arr[index]
    }
}

class MPExaminationItemModel {
    var id: Int = 0
    var content: String = ""
    var isChecked: Bool = false
    var itemH: CGFloat {
        if _itemH == 0 {
            let wid: CGFloat = mp_screenW - 30 - 23
            _itemH = content.size(UIFont.mpSmallFont, width: wid).height + 10
            if _itemH < 35 {
                _itemH = 35
            }
        }
        return _itemH
    }
    fileprivate var _itemH: CGFloat = 0
    class func toModel(_ dic1: Any?) -> MPExaminationItemModel? {
        guard let dic = dic1 as? [String: Any] else {
            return nil
        }
        let model = MPExaminationItemModel()
        model.id = toInt(dic["id"])
        model.content = toString(dic["content"])
        if model.content.isEmpty || model.id == 0 {
            return nil
        }
        return model
    }
}
