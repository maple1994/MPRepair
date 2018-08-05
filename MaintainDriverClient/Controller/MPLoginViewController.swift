//
//  MPLoginViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        let bgView = UIImageView()
        bgView.image = #imageLiteral(resourceName: "background")
        view.addSubview(bgView)
        
    }
    
    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var logoView: UIImageView!
    fileprivate var phoneTextField: UITextField!
    fileprivate var codeTextField: UITextField!
    fileprivate var loginButton: UIButton!
}
