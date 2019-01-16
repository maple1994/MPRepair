//
//  MPAdderssPickerView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/27.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import PGPickerView

/// 地址选择器
class MPAdderssPickerView: UIView {

    class func show(delegate: MPTextPickerViewDelegate?) {
        let pickerView = MPAdderssPickerView()
        pickerView.delegate = delegate
        pickerView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: mp_screenH)
        UIApplication.shared.keyWindow?.addSubview(pickerView)
    }
    
    weak var delegate: MPTextPickerViewDelegate?
    fileprivate let contentH: CGFloat = 265
    /// 地址第一级
    fileprivate var firstRow: Int = 0
    /// 地址第二级
    fileprivate var secondRow: Int = 0
    /// 地址第三级
    fileprivate var thridRow: Int = 0
    
    fileprivate lazy var addressModelArr: [MPAddressModel] = loadAddressData()
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
    
    /// 加载地址模型
    fileprivate func loadAddressData() -> [MPAddressModel] {
        var modelArr = [MPAddressModel]()
        guard let path = Bundle.main.path(forResource: "address.json", ofType: nil) else {
            return modelArr
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data.init(contentsOf: url) else {
            return modelArr
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return modelArr
        }
        guard let dic = json?["data"] as? [[String: Any]] else {
            return modelArr
        }
        for dic1 in dic {
            if
                let ID1 = dic1["id"] as? Int,
                let name1 = dic1["name"] as? String {
                var model1 = MPAddressModel(id: ID1, name: name1)
                var children = [MPAddressModel]()
                if let dic2 = dic1["children"] as? [[String: Any]] {
                    for dic3 in dic2 {
                        if
                            let ID2 = dic3["id"] as? Int,
                            let name2 = dic3["name"] as? String {
                            var model2 = MPAddressModel(id: ID2, name: name2)
                            var children2 = [MPAddressModel]()
                            if let dic4 = dic3["children"] as? [[String: Any]] {
                                for dic5 in dic4 {
                                    if let ID3 = dic5["id"] as? Int,
                                    let name3 = dic5["name"] as? String {
                                        let model3 = MPAddressModel(id: ID3, name: name3)
                                        children2.append(model3)
                                    }
                                }
                            }
                            model2.children = children2
                            children.append(model2)
                        }
                    }
                }
                model1.children = children
                modelArr.append(model1)
            }
        }
        
        return modelArr
    }
    
    fileprivate func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MPAdderssPickerView.dismiss))
        let bgView = UIView()
        bgView.addGestureRecognizer(tap)
        bgView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.4)
        addSubview(bgView)
        contentView = UIView()
        contentView.backgroundColor = UIColor.white
        pickerView = PGPickerView()
        pickerView.textColorOfSelectedRow = UIColor.navBlue
        pickerView.textColorOfOtherRow = UIColor.colorWithHexString("333333")
        pickerView.textFontOfSelectedRow = UIFont.mpXSmallFont
        pickerView.textFontOfOtherRow = UIFont.mpXSmallFont
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
        cancelButton.addTarget(self, action: #selector(MPAdderssPickerView.dismiss), for: .touchUpInside)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.mpDarkGray, for: .normal)
        cancelButton.titleLabel?.font = UIFont.mpNormalFont
        
        let confirmButton = UIButton()
        confirmButton.addTarget(self, action: #selector(MPAdderssPickerView.confirm), for: .touchUpInside)
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
        guard let pro = pickerView.textOfSelectedRow(inComponent: 0),
        let shi = pickerView.textOfSelectedRow(inComponent: 1),
        let xian = pickerView.textOfSelectedRow(inComponent: 2) else {
            return
        }
        let content = pro + shi + xian
        delegate?.pickerView(didSelect: 0, text: content)
        dismiss()
    }
    
    fileprivate var pickerView: PGPickerView!
    fileprivate var selectedText: String?
    fileprivate var contentView: UIView!
}

extension MPAdderssPickerView: PGPickerViewDataSource, PGPickerViewDelegate {
    func numberOfComponents(in pickerView: PGPickerView!) -> Int {
        return 3
    }
    func pickerView(_ pickerView: PGPickerView!, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return addressModelArr.count
        case 1:
            return addressModelArr[firstRow].children.count
        case 2:
            secondRow = pickerView.selectedRow(inComponent: 1)
            if secondRow < 0 || secondRow >= addressModelArr[firstRow].children.count {
                secondRow = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.pickerView.selectRow(0, inComponent: 1, animated: false)
                }
            }
            return addressModelArr[firstRow].children[secondRow].children.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: PGPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return addressModelArr[row].name
        case 1:
            return addressModelArr[firstRow].children[row].name
        case 2:
            return addressModelArr[firstRow].children[secondRow].children[row].name
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: PGPickerView!, textColorOfOtherRowInComponent component: Int) -> UIColor! {
        return UIColor.colorWithHexString("333333")
    }
    func pickerView(_ pickerView: PGPickerView!, textColorOfSelectedRowInComponent component: Int) -> UIColor! {
        return UIColor.navBlue
    }
    func pickerView(_ pickerView: PGPickerView!, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            firstRow = row
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        case 1:
            pickerView.reloadComponent(2)
        case 2:
            thridRow = row
        default:
            break
        }
    }
}

/// 地址模型
struct MPAddressModel {
    var id: Int
    var name: String
    var children: [MPAddressModel] = [MPAddressModel] ()
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}


