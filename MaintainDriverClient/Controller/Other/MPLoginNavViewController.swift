//
//  MPLoginNavViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/16.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 用于登录的导航控制器
class MPLoginNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        if let barImg = navigationBar.subviews.first {
            
            if #available(iOS 11, *) {
                barImg.alpha = 0
                for v in barImg.subviews {
                    v.alpha = 0
                }
            }else {
                barImg.alpha = 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backButton = UIButton()
            backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            backButton.addTarget(self, action: #selector(MPLoginNavViewController.back), for: .touchUpInside)
            backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 34)
            let inset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
            backButton.imageEdgeInsets = inset
            backButton.setTitleColor(UIColor.white, for: .normal)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
            interactivePopGestureRecognizer?.isEnabled = true
            tabBarController?.tabBar.isHidden = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func back() {
        let _ = self.popViewController(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension MPLoginNavViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count <= 1 {
            return false
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
