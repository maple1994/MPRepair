//
//  MPNewOrderTipsView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 提示新订单View
class MPNewOrderTipsView: UIView {
    class func show() {
        let view = MPNewOrderTipsView()
        view.frame = CGRect(x: 0, y: 0, width: MPUtils.screenW, height: MPUtils.screenH)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let effect = UIBlurEffect.init(style: .light)
        let visualView = UIVisualEffectView(effect: effect)
        addSubview(visualView)
        visualView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 20), text: "您有新的订单！", textColor: UIColor.navBlue)
        let subTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "请及时处理！", textColor: UIColor.darkGray)
        dismissButton = UIButton()
        dismissButton.setTitle("X", for: .normal)
        dismissButton.setTitleColor(UIColor.black, for: .normal)
        dismissButton.addTarget(self, action: #selector(MPNewOrderTipsView.dismiss), for: .touchUpInside)
        confirmButton = UIButton()
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = UIColor.navBlue
        confirmButton.addTarget(self, action: #selector(MPNewOrderTipsView.confirm), for: .touchUpInside)
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
//        contentView.setupCorner(10)
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.navBlue.cgColor
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(dismissButton)
        contentView.addSubview(confirmButton)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(250)
        }
        dismissButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(35)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dismissButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-25)
        }
        confirmButton.setupCorner(10)
    }
    
    @objc fileprivate func dismiss() {
        removeFromSuperview()
    }
    
    @objc fileprivate func confirm() {
        removeFromSuperview()
    }
    
    fileprivate var dismissButton: UIButton!
    fileprivate var confirmButton: UIButton!
    fileprivate var contentView: UIView!
}








