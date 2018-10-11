//
//  MPTiXianDetailViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/11.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 提现明细
class MPTiXianDetailViewController: UIViewController {
    fileprivate var mingXiModelArr: [MPMingXiModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "提现明细"
        setupUI()
        loadData()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if let ges = navigationController?.interactivePopGestureRecognizer {
            tableView.panGestureRecognizer.require(toFail: ges)
        }
    }
    
    fileprivate func loadData() {
        MPNetwordTool.getAccountInfo(method: 0, succ: { (arr) in
            self.mingXiModelArr = arr
            self.tableView.reloadData()
        }, fail: nil)
    }
    
    fileprivate var tableView: UITableView!
}

extension MPTiXianDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mingXiModelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPTiXianTableViewCell") as? MPTiXianTableViewCell
        if cell == nil {
            cell = MPTiXianTableViewCell(style: .default, reuseIdentifier: "MPTiXianTableViewCell")
        }
        let count = mingXiModelArr?.count ?? 0
        cell?.isLineHidden = (indexPath.row == count - 1)
        cell?.detailModel = mingXiModelArr?[indexPath.row]
        return cell!
    }
}









