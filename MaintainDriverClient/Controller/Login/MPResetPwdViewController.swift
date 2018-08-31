//
//  MPResetPwdViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/16.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 重置密码
class MPResetPwdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "重置密码"
        if #available(iOS 11, *) {
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
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
            make.top.equalToSuperview()
        }
        let tfH: CGFloat = 44
        let margin: CGFloat = 25
        phoneTextField = MPUnderLineTextField()
        phoneTextField.keyboardType = .numberPad
        phoneTextField.textColor = UIColor.white
        phoneTextField.attributedPlaceholder = getAttributeText("请输入手机号")
        codeTextField = MPUnderLineTextField()
        codeTextField.keyboardType = .numberPad
        codeTextField.textColor = UIColor.white
        codeTextField.attributedPlaceholder = getAttributeText("请输入验证码")
        pwdTextField = MPUnderLineTextField()
        pwdTextField.textColor = UIColor.white
        pwdTextField.keyboardType = .asciiCapable
        pwdTextField.attributedPlaceholder = getAttributeText("请输入新密码")
        pwdTextField.isSecureTextEntry = true
        pwdComfirmTextField = MPUnderLineTextField()
        pwdComfirmTextField.textColor = UIColor.white
        pwdComfirmTextField.keyboardType = .asciiCapable
        pwdComfirmTextField.attributedPlaceholder = getAttributeText("请确认新密码")
        pwdComfirmTextField.isSecureTextEntry = true
        saveButton = UIButton()
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitle("保存", for: .normal)
        saveButton.adjustsImageWhenHighlighted = false
        saveButton.addTarget(self, action: #selector(MPResetPwdViewController.save), for: .touchUpInside)
        saveButton.backgroundColor = UIColor.navBlue
        saveButton.setupCorner(3)
        getCodeButton = MPSendCodeButton(count: 60)
        getCodeButton.delegate = self
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(codeTextField)
        scrollView.addSubview(pwdTextField)
        scrollView.addSubview(pwdComfirmTextField)
        scrollView.addSubview(getCodeButton)
        scrollView.addSubview(saveButton)
        
        phoneTextField.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.height.equalTo(tfH)
            make.top.equalToSuperview().offset(70+64)
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
        saveButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(pwdComfirmTextField.snp.bottom).offset(60)
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
    
    @objc fileprivate func save() {
        if !isValid() {
            return
        }
        MPNetword.requestJson(target: .resetPwd(phone: phoneTextField.mText, pwd: pwdTextField.mText, code: codeTextField.mText), success: { (json) in
            MPTipsView.showMsg("修改成功")
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
        if pwdTextField.mText != pwdComfirmTextField.mText {
            MPTipsView.showMsg("两次输入的密码不同")
            return false
        }
        return true
    }
    
    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var phoneTextField: MPUnderLineTextField!
    fileprivate var codeTextField: MPUnderLineTextField!
    fileprivate var pwdTextField: MPUnderLineTextField!
    fileprivate var pwdComfirmTextField: MPUnderLineTextField!
    fileprivate var getCodeButton: MPSendCodeButton!
    fileprivate var saveButton: UIButton!
}

extension MPResetPwdViewController: MPSendCodeButtonDelegate {
    /// 获取验证码
    func getCode() {
        MPNetword.requestJson(target: .sendCode(phone: phoneTextField.text!, type: MPMsgCodeKey.reset_driver), success: { (json) in
            MPTipsView.showMsg("发送成功")
            self.getCodeButton.startTimeCount()
        }) { (error) in
            MPPrint(error)
            MPTipsView.showMsg("发送失败，请重新发送")
        }
    }
}
