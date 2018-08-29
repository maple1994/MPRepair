//
//  SendCodeBtn.swift
//  WLAPSwift
//
//  Created by 玉犀科技 on 2018/5/16.
//  Copyright © 2018年 谭徐杨. All rights reserved.
//

import UIKit

protocol MPSendCodeButtonDelegate: class {
    /// 获取验证码
    func getCode()
}

/// 发送验证码的按钮
class MPSendCodeButton: UIButton {
    
    /// 开启定时
    func startTimeCount() {
        setTitle("\(timeCount)", for: .normal)
        isEnabled = false
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo:nil, repeats: true)
    }
    
    weak var delegate: MPSendCodeButtonDelegate?
    fileprivate var time: Timer?
    /// count代表倒计多少秒
    fileprivate var count: Int
    /// 当前倒数的秒数
    fileprivate var timeCount = 0
    
    init(count: Int) {
        self.count = count
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        time?.invalidate()
        time = nil
    }
    
    private func setup() {
        setTitle("获取验证码", for: .normal)
        titleLabel?.font = UIFont.mpSmallFont
        backgroundColor = .clear
        adjustsImageWhenHighlighted = false
        setTitleColor(UIColor.navBlue, for: .normal)
        setupCorner(3)
        setupBorder(borderColor: UIColor.navBlue)
        addTarget(self, action: #selector(MPSendCodeButton.getCode), for: .touchUpInside)
    }
    
    @objc fileprivate func getCode() {
        timeCount = count
        delegate?.getCode()
    }
    
   @objc private func timerFired() {
        if timeCount != 1 {
            timeCount -= 1
            isEnabled = false
            setTitle("\(timeCount)", for: .normal)
        } else {
            isEnabled = true
            setTitle("获取验证码", for: .normal)
            time?.invalidate()
            time = nil
        }
    }
}
