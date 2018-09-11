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

    fileprivate var confirmPhotoArr: [MPPhotoModel] = [MPPhotoModel]()
    fileprivate var cheDengPhotoArr: [MPPhotoModel] = [MPPhotoModel]()
    fileprivate var paiQiPhotoArr: [MPPhotoModel] = [MPPhotoModel]()
    fileprivate var waiQiPhotoArr: [MPPhotoModel] = [MPPhotoModel]()
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
        for j in 0...3 {
            for i in 0...1 {
                let model = MPPhotoModel()
                if i == 0 {
                    model.title = "有效期内交的强险保单副本"
                }else {
                    model.title = "车钥匙"
                }
                switch j {
                case 0:
                    confirmPhotoArr.append(model)
                case 1:
                    cheDengPhotoArr.append(model)
                case 2:
                    paiQiPhotoArr.append(model)
                case 3:
                    waiQiPhotoArr.append(model)
                default:
                    break
                }
            }
        }
        setupUI()
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
        titleView = MPTitleView(titleArr: ["年检已过", "年检未过", "服务反馈"])
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
        tableView2.rowHeight = 135
        tableView3 = createTbView()
        
        contentView.addSubview(tableView1)
        contentView.addSubview(tableView2)
        contentView.addSubview(tableView3)
        tableView1.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(view).offset(-160)
            make.width.equalTo(mp_screenW)
        }
        tableView2.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(tableView1.snp.trailing)
            make.trailing.equalTo(tableView3.snp.leading)
            make.height.equalTo(view).offset(-160)
            make.width.equalTo(mp_screenW)
        }
        tableView3.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(view).offset(-160)
            make.width.equalTo(mp_screenW)
        }
    }
    
    fileprivate func createTbView() -> UITableView {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.showsVerticalScrollIndicator = false
        tb.separatorStyle = .none
        tb.delegate = self
        tb.dataSource = self
        tb.tableFooterView = MPFooterConfirmView(title: "确认提交", target: self, action: #selector(MPStartYearCheckViewController.confirm))
        return tb
    }
    
    @objc fileprivate func confirm() {
        var picArr = [UIImage]()
        var typeArr = [String]()
        var noteArr = [String]()
        if titleView.selectedIndex == 0 {
            for model in confirmPhotoArr {
                if let img = model.image {
                    picArr.append(img)
                    typeArr.append("get_confirm")
                    noteArr.append(model.title ?? "")
                }
            }
            let hud = MPTipsView.showLoadingView("上传中...")
            MPNetword.requestJson(target: .yearCheckSucc(id: orderModel.id, number: picArr.count, picArr: picArr, typeArr: typeArr, note: noteArr), success: { (_) in
                hud?.hide(animated: true)
                self.jump()
            }) { (_) in
                hud?.hide(animated: true)
                MPTipsView.showMsg("上传失败，请重新再试")
            }
        }else {
            var idArr = [Int]()
            for model in cheDengPhotoArr {
                if let img = model.image {
                    picArr.append(img)
                    idArr.append(1)
                    noteArr.append("车灯")
                }
            }
            for model in paiQiPhotoArr {
                if let img = model.image {
                    picArr.append(img)
                    idArr.append(2)
                    noteArr.append("排气")
                }
            }
            for model in waiQiPhotoArr {
                if let img = model.image {
                    picArr.append(img)
                    idArr.append(3)
                    noteArr.append("外观")
                }
            }
            let hud = MPTipsView.showLoadingView("上传中...")
            MPNetword.requestJson(target: .yearCheckFail(id: orderModel.id, number: picArr.count, picArr: picArr, itemIdArr: idArr, note: noteArr), success: { (_) in
                hud?.hide(animated: true)
                self.jump()
            }) { (_) in
                hud?.hide(animated: true)
                MPTipsView.showMsg("上传失败，请重新再试")
            }
        }

    }
    
    fileprivate func jump() {
        MPNetwordTool.getOrderInfo(id: self.orderModel.id, succ: { (model) in
            self.orderModel = model
        }, fail: nil)
        let vc = MPCheckOutFinishViewController2(model: orderModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
    fileprivate var titleView: MPTitleView!
    fileprivate var contentView: UIScrollView!
    fileprivate var tableView1: UITableView!
    fileprivate var tableView2: UITableView!
    fileprivate var tableView3: UITableView!
    fileprivate lazy var horizontalPhotoView: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: confirmPhotoArr, isShowTitle: true)
    fileprivate lazy var cheDengPhotoView: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: cheDengPhotoArr, isShowTitle: true)
    fileprivate lazy var paiQiPhotoView: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: paiQiPhotoArr, isShowTitle: true)
    fileprivate lazy var waiGuanPhotoView: MPHorizonScrollPhotoView = MPHorizonScrollPhotoView(modelArr: waiQiPhotoArr, isShowTitle: true)
    fileprivate lazy var feekbackView = MPFeedbackView()
}

extension MPStartYearCheckViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableView1 {
            return 1
        }else if tableView == tableView2 {
            return 3
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return 0
        }else if tableView == tableView2 {
            return 0
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPTwoPhotoTableViewCell") as? MPTwoPhotoTableViewCell
        if cell == nil {
            cell = MPTwoPhotoTableViewCell(style: .default, reuseIdentifier: "MPTwoPhotoTableViewCell")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableView1 {
            return MPTitleSectionHeaderView(title: "检车确认", reuseIdentifier: nil)
        }else if tableView == tableView2 {
            if section == 0 {
                 return MPTitleSectionHeaderView(title: "车灯", reuseIdentifier: nil)
            }else if section == 1 {
                 return MPTitleSectionHeaderView(title: "排气", reuseIdentifier: nil)
            }else {
                 return MPTitleSectionHeaderView(title: "外观", reuseIdentifier: nil)
            }
        }else {
            return feekbackView
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableView1 {
            return 50
        }else if tableView == tableView2 {
            return 50
        }else {
            return 195
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tableView1 {
            return horizontalPhotoView
        }else if tableView == tableView2 {
            if section == 0 {
                return cheDengPhotoView
            }else if section == 1 {
                return paiQiPhotoView
            }else {
                return waiGuanPhotoView
            }
        }else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tableView1 {
            return mp_hasTitlePicH + mp_vSpace + 10
        }else if tableView == tableView2 {
            return mp_hasTitlePicH + mp_vSpace + 10
        }else {
            return 0.01
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




