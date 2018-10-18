//
//  MPShowItemTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/18.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 展示年检未过项的Cell
class MPShowItemTableViewCell: UITableViewCell {
    
    var itemModel: MPComboItemModel? {
        didSet {
            if let name = itemModel?.name {
                nameLabel.text = "\(name):"
            }
            if let price = itemModel?.price {
                moneyLabel.text = String(format: "￥%.2f", price)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        nameLabel = UILabel(font: UIFont.mpNormalFont, text: "排气：", textColor: UIColor.black)
        moneyLabel = UILabel(font: UIFont.mpNormalFont, text: "￥500", textColor: UIColor.red)
        contentView.addSubview(nameLabel)
        contentView.addSubview(moneyLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    fileprivate var nameLabel: UILabel!
    fileprivate var moneyLabel: UILabel!
}
