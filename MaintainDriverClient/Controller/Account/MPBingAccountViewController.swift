//
//  MPBingAccountViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/9/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// 绑定支付宝账号
class MPBingAccountViewController: UIViewController {
    fileprivate let editViewH: CGFloat = 60
    fileprivate var name: String = ""
    fileprivate var account: String = ""
    /// 依次返回账号和真实姓名
    fileprivate var callback: ((String, String) -> Void)?
    
    init(account1: String?, name1: String?, callback: ((String, String) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.callback = callback
        if let a = account1 {
            account = a
        }
        if let n = name1 {
            name = n
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(MPBingAccountViewController.keyboardShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPBingAccountViewController.keyboardHidden(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: -
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "绑定账户"
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.viewBgColor
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bindButton = UIButton()
        bindButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        bindButton.setTitle("确认绑定", for: .normal)
        bindButton.setTitleColor(UIColor.white, for: .normal)
        bindButton.backgroundColor = UIColor.navBlue
        bindButton.addTarget(self, action: #selector(MPBingAccountViewController.save), for: .touchUpInside)
        bindButton.setupCorner(5)
        view.addSubview(bindButton)
        bindButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
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
    
    @objc fileprivate func remove() {
        editView.hideKeyBoard()
        bgView.isHidden = true
    }
    
    @objc fileprivate func save() {
        if name.isEmpty {
            MPTipsView.showMsg("请填写姓名")
            return
        }
        if account.isEmpty {
            MPTipsView.showMsg("请填写支付宝账号")
            return
        }
        callback?(account, name)
        navigationController?.popViewController(animated: true)
//        MPNetword.requestJson(target: .getAlipayBindedAccountInfo, success: { (json) in
//            guard let dic = json["data"] as? [String: Any] else {
//                self.endRefresh(false)
//                return
//            }
//            if let param = dic["params"] as? String {
//                AlipaySDK.defaultService()?.auth_V2(withInfo: param, fromScheme: "commayidriverclient", callback: { (dic) in
//                    self.handAlipayResult(dic)
//                })
//            }else {
//                self.endRefresh(false)
//            }
//        }) { (_) in
//            self.endRefresh(false)
//        }
    }
    
    @objc fileprivate func receiveAlipayResult(noti: Notification) {
        handAlipayResult(noti.userInfo)
    }
    
    fileprivate func handAlipayResult(_ result: Any?) {
        let dic = result as? [String: Any]
        let resultStatus = toInt(dic?["resultStatus"])
        guard let result = dic?["result"] as? String else {
            self.endRefresh(false)
            return
        }
        print(dic!)
        print(result)
        let arr = result.components(separatedBy: "&")
        var authCode = ""
        var userID = ""
        for str in arr {
            if str.hasPrefix("user_id=") {
                let startIndex = str.index(str.startIndex, offsetBy: "user_id=".count)
                let endIndex = str.endIndex
                userID = String(str[startIndex..<endIndex])
            }else if str.hasPrefix("auth_code=") {
                let startIndex = str.index(str.startIndex, offsetBy: "auth_code=".count)
                let endIndex = str.endIndex
                authCode = String(str[startIndex..<endIndex])
            }
        }
        if resultStatus != 9000 || authCode.isEmpty || userID.isEmpty {
            self.endRefresh(false)
            return
        }
        loadingView = MPTipsView.showLoadingView("正在绑定...")
        self.updateBindedAccount(authCode: authCode, appID: userID)
    }
    
    fileprivate func updateBindedAccount(authCode: String, appID: String) {
        MPNetword.requestJson(target: .updateAlipayAccount(alipayID: appID, authCode: authCode), success: { (_) in
            self.endRefresh(true)
            self.navigationController?.popViewController(animated: true)
        }, failure: { (_) in
            self.endRefresh(false)
        })
    }
    
    fileprivate func endRefresh(_ isSucc: Bool) {
        loadingView?.hide(animated: true)
        if !isSucc {
            MPTipsView.showMsg("绑定失败，请重新再试")
        }else {
            MPTipsView.showMsg("绑定成功")
        }
    }
    
    // MARK: - View
    fileprivate weak var loadingView: MBProgressHUD?
    fileprivate var tableView: UITableView!
    fileprivate var bindButton: UIButton!
    fileprivate lazy var bgView: UIControl = {
        let view = UIControl()
        view.isHidden = true
        view.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        view.addTarget(self, action: #selector(MPBingAccountViewController.remove), for: .touchDown)
        return view
    }()
    fileprivate lazy var editView: MPEditView = {
        let tv = MPEditView()
        return tv
    }()
}

extension MPBingAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MPSettingCell(style: .default, reuseIdentifier: "ID", isShowIcon: false)
        switch indexPath.row {
        case 0:
            cell.leftTitleLabel?.text = "姓名"
            let text = name.isEmpty ? "请输入真实姓名" : name
            cell.rightTitleLabel?.text = text
            cell.line?.backgroundColor = UIColor.colorWithHexString("#a3a3a3", alpha: 0.1)
        case 1:
            cell.leftTitleLabel?.text = "支付宝账号"
            let text = account.isEmpty ? "请输入支付宝账号" : account
            cell.rightTitleLabel?.text = text
            cell.line?.isHidden = true
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            editView.showKeyBoard(name, title: "姓名") { [weak self] (name) in
                self?.name = name!
                self?.tableView.reloadData()
            }
        case 1:
            editView.showKeyBoard(account, title: "支付宝账号") { [weak self] (name) in
                self?.account = name!
                self?.tableView.reloadData()
            }
        default:
            break
        }
    }
}
