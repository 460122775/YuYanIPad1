//
//  UserModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/9/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import UIKit

let USERCONST_LOGIN_IN_SUCCESS : Int32 = 1
let USERCONST_LOIGN_IN_FAILED : Int32 = 2
let USERCONST_GUEST_NAME : String = "guest"
let USERCONST_GUEST_PWD : String = "888888"

let USERCONST_JOB_GUEST : Int32 = 0
let USERCONST_JOB_NORMAL : Int32 = 1
let USERCONST_JOB_ADMIN : Int32 = 2
let USERCONST_JOB_DEVELOPER : Int32 = 3

let USERCONST_LOGINERRCD_INFOERR : Int32 = 1
let USERCONST_LOGINERRCD_OFFLINE : Int32 = 2
let USERCONST_LOGINERRCD_USERDEL : Int32 = 3
let USERCONST_LOGINERRCD_NOUSER : Int32 = 4
let USERCONST_LOGINERRCD_MAXLINE : Int32 = 5

struct tagLogin
{
    var name : String //32
    var pass : String //32
    var ip : String   //32
    var loginStatus : Int32
    var userLevel : Int32
    var userId : Int32
    var userSocket : UInt32
    var errorCode : Int32
}

class UserModel: NSObject {
    
    var needAutoLogin : Bool = false
    
    class var getInstance : UserModel
    {
        struct Static {
            static let instance : UserModel = UserModel()
        }
        return Static.instance
    }
    
    func setAutoLogin(_needAutoLogin : Bool)
    {
        needAutoLogin = _needAutoLogin
        if needAutoLogin == false && NSUserDefaults.standardUserDefaults().objectForKey(CURRENTUSERINFO) != nil
        {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(CURRENTUSERINFO)
        }
    }
    
    func loginControl(var userName : String?, var userPwd : String?)
    {
        // Get user info
        if userName == nil || userPwd == nil
        {
            if NSUserDefaults.standardUserDefaults().stringForKey(CURRENTUSERINFO) == nil
            {
                userName = USERCONST_GUEST_NAME
                userPwd = USERCONST_GUEST_PWD
            }else{
                CurrentUserVo = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey(CURRENTUSERINFO) as! NSData) as? UserVo
                if CurrentUserVo != nil
                {
                    userName = CurrentUserVo?.name
                    userPwd = CurrentUserVo?.pass
                }else{
                    return
                }
            }
        }
        
        let loginData : NSMutableData = NSMutableData()
        loginData.appendBytes([UInt8](userName!.utf8), length: userName!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        loginData.appendData(NSMutableData(length: 32 - userName!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))!)
        loginData.appendBytes([UInt8](userPwd!.utf8), length: userPwd!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        loginData.appendData(NSMutableData(length: 32 - userPwd!
            .lengthOfBytesUsingEncoding(NSUTF8StringEncoding))!)
        loginData.appendData(NSMutableData(length: 52)!)
    
        SocketCenter.getInstance.send(type: SOCKETCONST_TYPE_LOGIN, subType: 0, status: 0, data: loginData)
    }
    
    func loginResultControl(packageData _packageData : NSData, status _loginStatus : Int32)
    {
        if _loginStatus == USERCONST_LOGIN_IN_SUCCESS
        {
            CurrentUserVo = UserVo()
            CurrentUserVo!.name = String.init(data: _packageData.subdataWithRange(NSMakeRange(20, 32)), encoding: NSUTF8StringEncoding)!.stringByReplacingOccurrencesOfString("\0", withString: "")
            CurrentUserVo!.pass = String.init(data: _packageData.subdataWithRange(NSMakeRange(52, 32)), encoding: NSUTF8StringEncoding)!.stringByReplacingOccurrencesOfString("\0", withString: "")
            CurrentUserVo!.ip = String.init(data: _packageData.subdataWithRange(NSMakeRange(84, 32)), encoding: NSUTF8StringEncoding)!.stringByReplacingOccurrencesOfString("\0", withString: "")
            _packageData.getBytes(&CurrentUserVo!.jobs, range: NSMakeRange(120, 4))
            _packageData.getBytes(&CurrentUserVo!.userID, range: NSMakeRange(124, 4))
            _packageData.getBytes(&CurrentUserVo!.userSocketID, range: NSMakeRange(128, 4))
            if needAutoLogin == true
            {
                NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(CurrentUserVo!), forKey: CURRENTUSERINFO)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            if CurrentUserVo?.name != USERCONST_GUEST_NAME
            {
                SwiftNotice.showNoticeWithText(NoticeType.success, text: "登录成功！", autoClear: true, autoClearTime: 3)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("\(LOGIN)\(SUCCESS)", object: nil)
        }else if _loginStatus == USERCONST_LOIGN_IN_FAILED{
            // Get reason of login error.
            if _packageData.length < 136
            {
                return
            }
            var loginErrorCode : Int32 = -1
            _packageData.getBytes(&loginErrorCode, range: NSMakeRange(132, 4))
            NSNotificationCenter.defaultCenter().postNotificationName("\(LOGIN)\(FAIL)", object: "\(loginErrorCode)")
            SwiftNotice.showText("登录失败，用户名或密码错误！")
            // Login again by using guest account.
            loginControl(USERCONST_GUEST_NAME, userPwd: USERCONST_GUEST_PWD)
        }
    }
}
