//
//  AppDelegate.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 MaYi. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var isFirstLoad: Bool  = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        setupNormalUIStyle()
        setHomeVCToRootVC(false)
//        AMapServices.shared().apiKey = "fa5c335316d7a9bde2efb410932e6244"
        AMapServices.shared().apiKey = "c4742d7644f2be79719a8e5031902e51"
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        // 现加载本地
        MPNetwordTool.loadPicNameFromUserDefault()
        WXApi.registerApp(wechatAppID)
        return true
    }
    
    /// 设置HomeVC为根控制器
    func setHomeVCToRootVC(_ isAnimated: Bool) {
        let mainVC = MPHomeViewController()
        mainVC.isAnimationed = isAnimated
        let nav = MPNavigationController(rootViewController: mainVC)
        let leftVC = MPLeftMenuViewController()
        leftVC.delegate = mainVC
        SlideMenuOptions.leftViewWidth = mp_screenW * 0.6
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.animationDuration = 0.25
        SlideMenuOptions.contentViewOpacity = 0.2
        let slideVC = SlideMenuController(mainViewController: nav, leftMenuViewController: leftVC)
        self.window?.rootViewController = slideVC
        self.window?.makeKeyAndVisible()
    }
    
    /// 设置通用的UI样式
    fileprivate func setupNormalUIStyle() {
        UITableViewCell.appearance().selectionStyle = .none
        if #available(iOS 11, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix(wechatAppID) {
            WXApi.handleOpen(url, delegate: MPPaymentManager.shared)
        }else if url.host == "safepay"{
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (result) in
                MPPaymentManager.shared.alipayHandle(openUrl: result)
            })
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if isFirstLoad {
            isFirstLoad = false
            MPUserModel.shared.refreshUserInfo()
            return
        }
        let old = UserDefaults.standard.integer(forKey: "MP_USER_REFRESH_TIME")
        let now: Int = (Int)(Date().timeIntervalSinceReferenceDate)
        /// App相隔半个小时就自动刷新用户数据
        if now - old >= 1800 {
            MPUserModel.shared.refreshUserInfo()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // 杀死App时，移除用户信息，下次需要重新登录
        MPUserModel.shared.removeUserInfo()
    }


}

