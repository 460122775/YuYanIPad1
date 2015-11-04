//
//  NavListView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/26/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol SysSettingNavProtocol
{
    func loginBtnClick()
    
    func configBtnClick()
    
    func aboutUsBtnClick()
    
    func lawBtnClick()

    func clauseBtnClick()
    
    func versionBtnClick()
}

class NavListView : UIView
{
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var configBtn: UIButton!
    @IBOutlet var aboutUsBtn: UIButton!
    @IBOutlet var lawBtn: UIButton!
    @IBOutlet var clauseBtn: UIButton!
    @IBOutlet var versionBtn: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    
    var sysSettingDelegate : SysSettingNavProtocol!
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
    }
    
    func loginSuccessControl(userVo : UserVo)
    {
        if userVo.jobs == USERCONST_JOB_GUEST
        {
            userNameLabel.text = "未登录"
        }else{
            userNameLabel.text = userVo.name
        }
    }
    
    @IBAction func setBtnClickSelect(sender : UIButton)
    {
        self.configBtn.selected = false
        self.aboutUsBtn.selected = false
        self.lawBtn.selected = false
        self.clauseBtn.selected = false
        self.versionBtn.selected = false
        if sender == self.loginBtn
        {
            sysSettingDelegate.loginBtnClick()
        }else{
            sender.selected = true
            if sender == self.configBtn{
                sysSettingDelegate.configBtnClick()
            }else if sender == self.aboutUsBtn{
                sysSettingDelegate.aboutUsBtnClick()
            }else if sender == self.lawBtn{
                sysSettingDelegate.lawBtnClick()
            }else if sender == self.clauseBtn{
                sysSettingDelegate.clauseBtnClick()
            }else if sender == self.versionBtn{
                sysSettingDelegate.versionBtnClick()
            }
        }
    }
}