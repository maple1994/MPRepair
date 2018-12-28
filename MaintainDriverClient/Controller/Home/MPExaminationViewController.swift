//
//  MPExaminationViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPExaminationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "开始答题"
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        let headerView = UIView()
        numLabel = UILabel(font: UIFont.systemFont(ofSize: 20), text: "共30题", textColor: UIColor.white)
        bgImageView = UIImageView(image: UIImage(named: "count_down_bg"))
        headerView.addSubview(numLabel)
        headerView.addSubview(bgImageView)
        
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(headerView)
        view.addSubview(tableView)
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(110)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        tableView.register(MPExaminationCellTableViewCell.classForCoder(), forCellReuseIdentifier: "MPExaminationCellTableViewCell")
        let footerView = MPFooterConfirmView(title: "提交", target: self, action: #selector(MPExaminationViewController.submit))
        tableView.tableFooterView = footerView
    }
    
    @objc fileprivate func submit() {
        MPPrint("提交")
    }
    
    fileprivate var numLabel: UILabel!
    fileprivate var bgImageView: UIImageView!
    fileprivate var tableView: UITableView!
}

extension MPExaminationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPExaminationCellTableViewCell") as? MPExaminationCellTableViewCell
        if cell == nil {
            cell = MPExaminationCellTableViewCell(style: .default, reuseIdentifier: "MPExaminationCellTableViewCell")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "MPExaminationCellTableViewCell", configuration: { (cell) in

        })
    }
}