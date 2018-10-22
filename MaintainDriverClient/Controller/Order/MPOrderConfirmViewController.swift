//
//  MPOrderConfirmViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 订单信息确认
class MPOrderConfirmViewController: UIViewController {
    fileprivate let CellID = "MPOrderConfrimTableViewCell"
    fileprivate var orderModel: MPOrderModel
    
    init(model: MPOrderModel) {
        orderModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.viewBgColor
        navigationItem.title = "确认信息"
        if orderModel.state.rawValue <= 2 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消订单", style: .plain, target: self, action: #selector(MPOrderConfirmViewController.cancelOrder))
        }
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.mpSmallFont
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(MPOrderConfrimTableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.viewBgColor
        view.addSubview(tableView)
        tableView.tableFooterView = MPFooterConfirmView(title: "确认取车", target: self, action: #selector(MPOrderConfirmViewController.confirm))
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc fileprivate func cancelOrder() {
        MPNetwordTool.cancelOrder(orderModel, succ: {
            MPTipsView.showMsg("取消成功")
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: MP_refresh_ORDER_LIST_SUCC_NOTIFICATION, object: nil)
        }, fail: nil)
    }
    
    @objc fileprivate func confirm() {
        
        if orderModel.state == .nianJianing {
            if orderModel.survey_state == .failure {
                MPTipsView.showMsg("客户尚未支付")
                return
            }else  {
                let vc = MPStartYearCheckViewController(model: orderModel)
                navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        let vc = MPQuCheViewController2(model: orderModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate var tableView: UITableView!
    fileprivate var confrimButton: UIButton!
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPOrderConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    fileprivate func setupCell(_ indexPath: IndexPath, _ cell: MPOrderConfrimTableViewCell?) {
        let isHiddenLine = (indexPath.section == 0 && indexPath.row == 3) ||
            (indexPath.section == 1 && indexPath.row == 1) ||
            (indexPath.section == 2 && indexPath.row == 2) ||
            (indexPath.section == 3 && indexPath.row == 1)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell?.set(title: "车主姓名", value: orderModel.name, isHiddenLine: isHiddenLine)
            case 1:
                cell?.set(title: "品牌型号", value: orderModel.car_brand, isHiddenLine: isHiddenLine)
            case 2:
                cell?.set(title: "号码号牌", value: orderModel.car_code, isHiddenLine: isHiddenLine)
            case 3:
                cell?.set(title: "车辆类型", value: orderModel.car_type, isHiddenLine: isHiddenLine)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell?.set(title: "联系人", value: orderModel.name, isHiddenLine: isHiddenLine)
            case 1:
                cell?.set(title: "联系电话", value: orderModel.phone, isHiddenLine: isHiddenLine)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell?.set(title: "选择年检站", value: orderModel.surveystation?.name ?? "", isHiddenLine: isHiddenLine)
            case 1:
                cell?.set(title: "交接车地点", value: orderModel.order_address, isHiddenLine: isHiddenLine)
            case 2:
                cell?.set(title: "预约日期", value: orderModel.subscribe_time, isHiddenLine: isHiddenLine)
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                cell?.set(title: "套餐类型", value: orderModel.combo?.name ?? "", isHiddenLine: isHiddenLine)
            case 1:
                cell?.set(title: "套餐明细", value: orderModel.combo?.detail ?? "", isHiddenLine: isHiddenLine)
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPOrderConfrimTableViewCell") as? MPOrderConfrimTableViewCell
        if cell == nil {
            cell = MPOrderConfrimTableViewCell(style: .default, reuseIdentifier: "MPOrderConfrimTableViewCell")
        }
        if indexPath.section == 3 && indexPath.row == 1 {
            cell = MPOrderConfrimTableViewCell(style: .default, reuseIdentifier: "MP_COMBO")
        }
        setupCell(indexPath, cell)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.fd_heightForCell(withIdentifier: CellID, configuration: { (cell1) in
            let cell = cell1 as? MPOrderConfrimTableViewCell
            self.setupCell(indexPath, cell)
        })
        if height < 45 {
            return 49.5
        }else {
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MPTitleSectionHeaderView") as? MPTitleSectionHeaderView
        switch section {
        case 0:
            title = "客户信息"
        case 1:
            title = "联系方式"
        case 2:
            title = "取车信息"
        case 3:
            title = "套餐信息"
        default:
            break
        }
        if header == nil {
            header = MPTitleSectionHeaderView(title: title, reuseIdentifier: "MPTitleSectionHeaderView")
        }
        header?.title = title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
