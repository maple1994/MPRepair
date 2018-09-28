//
//  MPSettingCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 设置界面的Cell
class MPSettingCell: UITableViewCell {
    
    /// 是否显示头像
    fileprivate var isShowIcon: Bool = false
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, isShowIcon: Bool) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isShowIcon = isShowIcon
        setupUI()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        leftTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "头像", textColor: UIColor.fontBlack)
        let margin: CGFloat = 18
        if isShowIcon {
            iconView = UIImageView()
            iconView?.setupCorner(20)
            contentView.addSubview(iconView!)
            iconView?.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(40)
                make.trailing.equalToSuperview().offset(-margin)
            }
        }else {
            rightTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "王一清", textColor: UIColor.mpLightGary)
            contentView.addSubview(rightTitleLabel!)
            rightTitleLabel?.snp.makeConstraints({ (make) in
                make.trailing.equalToSuperview().offset(-margin)
                make.centerY.equalToSuperview()
            })
        }
        contentView.addSubview(leftTitleLabel!)
        leftTitleLabel?.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.centerY.equalToSuperview()
        }
        line = MPUtils.createLine()
        contentView.addSubview(line!)
        line?.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    var line: UIView?
    var leftTitleLabel: UILabel?
    var rightTitleLabel: UILabel?
    var iconView: UIImageView?
}
