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
    
    var row: Int = 0{
        didSet {
            if row % 2 == 0 {
                statusLabel.textColor = uncompleteColor
                statusLabel.text = "未完成"
            }else {
                statusLabel.textColor = completedColor
                statusLabel.text = "已完成"
            }
        }
    }
    fileprivate let smallFont = UIFont.systemFont(ofSize: 15)
    fileprivate let bigFont = UIFont.systemFont(ofSize: 17)
    fileprivate let uncompleteColor = UIColor.colorWithHexString("#E98F5A")
    fileprivate let completedColor = UIColor.colorWithHexString("#94F94D")
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
        let orderTitleLabel = createLabel(font: smallFont, text: "订单编号：", textColor: UIColor.lightGray)
        orderIDLabel = createLabel(font: smallFont, text: "20180729123124", textColor: UIColor.lightGray)
        statusLabel = createLabel(font: smallFont, text: "未完成", textColor: uncompleteColor)
        let line1 = MPUtils.createLine()
        let carTitleLabel = createLabel(font: smallFont, text: "车型：", textColor: UIColor.darkGray)
        carNameLabel = createLabel(font: smallFont, text: "奔驰x123124", textColor: UIColor.darkGray)
        let JJCDTitleLabel = createLabel(font: bigFont, text: "交接车点：", textColor: UIColor.black)
        JJCDLabel = createLabel(font: bigFont, text: "广州番禺桥兴商务大厦", textColor: UIColor.black)
        let NJDDTitleLabel = createLabel(font: bigFont, text: "年检车点：", textColor: UIColor.black)
        NJDDLabel = createLabel(font: bigFont, text: "广州番禺桥兴商务大厦", textColor: UIColor.black)
        let line2 = MPUtils.createLine()
        let timeTitleLabel = createLabel(font: smallFont, text: "预约时间：", textColor: UIColor.darkGray)
        timeLabel = createLabel(font: smallFont, text: "2018-07-29 下午", textColor: UIColor.darkGray)
        let moneyTitleLabel = createLabel(font: smallFont, text: "服务收费：", textColor: UIColor.darkGray)
        moneyLabel = createLabel(font: smallFont, text: "¥150.00", textColor: UIColor.red)
        
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
        }
        JJCDLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(JJCDTitleLabel.snp.trailing)
            make.top.equalTo(JJCDTitleLabel)
        }
        NJDDTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(orderTitleLabel)
            make.top.equalTo(JJCDTitleLabel.snp.bottom).offset(vMargin)
        }
        NJDDLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(NJDDTitleLabel.snp.trailing)
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
        blockView = MPUtils.createLine(UIColor.colorWithHexString("#f5f5f5"))
        contentView.addSubview(blockView)
        blockView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(moneyTitleLabel.snp.bottom).offset(vMargin)
        }
    }
    
    fileprivate func createLabel(font: UIFont, text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = 0
        return label
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
    /// 服务收尾
    fileprivate var moneyLabel: UILabel!
    /// 灰块
    fileprivate var blockView: UIView!
}


/// 分割灰块View
//class MPGrayBlockView: UITableViewHeaderFooterView {
//
//    convenience init(h: CGFloat, reuseIdentifier: String?) {
//        self.init(reuseIdentifier: reuseIdentifier)
//        frame = CGRect(x: 0, y: 0, width: MPUtils.screenW, height: h)
//    }
//
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        backgroundColor = UIColor.colorWithHexString("#F5F5F5")
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("")
//    }
//}
