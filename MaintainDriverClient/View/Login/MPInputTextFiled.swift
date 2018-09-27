//
//  MPInputTextFiled.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 登录的输入框
class MPInputTextFiled: MPUnderLineTextField {
    
    var leftIcon: UIImage? {
        didSet {
            iconLeftView.icon = leftIcon
        }
    }
    
    override init() {
        super.init()
        textColor = UIColor.colorWithHexString("#0093DD")
        iconLeftView = MPLeftIconView()
        iconLeftView.frame = CGRect(x: 0, y: 0, width: 48, height: 44)
        leftView = iconLeftView
        leftViewMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate var iconLeftView: MPLeftIconView!
}

/// 底部一条横线的textFiled
class MPUnderLineTextField: UITextField {
    var lineColor: UIColor? {
        didSet {
            line.backgroundColor = lineColor
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
        font = UIFont.mpNormalFont
        borderStyle = .none
        tintColor = UIColor.colorWithHexString("#0093DD")
        line = UIView()
        line.backgroundColor = UIColor.colorWithHexString("#0093DD", alpha: 0.1)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    fileprivate var line: UIView!
}


