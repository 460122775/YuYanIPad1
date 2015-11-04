//
//  LoginView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/26/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class LoginView : UIView
{
    @IBOutlet var userNameInput: UITextField!
    @IBOutlet var userPwdInput: UITextField!
    @IBOutlet var autoLoginCheckBtn: UIButton!
    @IBOutlet var autoLoginCheckBg: UIImageView!
    @IBOutlet var loginBtn: UIButton!
    
    override init(frame : CGRect)
    {
        super.init(frame:frame)
    }
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
    }
    
    @IBAction func autoLoginCheckBtn(sender: UIButton)
    {
        if autoLoginCheckBg.tag == 0
        {
            autoLoginCheckBg.image = UIImage(named: "setting_login_checkbox_checked.png")
            autoLoginCheckBg.tag = 1
            UserModel.getInstance.setAutoLogin(true)
        }else{
            autoLoginCheckBg.image = UIImage(named: "setting_login_checkbox.png")
            autoLoginCheckBg.tag = 0
            UserModel.getInstance.setAutoLogin(false)
        }
    }
    
    @IBAction func loginBtnClick(sender: UIButton)
    {
        // Judge null input.
        if userNameInput.text == nil
        {
            return
        }else if userPwdInput.text == nil{
            return
        }else if userNameInput.text == USERCONST_GUEST_NAME{
             SwiftNotice.showNoticeWithText(NoticeType.error, text: "对不起，不可以用访客登录！", autoClear: true, autoClearTime: 3)
            return
        }
        // Login Action.
        UserModel.getInstance.loginControl(userNameInput.text, userPwd: userPwdInput.text)
    }
}