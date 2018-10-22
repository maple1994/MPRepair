//
//  MPStartYearCheckViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/7.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 开始年检
class MPStartYearCheckViewController: UIViewController {
    /// 年检已过图片数组
    fileprivate var confirmPhotoArr: [MPPhotoModel] = [MPPhotoModel]()
    /// 年检未过图片数组
    fileprivate var failedPhotoArr: [MPPhotoModel] = [MPPhotoModel]()
    fileprivate var orderModel: MPOrderModel
    /// 年检检查项
    fileprivate var itemArr: [MPComboItemModel] = [MPComboItemModel]()
    /// 选择的检查项
    fileprivate var selectedItemArr: [MPComboItemModel]?
    
    // MARK: - Method
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
            let model1 = MPPhotoModel()
            if i == 0 {
                model.title = "证件信息"
                model1.title = "证件信息"
            }else {
                model.title = "车钥匙"
                model1.title = "车钥匙"
            }
            confirmPhotoArr.append(model)
            failedPhotoArr.append(model1)
        }
        setupUI()
        loadItemData()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.viewBgColor
        navigationItem.title = "开始年检"
        yearCheckTitileView = MPYearCheckTitleView()
        yearCheckTitileView.selectedIndex = 2
        view.addSubview(yearCheckTitileView)
        yearCheckTitileView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(105)
        }
        titleView = MPTitleView(titleArr: ["年检已过", "年检未过"])
        titleView.delegate = self
        view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(yearCheckTitileView.snp.bottom)
            make.height.equalTo(50)
        }
        contentView = UIScrollView()
        contentView.showsHorizontalScrollIndicator = false
        contentView.delegate = self
        contentView.bounces = false
        contentView.isPagingEnabled = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        tableView1 = createTbView()
        tableView2 = createTbView()
        tableView2.rowHeight = 44
        
        contentView.addSubview(tableView1)
        contentView.addSubview(tableView2)
        tableView1.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(view).offset(-160)
            make.width.equalTo(mp_screenW)
        }
        tableView2.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(tableView1.snp.trailing)
            make.height.equalTo(tableView1)
            make.width.equalTo(mp_screenW)
        }
        let confrimButton = UIButton()
        confrimButton.setTitle("确认提交", for: .normal)
        confrimButton.backgroundColor = UIColor.navBlue
        confrimButton.setTitleColor(UIColor.white, for: .normal)
        confrimButton.addTarget(self, action: #selector(MPStartYearCheckViewController.confirm), for: .touchUpInside)
        confrimButton.setupCorner(5)
        contentView.addSubview(confrimButton)
        confrimButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(tableView1)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }
        let btn1 = UIButton()
        btn1.setTitle("选择项目", for: .normal)
        btn1.setTitleColor(UIColor.navBlue, for: .normal)
        btn1.setupBorder(width: 1, borderColor: UIColor.navBlue)
        btn1.setupCorner(5)
        btn1.addTarget(self, action: #selector(MPStartYearCheckViewController.selectItem), for: .touchUpInside)
        let btn2 = UIButton()
        btn2.setTitle("确认提交", for: .normal)
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.backgroundColor = UIColor.navBlue
        btn2.setupCorner(5)
        btn2.addTarget(self, action: #selector(MPStartYearCheckViewController.failConfirm), for: .touchUpInside)
        contentView.addSubview(btn1)
        contentView.addSubview(btn2)
        btn1.snp.makeConstraints { (make) in
            make.leading.equalTo(tableView2).offset(18)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(40)
        }
        btn2.snp.makeConstraints { (make) in
            make.trailing.equalTo(tableView2).offset(-18)
            make.bottom.width.height.equalTo(btn1)
            make.leading.equalTo(btn1.snp.trailing).offset(15)
        }
    }
    
    fileprivate func createTbView() -> UITableView {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.showsVerticalScrollIndicator = false
        tb.separatorStyle = .none
        tb.delegate = self
        tb.dataSource = self
        return tb
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
    
    /// 加载检查项
    fileprivate func loadItemData() {
        MPNetwordTool.getYearCheckInfo(succ: { (arr) in
            self.itemArr = arr
        }) {
            
        }
    }
    
    @objc fileprivate func confirm() {
        var picArr = [UIImage]()
        var typeArr = [String]()
        var noteArr = [String]()
        if !isInvalid(confirmPhotoArr) {
            MPTipsView.showMsg("请选择图片")
            return
        }
        for model in confirmPhotoArr {
            if let img = model.image {
                picArr.append(img)
                typeArr.append("survey_upload")
                noteArr.append(model.title ?? "")
            }
        }
        let hud = MPTipsView.showLoadingView("上传中...")
        MPNetword.requestJson(target: .yearCheckSucc(id: orderModel.id, number: picArr.count, picArr: picArr, typeArr: typeArr, note: noteArr), success: { (_) in
            hud?.hide(animated: true)
            self.jump()
        }) { (_) in
            hud?.hide(animated: true)
        }
    }
    
    /// 选择项目
    @objc fileprivate func selectItem() {
        let selectItemView = MPSelectItemView.init(itemArr: itemArr) { [weak self] (selectedArr) in
            self?.selectedItemArr = selectedArr
            self?.tableView2.reloadData()
        }
        selectItemView.show()
    }
    
    /// 年检未过确认提交
    @objc fileprivate func failConfirm() {
        if !isInvalid(failedPhotoArr) {
            MPTipsView.showMsg("请选择图片")
            return
        }
        var itemIDArr = [Int]()
        var priceArr = [Double]()
        if let selectedArr = selectedItemArr {
            for item in selectedArr {
                itemIDArr.append(item.id)
                priceArr.append(item.price)
            }
        }
        let hud = MPTipsView.showLoadingView("上传中...")
        MPNetword.requestJson(target: .yearCheckFail(id: orderModel.id, number: 2, image1: failedPhotoArr[0].image!, note1: "证件信息", image2: failedPhotoArr[1].image!, note2: "车钥匙", number_item: itemIDArr.count, itemIDArr: itemIDArr, priceArr: priceArr), success: { (_) in
            self.navigationController?.popToRootViewController(animated: true)
            hud?.hide(animated: true)
        }) { (_) in
            hud?.hide(animated: true)
        }
    }
    
    fileprivate func jump() {
        MPNetwordTool.getOrderInfo(id: self.orderModel.id, succ: { (model) in
            self.orderModel = model
        }, fail: nil)
        let vc = MPCheckOutFinishViewController2(model: orderModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - View
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
    fileprivate var titleView: MPTitleView!
    fileprivate var contentView: UIScrollView!
    fileprivate var tableView1: UITableView!
    fileprivate var tableView2: UITableView!
    fileprivate lazy var horizontalPhotoView: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: confirmPhotoArr, isShowTitle: true)
    fileprivate lazy var horizontalPhotoView2: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: failedPhotoArr, isShowTitle: true)
    fileprivate var feekbackView: MPFeedbackView?
}

extension MPStartYearCheckViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableView1 {
            return 1
        }else {
            let count = selectedItemArr?.count ?? 0
            if count == 0 {
                return 1
            }else {
                return 2
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return 0
        }else {
            if section == 0 {
                return 0
            }else {
                return selectedItemArr?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPShowItemTableViewCell") as? MPShowItemTableViewCell
        if cell == nil {
            cell = MPShowItemTableViewCell(style: .default, reuseIdentifier: "MPShowItemTableViewCell")
        }
        cell?.itemModel = selectedItemArr?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableView1 {
            return MPTitleSectionHeaderView(title: survey_upload, reuseIdentifier: nil)
        }else {
            if section == 0 {
                return MPTitleSectionHeaderView(title: "上传图片", reuseIdentifier: nil)
            }else {
                return MPTitleSectionHeaderView(title: "年检未过项", reuseIdentifier: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableView1 {
            return 50
        }else  {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tableView1 {
            return horizontalPhotoView
        }else  {
            if section == 0 {
                return horizontalPhotoView2
            }else {
                return nil
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tableView1 {
            return mp_hasTitlePicH + mp_vSpace + 10
        }else {
            if section == 0 {
                return mp_hasTitlePicH + mp_vSpace + 10
            }else {
                return 0.01
            }
        }
    }
}

extension MPStartYearCheckViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != contentView {
            return
        }
        let offsetX = scrollView.contentOffset.x + mp_screenW * 0.5
        let index = Int(offsetX / mp_screenW)
        titleView.setupSelectedIndex(index)
        titleView.isTouch = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView != contentView {
            return
        }
        titleView.isTouch = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != contentView {
            return
        }
        if titleView.isTouch {
            return
        }
        titleView.setupOffsetX(scrollView.contentOffset.x)
    }
}

extension MPStartYearCheckViewController: MPTitleViewDelegate {
    func titleView(didSelect index: Int) {
        titleView.isTouch = true
        let offsetX: CGFloat = mp_screenW * CGFloat(index)
        contentView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        titleView.lastOffsetX = offsetX
    }
}




