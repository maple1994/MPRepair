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
    static func getAccountInfo(succ: ([MPMingXiModel]) -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 查询订单列表信息
    ///
    /// - Parameters:
    ///   - type: order：可以接的单，driver：已接订单
    ///   - finish: 0表示所有，1表示未完成，2表示已完成, 当type=driver的时候必填
    static func getOrderList(type: String, finish: Int, succ: ([MPOrderModel]) -> Void, fail: (() -> Void)?) {

    }
    
    /// 抢单
    ///
    /// - Parameters:
    ///   - id: 订单id
    static func grab(id: Int, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 取消订单
    ///
    /// - Parameters:
    ///   - id: 订单id
    static func cancelOrder(id: Int, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 确认取车
    ///
    /// - Parameters:
    ///   - id: 订单id
    ///   - number: picArr数量
    ///   - picArr: UIImage数组
    ///   - typeArr: 对应picArr的type
    ///   - note: 对应picArr的note
    static func quChe(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 开始年检
    ///
    /// - Parameters:
    ///   - id: 订单id
    static func startYearCheck(id: Int, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 年检已过
    ///
    /// - Parameters:
    ///   - id: 订单id
    ///   - number: picArr数量
    ///   - picArr: UIImage数组
    ///   - typeArr: 对应picArr的type
    ///   - note: 对应picArr的note
    static func yearCheckSucc(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 年检未过
    ///
    /// - Parameters:
    ///   - id: 订单id
    ///   - number: picArr数量
    ///   - picArr: UIImage数组
    ///   - typeArr: 对应picArr的type
    ///   - note: 对应picArr的note
    static func yearCheckFail(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 到达还车
    ///
    /// - Parameters:
    ///   - id: 订单id
    static func arriveHuanChe(id: Int, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 确认还车
    ///
    /// - Parameters:
    ///   - id: 订单id
    ///   - number: picArr数量
    ///   - picArr: UIImage数组
    ///   - typeArr: 对应picArr的type
    ///   - note: 对应picArr的note
    static func confirmReturn(id: Int, number: Int, picArr: [UIImage]?, typeArr: [String]?, note: [String]?, succ: () -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 查询订单信息
    ///
    /// - Parameters:
    ///   - id: 订单id
    static func getOrderInfo(id: Int, succ: (MPOrderModel) -> Void, fail: (() -> Void)?) {
        
    }
    
    /// 查询提交图片的类别名称信息
    static func getPicName() {
        
    }
}
