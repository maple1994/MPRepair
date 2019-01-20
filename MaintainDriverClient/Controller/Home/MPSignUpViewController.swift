//
//  MPSignUpViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/26.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// 报名页面
class MPSignUpViewController: UIViewController {

    fileprivate var modelArr = [[MPSignUpModel]]()
    /// 记录正在编辑的ip
    fileprivate var editingIP: IndexPath?
    fileprivate var uploadInfoModel: MPSignUpUploadModel = MPSignUpUploadModel()
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "报名页面"
        setupData()
        let footerView = MPFooterConfirmView(title: "下一步", target: self, action: #selector(MPSignUpViewController.confirm))
        footerView.frame.size.height = 130
        footerView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        let tmp = UIView(frame: CGRect(x: 0, y: 0, width: mp_screenW, height: 0.01))
        tableView.tableHeaderView = tmp
        tableView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        tableView.tableFooterView = footerView
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.footerView = footerView
        footerView.confrimButton.isUserInteractionEnabled = false;

        footerView.confrimButton.backgroundColor = UIColor.lightGray
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
        let sectionArr1 = [MPSignUpModel]()
        var sectionArr2 = [MPSignUpModel]()
        var sectionArr3 = [MPSignUpModel]()
        var sectionArr4 = [MPSignUpModel]()
        var sectionArr5 = [MPSignUpModel]()
        let model1 = MPSignUpModel(title: "姓名", content: nil, isShowDetailIcon: false, placeHolder: "请输入姓名")
        let model2 = MPSignUpModel(title: "身份证号", content: nil, isShowDetailIcon: false, placeHolder: "请输入身份证号")
        let model3 = MPSignUpModel(title: "籍贯", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model3.pickerType = .address
        sectionArr2.append(model1)
        sectionArr2.append(model2)
        sectionArr2.append(model3)
        
        let model4 = MPSignUpModel(title: "报名城市", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model4.pickerType = .address
        let model5 = MPSignUpModel(title: "居住地", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model5.pickerType = .address
        sectionArr3.append(model4)
        sectionArr3.append(model5)
        
        let model6 = MPSignUpModel(title: "紧急联系人姓名", content: nil, isShowDetailIcon: false, placeHolder: "请输入姓名")
        let model7 = MPSignUpModel(title: "紧急联系人号码", content: nil, isShowDetailIcon: false, placeHolder: "请输入电话号码")
        model7.keyboardType = .numberPad
        let model8 = MPSignUpModel(title: "紧急联系人关系", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model8.pickerType = .text
        model8.pickerContent = ["兄弟姐妹", "父母", "朋友"]
        sectionArr4.append(model6)
        sectionArr4.append(model7)
        sectionArr4.append(model8)
        
        let model9 = MPSignUpModel(title: "驾驶人档案编号", content: nil, isShowDetailIcon: false, placeHolder: "请输入编号")
        let model10 = MPSignUpModel(title: "准驾车型", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model10.pickerType = .text
        model10.pickerContent = ["小型蓝牌", "客车", "大货车"]
        let model11 = MPSignUpModel(title: "初领驾驶证日期", content: nil, isShowDetailIcon: true, placeHolder: nil)
        model11.pickerType = .date
        sectionArr5.append(model9)
        sectionArr5.append(model10)
        sectionArr5.append(model11)
        modelArr.append(sectionArr1)
        modelArr.append(sectionArr2)
        modelArr.append(sectionArr3)
        modelArr.append(sectionArr4)
        modelArr.append(sectionArr5)
    }
    
    @objc fileprivate func confirm() {
        if !uploadInfoModel.IDcard.isMatchRegularExp("^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$") {
            MPTipsView.showMsg("请输入合法的身份证")
            return
        }
        if !uploadInfoModel.exigency_phone.isMatchRegularExp("1[0-9]{10}$") {
            MPTipsView.showMsg("请输入合法的手机号码")
            return
        }
        let vc = MPUploadIDCartViewController(model: uploadInfoModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - View
    fileprivate lazy var processView: MPProcessView = {
        let v = MPProcessView()
        return v
    }()
    fileprivate var tableView: UITableView!
    fileprivate var footerView: MPFooterConfirmView?
}
// MARK: - Table view data source
extension MPSignUpViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPSignUpTableViewCell") as? MPSignUpTableViewCell
        if cell == nil {
            cell = MPSignUpTableViewCell(style: .default, reuseIdentifier: "MPSignUpTableViewCell")
        }
        cell?.delegate = self
        cell?.signUpModel = modelArr[indexPath.section][indexPath.row]
        cell?.isShowLine = (indexPath.row != modelArr[indexPath.section].count - 1)
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        switch section {
        case 0:
            title = "信息提交流程"
        case 1:
            title = "个人信息"
        case 2:
            title = "报名信息"
        case 3:
            title = "紧急联系人信息"
        case 4:
            title = "驾驶证信息"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArr[indexPath.section][indexPath.row]
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

extension MPSignUpViewController: MPTextPickerViewDelegate {
    func pickerView(didSelect row: Int, text: String) {
        guard let ip = editingIP else {
            return
        }
        switch ip.section {
        case 3:
            // 联系人关系
            uploadInfoModel.exigency_relation = row
        case 4:
            if ip.row == 1 {
                // 车型
                uploadInfoModel.driving_type = row
            }
        default:
            break
        }
        let model = modelArr[ip.section][ip.row]
        model.content = text
        signUpCellDidFilled()
        tableView.reloadData()
    }
}

extension MPSignUpViewController: MPSignUpTableViewCellDelegate {
    /// 填充了内容
    func signUpCellDidFilled() {
        var isValid: Bool = true
        for (section, arr) in modelArr.enumerated() {
            for (row, model) in arr.enumerated() {
                let content = model.content ?? ""
                if !content.isEmpty {
                    setupData(section, row, content)
                }else {
                    isValid = false
                    break
                }
            }
        }
        if isValid {
            footerView?.confrimButton.isUserInteractionEnabled = true;
            footerView?.confrimButton.backgroundColor = UIColor.navBlue
        }else {
            footerView?.confrimButton.isUserInteractionEnabled = false;
            
            footerView?.confrimButton.backgroundColor = UIColor.lightGray
        }
    }
    
    /// 设置上传模型的数据
    fileprivate func setupData(_ section: Int, _ row: Int, _ content: String) {
        switch section {
        case 1:
            switch row {
            case 0:
                uploadInfoModel.name = content
            case 1:
                uploadInfoModel.IDcard = content
            case 2:
                uploadInfoModel.native_place = content
            default:
                break
            }
        case 2:
            switch row {
            case 0:
                uploadInfoModel.city = content
            case 1:
                uploadInfoModel.place = content
            default:
                break
            }
        case 3:
            switch row {
            case 0:
                uploadInfoModel.exigency_name = content
            case 1:
                uploadInfoModel.exigency_phone = content
            default:
                break
            }
        case 4:
            switch row {
            case 0:
                uploadInfoModel.exigency_number = content
            case 2:
                uploadInfoModel.driving_date = content
            default:
                break
            }
        default:
            break
        }
    }
}

/// 报名上传模型
struct MPSignUpUploadModel {
    var id: Int {
        return MPUserModel.shared.userID
    }
    var name: String = ""
    var IDcard: String = ""
    /// 籍贯
    var native_place: String = ""
    /// 报名城市
    var city: String = ""
    /// 居住地
    var place: String = ""
    /// 紧急联系人姓名
    var exigency_name: String = ""
    /// 紧急联系人号码
    var exigency_phone: String = ""
    /// 紧急联系人关系 0:兄弟姐妹,1:父母,2:朋友
    var exigency_relation: Int = 0
    /// 驾驶人档案编号
    var exigency_number: String = ""
    /// 准驾车型 0:小型蓝牌,1:客车,2:大货车
    var driving_type: Int = 0
    /// 初领驾驶证日期
    var driving_date: String = ""
    /// 本职工作 0:个体工商户,1:企事业单位全职员工,2:其他兼职平台工作
    var work: Int = 0
    /// 有无代驾经历
    var driving_experience: Bool = false
    /// 曾就职的平台
    var work_platform: String = ""
    /// 历史接单量
    var historical_order: Int = 0
    
    /// 身份证正面
    var pic_idcard_front: UIImage?
    /// 身份证反面
    var pic_idcard_back: UIImage?
    /// 司机正面照
    var pic_driver: UIImage?
    /// 人证合一照
    var pic_user: UIImage?
    /// 驾驶证正面照
    var pic_drive_front: UIImage?
    /// 驾驶证副页照
    var pic_drive_back: UIImage?
    /// 每天可接单时长
    var time_day: String = ""
    /// 预期订单报酬
    var order_reward: Int = 0
}
