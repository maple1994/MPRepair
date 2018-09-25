//
//  MPUserAgreement.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/25.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import WebKit

/// 用户协议View
class MPUserAgreementView: UIView {
    
    class func show() {
        let view = MPUserAgreementView()
        view.frame = UIScreen.main.bounds
        view.startLoadUrl()
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    func startLoadUrl() {
        let url = URL(string: "http://www.nolasthope.cn/system/useragreement/")!
        let req = URLRequest(url: url)
        webView.load(req)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let titleLabel = UILabel(font: UIFont.mpNormalFont, text: "用户协议", textColor: UIColor.black)
        webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        let disagreeButton = UIButton()
        let agreeButton = UIButton()
        disagreeButton.setTitle("不同意", for: .normal)
        disagreeButton.titleLabel?.font = UIFont.mpSmallFont
        disagreeButton.setTitleColor(UIColor.colorWithHexString("9b9b9b"), for: .normal)
        agreeButton.setTitle("同意并继续", for: .normal)
        agreeButton.titleLabel?.font = UIFont.mpSmallFont
        agreeButton.addTarget(self, action: #selector(MPUserAgreementView.agreeAction), for: .touchUpInside)
        agreeButton.setTitleColor(UIColor.navBlue, for: .normal)
        disagreeButton.addTarget(self, action: #selector(MPUserAgreementView.disagreeAction), for: .touchUpInside)
        let line1 = MPUtils.createLine()
        let line2 = MPUtils.createLine()
        contentView = UIView()
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = UIColor.white
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(webView)
        contentView.addSubview(disagreeButton)
        contentView.addSubview(agreeButton)
        contentView.addSubview(line1)
        contentView.addSubview(line2)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(308)
            make.height.equalTo(444)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.bottom.equalTo(disagreeButton.snp.top).offset(-14)
        }
        disagreeButton.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(agreeButton)
            make.height.equalTo(50)
            make.trailing.equalTo(agreeButton.snp.leading)
        }
        agreeButton.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(agreeButton)
            make.height.equalTo(50)
        }
        line1.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(disagreeButton)
            make.height.equalTo(1)
        }
        line2.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalTo(agreeButton)
            make.width.equalTo(1)
        }
    }
    
    @objc fileprivate func disagreeAction() {
        print("不同意")
        removeFromSuperview()
    }
    
    @objc fileprivate func agreeAction() {
        print("同意")
        removeFromSuperview()
    }
    
    fileprivate var webView: WKWebView!
    fileprivate var contentView: UIView!
}
