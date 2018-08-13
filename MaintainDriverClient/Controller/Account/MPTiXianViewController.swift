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
    /// 是否提现微信
    fileprivate var isToWeChat: Bool = false
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
        tableView.rowHeight = 50
        
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
        let titleLabel = UILabel(font: UIFont.mpSmallFont, text: "提现金额", textColor: UIColor.mpDarkGray)
        let moneyLabel = UILabel(font: UIFont.mpXSmallFont, text: nil, textColor: UIColor.mpLightGary)
        moneyLabel.attributedText = getMoneyAttrStr(0.00)
        allTiXianBtn = UIButton()
        allTiXianBtn.setTitleColor(UIColor.navBlue, for: .normal)
        allTiXianBtn.setTitle("全部提现", for: .normal)
        allTiXianBtn.titleLabel?.font = UIFont.mpSmallFont
        allTiXianBtn.addTarget(self, action: #selector(MPTiXianViewController.allTiXian), for: .touchUpInside)
        textField = MPUnderLineTextField()
        textField.lineColor = UIColor.colorWithHexString("#DCDCDC")
        textField.placeholder = "请输入金额"
        textField.font = UIFont.mpBigFont
        textField.leftView = getLeftView()
        textField.leftViewMode = .always
        
        tbHeaderView.addSubview(titleLabel)
        tbHeaderView.addSubview(textField)
        tbHeaderView.addSubview(moneyLabel)
        tbHeaderView.addSubview(allTiXianBtn)
        tbHeaderView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 125)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalTo(mp_screenW - 30)
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
            NSAttributedStringKey.font: UIFont.mpXSmallFont,
            NSAttributedStringKey.foregroundColor: UIColor.mpLightGary
        ]
        let dic2: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.mpXSmallFont,
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
        if let cell = tableView.cellForRow(at: indexPath) as? MPTiXianToWeChatCell {
            cell.boxSelected = !cell.boxSelected
            isToWeChat = cell.boxSelected
        }
    }
}

class MPTiXianToWeChatCell: UITableViewCell {
    
    /// 单选按钮的选中状态
    var boxSelected: Bool = false {
        didSet {
            if boxSelected {
                checkBoxIconView.image = #imageLiteral(resourceName: "box_selected")
            }else {
                checkBoxIconView.image = #imageLiteral(resourceName: "box_unselected")
            }
        }
    }
    
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
        let tipLabel = UILabel(font: UIFont.mpNormalFont, text: nil, textColor: UIColor.fontBlack)
        let dic1: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.mpNormalFont,
            NSAttributedStringKey.foregroundColor: UIColor.fontBlack
        ]
        let dic2: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.mpSmallFont,
            NSAttributedStringKey.foregroundColor: UIColor.priceRed
        ]
        let str1 = NSAttributedString(string: "提现至微信", attributes: dic1)
        let str2 = NSAttributedString(string: "(将收取1%手续费)", attributes: dic2)
        let res = NSMutableAttributedString()
        res.append(str1)
        res.append(str2)
        tipLabel.attributedText = res
        checkBoxIconView = UIImageView()
        checkBoxIconView.image = #imageLiteral(resourceName: "box_unselected")
        contentView.addSubview(iconImageView)
        contentView.addSubview(tipLabel)
        contentView.addSubview(checkBoxIconView)
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        checkBoxIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(18)
        }
    }
    
    fileprivate var checkBoxIconView: UIImageView!

}










