//
//  MPProcessView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/26.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 显示报名流程的View
class MPProcessView: UIView {
    
    func setupSelectIndex(_ index: Int) {
        if index == 0 {
            numLabel1.backgroundColor = UIColor.navBlue
            numLabel2.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
            numLabel3.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
        }else if index == 1 {
            numLabel2.backgroundColor = UIColor.navBlue
            numLabel1.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
            numLabel3.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
        }else {
            numLabel3.backgroundColor = UIColor.navBlue
            numLabel2.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
            numLabel1.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
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
        backgroundColor = UIColor.white
        
        numLabel1 = UILabel(font: UIFont.systemFont(ofSize: 18), text: "1", textColor: UIColor.white)
        numLabel2 = UILabel(font: UIFont.systemFont(ofSize: 18), text: "2", textColor: UIColor.white)
        numLabel3 = UILabel(font: UIFont.systemFont(ofSize: 18), text: "3", textColor: UIColor.white)
        numLabel1.textAlignment = .center
        numLabel2.textAlignment = .center
        numLabel3.textAlignment = .center
        numLabel1.backgroundColor = UIColor.navBlue
        numLabel2.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
        numLabel3.backgroundColor = UIColor.colorWithHexString("#C4E6FF")
        titleLabel1 = UILabel(font: UIFont.mpXSmallFont, text: "填写基本信息", textColor: UIColor.colorWithHexString("#4A4A4A"))
        titleLabel2 = UILabel(font: UIFont.mpXSmallFont, text: "上传证件信息", textColor: UIColor.colorWithHexString("#4A4A4A"))
        titleLabel3 = UILabel(font: UIFont.mpXSmallFont, text: "填写工作信息", textColor: UIColor.colorWithHexString("#4A4A4A"))
        let line1 = UIView()
        line1.backgroundColor = UIColor.mpLightGary
        let line2 = UIView()
        line2.backgroundColor = UIColor.mpLightGary
        
        numLabel1.setupCorner(13)
        numLabel2.setupCorner(13)
        numLabel3.setupCorner(13)
        addSubview(numLabel1)
        addSubview(numLabel2)
        addSubview(numLabel3)
        addSubview(titleLabel1)
        addSubview(titleLabel2)
        addSubview(titleLabel3)
        addSubview(line1)
        addSubview(line2)
        
        numLabel1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(26)
        }
        numLabel2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(numLabel1)
            make.width.height.equalTo(26)
        }
        numLabel3.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-50)
            make.top.equalTo(numLabel1)
            make.width.height.equalTo(26)
        }
        titleLabel1.snp.makeConstraints { (make) in
            make.centerX.equalTo(numLabel1)
            make.top.equalTo(numLabel1.snp.bottom).offset(8)
        }
        titleLabel2.snp.makeConstraints { (make) in
            make.centerX.equalTo(numLabel2)
            make.top.equalTo(numLabel2.snp.bottom).offset(8)
        }
        titleLabel3.snp.makeConstraints { (make) in
            make.centerX.equalTo(numLabel3)
            make.top.equalTo(numLabel3.snp.bottom).offset(8)
        }
        line1.snp.makeConstraints { (make) in
            make.centerY.equalTo(numLabel1)
            make.leading.equalTo(numLabel1.snp.trailing)
            make.trailing.equalTo(numLabel2.snp.leading)
            make.height.equalTo(0.5)
        }
        line2.snp.makeConstraints { (make) in
            make.centerY.equalTo(numLabel1)
            make.leading.equalTo(numLabel2.snp.trailing)
            make.trailing.equalTo(numLabel3.snp.leading)
            make.height.equalTo(0.5)
        }
    }
    
    fileprivate var numLabel1: UILabel!
    fileprivate var numLabel2: UILabel!
    fileprivate var numLabel3: UILabel!
    fileprivate var titleLabel1: UILabel!
    fileprivate var titleLabel2: UILabel!
    fileprivate var titleLabel3: UILabel!
}
