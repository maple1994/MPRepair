//
//  MPLeftMenuViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SnapKit

protocol MPLeftMenuViewControllerDelegate: class {
    /// 登录
    func menuViewDidSelectLogin()
    /// 订单
    func menuViewDidSelectOrder()
    /// 账户
    func menuViewDidSelectAccount()
    /// 设置
    func menuViewDidSelectSetting()
}

class MPLeftMenuViewController: UIViewController {
    weak var delegate: MPLeftMenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        var name = MPUserModel.shared.userName
        if MPUserModel.shared.userName.isEmpty {
            name = "默认名"
        }
        userNameLabel.text = name
        userIconView.mp_setImage(MPUserModel.shared.picUrl)
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(MPLeftMenuViewController.loginSucc), name: MP_LOGIN_NOTIFICATION, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        tableView = UITableView()
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 54
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollsToTop = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        userIconView = UIImageView()
        userIconView.image = #imageLiteral(resourceName: "person")
        userIconView.isUserInteractionEnabled = true
        userIconView.setupCorner(35)
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.mpBigFont
        userNameLabel.textColor = UIColor.white
        userNameLabel.text = "未登录"
        let tbHeaderView = UIView()
        tbHeaderView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 150)
        tbHeaderView.backgroundColor = UIColor.navBlue
        tbHeaderView.addSubview(userIconView)
        tbHeaderView.addSubview(userNameLabel)
        
        userIconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
            make.width.height.equalTo(70)
        }
        userNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(userIconView.snp.bottom).offset(5)
        }
        tableView.tableHeaderView = tbHeaderView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MPLeftMenuViewController.userIconClick))
        userIconView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func loginSucc() {
        var name = MPUserModel.shared.userName
        if MPUserModel.shared.userName.isEmpty {
            name = "默认名"
        }
        userNameLabel.text = name
        userIconView.mp_setImage(MPUserModel.shared.picUrl)
    }
    
    @objc fileprivate func userIconClick() {
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
    }

    // MARK: - UIView
    fileprivate var tableView: UITableView!
    fileprivate var userIconView: UIImageView!
    fileprivate var userNameLabel: UILabel!
}

extension MPLeftMenuViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        userIconView.image = photos.first
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPLeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MeunCellID") as? MPMunuViewCell
        if cell == nil {
            cell = MPMunuViewCell(style: .default, reuseIdentifier: "MeunCellID")
        }
        switch indexPath.row {
        case 0:
            cell?.iconView.image = #imageLiteral(resourceName: "order")
            cell?.iconTitleLabel.text = "订单"
        case 1:
            cell?.iconView.image = #imageLiteral(resourceName: "account")
            cell?.iconTitleLabel.text = "账户"
        case 2:
            cell?.iconView.image = #imageLiteral(resourceName: "setting")
            cell?.iconTitleLabel.text = "设置"
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.menuViewDidSelectOrder()
        case 1:
            delegate?.menuViewDidSelectAccount()
        case 2:
            delegate?.menuViewDidSelectSetting()
        default:
            break
        }
    }

}



