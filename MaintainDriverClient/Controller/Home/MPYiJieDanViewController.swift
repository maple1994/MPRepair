//
//  MPYiJieDanViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 已接单
class MPYiJieDanViewController: UIViewController {

    fileprivate let CellID = "MPOrderTableViewCell_YiJieDan"
    fileprivate var modelArr: [MPOrderModel] = [MPOrderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(MPYiJieDanViewController.loginSucc), name: MP_LOGIN_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPYiJieDanViewController.loadData), name: MP_APP_LAUNCH_REFRESH_TOKEN_NOTIFICATION, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        tableView = UITableView()
        tableView.register(MPOrderTableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.viewBgColor
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc fileprivate func loadData() {
        MPNetwordTool.getOrderList(type: "driver", finish: 0, succ: { (arr) in
            self.modelArr = arr
            self.tableView.reloadData()
        }, fail: nil)
    }
    
    @objc fileprivate func loginSucc() {
        loadData()
    }
    
    fileprivate var tableView: UITableView!
}

extension MPYiJieDanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPOrderTableViewCell
        if cell == nil {
            cell = MPOrderTableViewCell(style: .default, reuseIdentifier: CellID)
        }
        cell?.orderModel = modelArr[indexPath.row]
        cell?.orderState = modelArr[indexPath.row].state
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = tableView.fd_heightForCell(withIdentifier: CellID) { (cell) in
            let cell1 = cell as? MPOrderTableViewCell
            cell1?.orderModel = self.modelArr[indexPath.row]
        }
        return h
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArr[indexPath.row]
        var vc: UIViewController? = nil
        switch model.state {
        case .waitPay, .waitJieDan:
            vc = MPOrderConfirmViewController(model: modelArr[indexPath.row])
        case .waitQuChe:
            vc = MPQuCheViewController2(model: modelArr[indexPath.row])
        case .waitNianJian:
            vc = MPStartYearCheckViewController2(model: modelArr[indexPath.row])
        case .nianJianing, .nianJianSucc:
            vc = MPStartYearCheckViewController(model: modelArr[indexPath.row])
        case .daoDaHuanChe, .yiHuanChe, .completed:
            vc = MPCheckOutFinishViewController1(model: modelArr[indexPath.row])
//        default:
//            vc = MPOrderConfirmViewController(model: modelArr[indexPath.row])
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
}
