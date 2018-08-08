//
//  MPMingXiTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 明细Cell
class MPMingXiTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        timeLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "2018-07-29 09:04", textColor: UIColor.mpDarkGray)
        startAddressLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "广州番禺区大石武警医院", textColor: UIColor.mpDarkGray)
        startAddressLabel.numberOfLines = 0
        endAddressLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "广州番禺区塘西桥兴商务大厦", textColor: UIColor.mpDarkGray)
        endAddressLabel.numberOfLines = 0
        moneyLabel = UILabel(font: UIFont.systemFont(ofSize: 16), text: "¥ 23.00", textColor: UIColor.priceRed)
        moneyLabel.textAlignment = .right
        moneyLabel.adjustsFontSizeToFitWidth = true
        iconImageView1 = UIImageView()
        iconImageView1.backgroundColor = UIColor.navBlue
        iconImageView1.setupCorner(7.5)
        iconImageView2 = UIImageView()
        iconImageView2.backgroundColor = UIColor.mpOrange
        iconImageView2.setupCorner(5)
        iconImageView3 = UIImageView()
        iconImageView3.backgroundColor = UIColor.mpGreen
        iconImageView3.setupCorner(5)
        contentView.addSubview(iconImageView1)
        contentView.addSubview(iconImageView2)
        contentView.addSubview(iconImageView3)
        contentView.addSubview(timeLabel)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(startAddressLabel)
        contentView.addSubview(endAddressLabel)
        
        iconImageView1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.height.width.equalTo(15)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView1)
            make.leading.equalTo(iconImageView1.snp.trailing).offset(10)
        }
        startAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(15).priority(.high)
            make.trailing.equalTo(moneyLabel.snp.leading).offset(-5)
        }
        iconImageView2.snp.makeConstraints { (make) in
            make.height.width.equalTo(10)
            make.centerX.equalTo(iconImageView1)
            make.centerY.equalTo(startAddressLabel)
        }
        endAddressLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(timeLabel)
            make.top.equalTo(startAddressLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.trailing.equalTo(moneyLabel.snp.leading).offset(-5)
        }
        iconImageView3.snp.makeConstraints { (make) in
            make.height.width.equalTo(10)
            make.centerX.equalTo(iconImageView1)
            make.centerY.equalTo(endAddressLabel)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(endAddressLabel.snp.centerY)
            make.width.equalTo(100)
        }
    }
    
    fileprivate var timeLabel: UILabel!
    fileprivate var moneyLabel: UILabel!
    fileprivate var startAddressLabel: UILabel!
    fileprivate var endAddressLabel: UILabel!
    fileprivate var iconImageView1: UIImageView!
    fileprivate var iconImageView2: UIImageView!
    fileprivate var iconImageView3: UIImageView!
}









