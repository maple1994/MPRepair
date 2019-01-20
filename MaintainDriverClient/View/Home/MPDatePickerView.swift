//
//  MPDatePickerView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/27.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import PGDatePicker

/// 日期选择器
class MPDatePickerView: UIView {
    class func show(delegate: MPTextPickerViewDelegate?) {
        let pickerView = MPDatePickerView()
        pickerView.delegate = delegate
        pickerView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: mp_screenH)
        UIApplication.shared.keyWindow?.addSubview(pickerView)
    }
    
    weak var delegate: MPTextPickerViewDelegate?
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
    
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MPDatePickerView.dismiss))
        let bgView = UIView()
        bgView.addGestureRecognizer(tap)
        bgView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.4)
        addSubview(bgView)
        
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        let pickerView = PGDatePicker()
        pickerView.locale = Locale(identifier: "zh-CN")
        pickerView.timeZone = TimeZone(secondsFromGMT: 8 * 3600)
        pickerView.maximumDate = Date()
        pickerView.setDate(Date())
        pickerView.textColorOfSelectedRow = UIColor.navBlue
        pickerView.textColorOfOtherRow = UIColor.colorWithHexString("333333")
        pickerView.textFontOfOtherRow = UIFont.mpNormalFont
        pickerView.textFontOfSelectedRow = UIFont.mpNormalFont
        pickerView.datePickerType = .type1
        pickerView.isHiddenMiddleText = true
        pickerView.datePickerMode = .date
        pickerView.delegate = self
        addSubview(contentView)
        self.pickerView = pickerView
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
        cancelButton.addTarget(self, action: #selector(MPDatePickerView.dismiss), for: .touchUpInside)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.mpDarkGray, for: .normal)
        cancelButton.titleLabel?.font = UIFont.mpNormalFont
        
        let confirmButton = UIButton()
        confirmButton.addTarget(self, action: #selector(MPDatePickerView.confirm), for: .touchUpInside)
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
        pickerView?.tapSelectedHandler()
        dismiss()
    }
    
    fileprivate weak var pickerView: PGDatePicker?
    fileprivate var selectedText: String?
    fileprivate var contentView: UIView!
}

extension MPDatePickerView: PGDatePickerDelegate {
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else {
            return
        }
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateStr = format.string(from: date)
        delegate?.pickerView(didSelect: 0, text: dateStr)
    }
}
