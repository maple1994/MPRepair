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
    
    fileprivate var titleColor: UIColor = UIColor.mpDarkGray
    fileprivate var titleFont: UIFont = UIFont.mpNormalFont
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let ID = reuseIdentifier {
            if ID == "MP_COMBO" {
                titleColor = UIColor.mpLightGary
                titleFont = UIFont.mpSmallFont
            }
        }
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        titleLabel = UILabel(font: titleFont, text: "车主姓名", textColor: titleColor)
        valueLabel = UILabel(font: titleFont, text: "王思迪", textColor: titleColor)
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
            make.top.equalTo(titleLabel)
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
        contentView.backgroundColor = UIColor.viewBgColor
        titleLabel = UILabel(font: UIFont.mpSmallFont, text: "明细", textColor: UIColor.mpDarkGray)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(5)
        })
    }
    fileprivate var titleLabel: UILabel!
    
}








