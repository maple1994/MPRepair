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
    fileprivate var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if MPUserModel.shared.isLogin {
            loadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(MPYiJieDanViewController.loginSucc), name: MP_LOGIN_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPYiJieDanViewController.loadData), name: MP_refresh_ORDER_LIST_SUCC_NOTIFICATION, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isFirstLoad {
            loadData()
        }
        isFirstLoad = false
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
        tableView.estimatedRowHeight = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc fileprivate func loadData() {
        MPNetwordTool.getOrderList(type: "driver", finish: 1, succ: { (arr) in
            self.modelArr = arr
            self.tableView.reloadData()
        }) {
            
        }
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
            vc = MPOrderConfirmViewController(model: model)
        case .waitQuChe:
            vc = MPQuCheViewController2(model: model)
        case .waitNianJian:
            vc = MPStartYearCheckViewController2(model: model)
        case .nianJianing:
            vc = MPOrderConfirmViewController(model: model)
        case .nianJianSucc:
            vc = MPCheckOutFinishViewController2(model: model)
        case .daoDaHuanChe, .yiHuanChe, .completed:
            vc = MPCheckOutFinishViewController1(model: model)
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
}
