//
//  MPNewOrderTipsView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

protocol MPNewOrderTipsViewDelegate: class {
    func tipsViewDidConfirm()
}

/// 提示新订单View
class MPNewOrderTipsView: UIView {
    class func show(title: String, subTitle: String, delegate: MPNewOrderTipsViewDelegate?) -> MPNewOrderTipsView {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, UIScreen.main.scale)
        UIApplication.shared.keyWindow?.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let view = MPNewOrderTipsView()
        view.delegate = delegate
        view.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: mp_screenH)
        view.bgImage = image
        view.set(title: title, subTitle: subTitle)
        UIApplication.shared.keyWindow?.addSubview(view)
        return view
    }
    
    /// 显示倒计时
    func showTimeCount() {
        timeCount()
        let timer = Timer(timeInterval: 1, target: self, selector: #selector(MPNewOrderTipsView.timeCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        self.timer = timer
        showResultView.isHidden = true
        timeCountView.isHidden = false
    }
    
    /// 结束倒计时
    func endTimeCount() {
        timer?.invalidate()
        timeCountView.isHidden = true
        showResultView.isHidden = false
    }
    
    func set(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
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
    
    weak var delegate: MPNewOrderTipsViewDelegate?
    
    // MARK: -
    fileprivate weak var timer: Timer?
    fileprivate var count: Int = 0
    
    // MARK: -
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: -
    fileprivate func setupUI() {
        bgImageView = UIImageView()
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        dismissButton = MPImageButtonView(image: #imageLiteral(resourceName: "close_dary"), pos: .rightTop, imageW: 16, imageH: 16)
        dismissButton.addTarget(self, action: #selector(MPNewOrderTipsView.dismiss), for: .touchUpInside)
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.navBlue.cgColor
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        showResultView = UIView()
        showResultView.backgroundColor = UIColor.white
        timeCountView = UIView()
        timeCountView.backgroundColor = UIColor.white
        addSubview(contentView)
        contentView.addSubview(showResultView)
        contentView.addSubview(timeCountView)
        contentView.addSubview(dismissButton)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(211)
        }
        showResultView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        timeCountView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        dismissButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(35)
        }
        timeCountView.isHidden = true
        setupResultView()
        setupTimeCountView()
    }
    
    fileprivate func setupResultView() {
        titleLabel = UILabel(font: UIFont.mpBigFont, text: "您有新的订单！", textColor: UIColor.navBlue)
        subTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "请及时处理！", textColor: UIColor.mpDarkGray)
        confirmButton = UIButton()
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.titleLabel?.font = UIFont.mpNormalFont
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = UIColor.navBlue
        confirmButton.addTarget(self, action: #selector(MPNewOrderTipsView.confirm), for: .touchUpInside)
        
        showResultView.addSubview(titleLabel)
        showResultView.addSubview(subTitleLabel)
        showResultView.addSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(53)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(29)
            make.centerX.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(35)
            make.bottom.equalToSuperview().offset(-18)
        }
        confirmButton.setupCorner(8)
    }
    
    fileprivate func setupTimeCountView() {
        let titleLabel = UILabel(font: UIFont.mpBigFont, text: "抢单中...", textColor: UIColor.navBlue)
        timeCountLabel = UILabel(font: UIFont.systemFont(ofSize: 30), text: "1s", textColor: UIColor.priceRed)
        timeCountView.addSubview(titleLabel)
        timeCountView.addSubview(timeCountLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(53)
            make.centerX.equalToSuperview()
        }
        timeCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc fileprivate func dismiss() {
        timer?.invalidate()
        removeFromSuperview()
    }
    
    @objc fileprivate func confirm() {
        timer?.invalidate()
        removeFromSuperview()
        delegate?.tipsViewDidConfirm()
    }
    
    @objc fileprivate func timeCount() {
        count += 1
        timeCountLabel.text = "\(count)s"
    }
    
    // MARK: - View
    fileprivate var titleLabel: UILabel!
    fileprivate var subTitleLabel: UILabel!
    fileprivate var dismissButton: MPImageButtonView!
    fileprivate var confirmButton: UIButton!
    fileprivate var contentView: UIView!
    /// 用于倒计时的View
    fileprivate var timeCountView: UIView!
    /// 显示时间的Label
    fileprivate var timeCountLabel: UILabel!
    /// 用于显示抢单结果的View
    fileprivate var showResultView: UIView!
    fileprivate var bgImageView: UIImageView!
}








