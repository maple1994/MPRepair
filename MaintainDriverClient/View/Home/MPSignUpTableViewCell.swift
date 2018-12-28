//
//  MPSignUpTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/26.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// Pciker的类型
enum MPPickerType {
    /// 一维文本选择器
    case text
    /// 年月选择器
    case date
    /// 地址选择器
    case address
    /// 没有选择器
    case none
}

/// 报名模型
class MPSignUpModel {
    /// 显示的标题
    var title: String?
    /// 填写的内容
    var content: String?
    /// 是否显示小三角
    var isShowDetailIcon: Bool = false
    /// picker类型
    var pickerType: MPPickerType = .none
    /// 当pickerType == .text时，显示的内容
    var pickerContent: [String] = [String]()
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
            textFiled.placeholder = signUpModel?.placeHolder
            let content = signUpModel?.content ?? ""
            let type = signUpModel?.pickerType ?? .none
            let isShow = signUpModel?.isShowDetailIcon ?? false
            detailIcon.isHidden = !isShow
            pickerLabel.isHidden = detailIcon.isHidden
            textFiled.isHidden = isShow
            if !content.isEmpty {
                if type == .none {
                    textFiled.text = content
                }else {
                    pickerLabel.text = content
                }
            }else {
                pickerLabel.text = ""
                textFiled.text = ""
            }
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
        pickerLabel = UILabel(font: UIFont.mpSmallFont, text: "", textColor: UIColor.colorWithHexString("#9B9B9B"))
        textFiled = UITextField()
        textFiled.delegate = self
        textFiled.font = UIFont.mpSmallFont
        textFiled.textColor = UIColor.colorWithHexString("#9B9B9B")
        textFiled.placeholder = "请输入姓名"
        textFiled.textAlignment = .right
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "black_right_arrow")
        contentView.addSubview(titleLabel)
        contentView.addSubview(textFiled)
        contentView.addSubview(detailIcon)
        contentView.addSubview(pickerLabel)
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
        pickerLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(detailIcon.snp.leading).offset(-5)
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
    fileprivate var pickerLabel: UILabel!
}

extension MPSignUpTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        signUpModel?.content = textField.trimText
    }
}
