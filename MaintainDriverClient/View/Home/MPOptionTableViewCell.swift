//
//  MPOptionTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/27.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

protocol MPOptionTableViewCellDelegate: class {
    func checkBox(didSelect isChecked: Bool)
}

class MPOptionTableViewCell: UITableViewCell {
    
    weak var delegate: MPOptionTableViewCellDelegate?
    var isChecked: Bool = true {
        didSet {
            if isChecked {
                yesCheckBox.isChecked = true
                noCheckBox.isChecked = false
            }else {
                yesCheckBox.isChecked = false
                noCheckBox.isChecked = true
            }
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
        titleLabel = UILabel(font: UIFont.mpSmallFont, text: "有无代驾经历", textColor: UIColor.colorWithHexString("4A4A4A"))
        yesCheckBox = MPCheckBoxButton()
        yesCheckBox.title = "是"
        yesCheckBox.isChecked = true
        noCheckBox = MPCheckBoxButton()
        noCheckBox.title = "否"
        yesCheckBox.addTarget(self, action: #selector(MPOptionTableViewCell.checkBoxAction(btn:)), for: .touchUpInside)
        noCheckBox.addTarget(self, action: #selector(MPOptionTableViewCell.checkBoxAction(btn:)), for: .touchUpInside)
        let line = MPUtils.createLine()
        contentView.addSubview(titleLabel)
        contentView.addSubview(yesCheckBox)
        contentView.addSubview(noCheckBox)
        contentView.addSubview(line)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
        }
        yesCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(35)
            make.width.equalTo(50)
        }
        noCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(yesCheckBox)
            make.leading.equalTo(yesCheckBox.snp.trailing).offset(80)
            make.height.equalTo(35)
            make.width.equalTo(50)
        }
        line.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.4)
        }
    }
    
    @objc fileprivate func checkBoxAction(btn: MPCheckBoxButton) {
        if btn.isChecked {
            return
        }
        if btn == yesCheckBox {
            yesCheckBox.isChecked = true
            noCheckBox.isChecked = false
            delegate?.checkBox(didSelect: true)
        }else {
            yesCheckBox.isChecked = false
            noCheckBox.isChecked = true
            delegate?.checkBox(didSelect: false)
        }
    }
    
    fileprivate var titleLabel: UILabel!
    fileprivate var yesCheckBox: MPCheckBoxButton!
    fileprivate var noCheckBox: MPCheckBoxButton!
}

/// 单选按钮
class MPCheckBoxButton: UIControl {
    /// 是否选中
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                iconImageView.image = UIImage(named: "box_selected")
            }else {
                iconImageView.image = UIImage(named: "box_unselected")
            }
        }
    }
    /// 设置title
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "box_unselected")
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 14), text: "是", textColor: UIColor.colorWithHexString("4A4A4A"))
        addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
//        contentView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
        }
    }
    
    fileprivate var contentView: UIView!
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
}
