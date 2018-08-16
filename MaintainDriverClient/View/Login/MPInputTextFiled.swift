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
        textColor = UIColor.white
        iconLeftView = MPLeftIconView()
        iconLeftView.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
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
        tintColor = UIColor.white
        line = UIView()
        line.backgroundColor = UIColor.white
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    fileprivate var line: UIView!
}


