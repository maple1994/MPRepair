//
//  MPOrderTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 订单Cell
class MPOrderTableViewCell: UITableViewCell {
    
    var orderModel: MPOrderModel = MPOrderModel() {
        didSet {
            orderIDLabel.text = "\(orderModel.order_code)"
            carNameLabel.text = orderModel.car_brand
            JJCDLabel.text = orderModel.order_address
            NJDDLabel.text = orderModel.surveystation?.name
            timeLabel.text = orderModel.subscribe_time
            moneyLabel.text = "\(orderModel.total_price)"
        }
    }
    var orderState: MPOrderState = MPOrderState.waitJieDan {
        didSet {
            statusLabel.isHidden = false
            if orderState == MPOrderState.completed {
                statusLabel.textColor = completedColor
                statusLabel.text = "已完成"
            }else {
                statusLabel.textColor = uncompleteColor
                statusLabel.text = "未完成"
            }
        }
    }

    fileprivate let smallFont = UIFont.mpSmallFont
    fileprivate let bigFont = UIFont.mpNormalFont
    fileprivate let uncompleteColor = UIColor.mpOrange
    fileprivate let completedColor = UIColor.mpGreen
    /// 左右间距
    fileprivate let hMargin: CGFloat = 15
    /// 上下间距
    fileprivate let vMargin: CGFloat = 15
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let orderTitleLabel = UILabel(font: smallFont, text: "订单编号：", textColor: UIColor.mpLightGary)
        orderIDLabel = UILabel(font: smallFont, text: "20180729123124", textColor: UIColor.mpLightGary)
        statusLabel = UILabel(font: smallFont, text: "未完成", textColor: uncompleteColor)
        statusLabel.isHidden = true
        let line1 = MPUtils.createLine()
        let carTitleLabel = UILabel(font: smallFont, text: "车型：", textColor: UIColor.mpDarkGray)
        carNameLabel = UILabel(font: smallFont, text: "奔驰x123124", textColor: UIColor.mpDarkGray)
        let JJCDTitleLabel = UILabel(font: bigFont, text: "交接车点：", textColor: UIColor.fontBlack)
        JJCDLabel = UILabel(font: bigFont, text: "广州番禺桥兴商务大厦", textColor: UIColor.fontBlack)
        JJCDLabel.numberOfLines = 0
        let NJDDTitleLabel = UILabel(font: bigFont, text: "年检车点：", textColor: UIColor.fontBlack)
        NJDDLabel = UILabel(font: bigFont, text: "广州番禺桥兴商务大厦", textColor: UIColor.fontBlack)
        NJDDLabel.numberOfLines = 0
        let line2 = MPUtils.createLine()
        let timeTitleLabel = UILabel(font: smallFont, text: "预约时间：", textColor: UIColor.mpDarkGray)
        timeLabel = UILabel(font: smallFont, text: "2018-07-29 下午", textColor: UIColor.mpDarkGray)
        let moneyTitleLabel = UILabel(font: smallFont, text: "服务收费：", textColor: UIColor.darkGray)
        moneyLabel = UILabel(font: smallFont, text: "¥ 150.00", textColor: UIColor.priceRed)
        
        contentView.addSubview(orderTitleLabel)
        contentView.addSubview(orderIDLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(line1)
        contentView.addSubview(carTitleLabel)
        contentView.addSubview(carNameLabel)
        contentView.addSubview(JJCDTitleLabel)
        contentView.addSubview(JJCDLabel)
        contentView.addSubview(NJDDTitleLabel)
        contentView.addSubview(NJDDLabel)
        contentView.addSubview(line2)
        contentView.addSubview(timeTitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(moneyTitleLabel)
        contentView.addSubview(moneyLabel)
        
        orderTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(hMargin)
            make.top.equalToSuperview().offset(vMargin)
        }
        orderIDLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel.snp.trailing)
            make.top.equalTo(orderTitleLabel)
        }
        statusLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-hMargin)
            make.top.equalTo(orderTitleLabel)
        }
        line1.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.trailing.equalTo(statusLabel)
            make.top.equalTo(orderTitleLabel.snp.bottom).offset(vMargin)
            make.height.equalTo(1)
        }
        carTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.top.equalTo(line1.snp.bottom).offset(vMargin)
        }
        carNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(carTitleLabel.snp.trailing)
            make.top.equalTo(carTitleLabel)
        }
        JJCDTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.top.equalTo(carTitleLabel.snp.bottom).offset(vMargin)
            make.width.equalTo(83)
        }
        JJCDLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(JJCDTitleLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-hMargin)
            make.top.equalTo(JJCDTitleLabel)
        }
        NJDDTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.top.equalTo(JJCDLabel.snp.bottom).offset(vMargin)
            make.width.equalTo(83)
        }
        NJDDLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(NJDDTitleLabel.snp.trailing)
            make.trailing.equalToSuperview().offset(-hMargin)
            make.top.equalTo(NJDDTitleLabel)
        }
        line2.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.trailing.equalTo(statusLabel)
            make.top.equalTo(NJDDTitleLabel.snp.bottom).offset(vMargin)
            make.height.equalTo(1)
        }
        timeTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.top.equalTo(line2.snp.bottom).offset(vMargin)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(timeTitleLabel.snp.trailing)
            make.top.equalTo(timeTitleLabel)
        }
        moneyTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(vMargin)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(moneyTitleLabel.snp.trailing)
            make.top.equalTo(moneyTitleLabel)
        }
        // 设置灰块
        blockView = MPUtils.createLine(UIColor.viewBgColor)
        contentView.addSubview(blockView)
        blockView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(10)
            make.top.greaterThanOrEqualTo(moneyTitleLabel.snp.bottom).offset(vMargin).priority(.low)
        }
    }
    
    // MARK: - View
    /// 订单ID
    fileprivate var orderIDLabel: UILabel!
    /// 完成状态
    fileprivate var statusLabel: UILabel!
    /// 车型
    fileprivate var carNameLabel: UILabel!
    /// 交接车点
    fileprivate var JJCDLabel: UILabel!
    /// 年检地点
    fileprivate var NJDDLabel: UILabel!
    /// 预约时间
    fileprivate var timeLabel: UILabel!
    /// 服务收费
    fileprivate var moneyLabel: UILabel!
    /// 灰块
    fileprivate var blockView: UIView!
}

