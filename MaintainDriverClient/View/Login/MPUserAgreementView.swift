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
    
    func startLoadUrl() {
        func loadWebViewUrl(_ urlString: String) {
            guard let url = URL(string: urlString) else {
                return
            }
            let req = URLRequest(url: url)
            webView.load(req)
        }
        func handleFailedEvent() {
            guard let str = UserDefaults.standard.object(forKey: "MP_GET_USER_AGREEMENT_URL_KEY") as? String else {
                return
            }
            loadWebViewUrl(str)
        }
        MPNetword.requestJson(target: .getUserAgreement, success: { (json) in
            guard let data = json["data"] as? [String: Any] else {
                handleFailedEvent()
                return
            }
            guard let url = data["url"] as? String else {
                handleFailedEvent()
                return
            }
            if !url.isEmpty {
                UserDefaults.standard.set(url, forKey: "MP_GET_USER_AGREEMENT_URL_KEY")
                loadWebViewUrl(url)
            }
        }) { (_) in
            handleFailedEvent()
        }
    }

    var isAgreeBlock: ((Bool) -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    deinit {
        MPPrint("协议View销毁了")
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
        isHidden = true
        isAgreeBlock?(false)
    }
    
    @objc fileprivate func agreeAction() {
        isHidden = true
        isAgreeBlock?(true)
    }
    
    fileprivate var webView: WKWebView!
    fileprivate var contentView: UIView!
}
