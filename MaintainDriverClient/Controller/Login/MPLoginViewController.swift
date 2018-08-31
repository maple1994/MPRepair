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

    fileprivate let provide = MoyaProvider<MPApiType>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if #available(iOS 11, *) {
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    fileprivate func setupUI() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        let contentView = UIImageView()
        contentView.image = #imageLiteral(resourceName: "background")
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
        let margin: CGFloat = 25
        logoView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        phoneTextField = MPInputTextFiled()
        phoneTextField.keyboardType = .numberPad
        phoneTextField.attributedPlaceholder = getAttributeText("请输入手机号")
        phoneTextField.leftIcon = #imageLiteral(resourceName: "mobile")
        pwdTextField = MPInputTextFiled()
        pwdTextField.keyboardType = .asciiCapable
        pwdTextField.attributedPlaceholder = getAttributeText("请输入密码")
        pwdTextField.isSecureTextEntry = true
        pwdTextField.leftIcon = #imageLiteral(resourceName: "pwd")
        loginButton = UIButton()
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitle("登录", for: .normal)
        loginButton.adjustsImageWhenHighlighted = false
        loginButton.addTarget(self, action: #selector(MPLoginViewController.login), for: .touchUpInside)
        loginButton.backgroundColor = UIColor.navBlue
        loginButton.setupCorner(3)
        resetPwdButton = UIButton()
        resetPwdButton.setTitle("忘记密码？", for: .normal)
        resetPwdButton.setTitleColor(UIColor.colorWithHexString("b7b7b7"), for: .normal)
        resetPwdButton.titleLabel?.font = UIFont.mpSmallFont
        resetPwdButton.addTarget(self, action: #selector(MPLoginViewController.resetPwd), for: .touchUpInside)
        
        registerButton = UIButton()
        registerButton.setTitle("新用户注册", for: .normal)
        registerButton.setTitleColor(UIColor.colorWithHexString("b7b7b7"), for: .normal)
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
            make.top.equalTo(pwdTextField.snp.bottom).offset(5)
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
            make.top.equalTo(resetPwdButton.snp.bottom).offset(20)
            make.height.equalTo(36)
        }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(MPLoginViewController.tap))
//        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func tap() {
        view.endEditing(true)
    }
    
    fileprivate func getAttributeText(_ text: String) -> NSAttributedString {
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.colorWithHexString("#B2B2B3"),
            NSAttributedStringKey.font: UIFont.mpSmallFont
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
        })
    }
    
    fileprivate func getUsetInfo() {
        if MPUserModel.shared.userID == 0 {
            MPTipsView.showMsg("登录失败，请重新再试")
            return
        }
        MPNetword.requestJson(target: .getUserInfo, success: { (json) in
            let dic = json["data"] as AnyObject
            guard
                let phone = dic["phone"] as? String,
                let name = dic["name"] as? String,
                let picUrl = dic["pic_url"] as? String,
                let point = dic["point"] as? Int,
                let isPass = dic["is_pass"] as? Bool
                else {
                    MPTipsView.showMsg("登录失败，请重新再试")
                    return
            }
            MPUserModel.shared.phone = phone
            MPUserModel.shared.userName = name
            MPUserModel.shared.picUrl = picUrl
            MPUserModel.shared.point = point
            MPUserModel.shared.isPass = isPass
            MPUserModel.shared.loginSucc()
            self.dismiss(animated: true, completion: nil)
        }) { (err) in
            MPTipsView.showMsg("登录失败，请重新再试")
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
    
    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var logoView: UIImageView!
    fileprivate var phoneTextField: MPInputTextFiled!
    fileprivate var pwdTextField: MPInputTextFiled!
    fileprivate var loginButton: UIButton!
    fileprivate var resetPwdButton: UIButton!
    fileprivate var registerButton: UIButton!
}

extension MPLoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
