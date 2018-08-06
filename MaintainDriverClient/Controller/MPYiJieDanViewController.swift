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
    }
    
    fileprivate var tableView: UITableView!
}

extension MPYiJieDanViewController: UITableViewDelegate, UITableViewDataSource {
    
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
