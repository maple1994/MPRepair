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
    
    fileprivate var itemModelArr: [MPComboItemModel]
    fileprivate var itemViewArr: [UIView] = [UIView]()
    
    init(itemArr: [MPComboItemModel]) {
        itemModelArr = itemArr
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        for item in itemModelArr {
            let itemView = MPFeedbackItem()
            itemView.itemModel = item
            itemView.addTarget(self, action: #selector(MPFeedbackView.itemClick(_:)), for: .touchUpInside)
            addSubview(itemView)
            itemViewArr.append(itemView)
        }
    }
    
    @objc fileprivate func itemClick(_ item: MPFeedbackItem) {
        item.isSelected = !item.isSelected
        if item.isSelected {
            item.nameButton.backgroundColor = UIColor.navBlue
        }else {
            item.nameButton.backgroundColor = UIColor.mpLightGary
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = frame.width / CGFloat(itemModelArr.count)
        let h: CGFloat = 135
        let y: CGFloat = 20
        for (index, view) in itemViewArr.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * w, y: y, width: w, height: h)
        }
    }
}

/// 维修反馈View的子Item
class MPFeedbackItem: UIControl {
    
    var itemModel: MPComboItemModel? {
        didSet {
            nameButton.setTitle(itemModel?.name, for: .normal)
            if let price = itemModel?.price {
                priceLabel.text = String(format: "¥ %.02f", price)
            }
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
        nameButton = UIButton()
        nameButton.setTitleColor(UIColor.white, for: .normal)
        nameButton.setTitle("车灯", for: .normal)
        nameButton.backgroundColor = UIColor.mpLightGary
        nameButton.titleLabel?.font = UIFont.mpNormalFont
        nameButton.isUserInteractionEnabled = false
        nameButton.setupCorner(4)
        titleLabel = UILabel(font: UIFont.mpXSmallFont, text: "检测调试费", textColor: UIColor.mpLightGary)
        priceLabel = UILabel(font: UIFont.mpNormalFont, text: "¥ 200.00", textColor: UIColor.priceRed)
        addSubview(nameButton)
        addSubview(titleLabel)
        addSubview(priceLabel)
        nameButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(38)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameButton.snp.bottom).offset(6)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
    }
    
    @objc fileprivate func btnClick() {
        
    }
    
    var nameButton: UIButton!
    fileprivate var titleLabel: UILabel!
    fileprivate var priceLabel: UILabel!
}




