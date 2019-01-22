//
//  MPExaminationViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/28.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPExaminationViewController: UIViewController {

    fileprivate var modelArr: [MPExaminationModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "开始答题"
        setupUI()
        loadData()
    }
    
    fileprivate func loadData() {
        MPNetword.requestJson(target: .getQuestions, success: { json in
            guard let dic = json["data"] as? [String: Any] else {
                return
            }
            guard let que_list = dic["question_list"] as? [[String: Any]] else {
                return
            }
            var arr = [MPExaminationModel]()
            for (index, data) in que_list.enumerated() {
                if let model = MPExaminationModel.toModel(data) {
                    let num = index + 1
                    model.content = "\(num)、\(model.content)"
                    arr.append(model)
                }
            }
            self.numLabel.text = "共\(arr.count)题"
            self.modelArr = arr
            self.tableView.reloadData()
        })
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        let headerView = UIView()
        numLabel = UILabel(font: UIFont.systemFont(ofSize: 20), text: "共--题", textColor: UIColor.white)
        bgImageView = UIImageView(image: UIImage(named: "count_down_bg"))
        headerView.addSubview(bgImageView)
        headerView.addSubview(numLabel)
        
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(headerView)
        view.addSubview(tableView)
        headerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(110)
        }
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        numLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(30)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        tableView.register(MPExaminationCellTableViewCell.classForCoder(), forCellReuseIdentifier: "MPExaminationCellTableViewCell")
        let footerView = MPFooterConfirmView(title: "提交", target: self, action: #selector(MPExaminationViewController.submit))
        tableView.tableFooterView = footerView
    }
    
    @objc fileprivate func submit() {
        guard let arr = modelArr else {
            return
        }
        // 判断有没完成所有题目
        var row: Int = 0
        var isComplete: Bool = true
        for (index, ans) in arr.enumerated() {
            var itemCompleteCount: Int = 0
            for item in ans.item_list {
                if item.isChecked {
                    itemCompleteCount += 1
                }
            }
            // 这道题未完成
            if itemCompleteCount == 0 {
                row = index
                isComplete = false
                break
            }
        }
        if !isComplete {
            _ = MPTipsView.showMsg("请完成所有题目")
            let ip = IndexPath(row: row, section: 0)
            tableView.scrollToRow(at: ip, at: .top, animated: true)
            return
        }
        var res = [String]()
        for model in arr {
            var anwArr = [String]()
            for item in model.item_list {
                if item.isChecked {
                    anwArr.append("\(item.id)")
                }
            }
            anwArr.sort()
            let str = anwArr.connect(with: "#")
            res.append(str)
        }
        let res1 = res.connect(with: ",")
        MPNetword.requestJson(target: .submitAnswer(ans: res1), success: { json in
            guard let data = json["data"] as? [String: Any] else {
                return
            }
            let right = toInt(data["right_amount"])
            let wrong = toInt(data["worry_amount"])
            let score = toInt(data["score"])
            let isPass = toBool(data["is_pass"])
            MPShowGradeView.show(correctNum: right, wrongNum: wrong, score: score, isPass: isPass, delegate: self)
            MPUserModel.shared.refreshUserInfo()
        })
    }
    
    // MARK : - View
    fileprivate var numLabel: UILabel!
    fileprivate var bgImageView: UIImageView!
    fileprivate var tableView: UITableView!
}

extension MPExaminationViewController: MPShowGradeViewDelegate {
    /// 重考
    func reexamine() {
        // 清除答案，并滚到顶部
        guard let arr = modelArr else {
            return
        }
        for ans in arr {
            for item in ans.item_list {
                item.isChecked = false
            }
        }
        if arr.count == 0 {
            return
        }
        let ip = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: ip, at: .top, animated: true)
        tableView.reloadData()
    }
    /// 购买保险
    func buyInsurance() {
        let vc = MPInsuranceViewController()
        MPUtils.push(vc)
    }
}

extension MPExaminationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPExaminationCellTableViewCell") as? MPExaminationCellTableViewCell
        if cell == nil {
            cell = MPExaminationCellTableViewCell(style: .default, reuseIdentifier: "MPExaminationCellTableViewCell")
        }
        cell?.model = modelArr?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return modelArr?[indexPath.row].rowHeight ?? 0.01
    }
}
