//
//  MPSettingViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// 设置界面
class MPSettingViewController: UIViewController {

    fileprivate let editViewH: CGFloat = 60
    fileprivate var userName: String = MPUserModel.shared.userName
    /// 修改后的img
    fileprivate var updatedImg: UIImage?
    
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        MPUserModel.shared.getUserInfo(succ: {
            MPUserModel.shared.serilization()
            self.tableView.reloadData()
        }, fail: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPSettingViewController.keyboardShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPSettingViewController.keyboardHidden(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        view.backgroundColor = UIColor.viewBgColor
        navigationItem.title = "设置"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(MPSettingViewController.save))
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.mpSmallFont
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
        
        tableView = UITableView()
        tableView.backgroundColor = UIColor.viewBgColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        loginOutButton = UIButton()
        loginOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginOutButton.setTitle("退出登录", for: .normal)
        loginOutButton.setTitleColor(UIColor.white, for: .normal)
        loginOutButton.backgroundColor = UIColor.navBlue
        loginOutButton.addTarget(self, action: #selector(MPSettingViewController.loginOut), for: .touchUpInside)
        loginOutButton.setupCorner(5)
        view.addSubview(loginOutButton)
        loginOutButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
        view.addSubview(bgView)
        view.addSubview(editView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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
        var name: String? = nil
        var pic: UIImage? = nil
        if userName != MPUserModel.shared.userName {
            name = userName
        }
        if let img = updatedImg {
            pic = img
        }
        MPNetword.requestJson(target: .updateUserInfo(name: name, pic: pic), success: { (json) in
            MPTipsView.showMsg("修改成功")
            MPUserModel.shared.userName = self.userName
            MPUserModel.shared.getUserInfo(succ: {
                MPUserModel.shared.serilization()
                NotificationCenter.default.post(name: MP_USERINFO_UPDATE_NOTIFICATION, object: nil)
            }, fail: nil)
        }) { (_) in
           MPTipsView.showMsg("修改失败")
        }
    }
    
    @objc fileprivate func loginOut() {
        MPUserModel.shared.loginOut()
    }
    
    // MARK: - View
    fileprivate var tableView: UITableView!
    fileprivate var loginOutButton: UIButton!
    fileprivate lazy var bgView: UIControl = {
        let view = UIControl()
        view.isHidden = true
        view.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        view.addTarget(self, action: #selector(MPSettingViewController.remove), for: .touchDown)
        return view
    }()
    fileprivate lazy var editView: MPEditView = {
        let tv = MPEditView()
        return tv
    }()
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MPSettingCell(style: .default, reuseIdentifier: "ID", isShowIcon: indexPath.row == 0)
        switch indexPath.row {
        case 0:
            cell.leftTitleLabel?.text = "头像"
            if let img = updatedImg {
                cell.iconView?.image = img
            }else {
                cell.iconView?.mp_setImage(MPUserModel.shared.picUrl)
            }
        case 1:
            cell.leftTitleLabel?.text = "昵称"
            cell.rightTitleLabel?.text = userName
        case 2:
            cell.leftTitleLabel?.text = "手机号"
            cell.rightTitleLabel?.text = MPUserModel.shared.phone
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 64
        default:
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return MPUtils.createLine(UIColor.white)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: self)!
            vc.showSelectBtn = false
            vc.circleCropRadius = 150
            vc.needCircleCrop = true
            vc.allowCrop = true
            vc.preferredLanguage = "zh-Hans"
            vc.naviBgColor = UIColor.navBlue
            vc.allowTakeVideo = false
            vc.allowPickingVideo = false
            present(vc, animated: true, completion: nil)
        case 1:
            editView.showKeyBoard(userName, title: "昵称") { [weak self] (name) in
                self?.userName = name!
                self?.tableView.reloadData()
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 26
    }
}

extension MPSettingViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        updatedImg = photos.first
        tableView.reloadData()
    }
}







