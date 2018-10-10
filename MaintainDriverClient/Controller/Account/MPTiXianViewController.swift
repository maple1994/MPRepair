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
    /// 是否选中支付宝
    fileprivate var isSelAplipay: Bool = true
    fileprivate var account: String = ""
    fileprivate var banlance: Double = MPUserModel.shared.balance ?? 0 {
        didSet {
            MPUserModel.shared.balance = banlance
        }
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setpuUI()
        if let account = UserDefaults.standard.object(forKey: MP_ALIPAY_ACCOUNT_KEY) as? String {
            accountTextField.text = account
        }
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
        let label2 = UILabel(font: UIFont.mpSmallFont, text: "支付宝账号", textColor: UIColor.mpDarkGray)
//        accountLabel = UILabel(font: UIFont.mpSmallFont, text: "请添加提现账号", textColor: UIColor.mpLightGary)
//        let arrowLabel = UILabel(font: UIFont.mpSmallFont, text: ">", textColor: UIColor.mpDarkGray)
//        let arrowLabel = UIImageView(image: UIImage(named: "right_arrow"))
        let blockLine = MPUtils.createLine(UIColor.viewBgColor)
//        let control = UIControl()
//        control.addTarget(self, action: #selector(MPTiXianViewController.bindAccount), for: .touchUpInside)
        
        let titleLabel = UILabel(font: UIFont.mpSmallFont, text: "提现金额", textColor: UIColor.mpDarkGray)
        moneyLabel = UILabel(font: UIFont.mpXSmallFont, text: nil, textColor: UIColor.mpLightGary)
        moneyLabel.attributedText = getMoneyAttrStr(banlance)
        allTiXianBtn = UIButton()
        allTiXianBtn.setTitleColor(UIColor.navBlue, for: .normal)
        allTiXianBtn.setTitle("全部提现", for: .normal)
        allTiXianBtn.titleLabel?.font = UIFont.mpSmallFont
        allTiXianBtn.addTarget(self, action: #selector(MPTiXianViewController.allTiXian), for: .touchUpInside)
        textField = MPUnderLineTextField()
        textField.lineColor = UIColor.colorWithHexString("#DCDCDC")
        textField.keyboardType = .decimalPad
        textField.placeholder = "请输入金额"
        textField.font = UIFont.mpBigFont
        textField.leftView = getLeftView()
        textField.leftViewMode = .always
        
        tbHeaderView.addSubview(label2)
        tbHeaderView.addSubview(accountTextField)
//        tbHeaderView.addSubview(arrowLabel)
//        tbHeaderView.addSubview(accountLabel)
//        tbHeaderView.addSubview(control)
        tbHeaderView.addSubview(blockLine)
        tbHeaderView.addSubview(titleLabel)
        tbHeaderView.addSubview(textField)
        tbHeaderView.addSubview(moneyLabel)
        tbHeaderView.addSubview(allTiXianBtn)
        tbHeaderView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 230)
        label2.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        accountTextField.snp.makeConstraints { (make) in
            make.top.equalTo(label2.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(mp_screenW - 30)
            make.height.equalTo(35)
        }
//        control.snp.makeConstraints { (make) in
//            make.height.equalTo(44)
//            make.leading.equalTo(accountLabel)
//            make.top.trailing.equalToSuperview()
//        }
//        arrowLabel.snp.makeConstraints { (make) in
//            make.trailing.equalToSuperview().offset(-15)
//            make.centerY.equalTo(label2)
//            make.width.equalTo(13)
//            make.height.equalTo(13)
//        }
//        accountLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(label2)
//            make.trailing.equalTo(arrowLabel.snp.leading).offset(-3)
//        }
        blockLine.snp.makeConstraints { (make) in
            make.top.equalTo(accountTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(6)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(blockLine.snp.bottom).offset(13)
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
        guard let money = textField.mText.toDouble() else {
            MPTipsView.showMsg("请收入合法的数字")
            return
        }
        if accountTextField.mText.isEmpty {
            MPTipsView.showMsg("请收入支付宝账号")
            return
        }
        if banlance < money {
            MPTipsView.showMsg("余额不足")
            return
        }
        UserDefaults.standard.set(accountTextField.mText, forKey: MP_ALIPAY_ACCOUNT_KEY)
        MPNetword.requestJson(target: .tiXian(money: money, via: "alipay", aliAccunt: accountTextField.mText), success: { (json) in
            self.banlance -= money
            self.moneyLabel.attributedText = self.getMoneyAttrStr(self.banlance)
            MPDialogView.showDialog("提现成功")
        }) { (_) in
//            MPTipsView.showMsg("提现失败")
        }
//        if !textField.mText.isMatchRegularExp("^[0-9]*$") {
//            MPTipsView.showMsg("请收入合法的数字")
//        }
//        guard let money = textField.mText.toDouble() else {
//            MPTipsView.showMsg("请收入合法的数字")
//            return
//        }
//        MPNetword.requestJson(target: .tiXian(money: money, via: "alipay"), success: { (json) in
//            MPTipsView.showMsg("提现成功")
//        }) { (_) in
//            MPTipsView.showMsg("提现失败")
//        }
    }
    
    @objc fileprivate func allTiXian() {
//        MPApiType.tiXian(money: <#T##Double#>, via: <#T##String#>)
//        MPNetword.requestJson(target: <#T##MPApiType#>, success: <#T##((AnyObject) -> Void)?##((AnyObject) -> Void)?##(AnyObject) -> Void#>, failure: <#T##((MoyaError) -> Void)?##((MoyaError) -> Void)?##(MoyaError) -> Void#>)
        textField.text = "\(banlance)"
    }
    
    @objc fileprivate func bindAccount() {
        let vc = MPBingAccountViewController.init {
            self.loadAccount()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func loadAccount() {
        MPNetword.requestJson(target: .getAlipayBindedAccount, success: { (json) in
            if let dic = json["data"] as? [String: Any] {
                let state = dic["state"] as? Bool ?? false
                let name = toString(dic["name"])
                if state && !name.isEmpty {
                    self.account = name
                    self.accountLabel.text = name
                }
            }
        })
    }
    
    // MARK: - View
    fileprivate lazy var accountTextField: UITextField = {
        let tf = MPUnderLineTextField()
        tf.placeholder = "清输入支付宝账号"
        tf.font = UIFont.mpNormalFont
        return tf
    }()
    fileprivate var accountLabel: UILabel!
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
        let cell = MPTiXianToWeChatCell(style: .default, reuseIdentifier: nil)
        cell.icon = UIImage(named: "alipay")
        cell.tips = "提现至支付宝"
        cell.boxSelected = isSelAplipay
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MPUtils.createLine(UIColor.viewBgColor)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isSelAplipay = !isSelAplipay
        tableView.reloadData()
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
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    var tips: String? {
        didSet {
            if let txt = tips {
                let dic1: [NSAttributedStringKey: Any] = [
                    NSAttributedStringKey.font: UIFont.mpNormalFont,
                    NSAttributedStringKey.foregroundColor: UIColor.fontBlack
                ]
                let dic2: [NSAttributedStringKey: Any] = [
                    NSAttributedStringKey.font: UIFont.mpSmallFont,
                    NSAttributedStringKey.foregroundColor: UIColor.priceRed
                ]
                let str1 = NSAttributedString(string: txt, attributes: dic1)
                let str2 = NSAttributedString(string: "(将收取1%手续费)", attributes: dic2)
                let res = NSMutableAttributedString()
                res.append(str1)
                res.append(str2)
                tipLabel.attributedText = res
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
        iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "wechat")
        tipLabel = UILabel(font: UIFont.mpNormalFont, text: nil, textColor: UIColor.fontBlack)
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
        checkBoxIconView.image = UIImage(named: "box_unselected")
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
        let line = MPUtils.createLine()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.4)
        }
    }
    
    fileprivate var iconImageView: UIImageView!
    fileprivate var tipLabel: UILabel!
    fileprivate var checkBoxIconView: UIImageView!

}










