//
//  MPWorkInfoViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/27.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// 工作相关信息
class MPWorkInfoViewController: UIViewController {
    init(model: MPSignUpUploadModel) {
        uploadInfoModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    var uploadInfoModel: MPSignUpUploadModel

    fileprivate var itemModelArr: [MPSignUpModel] = [MPSignUpModel]()
    /// 记录正在编辑的ip
    fileprivate var editingIP: IndexPath?
    /// 是否有代驾经历
    fileprivate var isHaveExp: Bool = false {
        didSet {
            uploadInfoModel.driving_experience = isHaveExp
        }
    }
    
    // MARK: - Life Circle
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
        self.footerView = footerView
        footerView.confrimButton.isUserInteractionEnabled = false
        footerView.confrimButton.backgroundColor = UIColor.lightGray
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    // MARK: - Method
    fileprivate func setupData() {
        if isHaveExp {
            itemModelArr = [
                model1, model2, model3,
                model4, model5, model6
            ]
        }else {
            itemModelArr = [
                model1, model2, model5, model6
            ]
        }
    }
    
    
    @objc fileprivate func submit() {
        for (i, model) in itemModelArr.enumerated() {
            if i == 0 || i == 1 {
                continue
            }
            if let content = model.content {
                setupInfoModel(i, content)
            }
        }
        let loadingView = MPTipsView.showLoadingView("正在上传...")
        MPNetword.requestJson(target: .driverSignUp(model: uploadInfoModel), success: { (_) in
            loadingView?.hide(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }, failure: { (error) in
            loadingView?.hide(animated: true)
            })
    }
    
    // MARK: - View
    fileprivate lazy var model1: MPSignUpModel =  {
        let model = MPSignUpModel(title: "本职工作", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model.pickerType = .text
        model.pickerContent = ["个体工商户", "企事业单位全职员工", "其他兼职平台工作"]
        return model
    }()
    fileprivate lazy var model2: MPSignUpModel =  {
        let model = MPSignUpModel(title: "", content: nil, isShowDetailIcon: false, placeHolder: nil)
        return model
    }()
    fileprivate lazy var model3: MPSignUpModel =  {
        let model = MPSignUpModel(title: "曾就职的平台", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model.pickerType = .text
        model.pickerContent = ["滴滴出行", "神州专车和神州租车", "曹操专车"]
        return model
    }()
    fileprivate lazy var model4: MPSignUpModel =  {
        let model = MPSignUpModel(title: "历史接单量", content: nil, isShowDetailIcon: false, placeHolder: "请输入接单量")
        model.keyboardType = .numberPad
        return model
    }()
    fileprivate lazy var model5: MPSignUpModel =  {
        let model = MPSignUpModel(title: "每天可接单时长", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model.pickerType = .text
        model.pickerContent = ["1到3小时", "3到5小时"]
        return model
    }()
    fileprivate lazy var model6: MPSignUpModel =  {
        let model = MPSignUpModel(title: "期待订单报酬", content: nil, isShowDetailIcon: false, placeHolder: "请输入期待报酬")
        model.keyboardType = .numberPad
        return model
    }()
    fileprivate lazy var processView: MPProcessView = {
        let v = MPProcessView()
        v.setupSelectIndex(2)
        return v
    }()
    fileprivate var tableView: UITableView!
    fileprivate var footerView: MPFooterConfirmView?
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
            cell?.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = itemModelArr[indexPath.row]
        switch model.pickerType {
        case .text:
            MPTextPickerView.show(model.pickerContent, delegate: self)
        case .address:
            MPAdderssPickerView.show(delegate: self)
        case .date:
            MPDatePickerView.show(delegate: self)
        case .none:
            break
        }
        editingIP = indexPath
    }
}

extension MPWorkInfoViewController: MPOptionTableViewCellDelegate {
    func checkBox(didSelect isChecked: Bool) {
        isHaveExp = isChecked
        setupData()
        setupConfirmButton()
        tableView.reloadData()
    }
}

extension MPWorkInfoViewController: MPTextPickerViewDelegate {
    func pickerView(didSelect row: Int, text: String) {
        guard let ip = editingIP else {
            return
        }
        let model = itemModelArr[ip.row]
        model.content = text
        tableView.reloadData()
        if ip.row == 0 {
            uploadInfoModel.work = row
        }
        setupConfirmButton()
    }
}

extension MPWorkInfoViewController: MPSignUpTableViewCellDelegate {
    func signUpCellDidFilled() {
        setupConfirmButton()
    }
    
    fileprivate func setupInfoModel(_ i: Int, _ content: String) {
        if isHaveExp {
            switch i {
            case 2:
                uploadInfoModel.work_platform = content
            case 3:
                uploadInfoModel.historical_order = content.toInt() ?? 0
            case 4:
                // 接单时长
                uploadInfoModel.time_day = content
            case 5:
                // 期待报酬
                uploadInfoModel.order_reward = content.toInt() ?? 0
            default:
                break
            }
        }else {
            switch i {
            case 2:
                uploadInfoModel.time_day = content
            case 3:
                uploadInfoModel.order_reward = content.toInt() ?? 0
            default:
                break
            }
        }
    }
    
    fileprivate func setupConfirmButton() {
        var isValid = true
        for (i, model) in itemModelArr.enumerated() {
            let content = model.content ?? ""
            if i != 1 && content.isEmpty {
                isValid = false
                break
            }
        }
        if isValid {
            footerView?.confrimButton.isUserInteractionEnabled = true
            footerView?.confrimButton.backgroundColor = UIColor.navBlue
        }else {
            footerView?.confrimButton.isUserInteractionEnabled = false
            footerView?.confrimButton.backgroundColor = UIColor.lightGray
        }
    }
}
