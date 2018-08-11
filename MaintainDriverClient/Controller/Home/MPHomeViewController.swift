//
//  MPHomeViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPHomeViewController: UIViewController {
    // TODO: 登录状态
    /// 标记用户是否已登录，未登录显示登录界面
    fileprivate var isLogin: Bool = true
    var isAnimationed: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            let loginVC = MPLoginViewController()
            present(loginVC, animated: isAnimationed, completion: nil)
        }
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideMenuController()?.leftPanGesture?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        slideMenuController()?.leftPanGesture?.isEnabled = false
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "person"), style: .plain, target: self, action: #selector(MPHomeViewController.meAction))
        navigationItem.titleView = segCtr
        segCtr.selectedSegmentIndex = 0
        
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        gongZuoTaiVC = MPGongZuoTaiViewController()
        yiJieDanVC = MPYiJieDanViewController()
        addChildViewController(gongZuoTaiVC)
        addChildViewController(yiJieDanVC)
        scrollView.addSubview(gongZuoTaiVC.view)
        scrollView.addSubview(yiJieDanVC.view)
        gongZuoTaiVC.view.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.height.equalTo(view)
        }
        yiJieDanVC.view.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(gongZuoTaiVC.view.snp.trailing)
            make.width.height.equalTo(view)
        }
        // 解决侧滑和scrollView的手势冲突
        if let leftPan = slideMenuController()?.leftPanGesture {        
            scrollView.panGestureRecognizer.require(toFail: leftPan)
        }
    }

    // MARK: - Action
    @objc fileprivate func meAction() {
        slideMenuController()?.openLeft()
//        MPTipsView.showLoadingView()
    }
    
    @objc fileprivate func segChange() {
        let offsetX: CGFloat = CGFloat(segCtr.selectedSegmentIndex) * MPUtils.screenW
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var gongZuoTaiVC: MPGongZuoTaiViewController!
    fileprivate var yiJieDanVC: MPYiJieDanViewController!
    fileprivate lazy var segCtr: UISegmentedControl = {
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)
        ]
        let ctr = UISegmentedControl(items: ["工作台", "已接单"])
        ctr.setTitleTextAttributes(dic, for: .normal)
        ctr.setTitleTextAttributes(dic, for: .selected)
        ctr.addTarget(self, action: #selector(MPHomeViewController.segChange), for: .valueChanged)
        return ctr
    }()
}

// MARK: - UIScrollViewDelegate
extension MPHomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / view.frame.width)
        segCtr.selectedSegmentIndex = index
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
}

// MARK: - MPLeftMenuViewControllerDelegate
extension MPHomeViewController: MPLeftMenuViewControllerDelegate {
    /// 登录
    func menuViewDidSelectLogin() {
        
    }
    /// 订单
    func menuViewDidSelectOrder() {
        slideMenuController()?.closeLeft()
        let vc = MPOrderViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 账户
    func menuViewDidSelectAccount() {
        slideMenuController()?.closeLeft()
        let vc = MPAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 设置
    func menuViewDidSelectSetting() {
        slideMenuController()?.closeLeft()
        let vc = MPSettingViewController()
        navigationController?.show(vc, sender: true)
    }
}
