//
//  MPQuCheViewController1.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 上门取车情况一
class MPQuCheViewController1: UIViewController {

    /// 检车区域的图片
    fileprivate var jianCheModelArr: [MPPhotoModel] = [MPPhotoModel]()
    /// 车身拍照区域的图片
    fileprivate var cheShenModelArr: [MPPhotoModel] = [MPPhotoModel]()
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
        for i in 0...1 {
            let model = MPPhotoModel()
            if i == 0 {
                model.title = "证件信息"
            }else {
                model.title = "车钥匙"
            }
            jianCheModelArr.append(model)
        }
        for i in 0...3 {
            let model = MPPhotoModel()
            switch i {
            case 0:
                model.title = "前45度角"
            case 1:
                model.title = "后45度角"
            case 2:
                model.title = "人车合照"
            case 3:
                model.title = "车内照"
            default:
                break
            }
            cheShenModelArr.append(model)
        }
        setupUI()
        setupNav()
        tableView.reloadData()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.viewBgColor
        yearCheckTitileView = MPYearCheckTitleView()
        yearCheckTitileView.selectedIndex = 1
        view.addSubview(yearCheckTitileView)
        yearCheckTitileView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(105)
        }
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.rowHeight = 135
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(yearCheckTitileView.snp.bottom)
        }
        tableView.tableFooterView = MPFooterConfirmView(title: "确认取车", target: self, action: #selector(MPQuCheViewController1.confirm))
    }
    
    fileprivate func setupNav() {
        navigationItem.title = "上门取车"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消订单", style: .plain, target: self, action: #selector(MPQuCheViewController1.cancelOrder))
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.mpSmallFont
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
    }
    
    @objc fileprivate func cancelOrder() {
        MPNetwordTool.cancelOrder(orderModel, succ: {
            MPTipsView.showMsg("取消成功")
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: MP_refresh_ORDER_LIST_SUCC_NOTIFICATION, object: nil)
        }, fail: nil)
    }
    
    /// 检测imgArr图片是否为空，判断是否可以上传
    fileprivate func isInvalid(_ imgArr: [MPPhotoModel]) -> Bool {
        for model in imgArr {
            if model.image == nil {
                return false
            }
        }
        return true
    }
    
    @objc fileprivate func confirm() {
        var picArr = [UIImage]()
        var typeArr = [String]()
        var noteArr = [String]()
        if !isInvalid(jianCheModelArr) {
            MPTipsView.showMsg("请选择图片")
            return
        }
        if !isInvalid(cheShenModelArr) {
            MPTipsView.showMsg("请选择图片")
            return
        }
        for model in jianCheModelArr {
            if let img = model.image {
                picArr.append(img)
                typeArr.append("get_confirm")
                noteArr.append(model.title ?? "")
            }
        }
        for model in cheShenModelArr {
            if let img = model.image {
                picArr.append(img)
                typeArr.append("get_car")
                noteArr.append(model.title ?? "")
            }
        }
        let hud = MPTipsView.showLoadingView("上传中...")
        MPNetword.requestJson(target: .quChe(id: orderModel.id, number: picArr.count, picArr: picArr, typeArr: typeArr, note: noteArr), success: { (json) in
            hud?.hide(animated: true)
            let vc = MPStartYearCheckViewController2(model: self.orderModel)
            MPUtils.push(vc)
        }) { (_) in
//            MPTipsView.showMsg("上传失败，请重新再试")
            hud?.hide(animated: true)
        }
    }
    
    fileprivate var tableView: UITableView!
    fileprivate lazy var secondSectionHeaderView: UIView = {
        let view = UIView()
        let titleView = MPTitleSectionHeaderView(title: "车身拍照", reuseIdentifier: nil)
        view.addSubview(titleView)
        let block = MPUtils.createLine(UIColor.white)
        view.addSubview(block)
        titleView.snp.makeConstraints({ (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        })
        block.snp.makeConstraints({ (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(15)
        })
        return view
    }()
    
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
    fileprivate lazy var horizontalPhotoView: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: jianCheModelArr, isShowTitle: true)
    fileprivate lazy var horizontalPhotoView2: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: cheShenModelArr, isShowTitle: true)
    fileprivate lazy var addPhotoView: MPAddPhotoView = {
        let view = MPAddPhotoView()
        view.delegate = self
        return view
    }()
}

extension MPQuCheViewController1: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPTwoPhotoTableViewCell") as? MPTwoPhotoTableViewCell
        if cell == nil {
            cell = MPTwoPhotoTableViewCell(style: .default, reuseIdentifier: "MPTwoPhotoTableViewCell")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let ID = "MPTitleSectionHeaderView"
        if section == 0 {
            return MPTitleSectionHeaderView(title: "证件照片", reuseIdentifier: ID)
        }else if section == 1 {
            return MPTitleSectionHeaderView(title: "车身拍照", reuseIdentifier: ID)
        }else {
            return MPTitleSectionHeaderView(title: "车损照片(最多可以上传6张图片)", reuseIdentifier: ID)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return horizontalPhotoView
        }else if section == 1 {
            return horizontalPhotoView2
        }else {
            return addPhotoView
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return mp_hasTitlePicH + mp_vSpace + 10
        }else if section == 1 {
            return (mp_hasTitlePicH + mp_vSpace + 10) * 2
        }else {
            let count = (addPhotoView.photoModelArr.count < 6) ? addPhotoView.photoModelArr.count + 1 : 6
            // 计算行数
            let row = (count + 2 - 1) / 2
            let h: CGFloat = (mp_noTitlePicH + mp_vSpace + 10) * CGFloat(row)
            return h
        }
    }
}

extension MPQuCheViewController1: MPAddPhotoViewDelegate {
    func addPhotoViewNeedReload() {
        tableView.reloadData()
    }
}

