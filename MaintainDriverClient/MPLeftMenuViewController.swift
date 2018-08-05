//
//  MPLeftMenuViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SnapKit

class MPLeftMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.reloadData()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        userIconView = UIImageView()
        userIconView.image = #imageLiteral(resourceName: "person")
        userIconView.isUserInteractionEnabled = true
        userNameLabel = UILabel()
        userNameLabel.textColor = UIColor.white
        userNameLabel.text = "未登录"
        let tbHeaderView = UIView()
        tbHeaderView.frame = CGRect(x: 0, y: 0, width: MPUtils.screenW, height: 150)
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
    
    @objc fileprivate func userIconClick() {
        
    }

    // MARK: - UIView
    fileprivate var tableView: UITableView!
    fileprivate var userIconView: UIImageView!
    fileprivate var userNameLabel: UILabel!
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
        // TODO: 事件处理
        switch indexPath.row {
        case 0:
            print("订单")
        case 1:
            print("账户")
        case 2:
            print("设置")
        default:
            break
        }
    }
}


// MARK: - MPMunuViewCell
class MPMunuViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        iconView = UIImageView()
        iconTitleLabel = UILabel()
        contentView.addSubview(iconView)
        contentView.addSubview(iconTitleLabel)
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        iconTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(10)
        }
    }
    
    var iconView: UIImageView!
    var iconTitleLabel: UILabel!
}



