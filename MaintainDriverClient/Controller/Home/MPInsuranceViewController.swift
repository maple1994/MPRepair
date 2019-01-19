//
//  MPInsuranceViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import WebKit


class MPInsuranceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "购买保险"
        setupUI()
        loadData()
    }
    
    fileprivate func setupUI() {
        webView = WKWebView(frame: CGRect.zero)
        buyButton = UIButton()
        buyButton.backgroundColor = UIColor.colorWithHexString("#FF8A4E")
        buyButton.setTitleColor(UIColor.white, for: .normal)
        buyButton.setTitle("立即投保", for: .normal)
        buyButton.titleLabel?.font = UIFont.mpNormalFont
        buyButton.addTarget(self, action: #selector(MPInsuranceViewController.buy), for: .touchUpInside)
        priceLabel = UILabel(font: UIFont.mpNormalFont, text: "--", textColor: UIColor.colorWithHexString("#FF8A4E"))
        let priceTitLabel = UILabel(font: UIFont.mpNormalFont, text: "总计：", textColor: UIColor.colorWithHexString("#333333"))
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        bottomView.addSubview(buyButton)
        bottomView.addSubview(priceLabel)
        bottomView.addSubview(priceTitLabel)
        view.addSubview(webView)
        view.addSubview(bottomView)
        webView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(52)
        }
        buyButton.snp.makeConstraints { (make) in
            make.trailing.bottom.top.equalToSuperview()
            make.width.equalTo(124)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(buyButton.snp.leading).offset(-18)
            make.centerY.equalToSuperview()
        }
        priceTitLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(priceLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
    
    fileprivate func loadData() {
        MPNetword.requestJson(target: .getInsurance, success: { json in
            guard let data = json["data"] as? [String: Any] else {
                return
            }
            let urlStr = toString(data["url"])
            let price = toDouble(data["price"])
            if let url = URL(string: urlStr) {
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
            self.priceLabel.text = String(format: "￥%.02f/年", price)
        })
    }
    
    @objc fileprivate func buy() {
        MPNetword.requestJson(target: .payInsurance(method: "alipay"), success: {json in
            guard let data = json["data"] as? [String: Any] else {
                return
            }
            let param = toString(data["params"])
            AlipaySDK.defaultService()?.payOrder(param, fromScheme: "commayidriverclient", callback: { (dic) in
                if let dic1 = dic {
                    print(dic1)
                }
            })
        })
    }
    
    fileprivate var webView: WKWebView!
    fileprivate var buyButton: UIButton!
    fileprivate var priceLabel: UILabel!
}
