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

    override func viewDidLoad() {
        super.viewDidLoad()
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
            make.height.equalTo(110)
        }
        titleView = MPTitleView(titleArr: ["年检已过", "年检未过", "服务反馈"])
        titleView.delegate = self
        view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(yearCheckTitileView.snp.bottom)
            make.height.equalTo(50)
        }
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        let view1 = UIView()
        view1.backgroundColor = UIColor.colorWithHexString("#ff0000", alpha: 0.3)
        let view2 = UIView()
        view2.backgroundColor = UIColor.colorWithHexString("#00ff00", alpha: 0.3)
        let view3 = UIView()
        view3.backgroundColor = UIColor.colorWithHexString("#0000ff", alpha: 0.3)
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
        view1.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(view).offset(-160)
            make.width.equalTo(MPUtils.screenW)
        }
        view2.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(view1.snp.trailing)
            make.trailing.equalTo(view3.snp.leading)
            make.height.equalTo(view).offset(-160)
            make.width.equalTo(MPUtils.screenW)
        }
        view3.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(view).offset(-160)
            make.width.equalTo(MPUtils.screenW)
        }
    }

    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
    fileprivate var titleView: MPTitleView!
    fileprivate var scrollView: UIScrollView!
}

extension MPStartYearCheckViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + MPUtils.screenW * 0.5
        let index = Int(offsetX / MPUtils.screenW)
        titleView.setupSelectedIndex(index)
        titleView.isTouch = false
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        titleView.isTouch = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if titleView.isTouch {
            return
        }
        titleView.setupOffsetX(scrollView.contentOffset.x)
    }
}

extension MPStartYearCheckViewController: MPTitleViewDelegate {
    func titleView(didSelect index: Int) {
        titleView.isTouch = true
        scrollView.setContentOffset(CGPoint(x: MPUtils.screenW * CGFloat(index), y: 0), animated: true)
        print(index)
    }
}




