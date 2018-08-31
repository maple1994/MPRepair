//
//  MPEditView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/11.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 编辑界面
class MPEditView: UIView {
    
    func showKeyBoard(_ text: String?, callBack: ((String?) -> Void)?) {
        editView.text = text
        self.callBack = callBack
        editView.becomeFirstResponder()
    }
    
    func hideKeyBoard() {
        editView.resignFirstResponder()
    }
    
    fileprivate var callBack: ((String) -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        editView = UITextView()
        editView.font = UIFont.mpNormalFont
        editView.textColor = UIColor.fontBlack
        editView.returnKeyType = .done
        editView.delegate = self
        titleLabel = UILabel(font: UIFont.mpNormalFont, text: "昵称", textColor: UIColor.mpDarkGray)
        addSubview(editView)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(10)
        }
        editView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate var editView: UITextView!
    fileprivate var titleLabel: UILabel!
}

extension MPEditView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView.text.isEmpty {
                MPTipsView.showMsg("昵称不能为空！")
                return false
            }
            textView.resignFirstResponder()
            callBack?(textView.text)
            return false
        }
        return true
    }
}




