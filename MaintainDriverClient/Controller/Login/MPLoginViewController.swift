//
//  MPLoginViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Moya

class MPLoginViewController: UIViewController {

    fileprivate let provide = MoyaProvider<MPApiType>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        provide.request(.login) { (result) in
//            switch result {
//            case let .success(moyaResponse):
//                let data = moyaResponse.data
//                let statusCode = moyaResponse.statusCode
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: mp_screenW, height: mp_screenH + 1)
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
        var offset: CGFloat = -64
        if #available(iOS 11, *) {
            offset = 0
        }
        scrollView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            
            make.top.equalToSuperview().offset(offset)
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
        pwdTextField.keyboardType = .numberPad
        pwdTextField.attributedPlaceholder = getAttributeText("请输入密码")
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
    
    @objc fileprivate func login() {
        dismiss(animated: true, completion: nil)
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
