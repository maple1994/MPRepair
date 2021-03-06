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
    
    func showKeyBoard(_ text: String?, title: String?, callBack: ((String?) -> Void)?) {
        editView.text = text
        self.callBack = callBack
        titleLabel.text = title
        editView.becomeFirstResponder()
    }
    
    func hideKeyBoard() {
        editView.resignFirstResponder()
    }
    
    func setKeyBoardType(_ type: UIKeyboardType) {
        if type == .decimalPad {
            let keyboard = WLDecimalKeyboard()
            keyboard.done = { [weak self] in
                self?.callBack?(self?.editView.text ?? "")
            }
            editView.inputView = keyboard
        }else if type == .numberPad {
            let keyboard = WLDecimalKeyboard(type: WLKeyBoadyTypeNumberPad)
            keyboard.done = { [weak self] in
                self?.callBack?(self?.editView.text ?? "")
            }
            editView.inputView = keyboard
        }else {
            editView.inputView = nil
            editView.keyboardType = type
        }
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
    
    var editView: UITextView!
    fileprivate var titleLabel: UILabel!
}

extension MPEditView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView.trimText.isEmpty {
                MPTipsView.showMsg("内容不能为空！")
                return false
            }
            textView.resignFirstResponder()
            callBack?(textView.trimText)
            return false
        }
        return true
    }
}




