//
//  Extension.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 扩展
extension UIColor {
    /// 导航栏的蓝色
    static let navBlue: UIColor = UIColor.colorWithHexString("#3cadff")
    /// view背景灰
    static let viewBgColor: UIColor = UIColor.colorWithHexString("#f5f5f5")
    /// 橙色
    static let mpOrange: UIColor = UIColor.colorWithHexString("#FF8A4E")
    /// 绿色
    static let mpGreen: UIColor = UIColor.colorWithHexString("#5FFF54")
    /// 价格红
    static let priceRed: UIColor = UIColor.colorWithHexString("#FF3C3C")
    /// 文字黑
    static let fontBlack: UIColor = UIColor.colorWithHexString("#333333")
    /// 浅灰
    static let mpLightGary: UIColor = UIColor.colorWithHexString("#a3a3a3")
    /// 深灰
    static let mpDarkGray: UIColor = UIColor.colorWithHexString("#5B5B5B")
    
    /// 返回16进制颜色
    ///
    /// - Parameters:
    ///   - hex: 16进制颜色
    ///   - alpha: 透明度
    class func colorWithHexString (_ hex:String, alpha:CGFloat = 1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.lengthOfBytes(using: String.Encoding.utf8) != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}


extension UILabel {
    convenience init(font: UIFont, text: String?, textColor: UIColor) {
        self.init(frame: CGRect.zero)
        self.font = font
        self.text = text
        self.textColor = textColor
    }
}

extension String {
    /// 自动算出字体空间大小
    func size(_ font:UIFont, width:CGFloat) -> CGSize {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let str = NSString(format: "%@", self)
        let dic = [NSAttributedStringKey.font:font]
        return str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
    }
}

extension UIView {
    func setupCorner(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    func setupBorder(width: CGFloat = 1, borderColor: UIColor) {
        layer.borderWidth = width
        layer.borderColor = borderColor.cgColor
    }
}
