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
    
    fileprivate let editViewH: CGFloat = 60
    fileprivate var itemList: [MPComboItemModel]
    
    init(itemArr: [MPComboItemModel]) {
        itemList = itemArr
        super.init(frame: CGRect.zero)
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(MPSelectItemView.keyboardShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPSelectItemView.keyboardHidden(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        addSubview(editBgView)
        addSubview(editView)
        editView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(editViewH)
        }
        editBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func keyboardShow(noti: Notification) {
        guard let info = noti.userInfo else {
            return
        }
        editBgView.isHidden = false
        if let duration = info["UIKeyboardAnimationDurationUserInfoKey"] as? Double,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let h = keyboardFrame.height + editViewH
            UIView.animate(withDuration: duration) {
                self.editView.transform = CGAffineTransform.init(translationX: 0, y: -h)
            }
        }
    }
    
    @objc func keyboardHidden(noti: Notification) {
        if let duration = noti.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double {
            UIView.animate(withDuration: duration) {
                self.editView.transform = CGAffineTransform.identity
            }
        }
        editBgView.isHidden = true
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
    
    // MARK: - Action
    @objc fileprivate func updateOrComplete() {
        
    }
    
    @objc fileprivate func dismissAction() {
        hide()
    }
    
    @objc fileprivate func confirmAction() {
        
    }
    
    @objc fileprivate func removeEditView() {
        editView.hideKeyBoard()
        editBgView.isHidden = true
    }
    
    // MARK: - View
    fileprivate var contentView: UIView!
    fileprivate var bgView: UIControl!
    fileprivate var tableView: UITableView!
    fileprivate lazy var editView: MPEditView = {
        let tv = MPEditView()
        tv.setKeyBoardType(UIKeyboardType.decimalPad)
        return tv
    }()
    fileprivate lazy var editBgView: UIControl = {
        let view = UIControl()
        view.isHidden = true
        view.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        view.addTarget(self, action: #selector(MPSelectItemView.removeEditView), for: .touchDown)
        return view
    }()
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPSelectItemView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPSelectCell") as? MPSelectCell
        if cell == nil {
            cell = MPSelectCell(reuseIdentifier: "MPSelectCell", isShowCheckBox: true)
        }
        cell?.itemModel = itemList[indexPath.row]
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension MPSelectItemView: MPSelectCellDelegate {
    func didShowKeyBoard(_ cell: MPSelectCell, moneyStr: String) {
        guard let ip = tableView.indexPath(for: cell) else {
            return
        }
        editView.showKeyBoard(moneyStr, title: "金额") { [weak self] (money) in
            if let price = money?.toDouble() {
                self?.itemList[ip.row].price = price
            }else {
                MPTipsView.showMsg("请输入合法数字")
            }
            self?.tableView.reloadData()
        }
    }
}

protocol MPSelectCellDelegate: class {
    func didShowKeyBoard(_ cell: MPSelectCell, moneyStr: String)
}

/// 年检未过Item选择View的Cell
class MPSelectCell: UITableViewCell {
    weak var delegate: MPSelectCellDelegate?
    var itemModel: MPComboItemModel? {
        didSet {
            nameLabel.text = itemModel?.name
            let money = itemModel?.price ?? 0
            if money == 0 {
                moneyLabel.text = "请输入金额"
            }else {
                moneyLabel.text = String(format: "%.2f", money)
            }
        }
    }
    
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
        moneyLabel = UILabel(font: UIFont.mpSmallFont, text: "请输入金额", textColor: UIColor.mpLightGary)
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
        contentView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        let control = UIControl()
        control.addTarget(self, action: #selector(MPSelectCell.showKeyBoard), for: .touchUpInside)
        contentView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(moneyLabel)
        }
    }
    
    @objc fileprivate func showKeyBoard() {
        let price = itemModel?.price ?? 0
        delegate?.didShowKeyBoard(self, moneyStr: "\(price)")
    }
    
    /// 选择按钮
    fileprivate var checkBoxView: UIImageView?
    /// 检查项
    fileprivate var nameLabel: UILabel!
    /// moneyLabel
    fileprivate var moneyLabel: UILabel!
}








