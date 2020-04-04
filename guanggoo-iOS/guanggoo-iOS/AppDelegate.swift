//
//  AppDelegate.swift
//  guanggoo-iOS
//
//  Created by tdx on 2017/12/11.
//  Copyright © 2017年 tdx. All rights reserved.
//

import UIKit
import DrawerController
import CYLTabBarController
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var drawController:DrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let ceneterViewController = CenterViewController.init(urlString: GUANGGUSITE);
//        ceneterViewController.title = "全部";
//        let centerNav = UINavigationController(rootViewController: ceneterViewController);
//        let leftViewController = LeftViewController();
//        leftViewController.vcDelegate = ceneterViewController;
//        let rightViewController = RightViewController();
//        rightViewController.vcDelegate = ceneterViewController;
//        drawController = DrawerController(centerViewController: centerNav, leftDrawerViewController: leftViewController, rightDrawerViewController: rightViewController);
//        drawController?.maximumLeftDrawerWidth = UIScreen.main.bounds.size.width*3/4;
//        drawController?.maximumRightDrawerWidth = 100;
//        drawController?.openDrawerGestureModeMask=OpenDrawerGestureMode.panningCenterView
//        drawController?.closeDrawerGestureModeMask=CloseDrawerGestureMode.all;
        
        PublishButton.register();
        let homeVC = HomeViewController.init();
        let homeNav = UINavigationController.init(rootViewController: homeVC);
        let homeVC1 = InterestViewController.init();
        homeVC1.title = "兴趣节点";
        let vc1Nav = UINavigationController.init(rootViewController: homeVC1);
        let homeVC2 = NotificationViewController.init(urlString: GUANGGUSITE + "notifications");
        let vc2Nav = UINavigationController.init(rootViewController: homeVC2);
        let homeVC3 = PersonalCenterViewController.init();
        let vc3Nav = UINavigationController.init(rootViewController: homeVC3);
        let dic1 = [CYLTabBarItemTitle:"社区动态",CYLTabBarItemImage:"homepage",CYLTabBarItemSelectedImage:"homepage_selected"];
        let dic2 = [CYLTabBarItemTitle:"兴趣节点",CYLTabBarItemImage:"groups",CYLTabBarItemSelectedImage:"groups_selected"];
        let dic3 = [CYLTabBarItemTitle:"消息通知",CYLTabBarItemImage:"message",CYLTabBarItemSelectedImage:"message_selected"];
        let dic4 = [CYLTabBarItemTitle:"个人中心",CYLTabBarItemImage:"settings",CYLTabBarItemSelectedImage:"settings_selected"];
        
        let tabVC = MainTabBarViewController.init(viewControllers: [homeNav,vc1Nav,vc2Nav,vc3Nav], tabBarItemsAttributes: [dic1,dic2,dic3,dic4])
        
        //初始化讯飞语音
        IFlySpeechUtility.createUtility("appid=5a4b2f2f");
        //初始化leanCloun
//        LeanCloud.initialize(applicationID: "7pPF4eyeCKI11qGEmbP67SgJ-gzGzoHsz", applicationKey: "iYv1dRM9UY3dt5vCpTXyzDGW")
        
        IQKeyboardManager.sharedManager().enable = true

        self.window = UIWindow()
        self.window?.frame  = UIScreen.main.bounds
        self.window?.rootViewController = tabVC
        self.window?.makeKeyAndVisible()
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

