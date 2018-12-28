//
//  MPInsuranceViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPInsuranceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "购买保险"
        setupUI()
    }
    
    fileprivate func setupUI() {
        buyButton = UIButton()
        buyButton.backgroundColor = UIColor.colorWithHexString("#FF8A4E")
        buyButton.setTitleColor(UIColor.white, for: .normal)
        buyButton.setTitle("立即投保", for: .normal)
        buyButton.titleLabel?.font = UIFont.mpNormalFont
        buyButton.addTarget(self, action: #selector(MPInsuranceViewController.buy), for: .touchUpInside)
        priceLabel = UILabel(font: UIFont.mpNormalFont, text: "￥553.00/年", textColor: UIColor.colorWithHexString("#FF8A4E"))
        let priceTitLabel = UILabel(font: UIFont.mpNormalFont, text: "总计：", textColor: UIColor.colorWithHexString("#333333"))
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        bottomView.addSubview(buyButton)
        bottomView.addSubview(priceLabel)
        bottomView.addSubview(priceTitLabel)
        view.addSubview(bottomView)
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
    
    @objc fileprivate func buy() {
        MPPrint("购买")
    }
    
    fileprivate var buyButton: UIButton!
    fileprivate var priceLabel: UILabel!
}
