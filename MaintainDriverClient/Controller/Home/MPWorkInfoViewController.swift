//
//  MPWorkInfoViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/27.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 工作相关信息
class MPWorkInfoViewController: UIViewController {

    fileprivate var itemModelArr: [MPSignUpModel] = [MPSignUpModel]()
    /// 是否有代驾经历
    fileprivate var isHaveExp: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "报名页面"
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let footerView = MPFooterConfirmView(title: "提交", target: self, action: #selector(MPWorkInfoViewController.submit))
        tableView.tableFooterView = footerView
        setupData()
    }
    
    fileprivate func setupData() {
        itemModelArr = [MPSignUpModel]()
        let model1 = MPSignUpModel(title: "本职工作", content: nil, isShowDetailIcon: true, placeHolder: nil)
        itemModelArr.append(model1)
        let model2 = MPSignUpModel(title: "", content: nil, isShowDetailIcon: false, placeHolder: nil)
        itemModelArr.append(model2)
        if isHaveExp {
            let model3 = MPSignUpModel(title: "曾就职的平台", content: nil, isShowDetailIcon: true, placeHolder: nil)
            itemModelArr.append(model3)
            let model4 = MPSignUpModel(title: "历史接单量", content: nil, isShowDetailIcon: false, placeHolder: "请输入接单量")
            itemModelArr.append(model4)
        }
        let model5 = MPSignUpModel(title: "每天可接单时长", content: nil, isShowDetailIcon: true, placeHolder: nil)
        itemModelArr.append(model5)
        let model6 = MPSignUpModel(title: "期待订单报酬", content: nil, isShowDetailIcon: false, placeHolder: "请输入期待报酬")
        itemModelArr.append(model6)
    }
    
    
    @objc fileprivate func submit() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - View
    fileprivate lazy var processView: MPProcessView = {
        let v = MPProcessView()
        v.setupSelectIndex(2)
        return v
    }()
    fileprivate var tableView: UITableView!

}

extension MPWorkInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else {
            return itemModelArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "MPSignUpTableViewCell") as? MPOptionTableViewCell
            if cell == nil {
                cell = MPOptionTableViewCell(style: .default, reuseIdentifier: "MPOptionTableViewCell")
            }
            cell?.delegate = self
            cell?.isChecked = isHaveExp
            return cell!
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "MPSignUpTableViewCell") as? MPSignUpTableViewCell
            if cell == nil {
                cell = MPSignUpTableViewCell(style: .default, reuseIdentifier: "MPSignUpTableViewCell")
            }
            cell?.signUpModel = itemModelArr[indexPath.row]
            cell?.isShowLine = (indexPath.row != itemModelArr.count - 1)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        switch section {
        case 0:
            title = "信息提交流程"
        case 1:
            title = "工作信息"
        default:
            break
        }
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MPTitleSectionHeaderView") as? MPTitleSectionHeaderView
        if headerView == nil {
            headerView = MPTitleSectionHeaderView(title: title, reuseIdentifier: "MPTitleSectionHeaderView")
        }
        headerView?.title = title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return processView
        }else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 85
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 80
        }else {
            return 50
        }
    }
}

extension MPWorkInfoViewController: MPOptionTableViewCellDelegate {
    func checkBox(didSelect isChecked: Bool) {
        isHaveExp = isChecked
        setupData()
        tableView.reloadData()
    }
}
