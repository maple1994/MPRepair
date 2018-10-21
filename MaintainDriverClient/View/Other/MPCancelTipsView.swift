//
//  MPCancelTipsView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/17.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import WebKit

/// 取消订单的提示View
class MPCancelTipsView: UIView {
    
    class func showTipsView(confirmBlock: (() -> Void)?) {
        let tipsView = MPCancelTipsView()
        tipsView.confirmBlock = confirmBlock
        tipsView.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(tipsView)
    }
    
    var confirmBlock: (() -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        webView = WKWebView()
        if let urlStr = UserDefaults.standard.object(forKey: "MP_DRIVER_CANCEL_RULER") as? String {
            if let url = URL.init(string: urlStr) {
                let requset = URLRequest(url: url)
                webView.load(requset)
            }
        }
        titleLabel = UILabel(font: UIFont.mpBigFont, text: "扣费标准", textColor: UIColor.white)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.navBlue
//        contentLabel = UILabel(font: UIFont.mpSmallFont, text: "1.离取车时间24小时以上，扣取20%的手续费\n2.离取车时间12-24小时以上，扣取30%的手续费\n3.离取车时间12小时以内，扣取30%的手续费", textColor: UIColor.mpDarkGray)
//        contentLabel.numberOfLines = 0
        cancelButton = UIButton()
        cancelButton.setTitle("我再想想", for: .normal)
        cancelButton.setTitleColor(UIColor.colorWithHexString("#9b9b9b"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.mpSmallFont
        cancelButton.addTarget(self, action: #selector(MPCancelTipsView.cancel), for: .touchUpInside)
        confirmButotn = UIButton()
        confirmButotn.setTitle("确认取消", for: .normal)
        confirmButotn.titleLabel?.font = UIFont.mpSmallFont
        confirmButotn.setTitleColor(UIColor.navBlue, for: .normal)
        confirmButotn.addTarget(self, action: #selector(MPCancelTipsView.confirm), for: .touchUpInside)
        let line1 = MPUtils.createLine()
        let line2 = MPUtils.createLine()
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        addSubview(contentView)
        contentView.addSubview(titleLabel)
//        contentView.addSubview(contentLabel)
        contentView.addSubview(webView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(confirmButotn)
        contentView.addSubview(line1)
        contentView.addSubview(line2)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
//        contentLabel.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(15)
//            make.trailing.equalToSuperview().offset(-15)
//            make.top.equalTo(titleLabel.snp.bottom).offset(15)
//        }
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(webView.snp.bottom).offset(0)
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        confirmButotn.snp.makeConstraints { (make) in
            make.height.width.equalTo(cancelButton)
            make.trailing.bottom.equalToSuperview()
            make.leading.equalTo(cancelButton.snp.trailing)
        }
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(cancelButton)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        line2.snp.makeConstraints { (make) in
            make.leading.equalTo(cancelButton.snp.trailing)
            make.top.bottom.equalTo(cancelButton)
            make.width.equalTo(1)
        }
    }
    
    @objc fileprivate func cancel() {
        removeFromSuperview()
    }
    
    @objc fileprivate func confirm() {
        confirmBlock?()
        removeFromSuperview()
    }
    
    fileprivate var contentView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var contentLabel: UILabel!
    fileprivate var cancelButton: UIButton!
    fileprivate var confirmButotn: UIButton!
    fileprivate var webView: WKWebView!
}









