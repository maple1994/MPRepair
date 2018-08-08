//
//  MPNewOrderTipsView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

/// 提示新订单View
class MPNewOrderTipsView: UIView {
    class func show(title: String, subTitle: String) {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, UIScreen.main.scale)
        UIApplication.shared.keyWindow?.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let view = MPNewOrderTipsView()
        view.frame = CGRect(x: 0, y: 0, width: MPUtils.screenW, height: MPUtils.screenH)
        view.bgImage = image
        view.set(title: title, subTitle: subTitle)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    /// 设置毛玻璃背景图
    var bgImage: UIImage? {
        didSet {
            if let img = bgImage {
                bgImageView.setImageToBlur(img, blurRadius: 10) { (_) in
                }
            }
        }
    }
    
    func set(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        bgImageView = UIImageView()
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 20), text: "您有新的订单！", textColor: UIColor.navBlue)
        subTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "请及时处理！", textColor: UIColor.mpDarkGray)
        dismissButton = UIButton()
        dismissButton.addTarget(self, action: #selector(MPNewOrderTipsView.dismiss), for: .touchUpInside)
        confirmButton = UIButton()
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = UIColor.navBlue
        confirmButton.addTarget(self, action: #selector(MPNewOrderTipsView.confirm), for: .touchUpInside)
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
//        contentView.setupCorner(10)
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.navBlue.cgColor
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(dismissButton)
        contentView.addSubview(confirmButton)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(250)
        }
        dismissButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(35)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dismissButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-25)
        }
        confirmButton.setupCorner(10)
    }
    
    @objc fileprivate func dismiss() {
        removeFromSuperview()
    }
    
    @objc fileprivate func confirm() {
        removeFromSuperview()
        let vc = MPOrderConfirmViewController()
        let nav = ((UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController)?.mainViewController as? UINavigationController)
        nav?.pushViewController(vc, animated: true)
    }
    
    fileprivate var titleLabel: UILabel!
    fileprivate var subTitleLabel: UILabel!
    fileprivate var dismissButton: UIButton!
    fileprivate var confirmButton: UIButton!
    fileprivate var contentView: UIView!
    fileprivate var bgImageView: UIImageView!
}








