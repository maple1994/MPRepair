//
//  MPSettingCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

protocol MPSettingCellDelegate: class {
    func settingCellDidClickIcon()
}

/// 设置界面的Cell
class MPSettingCell: UITableViewCell {
    
    /// 是否显示头像
    fileprivate var isShowIcon: Bool = false
    weak var delegate: MPSettingCellDelegate?
    
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
        leftTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 14), text: "头像", textColor: UIColor.fontBlack)
        let margin: CGFloat = 18
        if isShowIcon {
            iconView = UIButton()
            iconView?.setupCorner(20)
            iconView?.backgroundColor = UIColor.colorWithHexString("#ff0000", alpha: 0.3)
            iconView?.addTarget(self, action: #selector(MPSettingCell.iconClick), for: .touchUpInside)
            iconView?.adjustsImageWhenHighlighted = false
            contentView.addSubview(iconView!)
            iconView?.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(40)
                make.trailing.equalToSuperview().offset(-margin)
            }
        }else {
            rightTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 14), text: "王一清", textColor: UIColor.mpLightGary)
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
        let line = MPUtils.createLine()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc fileprivate func iconClick() {
        delegate?.settingCellDidClickIcon()
    }
    
    var leftTitleLabel: UILabel?
    var rightTitleLabel: UILabel?
    var iconView: UIButton?
}
