//
//  LoginResultView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 11/4/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol LoginResultProtocol
{
    func loginOutControl()
}

class LoginResultView: UIView {
    
    var loginProtocolDelegate : LoginResultProtocol?
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userJobImg: UIImageView!
    
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
    
    func loginSuccessControl(userVo : UserVo)
    {
        userNameLabel.text = userVo.name
        if userVo.jobs == USERCONST_JOB_NORMAL
        {
            userJobImg.image = UIImage(named: "setting_user_ico_normal.png")
        }else if userVo.jobs == USERCONST_JOB_ADMIN{
            userJobImg.image = UIImage(named: "setting_user_ico_admin.png")
        }else if userVo.jobs == USERCONST_JOB_DEVELOPER{
            userJobImg.image = UIImage(named: "setting_user_ico_super.png")
        }
    }
    
    @IBAction func loginOutBtnClick(sender: UIButton)
    {
        loginProtocolDelegate?.loginOutControl()
    }
}