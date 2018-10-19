//
//  MPProfileViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/19.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// 完善资料
class MPProfileViewController: UIViewController {

    fileprivate let editViewH: CGFloat = 60
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        NotificationCenter.default.addObserver(self, selector: #selector(MPProfileViewController.keyboardShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPProfileViewController.keyboardHidden(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - UI
    fileprivate func setupUI() {
        navigationItem.title = "填写资料卡"
        view.backgroundColor = UIColor.white
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.showsVerticalScrollIndicator = false
        let headerView = setupTBheaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 93)
        tableView.tableHeaderView = headerView
        
        view.addSubview(bgView)
        view.addSubview(editView)
        editView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(editViewH)
        }
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupTBheaderView() -> UIView {
        let tbView = UIView()
        nameTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "姓名", textColor: UIColor.mpDarkGray)
        idCardTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "身份证号", textColor: UIColor.mpDarkGray)
        nameLabel = UILabel(font: UIFont.mpSmallFont, text: "请输入姓名", textColor: UIColor.mpLightGary)
        idCardNumberLabel = UILabel(font: UIFont.mpSmallFont, text: "请输入身份证号", textColor: UIColor.mpLightGary)
        let line1 = MPUtils.createLine(UIColor.colorWithHexString("f2f2f2"))
        let line2 = MPUtils.createLine(UIColor.colorWithHexString("f2f2f2"))
        tbView.addSubview(nameTitleLabel)
        tbView.addSubview(idCardTitleLabel)
        tbView.addSubview(nameLabel)
        tbView.addSubview(idCardNumberLabel)
        tbView.addSubview(line1)
        tbView.addSubview(line2)
        
        nameTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(12)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameTitleLabel)
            make.trailing.equalToSuperview().offset(-15)
        }
        line1.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTitleLabel)
            make.width.equalTo(mp_screenW - 30)
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        idCardTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTitleLabel)
            make.top.equalTo(line1.snp.bottom).offset(12)
        }
        idCardNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(idCardTitleLabel)
            make.trailing.equalToSuperview().offset(-15)
        }
        line2.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(idCardTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(10)
        }
        let control1 = UIControl()
        control1.addTarget(self, action: #selector(MPProfileViewController.editName), for: .touchUpInside)
        let control2 = UIControl()
        control2.addTarget(self, action: #selector(MPProfileViewController.editIDCard), for: .touchUpInside)
        tbView.addSubview(control1)
        tbView.addSubview(control2)
        control1.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(line1.snp.top)
        }
        control2.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(line1.snp.bottom)
            make.bottom.equalTo(line2.snp.top)
        }
        return tbView
    }
    
    // MARK: - Action
    @objc func keyboardShow(noti: Notification) {
        guard let info = noti.userInfo else {
            return
        }
        bgView.isHidden = false
        if let duration = info["UIKeyboardAnimationDurationUserInfoKey"] as? Double,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let h = keyboardFrame.height + editViewH
            UIView.animate(withDuration: duration) {
                self.editView.transform = CGAffineTransform.init(translationX: 0, y: -h)
            }
        }
    }
    
    @objc func keyboardHidden(noti: Notification) {
        if let duration = noti.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double {
            UIView.animate(withDuration: duration) {
                self.editView.transform = CGAffineTransform.identity
            }
        }
        bgView.isHidden = true
    }
    
    @objc fileprivate func editName() {
        editView.setKeyBoardType(.default)
        var text = nameLabel.text ?? ""
        if text == "请输入姓名" {
            text = ""
        }
        editView.showKeyBoard(text, title: "姓名") { [weak self] (name) in
            self?.nameLabel.text = name
        }
    }
    
    @objc fileprivate func editIDCard() {
        editView.setKeyBoardType(.numberPad)
        var text = idCardNumberLabel.text ?? ""
        if text == "请输入身份证号" {
            text = ""
        }
        editView.showKeyBoard(text, title: "身份证号码") { [weak self] (idCardNum) in
            var num = idCardNum ?? ""
            if num.isEmpty {
               num = "请输入身份证号"
            }
            self?.idCardNumberLabel.text = num
        }
    }
    
    @objc fileprivate func remove() {
        editView.hideKeyBoard()
        bgView.isHidden = true
    }
    
    // MARK: - View
    fileprivate var tableView: UITableView!
    fileprivate var nameTitleLabel: UILabel!
    fileprivate var nameLabel: UILabel!
    fileprivate var idCardTitleLabel: UILabel!
    fileprivate var idCardNumberLabel: UILabel!
    fileprivate lazy var bgView: UIControl = {
        let view = UIControl()
        view.isHidden = true
        view.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        view.addTarget(self, action: #selector(MPProfileViewController.remove), for: .touchDown)
        return view
    }()
    fileprivate lazy var editView: MPEditView = {
        let tv = MPEditView()
        return tv
    }()
}
