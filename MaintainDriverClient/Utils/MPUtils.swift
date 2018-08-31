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

#if DEBUG
func MPPrint<T>(_ str: T) {
    print(str)
}
#else
func MPPrint<T>(_ str: T) {
}
#endif



