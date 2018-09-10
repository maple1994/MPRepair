//
//  MPGongZuoTaiViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

protocol MPGongZuoTaiViewControllerDelegate: class {
    /// 点击了出车
    func gongZuoTaiDidSelectChuChe()
}

/// 工作台
class MPGongZuoTaiViewController: UIViewController {

    fileprivate let CellID = "MPCheckBoxOrderTableViewCell"
    fileprivate var modelArr: [MPOrderModel] = [MPOrderModel]()
    weak var delegate: MPGongZuoTaiViewControllerDelegate?
    fileprivate var selectedModel: MPOrderModel?
    
    /// 下车
    func xiaCheAction() {
        listenButton.isHidden = true
        stealButton.isHidden = true
        chuCheButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(MPGongZuoTaiViewController.loginSucc), name: MP_LOGIN_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPGongZuoTaiViewController.loadData), name: MP_APP_LAUNCH_REFRESH_TOKEN_NOTIFICATION, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func loginSucc() {
        loadData()
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
        stealButton = UIButton()
        stealButton.setTitle("抢单", for: .normal)
        stealButton.setTitleColor(UIColor.navBlue, for: .normal)
        stealButton.setupCorner(5)
        stealButton.setupBorder(borderColor: UIColor.navBlue)
        stealButton.addTarget(self, action: #selector(MPGongZuoTaiViewController.stealAction), for: .touchUpInside)
        stealButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        stealButton.backgroundColor = UIColor.white
        listenButton = UIButton()
        listenButton.setTitle("听单", for: .normal)
        listenButton.setTitleColor(UIColor.white, for: .normal)
        listenButton.setupCorner(5)
        listenButton.backgroundColor = UIColor.navBlue
        listenButton.addTarget(self, action: #selector(MPGongZuoTaiViewController.listenAction), for: .touchUpInside)
        listenButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        chuCheButton = UIButton()
        chuCheButton.setTitle("出车", for: .normal)
        chuCheButton.setTitleColor(UIColor.white, for: .normal)
        chuCheButton.setupCorner(5)
        chuCheButton.backgroundColor = UIColor.navBlue
        chuCheButton.addTarget(self, action: #selector(MPGongZuoTaiViewController.chuCheAction), for: .touchUpInside)
        chuCheButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(stealButton)
        view.addSubview(listenButton)
        view.addSubview(chuCheButton)
        stealButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(44)
        }
        listenButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalTo(stealButton.snp.trailing).offset(15)
            make.width.equalTo(stealButton)
            make.bottom.equalTo(stealButton)
            make.height.equalTo(44)
        }
        chuCheButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(stealButton)
            make.bottom.equalTo(stealButton)
            make.height.equalTo(44)
        }
        listenButton.isHidden = true
        stealButton.isHidden = true
        chuCheButton.isHidden = false
    }
    
    @objc fileprivate func loadData() {
        MPNetwordTool.getOrderList(type: "order", finish: 0, succ: { (arr) in
            self.modelArr = arr
            self.tableView.reloadData()
        }, fail: nil)
    }
    
    // MARK: - Action
    @objc fileprivate func stealAction() {
        guard let order = modelArr.first else {
            return
        }
        let view = MPNewOrderTipsView.show(title: "抢单成功!", subTitle: "请尽快处理!", delegate: self)
        view.showTimeCount()
        MPNetword.requestJson(target: .grab(id: order.id), success: { (json) in
            view.endTimeCount()
            self.selectedModel = order
        }) { (_) in
            MPTipsView.showMsg("抢单失败")
            self.selectedModel = nil
            view.endTimeCount()
        }
    }
    
    @objc fileprivate func listenAction() {
        _ = MPNewOrderTipsView.show(title: "您有新的订单!", subTitle: "请及时处理!", delegate: self)
    }
    
    @objc fileprivate func chuCheAction() {
        delegate?.gongZuoTaiDidSelectChuChe()
        listenButton.isHidden = false
        stealButton.isHidden = false
        chuCheButton.isHidden = true
    }
    
    // MARK: - View
    fileprivate var tableView: UITableView!
    /// 抢单
    fileprivate var stealButton: UIButton!
    /// 听单
    fileprivate var listenButton: UIButton!
    /// 出车
    fileprivate var chuCheButton: UIButton!
}

extension MPGongZuoTaiViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let h = tableView.fd_heightForCell(withIdentifier: CellID) { (cell1) in
            let cell = cell1 as? MPOrderTableViewCell
            cell?.orderModel = self.modelArr[indexPath.row]
        }
        return h
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension MPGongZuoTaiViewController: MPNewOrderTipsViewDelegate {
    func tipsViewDidConfirm() {
        guard let model = selectedModel else {
            return
        }
        let vc = MPOrderConfirmViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
