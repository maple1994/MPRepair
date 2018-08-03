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
        view.backgroundColor = UIColor.red
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
