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
        tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
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
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
        let toolView = UIView()
        toolView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        contentView.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tableView.snp.top)
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
        delegate?.pickerView(didSelect: selectedRow, text: titleArr[selectedRow])
        dismiss()
    }
    
    fileprivate var selectedRow: Int = 0
    fileprivate var contentView: UIView!
    fileprivate var tableView: UITableView!
}

extension MPTextPickerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPTextPickerCell") as? MPTextPickerCell
        if cell == nil {
            cell = MPTextPickerCell(style: .default, reuseIdentifier: "ID")
        }
        cell?.centerLabel?.text = titleArr[indexPath.row]
        cell?.isChecked = indexPath.row == selectedRow
        cell?.isHiddenLine = indexPath.row == titleArr.count - 1
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.reloadData()
    }
}


class MPTextPickerCell: UITableViewCell {
    fileprivate let normalColor = UIColor.colorWithHexString("333333")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        centerLabel = UILabel(font: UIFont.mpNormalFont, text: nil, textColor: normalColor)
        centerLabel.textAlignment = .center
        centerLabel.adjustsFontSizeToFitWidth = true
        line = MPUtils.createLine()
        contentView.addSubview(centerLabel)
        contentView.addSubview(line)
        centerLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        line.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        line.isHidden = true
    }
    
    var centerLabel: UILabel!
    var line: UIView!
    var isChecked: Bool = false {
        didSet {
            let color = isChecked ? UIColor.navBlue : normalColor
            centerLabel.textColor = color
        }
    }
    var isHiddenLine: Bool = false {
        didSet {
            line.isHidden = isHiddenLine
        }
    }
}
