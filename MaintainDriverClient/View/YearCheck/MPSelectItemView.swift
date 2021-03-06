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
    /// 是否处于编辑中...，此时数据源用itemList
    /// 否则用selectedItemList
    fileprivate var isEdting: Bool = true
    fileprivate var selectedItemList: [MPComboItemModel] = [MPComboItemModel]()
    fileprivate var confirmBlock: (([MPComboItemModel]) -> Void)?
    
    init(itemArr: [MPComboItemModel], callback: (([MPComboItemModel]) -> Void)?) {
        itemList = itemArr
        super.init(frame: CGRect.zero)
        confirmBlock = callback
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
        editBtn = UIButton()
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
        tableView.showsVerticalScrollIndicator = false
        
        let line1 = MPUtils.createLine()
        let line2 = MPUtils.createLine()
        contentView.addSubview(titleLabel)
        contentView.addSubview(editBtn)
        contentView.addSubview(tableView)
        contentView.addSubview(confirmButton)
        contentView.addSubview(line1)
        contentView.addSubview(line2)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(15)
        }
        editBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(60)
        }
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(1)
        }
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.bottom.equalTo(confirmButton.snp.top).offset(-35)
        }
        
        line2.snp.makeConstraints { (make) in
            make.top.equalTo(confirmButton.snp.top).offset(-25)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(1)
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
        if isEdting {
            setupSelectedItem()
        }else {
            editBtn.setTitle("完成", for: .normal)
            isEdting = true
            tableView.reloadData()
        }
    }
    
    @objc fileprivate func dismissAction() {
        hide()
    }
    
    @objc fileprivate func confirmAction() {
        if isEdting {
            setupSelectedItem()
        }else {
            confirmBlock?(selectedItemList)
            hide()
        }
    }
    
    fileprivate func setupSelectedItem() {
        selectedItemList = [MPComboItemModel]()
        for item in itemList {
            if item.isSelected && item.price == 0 {
                MPTipsView.showMsg("请输入金额")
                return
            }
            if item.isSelected && item.price != 0 {
                let model = MPComboItemModel()
                model.id = item.id
                model.name = item.name
                model.price = item.price
                model.isSelected = true
                selectedItemList.append(model)
            }
        }
        if selectedItemList.count == 0 {
            MPTipsView.showMsg("请选择年检项")
            return
        }
        editBtn.setTitle("编辑", for: .normal)
        isEdting = false
        tableView.reloadData()
    }
    
    @objc fileprivate func removeEditView() {
        editView.hideKeyBoard()
        editBgView.isHidden = true
    }
    
    // MARK: - View
    fileprivate var editBtn: UIButton!
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
        if isEdting {
            return itemList.count
        }else {
            return selectedItemList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: MPComboItemModel? = nil
        var isShowCheckBox: Bool = true
        if isEdting {
            model = itemList[indexPath.row]
            isShowCheckBox = true
        }else {
            model = selectedItemList[indexPath.row]
            isShowCheckBox = false
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPSelectCell\(isShowCheckBox)") as? MPSelectCell
        if cell == nil {
            cell = MPSelectCell(reuseIdentifier: "MPSelectCell\(isShowCheckBox)", isShowCheckBox: isShowCheckBox)
        }
        cell?.itemModel = model
        if isEdting {
            cell?.delegate = self
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemList[indexPath.row].isSelected = !itemList[indexPath.row].isSelected
        tableView.reloadData()
    }
}

extension MPSelectItemView: MPSelectCellDelegate {
    func didShowKeyBoard(_ cell: MPSelectCell, moneyStr: String) {
        guard let ip = tableView.indexPath(for: cell) else {
            return
        }
        editView.showKeyBoard(moneyStr, title: "金额") { [weak self] (money) in
            let price = money?.toDouble() ?? 0
            self?.itemList[ip.row].price = price
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
            if isShowCheckBox {
                let money = itemModel?.price ?? 0
                if money == 0 {
                    moneyLabel.text = "请输入金额"
                }else {
                    moneyLabel.text = String(format: "%.2f", money)
                }
                let isSelected = itemModel?.isSelected ?? false
                if isSelected {
                    checkBoxView?.image = UIImage(named: "box_selected")
                }else {
                    checkBoxView?.image = UIImage(named: "box_unselected")
                }
            }else {
                let money = itemModel?.price ?? 0
                moneyLabel.text = "￥\(money)"
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
        nameLabel = UILabel(font: UIFont.mpSmallFont, text: "排气", textColor: UIColor.black)
        if isShowCheckBox {
            setupCheckBoxStyle()
        }else {
            setupNoCheckBoxStyle()
        }
    }
    
    fileprivate func setupCheckBoxStyle() {
        checkBoxView = UIImageView()
        checkBoxView?.image = UIImage(named: "box_unselected")
        moneyLabel = UILabel(font: UIFont.mpSmallFont, text: "请输入金额", textColor: UIColor.mpLightGary)
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkBoxView!)
        contentView.addSubview(moneyLabel)
        checkBoxView?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.width.height.equalTo(18)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkBoxView!.snp.trailing).offset(10)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        let control = UIControl()
        control.addTarget(self, action: #selector(MPSelectCell.showKeyBoard), for: .touchUpInside)
        contentView.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(120)
        }
    }
    
    fileprivate func setupNoCheckBoxStyle() {
        moneyLabel = UILabel(font: UIFont.mpSmallFont, text: "￥500", textColor: UIColor.red)
        contentView.addSubview(nameLabel)
        contentView.addSubview(moneyLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    @objc fileprivate func showKeyBoard() {
        let price = itemModel?.price ?? 0
        var text = "\(price)"
        if price == 0 {
            text = ""
        }
        delegate?.didShowKeyBoard(self, moneyStr: text)
    }
    
    /// 选择按钮
    fileprivate var checkBoxView: UIImageView?
    /// 检查项
    fileprivate var nameLabel: UILabel!
    /// moneyLabel
    fileprivate var moneyLabel: UILabel!
}








