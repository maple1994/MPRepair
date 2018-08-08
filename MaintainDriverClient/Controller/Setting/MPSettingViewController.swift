//
//  MPSettingViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 设置界面
class MPSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.viewBgColor
        navigationItem.title = "设置"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(MPSettingViewController.save))
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.mpSmallFont)
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
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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
    }
    
    @objc fileprivate func save() {
        print("保存")
    }
    
    @objc fileprivate func loginOut() {
        (UIApplication.shared.delegate as? AppDelegate)?.setHomeVCToRootVC(true)
    }
    
    fileprivate var tableView: UITableView!
    fileprivate var loginOutButton: UIButton!
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
        case 1:
            cell.leftTitleLabel?.text = "昵称"
            cell.rightTitleLabel?.text = "王一清"
        case 2:
            cell.leftTitleLabel?.text = "手机号"
            cell.rightTitleLabel?.text = "13445564538"
        default:
            break
        }
        cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 26
    }
}

extension MPSettingViewController: MPSettingCellDelegate {
    func settingCellDidClickIcon() {
        print("修改头像")
    }
}







