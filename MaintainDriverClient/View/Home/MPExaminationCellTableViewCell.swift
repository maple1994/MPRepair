//
//  MPExaminationCellTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 试卷Cell
class MPExaminationCellTableViewCell: UITableViewCell {
    
    var model: MPExaminationModel? {
        didSet {
            questionLabel.text = model?.content
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        questionLabel = UILabel(font: UIFont.mpSmallFont, text: "01. 驾驶机动车在道路上违反道路交通安", textColor: UIColor.colorWithHexString("#4A4A4A"))
        questionLabel.numberOfLines = 0
        optionButton1 = MPCheckBoxButton()
        optionButton1.title = "A: 违章行为"
        optionButton2 = MPCheckBoxButton()
        optionButton2.title = "B: 违法行为"
        optionButton3 = MPCheckBoxButton()
        optionButton3.title = "C: 过失行为"
        optionButton1.addTarget(self, action: #selector(MPExaminationCellTableViewCell.optionAction(_:)), for: .touchUpInside)
        optionButton2.addTarget(self, action: #selector(MPExaminationCellTableViewCell.optionAction(_:)), for: .touchUpInside)
        optionButton3.addTarget(self, action: #selector(MPExaminationCellTableViewCell.optionAction(_:)), for: .touchUpInside)
        
        let line = MPUtils.createLine()
        contentView.addSubview(questionLabel)
        contentView.addSubview(optionButton1)
        contentView.addSubview(optionButton2)
        contentView.addSubview(optionButton3)
        contentView.addSubview(line)
        questionLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
        }
        optionButton1.snp.makeConstraints { (make) in
            make.leading.equalTo(questionLabel)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
        optionButton2.snp.makeConstraints { (make) in
            make.leading.equalTo(questionLabel)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(optionButton1.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
        optionButton3.snp.makeConstraints { (make) in
            make.leading.equalTo(questionLabel)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(optionButton2.snp.bottom).offset(10).priority(.low)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
            make.height.equalTo(35)
        }
        line.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.4)
        }
    }
    
    @objc fileprivate func optionAction(_ btn: MPCheckBoxButton) {
        if btn.isChecked {
            return
        }
        optionButton1.isChecked = (btn == optionButton1)
        optionButton2.isChecked = (btn == optionButton2)
        optionButton3.isChecked = (btn == optionButton3)
    }
    
    fileprivate var questionLabel: UILabel!
    fileprivate var optionButton1: MPCheckBoxButton!
    fileprivate var optionButton2: MPCheckBoxButton!
    fileprivate var optionButton3: MPCheckBoxButton!
}
