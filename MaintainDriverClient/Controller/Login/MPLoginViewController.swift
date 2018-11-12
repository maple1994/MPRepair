//
//  MPLoginViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Moya
import IQKeyboardManagerSwift

class MPLoginViewController: UIViewController {
    
    fileprivate var isAgree: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if #available(iOS 11, *) {
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        readAccountInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    /// 读取用户账户信息
    fileprivate func readAccountInfo() {
        guard
            let account = UserDefaults.standard.object(forKey: MP_USER_ACCOUNT_KEY) as? String,
            let pwd = UserDefaults.standard.object(forKey: MP_USER_PWD_KEY) as? String else {
                return
        }
        phoneTextField.text = account
        pwdTextField.text = pwd
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        scrollView = UIScrollView()
        scrollView.delegate = self
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
        // 布局子内容
        let tfH: CGFloat = 44
        let margin: CGFloat = 35
        logoView = UIImageView(image: UIImage(named: "logo"))
        phoneTextField = MPInputTextFiled()
        phoneTextField.keyboardType = .numberPad
        phoneTextField.attributedPlaceholder = getAttributeText("请输入手机号")
        phoneTextField.leftIcon = UIImage(named: "mobile")
        pwdTextField = MPInputTextFiled()
        pwdTextField.keyboardType = .asciiCapable
        pwdTextField.attributedPlaceholder = getAttributeText("请输入密码")
        pwdTextField.isSecureTextEntry = true
        pwdTextField.leftIcon = UIImage(named: "pwd")
        loginButton = UIButton()
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitle("登录", for: .normal)
        loginButton.adjustsImageWhenHighlighted = false
        loginButton.addTarget(self, action: #selector(MPLoginViewController.login), for: .touchUpInside)
        loginButton.backgroundColor = UIColor.navBlue
        loginButton.setupCorner(19)
        resetPwdButton = UIButton()
        resetPwdButton.setTitle("忘记密码？", for: .normal)
        resetPwdButton.setTitleColor(UIColor.colorWithHexString("#0093DD"), for: .normal)
        resetPwdButton.titleLabel?.font = UIFont.mpSmallFont
        resetPwdButton.addTarget(self, action: #selector(MPLoginViewController.resetPwd), for: .touchUpInside)
        
        registerButton = UIButton()
        registerButton.setTitle("新用户注册", for: .normal)
        registerButton.setTitleColor(UIColor.colorWithHexString("#0093DD"), for: .normal)
        registerButton.titleLabel?.font = UIFont.mpSmallFont
        registerButton.addTarget(self, action: #selector(MPLoginViewController.register), for: .touchUpInside)
        
        scrollView.addSubview(logoView)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(pwdTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(resetPwdButton)
        scrollView.addSubview(registerButton)
        
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(112)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.height.equalTo(tfH)
            make.top.equalTo(logoView.snp.bottom).offset(60)
        }
        pwdTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.height.equalTo(tfH)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
        }
        resetPwdButton.snp.makeConstraints { (make) in
            make.leading.equalTo(pwdTextField)
            make.top.equalTo(pwdTextField.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
        registerButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(pwdTextField)
            make.top.equalTo(resetPwdButton)
            make.height.equalTo(35)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.top.equalTo(resetPwdButton.snp.bottom).offset(37)
            make.height.equalTo(38)
        }
        
        setupAgreementView()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(MPLoginViewController.tap))
//        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func tap() {
        view.endEditing(true)
    }
    
    fileprivate func getAttributeText(_ text: String) -> NSAttributedString {
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.colorWithHexString("#A8D9F5"),
            NSAttributedStringKey.font: UIFont.mpNormalFont
        ]
        return NSAttributedString(string: text, attributes: dic)
    }
    
    /// 检测输入是否合法
    fileprivate func isValid() -> Bool {
        if !phoneTextField.trimText.isMatchRegularExp("1[0-9]{10}$") {
            MPTipsView.showMsg("请输入合法的手机号码")
            return false
        }
        if pwdTextField.mText.isEmpty {
            MPTipsView.showMsg("请输入密码")
            return false
        }
        if !isAgree {
            MPTipsView.showMsg("请同意用户协议")
            return false
        }
        return true
    }
    
    @objc fileprivate func login() {
        if !isValid() {
            return
        }
        MPNetword.requestJson(target: .login(phone: phoneTextField.mText, pwd: pwdTextField.mText), success: { (json) in
            let dic = json["data"] as AnyObject
            guard let ID = dic["user_id"] as? Int,
                let token = dic["token"] as? String,
                let expire = dic["expire"] as? String else {
                    MPTipsView.showMsg("登录失败，请重新再试")
                    return
            }
            MPUserModel.shared.userID = ID
            MPUserModel.shared.token = token
            MPUserModel.shared.expire = expire
            self.getUsetInfo()
            UserDefaults.standard.set(self.phoneTextField.mText, forKey: MP_USER_ACCOUNT_KEY)
            UserDefaults.standard.set(self.pwdTextField.mText, forKey: MP_USER_PWD_KEY)
            UserDefaults.standard.synchronize()
        })
    }
    
    fileprivate func getUsetInfo() {
        if MPUserModel.shared.userID == 0 {
            MPTipsView.showMsg("登录失败，请重新再试")
            return
        }
        MPUserModel.shared.getUserInfo(succ: {
            MPUserModel.shared.loginSucc()
            self.dismiss(animated: true, completion: nil)
        }) {
            MPTipsView.showMsg("登录失败，请重新再试")
        }
    }
    
    /// 设置协议区域View
    fileprivate func setupAgreementView() {
        checkBoxImgView = UIImageView()
        checkBoxImgView.image = UIImage(named: "box_selected")
        let label1 = UILabel(font: UIFont.mpSmallFont, text: "阅读并同意", textColor: UIColor.colorWithHexString("#000000", alpha: 0.3))
        let label2 = UILabel(font: UIFont.mpSmallFont, text: "《8号养车代驾司机协议》", textColor: UIColor.navBlue)
        let agreementView = UIView()
        agreementView.addSubview(checkBoxImgView)
        agreementView.addSubview(label1)
        agreementView.addSubview(label2)
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
        control1.addTarget(self, action: #selector(MPLoginViewController.checkBoxAction), for: .touchUpInside)
        control2.addTarget(self, action: #selector(MPLoginViewController.agreementAction), for: .touchUpInside)
        agreementView.addSubview(control1)
        agreementView.addSubview(control2)
        control1.snp.makeConstraints { (make) in
            make.leading.equalTo(checkBoxImgView)
            make.trailing.equalTo(label1)
            make.top.bottom.equalToSuperview()
        }
        control2.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(label2)
            make.top.bottom.equalToSuperview()
        }
        view.addSubview(agreementView)
        agreementView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
    }
    
    @objc fileprivate func resetPwd() {
        let vc = MPResetPwdViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func register() {
        let vc = MPRegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
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
    
    
    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var logoView: UIImageView!
    fileprivate var phoneTextField: MPInputTextFiled!
    fileprivate var pwdTextField: MPInputTextFiled!
    fileprivate var loginButton: UIButton!
    fileprivate var resetPwdButton: UIButton!
    fileprivate var registerButton: UIButton!
    fileprivate var checkBoxImgView: UIImageView!
    fileprivate var agreementView: MPUserAgreementView!
}

extension MPLoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
