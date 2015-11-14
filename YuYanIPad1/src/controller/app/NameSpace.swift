//
//  NameSpace.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/10/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation

var IP_Server : String = "192.168.137.1" // 192.168.191.1
var PORT_SERVER : Int = 8080 // 9090
var URL_Server : String = "http://\(IP_Server):\(PORT_SERVER)/XYSystem"
var URL_DATA : String = "http://\(IP_Server):\(PORT_SERVER)/data"

var IP_PT : String = "\(IP_Server)"
var PORT_PT : UInt16 = 8112

var PATH_PRODUCT : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! + "/produtFile/"

var HeartPkgCycle : NSTimeInterval = 4.0
var MAX_PRODUCTCACHE : Int = 30

var CurrentUserVo : UserVo?

var ZeroValue : UInt32 = 0
var BYTE_ZERO : UInt8 = 0

let SOCKET : String = "Socket"
let LOGIN : String = "Login"
    let CURRENTUSERINFO : String = "CurrentUserInfo"
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