//
//  MPCheckOutFinishViewController1.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/7.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 检完还车1
class MPCheckOutFinishViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.viewBgColor
        yearCheckTitileView = MPYearCheckTitleView()
        yearCheckTitileView.selectedIndex = 3
        view.addSubview(yearCheckTitileView)
        yearCheckTitileView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(110)
        }
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.rowHeight = 135
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(yearCheckTitileView.snp.bottom)
        }
        tableView.tableFooterView = MPFooterConfirmView(title: "确认还车", target: self, action: #selector(MPCheckOutFinishViewController1.confirm))
    }
    
    fileprivate func setupNav() {
        navigationItem.title = "检完还车"
    }
    
    @objc fileprivate func confirm() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate var tableView: UITableView!
    fileprivate lazy var secondSectionHeaderView: UIView = {
        let view = UIView()
        let titleView = MPTitleSectionHeaderView(title: "车身拍照", reuseIdentifier: nil)
        view.addSubview(titleView)
        let block = MPUtils.createLine(UIColor.white)
        view.addSubview(block)
        titleView.snp.makeConstraints({ (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        })
        block.snp.makeConstraints({ (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(15)
        })
        return view
    }()
    
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
    fileprivate lazy var horizontalPhotoView: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView()
}

extension MPCheckOutFinishViewController1: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else {
            return 3
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPTwoPhotoTableViewCell") as? MPTwoPhotoTableViewCell
        if cell == nil {
            cell = MPTwoPhotoTableViewCell(style: .default, reuseIdentifier: "MPTwoPhotoTableViewCell")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let ID = "MPTitleSectionHeaderView"
        if section == 0 {
            return MPTitleSectionHeaderView(title: "检查确认", reuseIdentifier: ID)
        }else {
            return secondSectionHeaderView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return horizontalPhotoView
        }else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 170
        }
        return 0.01
    }
}