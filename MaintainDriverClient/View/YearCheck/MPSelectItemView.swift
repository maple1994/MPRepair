//
//  MPYearCheckItemView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/17.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// 年检未过的Item选择View
class MPSelectItemView: UIView {
    
    func show() {
        IQKeyboardManager.shared.enableAutoToolbar = false
        layoutIfNeeded()
        contentView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(0)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hide() {
        IQKeyboardManager.shared.enableAutoToolbar = true
        contentView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(440)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.removeFromSuperview()
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
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        bgView = UIControl()
        bgView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        bgView.addTarget(self, action: #selector(MPSelectItemView.dismissAction), for: .touchUpInside)
        keyWindow.addSubview(self)
        addSubview(bgView)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.setupCorner(8)
        addSubview(contentView)
        let tmpView = UIView()
        tmpView.backgroundColor = UIColor.white
        addSubview(tmpView)
        contentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(440)
            make.bottom.equalToSuperview().offset(440)
        }
        tmpView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        setupContentView()
    }
    
    fileprivate func setupContentView() {
        let titleLabel = UILabel(font: UIFont.mpNormalFont, text: "年检未过项", textColor: UIColor.black)
        let editBtn = UIButton()
        editBtn.setTitleColor(UIColor.navBlue, for: .normal)
        editBtn.setTitle("完成", for: .normal)
        editBtn.titleLabel?.font = UIFont.mpSmallFont
        editBtn.addTarget(self, action: #selector(MPSelectItemView.updateOrComplete), for: .touchUpInside)
        let confirmButton = UIButton()
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.backgroundColor = UIColor.navBlue
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.mpBigFont
        confirmButton.addTarget(self, action: #selector(MPSelectItemView.confirmAction), for: .touchUpInside)
        confirmButton.setupCorner(4)
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 38
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(editBtn)
        contentView.addSubview(tableView)
        contentView.addSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(15)
        }
        editBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(60)
        }
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.bottom.equalTo(confirmButton.snp.top).offset(-35)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }
    
    @objc fileprivate func updateOrComplete() {
        
    }
    
    @objc fileprivate func dismissAction() {
        hide()
    }
    
    @objc fileprivate func confirmAction() {
        
    }
    
    fileprivate var contentView: UIView!
    fileprivate var bgView: UIControl!
    fileprivate var tableView: UITableView!
}

extension MPSelectItemView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPSelectCell") as? MPSelectCell
        if cell == nil {
            cell = MPSelectCell(reuseIdentifier: "MPSelectCell", isShowCheckBox: true)
        }
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension MPSelectItemView: MPSelectCellDelegate {
    func didShowKeyBoard(_ cell: MPSelectCell) {
        let ip = tableView.indexPath(for: cell)
        tableView.setContentOffset(CGPoint(x: 0, y: CGFloat(ip!.row) * 38), animated: true)
    }
    func didHiddenKeyBoady(_ cell: MPSelectCell) {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

protocol MPSelectCellDelegate: class {
    func didShowKeyBoard(_ cell: MPSelectCell)
    func didHiddenKeyBoady(_ cell: MPSelectCell)
}

/// 年检未过Item选择View的Cell
class MPSelectCell: UITableViewCell {
    weak var delegate: MPSelectCellDelegate?
    fileprivate var isShowCheckBox: Bool
    init(reuseIdentifier: String?, isShowCheckBox: Bool) {
        self.isShowCheckBox = isShowCheckBox
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        if isShowCheckBox {
            checkBoxView = UIImageView()
            checkBoxView?.image = UIImage(named: "box_unselected")
        }
        nameLabel = UILabel(font: UIFont.mpSmallFont, text: "排气", textColor: UIColor.black)
        moneyInputView = UITextField()
        moneyInputView.placeholder = "请输入金额"
        moneyInputView.textColor = UIColor.mpLightGary
        moneyInputView.font = UIFont.mpSmallFont
        moneyInputView.delegate = self
        contentView.addSubview(nameLabel)
        if isShowCheckBox {
            contentView.addSubview(checkBoxView!)
            checkBoxView?.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(25)
                make.width.height.equalTo(18)
            }
            nameLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalTo(checkBoxView!.snp.trailing).offset(10)
            }
        }else {
            nameLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(25)
            }
        }
        contentView.addSubview(moneyInputView)
        moneyInputView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(80)
        }
    }
    
    /// 选择按钮
    fileprivate var checkBoxView: UIImageView?
    /// 检查项
    fileprivate var nameLabel: UILabel!
    /// 输入框
    fileprivate var moneyInputView: UITextField!
}

// MARK: - UITextFieldDelegate
extension MPSelectCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didShowKeyBoard(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didHiddenKeyBoady(self)
    }
}









