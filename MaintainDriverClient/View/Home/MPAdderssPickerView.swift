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
        tableView1 = createTb()
        tableView2 = createTb()
        tableView3 = createTb()
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
        contentView.addSubview(tableView1)
        contentView.addSubview(tableView2)
        contentView.addSubview(tableView3)
        tableView1.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(220)
            make.width.equalTo(tableView2)
            make.width.equalTo(tableView3)
        }
        tableView2.snp.makeConstraints { (make) in
            make.leading.equalTo(tableView1.snp.trailing)
            make.trailing.equalTo(tableView3.snp.leading)
            make.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
        tableView3.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
        let toolView = UIView()
        toolView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        contentView.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tableView1.snp.top)
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
    
    fileprivate func createTb() -> UITableView {
        let tb = UITableView()
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.delegate = self
        tb.dataSource = self
        return tb
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
        let pro = addressModelArr[firstRow].name
        let shi = addressModelArr[firstRow].children[secondRow].name
        let xian = addressModelArr[firstRow].children[secondRow].children[thridRow].name
        let content = pro + shi + xian
        delegate?.pickerView(didSelect: 0, text: content)
        dismiss()
    }
    
    // MARK: - View
    fileprivate var tableView1: UITableView!
    fileprivate var tableView2: UITableView!
    fileprivate var tableView3: UITableView!
    fileprivate var selectedText: String?
    fileprivate var contentView: UIView!
}

extension MPAdderssPickerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1
        {
            return addressModelArr.count
        }
        else if tableView == tableView2 {
            return addressModelArr[firstRow].children.count
        }
        else
        {
            if secondRow < 0 || secondRow >= addressModelArr[firstRow].children.count
            {
                secondRow = 0
            }
            return addressModelArr[firstRow].children[secondRow].children.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPTextPickerCell") as? MPTextPickerCell
        if cell == nil {
            cell = MPTextPickerCell(style: .default, reuseIdentifier: "MPTextPickerCell")
        }
        if tableView == tableView1 {
            cell?.centerLabel.text = addressModelArr[indexPath.row].name
            cell?.isChecked = indexPath.row == firstRow
        }else if tableView == tableView2 {
            cell?.centerLabel.text = addressModelArr[firstRow].children[indexPath.row].name
            cell?.isChecked = indexPath.row == secondRow
        }else {
            cell?.centerLabel.text = addressModelArr[firstRow].children[secondRow].children[indexPath.row].name
            cell?.isChecked = indexPath.row == thridRow
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            firstRow = indexPath.row
            secondRow = 0
            thridRow = 0
            tableView1.reloadData()
            tableView2.reloadData()
            tableView3.reloadData()
            scrollToTop(tableView2)
            scrollToTop(tableView3)
        }else if tableView == tableView2 {
            secondRow = indexPath.row
            thridRow = 0
            tableView2.reloadData()
            tableView3.reloadData()
            scrollToTop(tableView3)
        }else {
            thridRow = indexPath.row
            tableView3.reloadData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tableView1 {
            adjust(tableView: tableView1, offsetY: scrollView.contentOffset.y)
        }else if scrollView == tableView2 {
            adjust(tableView: tableView2, offsetY: scrollView.contentOffset.y)
        }else {
            adjust(tableView: tableView3, offsetY: scrollView.contentOffset.y)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        if scrollView == tableView1 {
            adjust(tableView: tableView1, offsetY: scrollView.contentOffset.y)
        }else if scrollView == tableView2 {
            adjust(tableView: tableView2, offsetY: scrollView.contentOffset.y)
        }else {
            adjust(tableView: tableView3, offsetY: scrollView.contentOffset.y)
        }
    }
    
    fileprivate func adjust(tableView: UITableView, offsetY: CGFloat) {
        let rowH: CGFloat = 44
        let row = (Int)(offsetY / rowH)
        let ip = IndexPath(row: row, section: 0)
        tableView.scrollToRow(at: ip, at: .top, animated: true)
    }
    
    fileprivate func scrollToTop(_ tb: UITableView) {
        let ip = IndexPath(row: 0, section: 0)
        tb.scrollToRow(at: ip, at: .top, animated: true)
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


