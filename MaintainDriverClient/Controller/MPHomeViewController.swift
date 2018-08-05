//
//  MPHomeViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let btn = UIButton()
        btn.addTarget(self, action: #selector(MPHomeViewController.btnClick), for: .touchUpInside)
        btn.setTitle("clike me", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 50)
        view.addSubview(btn)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "person"), style: .plain, target: self, action: #selector(MPHomeViewController.meAction))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideMenuController()?.leftPanGesture?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        slideMenuController()?.leftPanGesture?.isEnabled = false
    }
    
    
    @objc fileprivate func btnClick() {
        let vc = UIViewController()
        vc.title = "test"
        vc.view.backgroundColor = UIColor.white
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc fileprivate func meAction() {
        slideMenuController()?.openLeft()
    }
}

// MARK: - MPLeftMenuViewControllerDelegate
extension MPHomeViewController: MPLeftMenuViewControllerDelegate {
    /// 登录
    func menuViewDidSelectLogin() {
        let vc = MPLoginViewController()
        present(vc, animated: true, completion: nil)
    }
    /// 订单
    func menuViewDidSelectOrder() {
        slideMenuController()?.closeLeft()
        let vc = MPOrderViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 账户
    func menuViewDidSelectAccount() {
        slideMenuController()?.closeLeft()
        let vc = MPAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 设置
    func menuViewDidSelectSetting() {
        // TODO: 设置
        slideMenuController()?.closeLeft()
    }
}
