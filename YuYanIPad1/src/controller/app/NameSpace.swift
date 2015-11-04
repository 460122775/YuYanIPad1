//
//  NameSpace.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/10/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation

var IP_Server : String = "192.168.191.1"
var PORT_SERVER : Int = 9090
var URL_Server : String = "http://\(IP_Server):\(PORT_SERVER)/XYSystem"

var IP_PT : String = "192.168.191.1"
var PORT_PT : UInt16 = 8112

var HeartPkgCycle : NSTimeInterval = 5.0

var CurrentUserVo : UserVo?

var ZeroValue : UInt32 = 0
var BYTE_ZERO : UInt8 = 0

let SOCKET : String = "Socket"
let LOGIN : String = "Login"
    let CURRENTUSERINFO : String = "CurrentUserInfo"
//    let USERNAME : String = "UserName"
//    let USERPWD : String = "UserPWD"
//    let USERTYPE : String = "UserType"
let SUCCESS : String = "Success"
let FAIL : String = "Fail"

let INSERT : String = "Insert"
let DELETE : String = "Delete"
let UPDATE : String = "Update"
let SELECT : String = "Select"

let PRODUCTCONFIG : String = "ProductConfig"
let HISTORYPRODUCT : String = "HistoryProduct"
let PRODUCT : String = "Product"
let PRODUCTTYPELIST : String = "ProductTypeList"

let SYSTEMCONFIG : String = "SystemConfig"
let ABOUTUS : String = "AboutUs"
let LAWINFO : String = "LawInfo"
let CLAUSEINFO : String = "ClauseInfo"
let VERSIONINFO : String = "VersionInfo"