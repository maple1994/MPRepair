//
//  MPDialogView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 弹窗View
class MPDialogView: UIView {
    
    class func showDialog(_ txt: String) {
        let view = MPDialogView()
        view.text = txt
        view.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    var text: String? {
        didSet {
            titleLabel.text = text
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
        backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 20), text: "提现成功！", textColor: UIColor.mpDarkGray)
        titleLabel.numberOfLines = 0
        confirmButton = UIButton()
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(MPDialogView.confirmAction), for: .touchUpInside)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmButton.layer.cornerRadius = 4
        confirmButton.backgroundColor = UIColor.navBlue
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(confirmButton)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(150)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(39)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-25)
            make.width.equalTo(110)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc fileprivate func confirmAction() {
        removeFromSuperview()
    }
    
    fileprivate var contentView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var confirmButton: UIButton!
}
