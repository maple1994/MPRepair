//
//  MPPickerView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/26.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import PGPickerView

protocol MPTextPickerViewDelegate: class {
    func pickerView(didSelect row: Int, text: String)
}

/// 选择一维数组的Text选择器
class MPTextPickerView: UIView {
    
    class func show(_ titleArr: [String], delegate: MPTextPickerViewDelegate?) {
        let pickerView = MPTextPickerView(titleArr: titleArr)
        pickerView.delegate = delegate
        pickerView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: mp_screenH)
        UIApplication.shared.keyWindow?.addSubview(pickerView)
    }
    
    weak var delegate: MPTextPickerViewDelegate?
    fileprivate var titleArr: [String]
    fileprivate let contentH: CGFloat = 265
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
        contentView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(0)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    init(titleArr: [String]) {
        self.titleArr = titleArr
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MPTextPickerView.dismiss))
        let bgView = UIView()
        bgView.addGestureRecognizer(tap)
        bgView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.4)
        addSubview(bgView)
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        let pickerView = PGPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(contentView)
        bgView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.top)
        }
        contentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(contentH)
            make.bottom.equalToSuperview().offset(contentH)
        }
        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
        let toolView = UIView()
        toolView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        contentView.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(pickerView.snp.top)
        }
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(MPTextPickerView.dismiss), for: .touchUpInside)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.mpDarkGray, for: .normal)
        cancelButton.titleLabel?.font = UIFont.mpNormalFont
        
        let confirmButton = UIButton()
        confirmButton.addTarget(self, action: #selector(MPTextPickerView.confirm), for: .touchUpInside)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(UIColor.navBlue, for: .normal)
        confirmButton.titleLabel?.font = UIFont.mpNormalFont
        toolView.addSubview(cancelButton)
        toolView.addSubview(confirmButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(60)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(60)
        }
    }
    
    @objc fileprivate func dismiss() {
        contentView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(contentH)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @objc fileprivate func confirm() {
        let row = selectedRow ?? 0
        delegate?.pickerView(didSelect: row, text: titleArr[row])
        dismiss()
    }
    
    fileprivate var selectedRow: Int?
    fileprivate var contentView: UIView!
}

extension MPTextPickerView: PGPickerViewDataSource, PGPickerViewDelegate {
    func numberOfComponents(in pickerView: PGPickerView!) -> Int {
        return 1
    }
    func pickerView(_ pickerView: PGPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return titleArr.count
    }
    func pickerView(_ pickerView: PGPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return titleArr[row]
    }
    func pickerView(_ pickerView: PGPickerView!, textColorOfOtherRowInComponent component: Int) -> UIColor! {
        return UIColor.colorWithHexString("333333")
    }
    func pickerView(_ pickerView: PGPickerView!, textColorOfSelectedRowInComponent component: Int) -> UIColor! {
        return UIColor.navBlue
    }
    func pickerView(_ pickerView: PGPickerView!, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}

