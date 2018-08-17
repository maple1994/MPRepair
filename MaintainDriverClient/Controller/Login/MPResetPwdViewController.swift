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
        var offset: CGFloat = -64
        if #available(iOS 11, *) {
            offset = 0
        }
        scrollView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(offset)
        }
        let tfH: CGFloat = 44
        let margin: CGFloat = 25
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
        saveButton = UIButton()
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitle("保存", for: .normal)
        saveButton.adjustsImageWhenHighlighted = false
        saveButton.addTarget(self, action: #selector(MPResetPwdViewController.save), for: .touchUpInside)
        saveButton.backgroundColor = UIColor.navBlue
        saveButton.setupCorner(3)
        getCodeButton = MPSendCodeButton(count: 60)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(codeTextField)
        scrollView.addSubview(pwdComfirmTextField)
        scrollView.addSubview(pwdTextField)
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
