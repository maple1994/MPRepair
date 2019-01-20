//
//  MPShowGradeView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

protocol MPShowGradeViewDelegate: class {
    /// 重考
    func reexamine()
    /// 购买保险
    func buyInsurance()
}

/// 显示考试成绩的View
class MPShowGradeView: UIView {
    
    class func show(correctNum: Int, wrongNum: Int, score: Int, isPass: Bool, delegate: MPShowGradeViewDelegate?) {
        var tips = "很抱歉，请再接再厉！"
        if isPass {
            tips = "恭喜你，成为八号养车代驾司机！"
        }
        let view = MPShowGradeView()
        view.setup(tips: tips, correctNum: correctNum, wrongNum: wrongNum, score: score, isPass: isPass)
        view.delegate = delegate
        view.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    /// 设置显示的内容
    ///
    /// - Parameters:
    ///   - tips: 提示语
    ///   - correctNum: 回答正确的数量
    ///   - wrongNum: 回答错误的数量
    ///   - isPass: 是否通过考试
    func setup(tips: String, correctNum: Int, wrongNum: Int, score: Int, isPass: Bool) {
        tipsLabel.text = tips
        correctLabel.text = "\(correctNum)题"
        wrongLabel.text = "\(wrongNum)题"
        gradeLabel.text = "\(score)"
        self.isPass = isPass
        if isPass {
            confirmButton.setTitle("确认加盟", for: .normal)
            gradeBgView.image = UIImage(named: "star_yellow")
            gradeLabel.textColor = UIColor.colorWithHexString("FF3C3C")
            fenLabel.textColor = UIColor.colorWithHexString("FF3C3C")
        }else {
            confirmButton.setTitle("重新答题", for: .normal)
            gradeBgView.image = UIImage(named: "star_gray")
            gradeLabel.textColor = UIColor.colorWithHexString("777777")
            fenLabel.textColor = UIColor.colorWithHexString("777777")
        }
    }
    
    weak var delegate: MPShowGradeViewDelegate?
    fileprivate var isPass: Bool = false
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.4)
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.setupCorner(12)
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(345)
            make.centerY.equalToSuperview()
        }
        
        let titleLabel = UILabel(font: UIFont.systemFont(ofSize: 16), text: "本次考试得分", textColor: UIColor.colorWithHexString("4A4A4A"))
        let closeBtn = MPImageButtonView(image: UIImage(named: "close_dary"), pos: .rightTop, imageW: 16, imageH: 16)
        closeBtn.addTarget(self, action: #selector(MPShowGradeView.dismiss), for: .touchUpInside)
        gradeLabel = UILabel(font: UIFont.systemFont(ofSize: 32), text: "80", textColor: UIColor.colorWithHexString("#FF3C3C"))
        fenLabel = UILabel(font: UIFont.mpNormalFont, text: "分", textColor: UIColor.colorWithHexString("#FF3C3C"))
        gradeBgView = UIImageView(image: UIImage(named: "star_yellow"))
        correctLabel = UILabel(font: UIFont.mpNormalFont, text: "26题", textColor: UIColor.colorWithHexString("#4A4A4A"))
        wrongLabel = UILabel(font: UIFont.mpNormalFont, text: "4题", textColor: UIColor.colorWithHexString("#4A4A4A"))
        let correctTitLabel = UILabel(font: UIFont.mpSmallFont, text: "答题正确", textColor: UIColor.colorWithHexString("9B9B9B"))
        let wrongTitLabel = UILabel(font: UIFont.mpSmallFont, text: "答题错误", textColor: UIColor.colorWithHexString("9B9B9B"))
        let separator = UIImageView(image: UIImage(named: "separator"))
        tipsLabel = UILabel(font: UIFont.mpNormalFont, text: "恭喜你，成为八号养车代驾司机！", textColor: UIColor.colorWithHexString("#9B9B9B"))
        tipsLabel.numberOfLines = 0
        tipsLabel.textAlignment = .center
        confirmButton = UIButton()
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = UIColor.navBlue
        confirmButton.setTitle("确认加盟", for: .normal)
        confirmButton.addTarget(self, action: #selector(MPShowGradeView.confirm), for: .touchUpInside)
        confirmButton.titleLabel?.font = UIFont.mpBigFont
        confirmButton.setupCorner(4)
        
        contentView.addSubview(closeBtn)
        contentView.addSubview(titleLabel)
        contentView.addSubview(gradeBgView)
        contentView.addSubview(gradeLabel)
        contentView.addSubview(fenLabel)
        contentView.addSubview(correctLabel)
        contentView.addSubview(correctTitLabel)
        contentView.addSubview(wrongLabel)
        contentView.addSubview(wrongTitLabel)
        contentView.addSubview(separator)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(confirmButton)
        
        closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(35)
            make.width.equalTo(60)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
        }
        gradeBgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.height.equalTo(39)
            make.width.equalTo(124)
        }
        gradeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel).offset(35)
        }
        fenLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(gradeLabel).offset(-5)
            make.leading.equalTo(gradeLabel.snp.trailing).offset(3)
        }
        correctTitLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(separator).offset(10)
            make.bottom.equalTo(separator.snp.top).offset(-15)
        }
        correctLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(correctTitLabel)
            make.bottom.equalTo(correctTitLabel.snp.top).offset(-3)
        }
        wrongTitLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(separator).offset(-10)
            make.bottom.equalTo(separator.snp.top).offset(-15)
        }
        wrongLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(wrongTitLabel)
            make.bottom.equalTo(wrongTitLabel.snp.top).offset(-3)
        }
        separator.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(gradeBgView.snp.bottom).offset(85)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(18)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    @objc fileprivate func dismiss() {
        removeFromSuperview()
    }
    
    @objc fileprivate func confirm() {
        if isPass {
            delegate?.buyInsurance()
        }else {
            delegate?.reexamine()
        }
        dismiss()
    }
    
    // MARK: - View
    fileprivate var fenLabel: UILabel!
    fileprivate var gradeBgView: UIImageView!
    fileprivate var gradeLabel: UILabel!
    fileprivate var correctLabel: UILabel!
    fileprivate var wrongLabel: UILabel!
    fileprivate var tipsLabel: UILabel!
    fileprivate var confirmButton: UIButton!
}
