//
//  MPFeedbackView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/7.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 维修反馈View
class MPFeedbackView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        item1 = MPFeedbackItem()
        item2 = MPFeedbackItem()
        item3 = MPFeedbackItem()
        item1.nameButton.backgroundColor = UIColor.navBlue
        item2.nameButton.setTitle("排气", for: .normal)
        item3.nameButton.setTitle("外观", for: .normal)
        addSubview(item1)
        addSubview(item2)
        addSubview(item3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = frame.width / 3
        let h: CGFloat = 135
        let y: CGFloat = 20
        item1.frame = CGRect(x: 0, y: y, width: w, height: h)
        item2.frame = CGRect(x: w, y: y, width: w, height: h)
        item3.frame = CGRect(x: 2 * w, y: y, width: w, height: h)
    }
    
    fileprivate var item1: MPFeedbackItem!
    fileprivate var item2: MPFeedbackItem!
    fileprivate var item3: MPFeedbackItem!
}

/// 维修反馈View的子Item
class MPFeedbackItem: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        nameButton = UIButton()
        nameButton.setTitleColor(UIColor.white, for: .normal)
        nameButton.setTitle("车灯", for: .normal)
        nameButton.backgroundColor = UIColor.colorWithHexString("#A3A3A3")
        nameButton.setupCorner(10)
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 13), text: "检测调试费", textColor: UIColor.lightGray)
        priceLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "¥ 200.00", textColor: UIColor.red)
        addSubview(nameButton)
        addSubview(titleLabel)
        addSubview(priceLabel)
        nameButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameButton.snp.bottom).offset(8)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    @objc fileprivate func btnClick() {
        
    }
    
    var nameButton: UIButton!
    fileprivate var titleLabel: UILabel!
    fileprivate var priceLabel: UILabel!
}




