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
    fileprivate weak var timer: Timer?
    fileprivate var time: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付订单"
        setupTbHeader()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer?.invalidate()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    fileprivate func loadData() {
        MPNetword.requestJson(target: .payInsurance(method: "create", order_method: ""), success: {json in
            guard let data = json["data"] as? [String: Any] else {
                return
            }
            let time = toInt(data["time"])
            self.time = time
            self.startTimer()
            let orderCode = toString(data["order_code"])
            let price = toDouble(data["price"])
            self.priceLabel.text = String(format: "￥%.02f", price)
            self.orderLabel.text = "订单编号：\(orderCode)"
        })
    }
    
    fileprivate func startTimer() {
        if time == 0 {
            return
        }
        self.timer?.invalidate()
        timeLabel.text = getDateStr(time)
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(MPPaymentViewController.countDown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        self.timer = timer
    }
    
    fileprivate func getDateStr(_ time: Int) -> String? {
        let df = DateFormatter()
        df.dateFormat = "mm:ss"
        guard let date = df.date(from: "00:00") else {
            return nil
        }
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: Calendar.Component.second, value: time, to: date) else {
            return nil
        }
        return df.string(from: newDate)
    }
    
    @objc fileprivate func countDown() {
        time -= 1
        if time <= 0 {
            timer?.invalidate()
            timeLabel.text = "00:00"
        }else {
            timeLabel.text = getDateStr(time)
        }
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
        let order = isCheckAlipay ? "alipay" : "weixin"
        MPNetword.requestJson(target: .payInsurance(method: "pay", order_method: order), success: {json in
            guard let data = json["data"] as? [String: Any] else {
                return
            }
            let param = toString(data["params"])
            if self.isCheckAlipay {
                self.alipy(param)
            }else {
                self.wechat(param)
            }
        })
    }
    
    fileprivate func alipy(_ param: String) {
        AlipaySDK.defaultService()?.payOrder(param, fromScheme: "commayidriverclient", callback: { (dic) in
            if let dic1 = dic {
                print(dic1)
            }
        })
    }
    
    fileprivate func wechat(_ param: String) {
        
    }
    
    // MARK: - View
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
