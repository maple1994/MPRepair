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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "我的订单"
    }

}
