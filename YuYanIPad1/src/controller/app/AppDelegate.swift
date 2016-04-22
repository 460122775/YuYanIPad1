//
//  AppDelegate.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/16/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window!.rootViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        self.window!.makeKeyAndVisible()
//        self.shareSDKInit()
        return true
    }
    
//    func shareSDKInit()
//    {
//        ShareSDK.registerApp("1196e24b12762",
//                             
//                             activePlatforms: [SSDKPlatformType.TypeSinaWeibo.rawValue,
//                                SSDKPlatformType.TypeTencentWeibo.rawValue,
//                                SSDKPlatformType.TypeFacebook.rawValue,
//                                SSDKPlatformType.TypeWechat.rawValue,],
//                             onImport: {(platform : SSDKPlatformType) -> Void in
//                                
//                                switch platform{
//                                    
//                                case SSDKPlatformType.TypeWechat:
//                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//                                    
//                                case SSDKPlatformType.TypeQQ:
//                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
//                                default:
//                                    break
//                                }
//            },
//                             onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
//                                switch platform {
//                                    
//                                case SSDKPlatformType.TypeSinaWeibo:
//                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                                    appInfo.SSDKSetupSinaWeiboByAppKey("568898243",
//                                        appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
//                                        redirectUri : "http://www.sharesdk.cn",
//                                        authType : SSDKAuthTypeBoth)
//                                    break
//                                    
//                                case SSDKPlatformType.TypeWechat:
//                                    //设置微信应用信息
//                                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
//                                    break
//                                    
//                                case SSDKPlatformType.TypeTencentWeibo:
//                                    //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
//                                    appInfo.SSDKSetupTencentWeiboByAppKey("801307650",
//                                        appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
//                                        redirectUri : "http://www.sharesdk.cn")
//                                    break
//                                default:
//                                    break
//                                    
//                                }
//        })
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // Close socket.
        NSNotificationCenter.defaultCenter().postNotificationName("\(APP_STOP)", object: nil)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        // Connect Socket.
        NSNotificationCenter.defaultCenter().postNotificationName("\(APP_ACTIVE)", object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Close socket.
        NSNotificationCenter.defaultCenter().postNotificationName("\(APP_STOP)", object: nil)
    }
}

