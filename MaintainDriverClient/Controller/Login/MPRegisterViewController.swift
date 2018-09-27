//
//  MPRegisterViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/16.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 注册
class MPRegisterViewController: UIViewController {

    fileprivate var isAgree: Bool = true
    fileprivate var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if #available(iOS 11, *) {
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        scrollView = UIScrollView()
        let contentView = UIView()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(mp_screenH)
            make.width.equalTo(mp_screenW)
        }
        scrollView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        let tfH: CGFloat = 44
        let margin: CGFloat = 35
        let titleLabel1 = UILabel(font: UIFont.systemFont(ofSize: 28), text: "您好，", textColor: UIColor.black)
        let titleLabel2 = UILabel(font: UIFont.systemFont(ofSize: 16), text: "欢迎来到8号养车！", textColor: UIColor.colorWithHexString("#4A4A4A"))
        phoneTextField = MPUnderLineTextField()
        phoneTextField.keyboardType = .numberPad
        phoneTextField.textColor = UIColor.colorWithHexString("#0093DD")
        phoneTextField.attributedPlaceholder = getAttributeText("请输入手机号")
        codeTextField = MPUnderLineTextField()
        codeTextField.keyboardType = .numberPad
        codeTextField.textColor = UIColor.colorWithHexString("#0093DD")
        codeTextField.attributedPlaceholder = getAttributeText("请输入验证码")
        pwdTextField = MPUnderLineTextField()
        pwdTextField.keyboardType = .asciiCapable
        pwdTextField.textColor = UIColor.colorWithHexString("#0093DD")
        pwdTextField.attributedPlaceholder = getAttributeText("请输入密码")
        pwdTextField.isSecureTextEntry = true
        
        registerButton = UIButton()
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.setTitle("注册", for: .normal)
        registerButton.adjustsImageWhenHighlighted = false
        registerButton.addTarget(self, action: #selector(MPRegisterViewController.register), for: .touchUpInside)
        registerButton.backgroundColor = UIColor.navBlue
        registerButton.setupCorner(19)
        getCodeButton = MPSendCodeButton(count: 60)
        getCodeButton.delegate = self
        let protocalView = createAgreementView()
        scrollView.addSubview(titleLabel1)
        scrollView.addSubview(titleLabel2)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(codeTextField)
        scrollView.addSubview(pwdTextField)
        scrollView.addSubview(getCodeButton)
        scrollView.addSubview(protocalView)
        scrollView.addSubview(registerButton)
        
        titleLabel1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.top.equalToSuperview().offset(90)
        }
        titleLabel2.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel1)
            make.top.equalTo(titleLabel1.snp.bottom).offset(3)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.height.equalTo(tfH)
            make.top.equalTo(titleLabel2.snp.bottom).offset(84)
        }
        codeTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(phoneTextField)
            make.height.equalTo(tfH)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
        }
        pwdTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(phoneTextField)
            make.height.equalTo(tfH)
            make.top.equalTo(codeTextField.snp.bottom).offset(10)
        }
        protocalView.snp.makeConstraints { (make) in
            make.top.equalTo(pwdTextField.snp.bottom).offset(10)
            make.leading.equalTo(phoneTextField)
            make.height.equalTo(35)
        }
        registerButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(protocalView.snp.bottom).offset(38)
            make.height.equalTo(38)
        }
        getCodeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(codeTextField)
            make.bottom.equalTo(codeTextField.snp.bottom).offset(-8)
            make.height.equalTo(30)
            make.width.equalTo(86)
        }
    }
    
    fileprivate func getAttributeText(_ text: String) -> NSAttributedString {
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.colorWithHexString("#000000", alpha: 0.3),
            NSAttributedStringKey.font: UIFont.mpNormalFont
        ]
        return NSAttributedString(string: text, attributes: dic)
    }
    
    @objc fileprivate func register() {
        if !isValid() {
            return
        }
        if !isAgree {
            MPTipsView.showMsg("请同意用户协议")
            return
        }
        MPNetword.requestJson(target: .register(phone: phoneTextField.mText, pwd: pwdTextField.mText, code: codeTextField.mText), success: { (json) in
            MPTipsView.showMsg("注册成功")
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    /// 检测输入是否合法
    fileprivate func isValid() -> Bool {
        if !phoneTextField.trimText.isMatchRegularExp("1[0-9]{10}$") {
            MPTipsView.showMsg("请输入合法的手机号码")
            return false
        }
        if codeTextField.trimText.isEmpty {
            MPTipsView.showMsg("请输入验证码")
            return false
        }
        if pwdTextField.trimText.isEmpty  {
            MPTipsView.showMsg("请输入密码")
            return false
        }
        return true
    }
    
    @objc fileprivate func checkBoxAction() {
        isAgree = !isAgree
        setupCheckBox()
    }
    
    fileprivate func setupCheckBox() {
        if isAgree {
            checkBoxImgView.image = UIImage(named: "box_selected")
        }else {
            checkBoxImgView.image = UIImage(named: "box_unselected")
        }
    }
    
    @objc fileprivate func agreementAction() {
        agreementView = MPUserAgreementView()
        agreementView.frame = self.view.bounds
        agreementView.startLoadUrl()
        agreementView.isAgreeBlock = { [weak self] (res) in
            self?.isAgree = res
            self?.setupCheckBox()
        }
        self.view.addSubview(agreementView)
    }
    
    /// 设置协议区域View
    fileprivate func createAgreementView() -> UIView {
        checkBoxImgView = UIImageView()
        checkBoxImgView.image = UIImage(named: "box_selected")
        let label1 = UILabel(font: UIFont.mpSmallFont, text: "阅读并同意", textColor: UIColor.colorWithHexString("#000000", alpha: 0.3))
        let label2 = UILabel(font: UIFont.mpSmallFont, text: "《8号养车用户协议》", textColor: UIColor.navBlue)
        let tmpView = UIView()
        tmpView.addSubview(checkBoxImgView)
        tmpView.addSubview(label1)
        tmpView.addSubview(label2)
        checkBoxImgView.snp.makeConstraints { (make) in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        label1.snp.makeConstraints { (make) in
            make.leading.equalTo(checkBoxImgView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
        label2.snp.makeConstraints { (make) in
            make.leading.equalTo(label1.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        let control1 = UIControl()
        let control2 = UIControl()
        control1.addTarget(self, action: #selector(MPRegisterViewController.checkBoxAction), for: .touchUpInside)
        control2.addTarget(self, action: #selector(MPRegisterViewController.agreementAction), for: .touchUpInside)
        tmpView.addSubview(control1)
        tmpView.addSubview(control2)
        control1.snp.makeConstraints { (make) in
            make.leading.equalTo(checkBoxImgView)
            make.trailing.equalTo(label1)
            make.top.bottom.equalToSuperview()
        }
        control2.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(label2)
            make.top.bottom.equalToSuperview()
        }
        return tmpView
    }

    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var phoneTextField: MPUnderLineTextField!
    fileprivate var codeTextField: MPUnderLineTextField!
    fileprivate var pwdTextField: MPUnderLineTextField!
    fileprivate var getCodeButton: MPSendCodeButton!
    fileprivate var registerButton: UIButton!
    fileprivate var agreementView: MPUserAgreementView!
    fileprivate var checkBoxImgView: UIImageView!
}

extension MPRegisterViewController: MPSendCodeButtonDelegate {
    /// 获取验证码
    func getCode() {
        MPNetword.requestJson(target: .sendCode(phone: phoneTextField.text!, type: MPMsgCodeKey.register_driver), success: { (json) in
            MPTipsView.showMsg("发送成功")
            self.getCodeButton.startTimeCount()
        }) { (error) in
            MPPrint(error)
            MPTipsView.showMsg("发送失败，请重新发送")
        }
    }
}
