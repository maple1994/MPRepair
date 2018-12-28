//
//  MPHomeViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPHomeViewController: UIViewController {
    /// 标记用户是否已登录，未登录显示登录界面
    fileprivate var isLogin: Bool {
        return MPUserModel.shared.isLogin
    }
    var isAnimationed: Bool = false
    fileprivate var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            let loginVC = MPLoginViewController()
            let nav = MPLoginNavViewController(rootViewController: loginVC)
            present(nav, animated: isAnimationed, completion: nil)
        }
        setupUI()
        updateIcon()
        NotificationCenter.default.addObserver(self, selector: #selector(MPHomeViewController.scrollToYiJieDan), name: MP_SCROLL_TO_YI_JIE_DAN_NOTIFICATION, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slideMenuController()?.leftPanGesture?.isEnabled = true
        if !isFirstLoad {
            updateIcon()
        }
        isFirstLoad = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        slideMenuController()?.leftPanGesture?.isEnabled = false
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: userImageButton)
        
        navigationItem.titleView = segCtr
        segCtr.selectedSegmentIndex = 0
        
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        gongZuoTaiVC = MPGongZuoTaiViewController()
        gongZuoTaiVC.delegate = self
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
//        slideMenuController()?.openLeft()
        let vc = MPLeagueViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func segChange() {
        let offsetX: CGFloat = CGFloat(segCtr.selectedSegmentIndex) * mp_screenW
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    /// 滚动到已接单
    @objc fileprivate func scrollToYiJieDan() {
        segCtr.selectedSegmentIndex = 1
        let offsetX: CGFloat = CGFloat(segCtr.selectedSegmentIndex) * mp_screenW
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
    fileprivate func updateIcon() {
        iconImageView.mp_setImage(MPUserModel.shared.picUrl)
    }
    
    // MARK: - View
    fileprivate var scrollView: UIScrollView!
    fileprivate var gongZuoTaiVC: MPGongZuoTaiViewController!
    fileprivate var yiJieDanVC: MPYiJieDanViewController!
    fileprivate lazy var userImageButton: UIControl = {
        let img = UIImage(named: "person")?.withRenderingMode(.alwaysOriginal)
        let btn = UIControl()
        btn.addTarget(self, action: #selector(MPHomeViewController.meAction), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        btn.layer.cornerRadius = 17.5
        btn.layer.masksToBounds = true
        btn.addSubview(self.iconImageView)
        self.iconImageView.image = img
        self.iconImageView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        return btn
    }()
    fileprivate lazy var iconImageView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
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

// MARK: - MPGongZuoTaiViewControllerDelegate
extension MPHomeViewController: MPGongZuoTaiViewControllerDelegate {
    /// 点击了出车
    func gongZuoTaiDidSelectChuChe() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下车", style: .plain, target: self, action: #selector(MPHomeViewController.xiaChe))
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.mpSmallFont
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
    }
    
    @objc fileprivate func xiaChe() {
        navigationItem.rightBarButtonItem = nil
        gongZuoTaiVC?.xiaCheAction()
    }
}
