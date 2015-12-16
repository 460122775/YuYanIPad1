//
//  MainViewController.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/16/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class MainViewController : UIViewController
{
    
    @IBOutlet var currentBtn: UIButton!
    @IBOutlet var historyBtn: UIButton!
    @IBOutlet var chatBtn: UIButton!
    @IBOutlet var thresholdBtn: UIButton!
    @IBOutlet var settingBtn: UIButton!
    @IBOutlet var rightView: UIView!
    var currentViewBtn : UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.currentBtnClick(currentBtn)
        // Init Database.
        DBModel.initDB()
        // Get Product Config.
        ProductUtilModel.getInstance.selectProductConfigFromLocal()
        // Add Listener.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "socketConnectSuccess:", name: "\(SOCKET)\(SUCCESS)", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "socketConnectFail:", name: "\(SOCKET)\(FAIL)", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getProductTypeListControl:", name: "\(PRODUCTTYPELIST)\(SELECT)", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccessControl", name: "\(LOGIN)\(SUCCESS)", object: nil)
        // Connect Socket.
        SocketCenter.getInstance.conntcpclient()
    }
    
    func socketConnectSuccess(notification : NSNotification)
    {
        UserModel.getInstance.loginControl(nil, userPwd: nil)
    }
    
    var connectCount : UInt32 = 0
    func socketConnectFail(notification : NSNotification)
    {
        connectCount++
        if connectCount == 11
        {
            return
        }
        SocketCenter.getInstance.conntcpclient()
    }
    
    func getProductTypeListControl(notification : NSNotification)
    {
        ProductUtilModel.getInstance.productTypeListReceived(productListData: notification.object as? NSData)
    }
    
    func loginSuccessControl()
    {
//        if CurrentUserVo!.jobs == USERCONST_JOB_GUEST
//        {
//            settingBtn.titleLabel?.text = settingBtn.titleLabel?.text?.stringByReplacingOccurrencesOfString("已", withString: "未")
//        }else{
//            settingBtn.titleLabel?.text = settingBtn.titleLabel?.text?.stringByReplacingOccurrencesOfString("未", withString: "已")
//        }
    }
    
    var productViewController : ProductViewController?
    @IBAction func currentBtnClick(sender: UIButton)
    {
        if self.changeBtnState(sender)
        {
            if productViewController == nil
            {
                productViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
                self.addChildViewController(productViewController!)
            }
            // Remove all subviews.
            self.rightView.subviews.map { $0.removeFromSuperview() }
            self.rightView.addSubview(productViewController!.view)
        }
    }
    
    var historyViewController : HistoryViewController?
    @IBAction func historyBtnClick(sender: UIButton)
    {
        if self.changeBtnState(sender)
        {
            if historyViewController == nil
            {
                historyViewController = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
                self.addChildViewController(historyViewController!)
            }
            // Remove all subviews.
            self.rightView.subviews.map { $0.removeFromSuperview() }
            self.rightView.addSubview(historyViewController!.view)
        }
    }
    
    var chatViewController : ChatViewController?
    @IBAction func chatBtnClick(sender: UIButton)
    {
        if self.changeBtnState(sender)
        {
            if chatViewController == nil
            {
                chatViewController = ChatViewController(nibName: "ChatViewController", bundle: nil)
                self.addChildViewController(chatViewController!)
            }
            // Remove all subviews.
            self.rightView.subviews.map { $0.removeFromSuperview() }
            self.rightView.addSubview(chatViewController!.view)
        }
    }
    
    var thresholdViewController : ThresholdViewController?
    @IBAction func thresholdBtnClick(sender: UIButton)
    {
        if self.changeBtnState(sender)
        {
            if thresholdViewController == nil
            {
                thresholdViewController = ThresholdViewController(nibName: "ThresholdViewController", bundle: nil)
                self.addChildViewController(thresholdViewController!)
            }
            // Remove all subviews.
            self.rightView.subviews.map { $0.removeFromSuperview() }
            self.rightView.addSubview(thresholdViewController!.view)
        }
    }
    
    var settingViewController : SettingViewController?
    @IBAction func settingBtnClick(sender: UIButton)
    {
        if self.changeBtnState(sender)
        {
            if settingViewController == nil
            {
                settingViewController = SettingViewController(nibName: "SettingViewController", bundle: nil)
                self.addChildViewController(settingViewController!)
            }
            // Remove all subviews.
            self.rightView.subviews.map { $0.removeFromSuperview() }
            self.rightView.addSubview(settingViewController!.view)
        }
    }
    
    func changeBtnState(sender : UIButton) -> Bool
    {
        if currentViewBtn == sender
        {
            return false
        }else if currentViewBtn != nil {
            self.currentViewBtn!.selected = false
        }
        self.currentViewBtn = sender
        self.currentViewBtn!.selected = true
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}