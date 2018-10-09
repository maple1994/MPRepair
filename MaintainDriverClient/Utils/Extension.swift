//
//  Extension.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Kingfisher

/// 扩展
extension UIColor {
    /// 导航栏的蓝色#3cadff
    static let navBlue: UIColor = UIColor.colorWithHexString("#3cadff")
    /// view背景灰#f5f5f5
    static let viewBgColor: UIColor = UIColor.colorWithHexString("#f5f5f5")
    /// 橙色#FF8A4E
    static let mpOrange: UIColor = UIColor.colorWithHexString("#FF8A4E")
    /// 绿色#5FFF54
    static let mpGreen: UIColor = UIColor.colorWithHexString("#5FFF54")
    /// 价格红#FF3C3C
    static let priceRed: UIColor = UIColor.colorWithHexString("#FF3C3C")
    /// 文字黑#333333
    static let fontBlack: UIColor = UIColor.colorWithHexString("#333333")
    /// 浅灰#a3a3a3
    static let mpLightGary: UIColor = UIColor.colorWithHexString("#a3a3a3")
    /// 深灰#5B5B5B
    static let mpDarkGray: UIColor = UIColor.colorWithHexString("#5B5B5B")
    static var randomColor: UIColor {
        let r = CGFloat(arc4random() % 255)
        let g = CGFloat(arc4random() % 255)
        let b = CGFloat(arc4random() % 255)
        return UIColor.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
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

extension UIFont {
    /// 小小字体12
    static let mpXSmallFont = UIFont.systemFont(ofSize: 12)
    /// 小字体14
    static let mpSmallFont = UIFont.systemFont(ofSize: 14)
    /// 普通大小字体16
    static let mpNormalFont = UIFont.systemFont(ofSize: 16)
    /// 大字体18
    static let mpBigFont = UIFont.systemFont(ofSize: 18)
}

private func defaultNumberFormatter() -> NumberFormatter {
    return threadLocalInstance(.defaultNumberFormatter, initialValue: NumberFormatter())
}

private func threadLocalInstance<T: AnyObject>(_ identifier: ThreadLocalIdentifier, initialValue: @autoclosure () -> T) -> T {
    #if os(Linux)
    var storage = Thread.current.threadDictionary
    #else
    let storage = Thread.current.threadDictionary
    #endif
    let k = identifier.objcDictKey
    
    let instance: T = storage[k] as? T ?? initialValue()
    if storage[k] == nil {
        storage[k] = instance
    }
    
    return instance
}

private enum ThreadLocalIdentifier {
    case dateFormatter(String)
    
    case defaultNumberFormatter
    case localeNumberFormatter(Locale)
    
    var objcDictKey: String {
        switch self {
        case .dateFormatter(let format):
            return "SS\(self)\(format)"
        case .localeNumberFormatter(let l):
            return "SS\(self)\(l.identifier)"
        default:
            return "SS\(self)"
        }
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
    
    /// 是否匹配正则
    func isMatchRegularExp(_ pattern: String) -> Bool {
        guard let reg = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive) else {
            return false
        }
        let result = reg.matches(in: self, options: .reportProgress, range: NSMakeRange(0, self.count))
        return (result.count > 0)
    }
    
    func toDouble() -> Double? {
        if let number : NSNumber = defaultNumberFormatter().number(from: self){
            return number.doubleValue
        }
        return nil
    }
    
    func toFloat() -> Float? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        df.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? TimeZone.current
        return df.date(from: self)
    }
    
    func toJson() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return nil
        }
        return dic as? [String: Any]
    }
}

extension UITextField {
    /// 去掉左右空格的text
    var trimText: String {
        get {
            let txt = text ?? ""
            return txt.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
    
    /// 肯定有值的txt
    var mText: String {
        return text ?? ""
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

extension UIImageView {
    func mp_setImage(_ urlString: String) {
        let url = URL(string: urlString)
        kf.setImage(with: url, placeholder: UIImage(named: "person"), options: nil, progressBlock: nil) { (img, _, _, _) in
            if img == nil {
                self.image = UIImage(named: "person")
            }
        }
    }
}

extension Array {
    func get(_ index: Int) -> Element?{
        if index < 0 || index >= self.count {
            return nil
        }
        return self[index]
    }
}

extension UIImage {
    var base64: String? {
        if let base = UIImageJPEGRepresentation(self, 0.3)?.base64EncodedString(){
            return base
        }
        return nil
    }
}

// MARK:- 给所有遵守Codeale协议添加便利转换方法
extension Decodable{
    static func deserialize<T:Decodable>(from: String) -> T?{
        guard let data : Data = from.data(using: .utf8) else {
            return nil
        }
        let decoder : JSONDecoder = JSONDecoder()
        guard let temp : T = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        return temp
    }
    
    //字典转模型
    static func mapFromDict<T : Decodable>(_ dict : [String: Any]) -> T? {
        guard let JSONString = dict.toJSONString() else {
            return nil
        }
        guard let jsonData = JSONString.data(using: .utf8) else {
            return nil
        }
        let decoder = JSONDecoder()
        
        if let obj = try? decoder.decode(T.self, from: jsonData) {
            return obj
        }
        return nil
    }
}

extension Dictionary {
    func toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("dict转json失败")
            return nil
        }
        if let newData : Data = try? JSONSerialization.data(withJSONObject: self, options: []) {
            let JSONString = NSString(data:newData as Data,encoding: String.Encoding.utf8.rawValue)
            return JSONString as String? ?? nil
        }
        print("dict转json失败")
        return nil
    }
}

extension Encodable{
    func toJSONString()->String? {
        let encoder : JSONEncoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            return nil
        }
        return String(data : data,encoding:.utf8)
    }
}

