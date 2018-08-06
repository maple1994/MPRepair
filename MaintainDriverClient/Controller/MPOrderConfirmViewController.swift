//
//  MPOrderConfirmViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 订单信息确认
class MPOrderConfirmViewController: UIViewController {
    fileprivate let CellID = "MPOrderConfrimTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.viewBgColor
        navigationItem.title = "确认信息"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消订单", style: .plain, target: self, action: #selector(MPOrderConfirmViewController.cancelOrder))
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.viewBgColor
        
        confrimButton = UIButton()
        confrimButton.setTitle("确认取车", for: .normal)
        confrimButton.backgroundColor = UIColor.navBlue
        confrimButton.setTitleColor(UIColor.white, for: .normal)
        confrimButton.addTarget(self, action: #selector(MPOrderConfirmViewController.confirm), for: .touchUpInside)
        confrimButton.setupCorner(5)
        view.addSubview(tableView)
        
        let tbFooterView = UIView()
        tbFooterView.addSubview(confrimButton)
        confrimButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        tbFooterView.frame = CGRect(x: 0, y: 0, width: MPUtils.screenW, height: 150)
        tableView.tableFooterView = tbFooterView
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(MPOrderConfrimTableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
    }
    
    @objc fileprivate func cancelOrder() {
        print("取消订单")
    }
    
    @objc fileprivate func confirm() {
        print("确认取车")
    }
    
    fileprivate var tableView: UITableView!
    fileprivate var confrimButton: UIButton!
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPOrderConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPOrderConfrimTableViewCell
        if cell == nil {
            cell = MPOrderConfrimTableViewCell(style: .default, reuseIdentifier: CellID)
        }
        let isHiddenLine = (indexPath.section == 0 && indexPath.row == 4) ||
        (indexPath.section == 1 && indexPath.row == 1) ||
        (indexPath.section == 2 && indexPath.row == 2)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell?.set(title: "车主姓名", value: "王思迪", isHiddenLine: isHiddenLine)
            case 1:
                cell?.set(title: "身份证号码", value: "42510199404046434", isHiddenLine: isHiddenLine)
            case 2:
                cell?.set(title: "品牌型号", value: "奥迪 A8L", isHiddenLine: isHiddenLine)
            case 3:
                cell?.set(title: "号码号牌", value: "粤 AB5642", isHiddenLine: isHiddenLine)
            case 4:
                cell?.set(title: "车辆类型", value: "小桥车", isHiddenLine: isHiddenLine)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell?.set(title: "联系人", value: "王小二", isHiddenLine: isHiddenLine)
            case 1:
                cell?.set(title: "联系电话", value: "13556674538", isHiddenLine: isHiddenLine)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell?.set(title: "选择年检站", value: "城厢区海沧机动年检站", isHiddenLine: isHiddenLine)
            case 1:
                cell?.set(title: "交接车地点", value: "兴南大道33号", isHiddenLine: isHiddenLine)
            case 2:
                cell?.set(title: "预约日期", value: "2018-07-16 商务", isHiddenLine: isHiddenLine)
            default:
                break
            }
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: CellID, configuration: { (_) in
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        switch section {
        case 0:
            title = "客户信息"
        case 1:
            title = "联系方式"
        case 2:
            title = "取车信息"
        default:
            break
        }
        return MPTitleSectionHeaderView(title: title, reuseIdentifier: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
