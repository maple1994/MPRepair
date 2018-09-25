//
//  MPAuthorityTipView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/25.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 权限提示View
class MPAuthorityTipView: UIView {

    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    deinit {
        MPPrint("MPAuthorityTipView deinit")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.2)
        setupSuccView()
        setupFailView()
        addSubview(succView)
        addSubview(failView)
        succView.isHidden = true
        failView.isHidden = false
        
        succView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(216)
        }
        failView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(204)
        }
    }
    
    @objc fileprivate func dimiss() {
        removeFromSuperview()
    }
    
    @objc fileprivate func peiXun() {
        succView.isHidden = false
        failView.isHidden = true
    }
    
    fileprivate func setupSuccView() {
        succView = UIView()
        succView.backgroundColor = UIColor.white
        succView.layer.cornerRadius = 4
        
        succView = UIView()
        succView.backgroundColor = UIColor.white
        succView.layer.cornerRadius = 4
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "authority_tip")
        let titleLabel = UILabel(font: UIFont.mpSmallFont, text: "恭喜您，预约培训成功！", textColor: UIColor.mpDarkGray)
        let subTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "我们将会在1-2个工作日内联系您", textColor: UIColor.mpLightGary)
        let confirmButton = UIButton()
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = UIColor.navBlue
        confirmButton.titleLabel?.font = UIFont.mpNormalFont
        confirmButton.layer.cornerRadius = 4
        confirmButton.addTarget(self, action: #selector(MPAuthorityTipView.dimiss), for: .touchUpInside)
        
        succView.addSubview(iconImageView)
        succView.addSubview(titleLabel)
        succView.addSubview(subTitleLabel)
        succView.addSubview(confirmButton)
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
            make.width.equalTo(84)
            make.height.equalTo(79)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(14)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitleLabel.snp.bottom).offset(18)
            make.width.equalTo(110)
            make.height.equalTo(30)
        }
    }
    
    fileprivate func setupFailView() {
        failView = UIView()
        failView.backgroundColor = UIColor.white
        failView.layer.cornerRadius = 4
        
         let iconImageView = UIImageView()
         iconImageView.image = UIImage(named: "authority_tip")
         let titleLabel = UILabel(font: UIFont.mpSmallFont, text: "很抱歉，您需要培训后才能使用软件", textColor: UIColor.mpDarkGray)
         let cancelButton = UIButton()
         cancelButton.setTitle("暂不需要", for: .normal)
         cancelButton.setTitleColor(UIColor.colorWithHexString("9b9b9b"), for: .normal)
         cancelButton.titleLabel?.font = UIFont.mpSmallFont
         let peiXunButton = UIButton()
         peiXunButton.setTitle("我要培训", for: .normal)
         peiXunButton.setTitleColor(UIColor.navBlue, for: .normal)
         peiXunButton.titleLabel?.font = UIFont.mpSmallFont
         peiXunButton.addTarget(self, action: #selector(MPAuthorityTipView.peiXun), for: .touchUpInside)
         cancelButton.addTarget(self, action: #selector(MPAuthorityTipView.dimiss), for: .touchUpInside)
        let line1 = MPUtils.createLine()
        let line2 = MPUtils.createLine()
        
        failView.addSubview(iconImageView)
        failView.addSubview(titleLabel)
        failView.addSubview(cancelButton)
        failView.addSubview(peiXunButton)
        failView.addSubview(line1)
        failView.addSubview(line2)
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(23)
            make.width.equalTo(84)
            make.height.equalTo(79)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(19)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(peiXunButton)
            make.height.equalTo(44)
            make.trailing.equalTo(peiXunButton.snp.leading)
        }
        peiXunButton.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(cancelButton)
            make.height.equalTo(44)
        }
        line1.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(cancelButton)
            make.height.equalTo(1)
        }
        line2.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalTo(peiXunButton)
            make.width.equalTo(1)
        }
    }
    
    fileprivate var succView: UIView!
    fileprivate var failView: UIView!
}
