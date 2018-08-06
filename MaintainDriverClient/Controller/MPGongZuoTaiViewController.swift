//
//  MPGongZuoTaiViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 工作台
class MPGongZuoTaiViewController: UIViewController {

    fileprivate let CellID = "MPOrderTableViewCell_GongZuoTai"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.viewBgColor
        tableView.register(MPOrderTableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
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
        view.addSubview(stealButton)
        view.addSubview(listenButton)
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
    }
    
    @objc fileprivate func stealAction() {
        MPNewOrderTipsView.show(title: "抢单成功!", subTitle: "请尽快处理!")
    }
    
    @objc fileprivate func listenAction() {
        MPNewOrderTipsView.show(title: "您有新的订单!", subTitle: "请及时处理!")
    }
    
    fileprivate var tableView: UITableView!
    /// 抢单
    fileprivate var stealButton: UIButton!
    /// 听单
    fileprivate var listenButton: UIButton!
}

extension MPGongZuoTaiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPOrderTableViewCell
        if cell == nil {
            cell = MPOrderTableViewCell(style: .default, reuseIdentifier: CellID)
        }
        cell?.row = indexPath.row
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = tableView.fd_heightForCell(withIdentifier: CellID) { (cell) in
            
        }
        return h
    }
}
