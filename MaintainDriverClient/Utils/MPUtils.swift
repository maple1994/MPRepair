//
//  MPUtils.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 工具类
class MPUtils {
    
    class func createLine(_ lineColor: UIColor = UIColor.colorWithHexString("#E0E0E0")) -> UIView {
        let line = UIView()
        line.backgroundColor = lineColor
        return line
    }
    
    class func toInt(_ value: Any?) -> Int? {
        guard let value1 = value else {
            return nil
        }
        if let val = value1 as? Int {
            return val
        }
        if let val = value1 as? String {
            return val.toInt()
        }
        return nil
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



