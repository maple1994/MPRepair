//
//  AppDelegate.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/2.
//  Copyright © 2018年 MaYi. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        setupNormalUIStyle()
        setHomeVCToRootVC(false)
        AMapServices.shared().apiKey = "4a539db4a6b5dca1d1dc53de781c3bd0"
        return true
    }
    
    /// 设置HomeVC为根控制器
    func setHomeVCToRootVC(_ isAnimated: Bool) {
        let mainVC = MPHomeViewController()
        mainVC.isAnimationed = isAnimated
        let nav = MPNavigationController(rootViewController: mainVC)
        let leftVC = MPLeftMenuViewController()
        leftVC.delegate = mainVC
        SlideMenuOptions.leftViewWidth = MPUtils.screenW * 0.6
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
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
        }
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

