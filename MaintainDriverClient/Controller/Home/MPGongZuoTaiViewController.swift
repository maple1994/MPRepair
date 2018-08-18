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
    fileprivate var orderModelArr: [MPOrderModel]?
    weak var delegate: MPGongZuoTaiViewControllerDelegate?
    
    /// 下车
    func xiaCheAction() {
        listenButton.isHidden = true
        stealButton.isHidden = true
        chuCheButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        orderModelArr = [MPOrderModel]()
        orderModelArr?.append(MPOrderModel())
        orderModelArr?.append(MPOrderModel())
        tableView.reloadData()
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
    
    // MARK: - Action
    @objc fileprivate func stealAction() {
//        guard let arr = orderModelArr else {
//            return
//        }
//        var isValid = false
//        for model in arr {
//            if model.isSelected {
//                isValid = true
//                break
//            }
//        }
//        if !isValid {
//            MPTipsView.showMsg("请选择订单")
//            return 
//        }
        let view = MPNewOrderTipsView.show(title: "抢单成功!", subTitle: "请尽快处理!")
        view.showTimeCount()
    }
    
    @objc fileprivate func listenAction() {
        _ = MPNewOrderTipsView.show(title: "您有新的订单!", subTitle: "请及时处理!")
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
        return orderModelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPOrderTableViewCell
        if cell == nil {
            cell = MPOrderTableViewCell(style: .default, reuseIdentifier: CellID)
        }
        cell?.isStateHidden = true
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = tableView.fd_heightForCell(withIdentifier: CellID) { (cell1) in
//            let cell = cell1 as? MPOrderTableViewCell
        }
        return h
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let arr = orderModelArr else {
            return
        }
        orderModelArr?[indexPath.row].isSelected = !arr[indexPath.row].isSelected
        tableView.reloadData()
    }
}
