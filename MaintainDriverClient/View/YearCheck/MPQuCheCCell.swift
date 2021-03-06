//
//  MPQuCheCCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

protocol MPQuCheCCellDelegate: class {
    /// 联系
    func quCheCellDidSelectContact()
    /// 导航
    func quCheCellDidSelectNavigation()
}

/// 上门取车Cell，时间地点车型，两个按钮
class MPQuCheCCell: UITableViewCell {
    
    weak var delegate: MPQuCheCCellDelegate?
    
    func hiddenRightView() {
        contactButton.isHidden = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let carTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "车型：", textColor: UIColor.mpLightGary)
        carNameLabel = UILabel(font: UIFont.mpSmallFont, text: "奔驰x123124", textColor: UIColor.mpLightGary)
        addressTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "交接地点：", textColor: UIColor.fontBlack)
        addressLabel = UILabel(font: UIFont.mpSmallFont, text: "兴南大道33号月雅苑门口", textColor: UIColor.fontBlack)
        addressLabel.numberOfLines = 0
        timeTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "交接时间：", textColor: UIColor.colorWithHexString("616161"))
        timeLabel = UILabel(font: UIFont.mpSmallFont, text: "2018-07-29 下午", textColor: UIColor.colorWithHexString("616161"))
        contactButton = MPImageButtonView(image: #imageLiteral(resourceName: "phone"), pos: .center, imageW: 30, imageH: 30)
        navigationButton = MPImageButtonView(image: #imageLiteral(resourceName: "navigation"), pos: .center, imageW: 30, imageH: 30)
        contactButton.addTarget(self, action: #selector(MPQuCheCCell.contact), for: .touchUpInside)
        navigationButton.addTarget(self, action: #selector(MPQuCheCCell.navigation), for: .touchUpInside)
        
        contentView.addSubview(carTitleLabel)
        contentView.addSubview(carNameLabel)
        contentView.addSubview(addressTitleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(timeTitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contactButton)
        contentView.addSubview(navigationButton)
        
        carTitleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(15)
        }
        carNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(carTitleLabel)
            make.leading.equalTo(carTitleLabel.snp.trailing)
        }
        addressTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(carTitleLabel)
            make.width.equalTo(73)
            make.top.equalTo(carNameLabel.snp.bottom).offset(15)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressTitleLabel)
            make.leading.equalTo(addressTitleLabel.snp.trailing)
            make.trailing.equalTo(contactButton.snp.leading).offset(-5)
        }
        timeTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(carTitleLabel)
            make.width.equalTo(73)
            make.top.equalTo(addressLabel.snp.bottom).offset(15).priority(.high)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeTitleLabel)
            make.leading.equalTo(timeTitleLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-12)
        }
        navigationButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.height.width.equalTo(35)
            make.bottom.equalToSuperview().offset(-30)
        }
        contactButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(35)
            make.trailing.equalTo(navigationButton.snp.leading).offset(-10)
            make.top.equalTo(navigationButton)
        }
    }
    
    @objc fileprivate func contact() {
        delegate?.quCheCellDidSelectContact()
    }
    
    @objc fileprivate func navigation() {
        delegate?.quCheCellDidSelectNavigation()
    }
    
    var addressTitleLabel: UILabel!
    var timeTitleLabel: UILabel!
    var carNameLabel: UILabel!
    var addressLabel: UILabel!
    var timeLabel: UILabel!
    fileprivate var contactButton: MPImageButtonView!
    fileprivate var navigationButton: MPImageButtonView!
}
