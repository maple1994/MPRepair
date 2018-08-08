//
//  MPMunuViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 侧边菜单Cell
class MPMunuViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        iconView = UIImageView()
        iconTitleLabel = UILabel()
        iconTitleLabel.font = UIFont.mpBigFont
        iconTitleLabel.textColor = UIColor.fontBlack
        contentView.addSubview(iconView)
        contentView.addSubview(iconTitleLabel)
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        iconTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(10)
        }
    }
    
    var iconView: UIImageView!
    var iconTitleLabel: UILabel!
}

