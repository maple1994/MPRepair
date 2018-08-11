//
//  MPTipsView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/11.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 显示提示语的View
class MPTipsView {
    /// 显示提示语
    class func showMsg(_ text: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.color = UIColor.black
        hud.label.text = text
        hud.contentColor = UIColor.white
        hud.hide(animated: true, afterDelay: 1)
    }
    
    /// 显示正在loading的标志
    class func showLoadingView() {
//        guard let window = UIApplication.shared.keyWindow else {
//            return
//        }
//        let hud = MBProgressHUD.showAdded(to: window, animated: true)
    }
}
