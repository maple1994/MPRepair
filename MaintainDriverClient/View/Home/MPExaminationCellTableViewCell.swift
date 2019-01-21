//
//  MPExaminationCellTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 试卷Cell
class MPExaminationCellTableViewCell: UITableViewCell {
    
    var model: MPExaminationModel? {
        didSet {
            questionLabel.text = model?.content
            answerView.itemList = model?.item_list
            answerView.isMulti = model?.is_multiple ?? false
            if let itemH = model?.itemListHeight {
                answerView.snp.updateConstraints { (make) in
                    make.height.equalTo(itemH)
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        questionLabel = UILabel(font: UIFont.mpSmallFont, text: "01. 驾驶机动车在道路上违反道路交通安", textColor: UIColor.colorWithHexString("#4A4A4A"))
        questionLabel.numberOfLines = 0
        answerView = MPAnswerView()
        let line = MPUtils.createLine()
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerView)
        contentView.addSubview(line)
        questionLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
        }
        answerView.snp.makeConstraints { (make) in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(140)
        }
        line.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc fileprivate func optionAction(_ btn: MPCheckBoxButton) {
    }
    
    fileprivate var questionLabel: UILabel!
    fileprivate var answerView: MPAnswerView!
}


class MPAnswerView: UIView {
    /// 是否是多选
    var isMulti: Bool = false
    var itemList: [MPExaminationItemModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate var tableView: UITableView!
}

extension MPAnswerView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPAnswerCell") as? MPAnswerCell
        if cell == nil {
            cell = MPAnswerCell(style: .default, reuseIdentifier: "MPAnswerCell")
        }
        cell?.itemModel = itemList?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let list = itemList else {
            return
        }
        if isMulti {
            // 多选
            itemList?[indexPath.row].isChecked = !list[indexPath.row].isChecked
        }else {
            // 单选
            for (index, _) in list.enumerated() {
                if index == indexPath.row {
                    itemList?[indexPath.row].isChecked = true
                }else {
                    itemList?[index].isChecked = false
                }
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemList?[indexPath.row].itemH ?? 0
    }
}

class MPAnswerCell: UITableViewCell {
    
    var itemModel: MPExaminationItemModel? {
        didSet {
            optionButton.title = itemModel?.content
            optionButton.isChecked = itemModel?.isChecked ?? false
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        optionButton = MPCheckBoxButton()
        optionButton.alignTop = true
        optionButton.isUserInteractionEnabled = false
        optionButton.title = "A: 违章行为"
        contentView.addSubview(optionButton)
        optionButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate var optionButton: MPCheckBoxButton!
}
