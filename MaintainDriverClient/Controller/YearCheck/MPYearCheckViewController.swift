//
//  MPYearCheckViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 年检控制器
class MPYearCheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.viewBgColor
        yearCheckTitileView = MPYearCheckTitleView()
        yearCheckTitileView.delegate = self
        yearCheckTitileView.selectedIndex = 0
        view.addSubview(yearCheckTitileView)
        yearCheckTitileView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(105)
        }
    }
    
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
    fileprivate lazy var quCheVC1: MPQuCheViewController1 = MPQuCheViewController1()
    fileprivate lazy var quCheVC2: MPQuCheViewController2 = MPQuCheViewController2()
}

// MARK: - MPYearCheckTitleViewDelegate
extension MPYearCheckViewController: MPYearCheckTitleViewDelegate {
    func yearCheckTitleView(didSelect index: Int) {
        switch index {
        case 0:
            navigationItem.title = "查看信息"
        case 1:
            navigationItem.title = "上门取车"
//            show(vc: quCheVC1)
            show(vc: quCheVC2)
        case 2:
            navigationItem.title = "开始年检"
        case 3:
            navigationItem.title = "检完还车"
        default:
            break
        }
    }
    
    func show(vc: UIViewController) {
        if !childViewControllers.contains(vc) {
            addChildViewController(vc)
        }
        view.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.top.equalTo(yearCheckTitileView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
