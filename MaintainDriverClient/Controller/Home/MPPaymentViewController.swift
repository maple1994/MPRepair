//
//  MPPaymentViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2019/1/21.
//  Copyright © 2019年 Maple. All rights reserved.
//

import UIKit

/// 支付页面
class MPPaymentViewController: UITableViewController {
    
    fileprivate var isCheckAlipay: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付订单"
        setupTbHeader()
    }
    
    fileprivate func setupTbHeader() {
        let tbHeader = UIView()
        tbHeader.backgroundColor = UIColor.white
        let label1 = UILabel(font: UIFont.systemFont(ofSize: 16), text: "支付剩余时间：", textColor: UIColor.mpLightGary)
        timeLabel = UILabel(font: UIFont.mpNormalFont, text: "00:00", textColor: UIColor.mpLightGary)
        priceLabel = UILabel(font: UIFont.systemFont(ofSize: 26), text: "￥200", textColor: UIColor.red)
        orderLabel = UILabel(font: UIFont.mpNormalFont, text: "订单编号：XXXXXXXX", textColor: UIColor.mpLightGary)
        orderLabel.textAlignment = .center
        let block = MPUtils.createLine(UIColor.viewBgColor)
        tbHeader.addSubview(label1)
        tbHeader.addSubview(timeLabel)
        tbHeader.addSubview(priceLabel)
        tbHeader.addSubview(orderLabel)
        tbHeader.addSubview(block)
        tbHeader.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 125)
        
        label1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(label1.snp.trailing)
            make.centerY.equalTo(label1)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
        }
        orderLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(priceLabel.snp.bottom).offset(15)
        }
        block.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
        tableView.tableHeaderView = tbHeader
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.backgroundColor = UIColor.viewBgColor
        let h: CGFloat = mp_screenH - 84 - 125 - 100
        let footerView = MPFooterConfirmView(title: "确认支付", target: self, action: #selector(MPPaymentViewController.confirm))
        footerView.frame.size.height = h
        tableView.tableFooterView = footerView
    }
    
    @objc fileprivate func confirm() {
        
    }
    
    fileprivate var timeLabel: UILabel!
    fileprivate var orderLabel: UILabel!
    fileprivate var priceLabel: UILabel!
    fileprivate var confirmButton: UIButton!
}

extension MPPaymentViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MPTiXianToWeChatCell(style: .default, reuseIdentifier: nil)
        if indexPath.row == 0 {
            cell.icon = UIImage(named: "wechat")
            cell.boxSelected = !isCheckAlipay
            cell.normalTitle = "微信支付"
        }else {
            cell.icon = UIImage(named: "alipay")
            cell.boxSelected = isCheckAlipay
            cell.normalTitle = "支付宝支付"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            isCheckAlipay = false
        }else {
            isCheckAlipay = true
        }
        tableView.reloadData()
    }
}
