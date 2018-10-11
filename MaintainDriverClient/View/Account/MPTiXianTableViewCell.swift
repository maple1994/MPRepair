//
//  MPTiXianTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/11.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 提现明细Cell
class MPTiXianTableViewCell: UITableViewCell {

    var detailModel: MPMingXiModel? {
        didSet {
            timeLabel.text = detailModel?.create_time
            if let money = detailModel?.cost {
                moneyLabel.text = String(format: "¥ %.02f", money)
            }
        }
    }
    
    var isLineHidden: Bool = false {
        didSet {
            line.isHidden = isLineHidden
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        aliTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "支付宝提现", textColor: UIColor.mpDarkGray)
        timeLabel = UILabel(font: UIFont.mpSmallFont, text: "2018-10-10 23:19:04", textColor: UIColor.mpDarkGray)
        timeLabel.numberOfLines = 0
        moneyLabel = UILabel(font: UIFont.mpNormalFont, text: "¥ 23.00", textColor: UIColor.priceRed)
        moneyLabel.textAlignment = .right
        moneyLabel.adjustsFontSizeToFitWidth = true
        iconImageView1 = UIImageView()
        iconImageView1.backgroundColor = UIColor.navBlue
        iconImageView1.setupCorner(7)
        iconImageView2 = UIImageView()
        iconImageView2.backgroundColor = UIColor.mpOrange
        iconImageView2.setupCorner(5)
        contentView.addSubview(iconImageView1)
        contentView.addSubview(iconImageView2)
        contentView.addSubview(aliTitleLabel)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(timeLabel)
        
        iconImageView1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(14)
            make.height.width.equalTo(14)
        }
        aliTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView1)
            make.leading.equalTo(iconImageView1.snp.trailing).offset(10)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(aliTitleLabel)
            make.top.equalTo(aliTitleLabel.snp.bottom).offset(15).priority(.high)
            make.trailing.equalTo(moneyLabel.snp.leading).offset(-5)
        }
        iconImageView2.snp.makeConstraints { (make) in
            make.height.width.equalTo(10)
            make.centerX.equalTo(iconImageView1)
            make.centerY.equalTo(timeLabel)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalTo(timeLabel.snp.centerY)
            make.width.equalTo(100)
        }
        line = MPUtils.createLine()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    fileprivate var aliTitleLabel: UILabel!
    fileprivate var moneyLabel: UILabel!
    fileprivate var timeLabel: UILabel!
    fileprivate var iconImageView1: UIImageView!
    fileprivate var iconImageView2: UIImageView!
    fileprivate var line: UIView!

}
