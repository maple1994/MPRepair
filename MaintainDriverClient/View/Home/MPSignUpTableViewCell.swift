//
//  MPSignUpTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/26.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 报名模型
class MPSignUpModel {
    /// 显示的标题
    var title: String?
    /// 填写的内容
    var content: String?
    /// 是否显示小三角
    var isShowDetailIcon: Bool = false
    var placeHolder: String?
    
    init(title: String?, content: String?, isShowDetailIcon: Bool, placeHolder: String?) {
        self.title = title
        self.content = content
        self.isShowDetailIcon = isShowDetailIcon
        self.placeHolder = placeHolder
    }
}

/// 报名页面Cell
class MPSignUpTableViewCell: UITableViewCell {
    
    var isShowLine: Bool = true {
        didSet {
            line?.isHidden = !isShowLine
        }
    }
    
    var signUpModel: MPSignUpModel? {
        didSet {
            titleLabel.text = signUpModel?.title
            let isShow = signUpModel?.isShowDetailIcon ?? false
            detailIcon.isHidden = !isShow
            textFiled.isHidden = isShow
            textFiled.placeholder = signUpModel?.placeHolder
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
        titleLabel = UILabel(font: UIFont.mpSmallFont, text: "姓名", textColor: UIColor.colorWithHexString("#4A4A4A"))
        textFiled = UITextField()
        textFiled.font = UIFont.mpSmallFont
        textFiled.textColor = UIColor.colorWithHexString("#9B9B9B")
        textFiled.placeholder = "请输入姓名"
        textFiled.textAlignment = .right
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "black_right_arrow")
        contentView.addSubview(titleLabel)
        contentView.addSubview(textFiled)
        contentView.addSubview(detailIcon)
        let line = MPUtils.createLine()
        contentView.addSubview(line)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        textFiled.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
        }
        detailIcon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        line.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(0.4)
            make.bottom.equalToSuperview()
        }
        self.line = line
    }
    
    fileprivate var titleLabel: UILabel!
    fileprivate var textFiled: UITextField!
    fileprivate var detailIcon: UIImageView!
    fileprivate weak var line: UIView?
}
