//
//  MPFooterConfirmView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 底部确认按钮View
class MPFooterConfirmView: UIView {
    init(title: String, target: Any?, action: Selector) {
        let rect = CGRect(x: 0, y: 0, width: mp_screenW, height: 150)
        super.init(frame: rect)
        confrimButton = UIButton()
        confrimButton.setTitle(title, for: .normal)
        confrimButton.backgroundColor = UIColor.navBlue
        confrimButton.setTitleColor(UIColor.white, for: .normal)
        confrimButton.addTarget(target, action: action, for: .touchUpInside)
        confrimButton.setupCorner(5)
        
        addSubview(confrimButton)
        confrimButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    fileprivate var confrimButton: UIButton!
}
