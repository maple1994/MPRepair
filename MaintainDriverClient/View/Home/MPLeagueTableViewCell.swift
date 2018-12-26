//
//  MPLeagueTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/26.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 司机加盟Cell
class MPLeagueTableViewCell: UITableViewCell {
    
    func setupCell(num: Int, title: String, content: String, isHiddenLine: Bool) {
        numLabel.text = "\(num)"
        titleLabel.text = title
        contentLabel.text = content
        line.isHidden = isHiddenLine
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        titleLabel = UILabel(font: UIFont.mpSmallFont, text: "基本信息提交", textColor: UIColor.colorWithHexString("#010101"))
        contentLabel = UILabel(font: UIFont.systemFont(ofSize: 13), text: "根据注册内容指引如实并完整提交信息（姓名", textColor: UIColor.colorWithHexString("#9B9B9B"))
        contentLabel.numberOfLines = 0
        numLabel = UILabel(font: UIFont.systemFont(ofSize: 12), text: "1", textColor: UIColor.white)
        numLabel.backgroundColor = UIColor.navBlue
        numLabel.setupCorner(7.5)
        numLabel.textAlignment = .center
        line = UIView()
        line.backgroundColor = UIColor.mpLightGary
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(line)
        
        numLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(15)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(numLabel)
            make.leading.equalTo(numLabel.snp.trailing).offset(10)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-40)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(numLabel.snp.bottom)
            make.leading.equalToSuperview().offset(27)
            make.width.equalTo(0.4)
            make.bottom.equalTo(contentLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    fileprivate var titleLabel: UILabel!
    fileprivate var contentLabel: UILabel!
    fileprivate var numLabel: UILabel!
    fileprivate var line: UIView!

}
