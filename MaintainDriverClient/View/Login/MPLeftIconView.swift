//
//  MPLeftIconView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPLeftIconView: UIView {
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
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
        iconImageView = UIImageView()
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        let line = UIView()
        line.backgroundColor = UIColor.white
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(15)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
        }
    }
    
    fileprivate var iconImageView: UIImageView!
}
