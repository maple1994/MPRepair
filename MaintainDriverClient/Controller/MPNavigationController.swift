//
//  MPNavigationController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏颜色
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = UIColor.navBlue
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.white
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backButton = UIButton()
            backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            backButton.addTarget(self, action: #selector(MPNavigationController.back), for: .touchUpInside)
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
extension MPNavigationController: UIGestureRecognizerDelegate {
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
