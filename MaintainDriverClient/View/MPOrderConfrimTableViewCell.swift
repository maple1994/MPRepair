//
//  MPOrderConfrimTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 订单确认Cell
class MPOrderConfrimTableViewCell: UITableViewCell {
    
    func set(title: String, value: String, isHiddenLine: Bool) {
        titleLabel.text = title
        valueLabel.text = value
        line.isHidden = isHiddenLine
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 16), text: "车主姓名", textColor: UIColor.mpDarkGray)
        valueLabel = UILabel(font: UIFont.systemFont(ofSize: 16), text: "王思迪", textColor: UIColor.mpDarkGray)
        valueLabel.numberOfLines = 0
        line = MPUtils.createLine()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(line)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        valueLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(120)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        line.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(1)
        }
        
    }
    
    fileprivate var titleLabel: UILabel!
    fileprivate var valueLabel: UILabel!
    fileprivate var line: UIView!
}

/// 显示title，背景色为灰色的sectionHeader
class MPTitleSectionHeaderView: UITableViewHeaderFooterView {
    convenience init(title: String?, reuseIdentifier: String?) {
        self.init(reuseIdentifier: reuseIdentifier)
        titleLabel.text = title
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    fileprivate func setupUI() {
        backgroundColor = UIColor.viewBgColor
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 16), text: "明细", textColor: UIColor.mpDarkGray)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(5)
        })
    }
    fileprivate var titleLabel: UILabel!
}








