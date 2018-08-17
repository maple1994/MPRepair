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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        scrollView = UIScrollView()
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
            make.top.equalToSuperview().offset(-64)
        }
        let tfH: CGFloat = 44
        let margin: CGFloat = 25
        logoView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        phoneTextField = MPUnderLineTextField()
        phoneTextField.keyboardType = .numberPad
        phoneTextField.attributedPlaceholder = getAttributeText("请输入手机号")
        codeTextField = MPUnderLineTextField()
        codeTextField.keyboardType = .numberPad
        codeTextField.attributedPlaceholder = getAttributeText("请输入验证码")
        pwdTextField = MPUnderLineTextField()
        pwdTextField.attributedPlaceholder = getAttributeText("请输入新密码")
        pwdComfirmTextField = MPUnderLineTextField()
        pwdComfirmTextField.attributedPlaceholder = getAttributeText("请确认新密码")
        registerButton = UIButton()
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.setTitle("注册", for: .normal)
        registerButton.adjustsImageWhenHighlighted = false
        registerButton.addTarget(self, action: #selector(MPRegisterViewController.register), for: .touchUpInside)
        registerButton.backgroundColor = UIColor.navBlue
        registerButton.setupCorner(3)
        getCodeButton = MPSendCodeButton(count: 60)
        scrollView.addSubview(logoView)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(codeTextField)
        scrollView.addSubview(pwdComfirmTextField)
        scrollView.addSubview(pwdTextField)
        scrollView.addSubview(getCodeButton)
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
        pwdComfirmTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(phoneTextField)
            make.height.equalTo(tfH)
            make.top.equalTo(pwdTextField.snp.bottom).offset(10)
        }
        registerButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(pwdComfirmTextField.snp.bottom).offset(45)
            make.height.equalTo(36)
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
            NSAttributedStringKey.foregroundColor: UIColor.colorWithHexString("#B2B2B3"),
            NSAttributedStringKey.font: UIFont.mpSmallFont
        ]
        return NSAttributedString(string: text, attributes: dic)
    }
    
    @objc fileprivate func register() {
        
    }

    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var phoneTextField: MPUnderLineTextField!
    fileprivate var codeTextField: MPUnderLineTextField!
    fileprivate var pwdTextField: MPUnderLineTextField!
    fileprivate var pwdComfirmTextField: MPUnderLineTextField!
    fileprivate var getCodeButton: MPSendCodeButton!
    fileprivate var logoView: UIImageView!
    fileprivate var registerButton: UIButton!
}
