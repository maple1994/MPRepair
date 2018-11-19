//
//  MPUtils.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

/// 工具类
class MPUtils {
    
    class func createLine(_ lineColor: UIColor = UIColor.colorWithHexString("#E0E0E0")) -> UIView {
        let line = UIView()
        line.backgroundColor = lineColor
        return line
    }
    
    /// 压入一个控制器的同时，把当前的控制器移除
    class func push(_ vc: UIViewController) {
        let slideVC = UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController
        let navVC = slideVC?.mainViewController as? UINavigationController
        if let navs : [UIViewController] = navVC?.viewControllers {
            guard navs.count > 0 else{
                return
            }
            let index : Int = navs.count - 2
            guard index >= 0 else{
                return
            }
            navs[index].navigationController?.pushViewController(vc, animated: true)
            navVC?.viewControllers.remove(at: navs.count - 1)
        }
    }
}

func toInt(_ value: Any?) -> Int {
    if let value1 = value as? Int {
        return value1
    }
    if let value2 = value as? String {
        return value2.toInt() ?? 0
    }
    return 0
}

func toString(_ value: Any?) -> String {
    if let value1 = value as? String {
        return value1
    }
    return ""
}

func toBool(_ value: Any?) -> Bool {
    if let value1 = value as? Bool {
        return value1
    }
    return false
}

func toDouble(_ value: Any?) -> Double {
    if let value1 = value as? Double {
        return value1
    }
    if let value2 = value as? String {
        return value2.toDouble() ?? 0
    }
    return 0
}

#if DEBUG
func MPPrint<T>(_ str: T) {
    print(str)
}
#else
func MPPrint<T>(_ str: T) {
}
#endif



