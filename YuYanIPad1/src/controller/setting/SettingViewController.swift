//
//  SettingViewController.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController : UIViewController, SysSettingNavProtocol, LoginResultProtocol
{
    var navListView : NavListView?
    var loginView : LoginView?
    var loginResultView : LoginResultView?
    var configView : ConfigView?
    var aboutUsView : AboutUsView?
    var lawInfoVIew : LawView?
    var clauseInfoView : ClauseView?
    var versionInfoVIew : VersionView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Init left list view.
        self.navListView = (NSBundle.mainBundle().loadNibNamed("NavListView", owner: self, options: nil) as NSArray).lastObject as? NavListView
        self.navListView!.frame.origin = CGPointMake(0, 0)
        self.view.addSubview(self.navListView!)
        self.navListView?.sysSettingDelegate = self
        // Add observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingViewController.loginSuccess), name: "\(LOGIN)\(SUCCESS)", object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // Default show login view.
        self.navListView?.setBtnClickSelect((self.navListView?.loginBtn)!)
    }
    
    func loginSuccess()
    {
        if CurrentUserVo?.jobs > USERCONST_JOB_GUEST
        {
            // Init login view.
            self.loginResultView = (NSBundle.mainBundle().loadNibNamed("LoginResultView", owner: self, options: nil) as NSArray).lastObject as? LoginResultView
            self.loginResultView?.loginProtocolDelegate = self
            self.loginResultView!.frame.origin = CGPointMake(240, 0)
            for view in self.view.subviews {view.removeFromSuperview()}
//            self.view.subviews.map { $0.removeFromSuperview() }
            self.view.addSubview(self.navListView!)
            self.view.addSubview(self.loginResultView!)
            self.loginResultView?.loginSuccessControl(CurrentUserVo!)
            self.navListView?.loginSuccessControl(CurrentUserVo!)
        }
    }
    
    func loginOutControl()
    {
        loginBtnClick()
        UserModel.getInstance.loginControl(USERCONST_GUEST_NAME, _userPwd: USERCONST_GUEST_PWD)
    }
    
    func loginBtnClick()
    {
        if CurrentUserVo?.jobs > USERCONST_JOB_GUEST
        {
            loginSuccess()
        }else{
            // Init login view.
            self.loginView = (NSBundle.mainBundle().loadNibNamed("LoginView", owner: self, options: nil) as NSArray).lastObject as? LoginView
            self.loginView!.frame.origin = CGPointMake(240, 0)
            for view in self.view.subviews {view.removeFromSuperview()}
//            self.view.subviews.map { $0.removeFromSuperview() }
            self.view.addSubview(self.navListView!)
            self.view.addSubview(self.loginView!)
        }
    }
    
    func configBtnClick()
    {
        // Init system config view.
        self.configView = (NSBundle.mainBundle().loadNibNamed("ConfigView", owner: self, options: nil) as NSArray).lastObject as? ConfigView
        self.configView!.frame.origin = CGPointMake(240, 0)
        for view in self.view.subviews {view.removeFromSuperview()}
//        self.view.subviews.map { $0.removeFromSuperview() }
        self.view.addSubview(self.navListView!)
        self.view.addSubview(self.configView!)
        self.configView!.setViewByData()
    }
    
    func aboutUsBtnClick()
    {
        // Init aboutus view.
        self.aboutUsView = (NSBundle.mainBundle().loadNibNamed("AboutUsView", owner: self, options: nil) as NSArray).lastObject as? AboutUsView
        self.aboutUsView!.frame.origin = CGPointMake(240, 0)
        for view in self.view.subviews {view.removeFromSuperview()}
//        self.view.subviews.map { $0.removeFromSuperview() }
        self.view.addSubview(self.navListView!)
        self.view.addSubview(self.aboutUsView!)
    }
    
    func lawBtnClick()
    {
        // Init law info view.
        self.lawInfoVIew = (NSBundle.mainBundle().loadNibNamed("LawView", owner: self, options: nil) as NSArray).lastObject as? LawView
        self.lawInfoVIew!.frame.origin = CGPointMake(240, 0)
        for view in self.view.subviews {view.removeFromSuperview()}
//        self.view.subviews.map { $0.removeFromSuperview() }
        self.view.addSubview(self.navListView!)
        self.view.addSubview(self.lawInfoVIew!)
    }
    
    func clauseBtnClick()
    {
        // Init clause info view.
        self.clauseInfoView = (NSBundle.mainBundle().loadNibNamed("ClauseView", owner: self, options: nil) as NSArray).lastObject as? ClauseView
        self.clauseInfoView!.frame.origin = CGPointMake(240, 0)
        for view in self.view.subviews {view.removeFromSuperview()}
//        self.view.subviews.map { $0.removeFromSuperview() }
        self.view.addSubview(self.navListView!)
        self.view.addSubview(self.clauseInfoView!)
    }
    
    func versionBtnClick()
    {
        // Init version info view.
        self.versionInfoVIew = (NSBundle.mainBundle().loadNibNamed("VersionView", owner: self, options: nil) as NSArray).lastObject as? VersionView
        self.versionInfoVIew!.frame.origin = CGPointMake(240, 0)
        for view in self.view.subviews {view.removeFromSuperview()}
//        self.view.subviews.map { $0.removeFromSuperview() }
        self.view.addSubview(self.navListView!)
        self.view.addSubview(self.versionInfoVIew!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    