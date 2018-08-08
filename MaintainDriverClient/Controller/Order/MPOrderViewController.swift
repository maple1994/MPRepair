//
//  MPOrderViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 我的订单
class MPOrderViewController: UIViewController {
    fileprivate let CellID1 = "MPOrderTableViewCell_UNComplete"
    fileprivate let CellID2 = "MPOrderTableViewCell_Completed"
    fileprivate let blockViewH: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "我的订单"
        titleView = MPTitleView(titleArr: ["未完成的订单", "已完成的订单"])
        titleView.delegate = self
        contentView = UIScrollView()
        contentView.showsHorizontalScrollIndicator = false
        contentView.isPagingEnabled = true
        contentView.delegate = self
        view.addSubview(titleView)
        view.addSubview(contentView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        uncompleteTableView = createTbView(cellID: CellID1)
        completedTableView = createTbView(cellID: CellID2)
        
        contentView.addSubview(uncompleteTableView)
        contentView.addSubview(completedTableView)
        
        uncompleteTableView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(MPUtils.screenW)
            make.height.equalTo(view).offset(-44)
        }
        completedTableView.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(uncompleteTableView.snp.trailing)
            make.width.equalTo(MPUtils.screenW)
            make.height.equalTo(view).offset(-44)
        }
    }
    
    fileprivate func createTbView(cellID: String) -> UITableView {
        let tb = UITableView()
        tb.register(MPOrderTableViewCell.classForCoder(), forCellReuseIdentifier: cellID)
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.backgroundColor = UIColor.viewBgColor
        return tb
    }
    
    fileprivate var uncompleteTableView: UITableView!
    fileprivate var completedTableView: UITableView!
    fileprivate var titleView: MPTitleView!
    fileprivate var contentView: UIScrollView!
}

extension MPOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == uncompleteTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: CellID1) as? MPOrderTableViewCell
            if cell == nil {
                cell = MPOrderTableViewCell(style: .default, reuseIdentifier: CellID1)
            }
            cell?.row = indexPath.row
            return cell!
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: CellID2) as? MPOrderTableViewCell
            if cell == nil {
                cell = MPOrderTableViewCell(style: .default, reuseIdentifier: CellID1)
            }
            cell?.row = indexPath.row
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == uncompleteTableView {
            let h = tableView.fd_heightForCell(withIdentifier: CellID1) { (cell) in
                
            }
            return h
        }else {
            let h = tableView.fd_heightForCell(withIdentifier: CellID2) { (cell) in
                
            }
            return h
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != contentView {
            return
        }
        let offsetX = scrollView.contentOffset.x + MPUtils.screenW * 0.5
        let index = Int(offsetX / MPUtils.screenW)
        titleView.setupSelectedIndex(index)
        titleView.isTouch = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView != contentView {
            return
        }
        titleView.isTouch = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != contentView {
            return
        }
        if titleView.isTouch {
            return
        }
        titleView.setupOffsetX(scrollView.contentOffset.x)
    }
}

extension MPOrderViewController: MPTitleViewDelegate {
    func titleView(didSelect index: Int) {
        titleView.isTouch = true
        let offsetX: CGFloat = MPUtils.screenW * CGFloat(index)
        contentView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        titleView.lastOffsetX = offsetX
    }
}
