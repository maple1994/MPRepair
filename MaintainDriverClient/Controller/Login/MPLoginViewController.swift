//
//  MPLoginViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
            make.height.equalTo(MPUtils.screenH)
            make.width.equalTo(MPUtils.screenW)
        }
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // 布局子内容
        let tfH: CGFloat = 44
        let margin: CGFloat = 25
        sendCodeBtn = MPSendCodeButton(count: 60)
        logoView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        phoneTextField = MPInputTextFiled()
        phoneTextField.attributedPlaceholder = getAttributeText("请输入手机号")
        phoneTextField.leftIcon = #imageLiteral(resourceName: "mobile")
        codeTextField = MPInputTextFiled()
        codeTextField.attributedPlaceholder = getAttributeText("请输入验证码")
        codeTextField.leftIcon = #imageLiteral(resourceName: "pwd")
        loginButton = UIButton()
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitle("登录", for: .normal)
        loginButton.adjustsImageWhenHighlighted = false
        loginButton.addTarget(self, action: #selector(MPLoginViewController.login), for: .touchUpInside)
        loginButton.backgroundColor = UIColor.navBlue
        loginButton.setupCorner(5)
        
        scrollView.addSubview(logoView)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(codeTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(sendCodeBtn)
        
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
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.height.equalTo(tfH)
            make.top.equalTo(phoneTextField.snp.bottom).offset(10)
        }
        sendCodeBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(codeTextField.snp.bottom).offset(-10)
            make.trailing.equalTo(codeTextField)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        loginButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.top.equalTo(codeTextField.snp.bottom).offset(45)
            make.height.equalTo(36)
        }
    }
    
    fileprivate func getAttributeText(_ text: String) -> NSAttributedString {
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.colorWithHexString("#B2B2B3"),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)
        ]
        return NSAttributedString(string: text, attributes: dic)
    }
    
    @objc fileprivate func login() {
        (UIApplication.shared.delegate as? AppDelegate)?.setHomeVCToRootVC()
    }

    
    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var logoView: UIImageView!
    fileprivate var phoneTextField: MPInputTextFiled!
    fileprivate var codeTextField: MPInputTextFiled!
    fileprivate var loginButton: UIButton!
    fileprivate var sendCodeBtn: MPSendCodeButton!
}
