//
//  MPTiXianViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 提现界面
class MPTiXianViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setpuUI()
    }
    
    fileprivate func setpuUI() {
        navigationItem.title = "我的账号"
        view.backgroundColor = UIColor.viewBgColor
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 54
        
        confirmButton = UIButton()
        confirmButton.addTarget(self, action: #selector(MPTiXianViewController.confirm), for: .touchUpInside)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setTitle("确认提现", for: .normal)
        confirmButton.setupCorner(5)
        confirmButton.backgroundColor = UIColor.navBlue
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(tableView)
        view.addSubview(confirmButton)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35)
            make.width.equalTo(170)
            make.height.equalTo(44)
        }
        let tbHeaderView = UIView()
        tbHeaderView.backgroundColor = UIColor.white
        let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "提现金额", textColor: UIColor.darkGray)
        let moneyLabel = UILabel(font: UIFont.systemFont(ofSize: 13), text: nil, textColor: UIColor.lightGray)
        moneyLabel.attributedText = getMoneyAttrStr(0.00)
        allTiXianBtn = UIButton()
        allTiXianBtn.setTitleColor(UIColor.navBlue, for: .normal)
        allTiXianBtn.setTitle("全部提现", for: .normal)
        allTiXianBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        allTiXianBtn.addTarget(self, action: #selector(MPTiXianViewController.allTiXian), for: .touchUpInside)
        textField = MPUnderLineTextField()
        textField.lineColor = UIColor.colorWithHexString("#DCDCDC")
        textField.placeholder = "请输入金额"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.leftView = getLeftView()
        textField.leftViewMode = .always
        
        tbHeaderView.addSubview(titleLabel)
        tbHeaderView.addSubview(textField)
        tbHeaderView.addSubview(moneyLabel)
        tbHeaderView.addSubview(allTiXianBtn)
        tbHeaderView.frame = CGRect(x: 0, y: 0, width: MPUtils.screenW, height: 125)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalTo(MPUtils.screenW - 30)
            make.height.equalTo(44)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
        allTiXianBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(textField.snp.bottom).offset(3)
        }
        tableView.tableHeaderView = tbHeaderView
    }
    
    /// 创建leftView
    fileprivate func getLeftView() -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = "¥"
        label.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
        return view
    }
    
    /// 转为富文本
    fileprivate func getMoneyAttrStr(_ money: Double) -> NSAttributedString {
        let dic1: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
        ]
        let dic2: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13),
            NSAttributedStringKey.foregroundColor: UIColor.priceRed
        ]
        let str1 = NSAttributedString(string: "可提现余额", attributes: dic1)
        let str2 = NSAttributedString(string: String(format: " %.2f ", money), attributes: dic2)
        let str3 = NSAttributedString(string: "元", attributes: dic1)
        let res = NSMutableAttributedString()
        res.append(str1)
        res.append(str2)
        res.append(str3)
        return res
    }
    
    @objc fileprivate func confirm() {
        print("确认提现")
    }
    
    @objc fileprivate func allTiXian() {
        print("全部提现")
    }
    
    fileprivate var tableView: UITableView!
    fileprivate var tiXianBtn: UIButton!
    fileprivate var moneyLabel: UILabel!
    fileprivate var allTiXianBtn: UIButton!
    fileprivate var confirmButton: UIButton!
    fileprivate var textField: MPUnderLineTextField!
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPTiXianViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPTiXianToWeChatCell") as? MPTiXianToWeChatCell
        if cell == nil {
            cell = MPTiXianToWeChatCell(style: .default, reuseIdentifier: "MPTiXianToWeChatCell")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MPUtils.createLine(UIColor.viewBgColor)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("check box")
    }
}

class MPTiXianToWeChatCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let iconImageView = UIImageView()
        iconImageView.image = #imageLiteral(resourceName: "wechat")
        let tipLabel = UILabel(font: UIFont.systemFont(ofSize: 17), text: nil, textColor: UIColor.black)
        let dic1: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        let dic2: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: UIColor.priceRed
        ]
        let str1 = NSAttributedString(string: "提现至微信", attributes: dic1)
        let str2 = NSAttributedString(string: "(将收取1%手续费)", attributes: dic2)
        let res = NSMutableAttributedString()
        res.append(str1)
        res.append(str2)
        tipLabel.attributedText = res
        let checkBoxIcon = UIImageView()
        checkBoxIcon.image = #imageLiteral(resourceName: "box_unselected")
        contentView.addSubview(iconImageView)
        contentView.addSubview(tipLabel)
        contentView.addSubview(checkBoxIcon)
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        checkBoxIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
    }

}










