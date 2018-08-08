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
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)
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
        print("退出")
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

protocol MPSettingCellDelegate: class {
    func settingCellDidClickIcon()
}

/// 设置界面的Cell
class MPSettingCell: UITableViewCell {
    
    /// 是否显示头像
    fileprivate var isShowIcon: Bool = false
    weak var delegate: MPSettingCellDelegate?
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, isShowIcon: Bool) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isShowIcon = isShowIcon
        setupUI()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        leftTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 14), text: "头像", textColor: UIColor.fontBlack)
        let margin: CGFloat = 18
        if isShowIcon {
            iconView = UIButton()
            iconView?.setupCorner(20)
            iconView?.backgroundColor = UIColor.colorWithHexString("#ff0000", alpha: 0.3)
            iconView?.addTarget(self, action: #selector(MPSettingCell.iconClick), for: .touchUpInside)
            iconView?.adjustsImageWhenHighlighted = false
            contentView.addSubview(iconView!)
            iconView?.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(40)
                make.trailing.equalToSuperview().offset(-margin)
            }
        }else {
            rightTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 14), text: "王一清", textColor: UIColor.mpLightGary)
            contentView.addSubview(rightTitleLabel!)
            rightTitleLabel?.snp.makeConstraints({ (make) in
                make.trailing.equalToSuperview().offset(-margin)
                make.centerY.equalToSuperview()
            })
        }
        contentView.addSubview(leftTitleLabel!)
        leftTitleLabel?.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.centerY.equalToSuperview()
        }
        let line = MPUtils.createLine()
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc fileprivate func iconClick() {
        delegate?.settingCellDidClickIcon()
    }
    
    var leftTitleLabel: UILabel?
    var rightTitleLabel: UILabel?
    var iconView: UIButton?
}






