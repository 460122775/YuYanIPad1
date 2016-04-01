//
//  NameSpace.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/10/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation

var IP_Server : String = "192.168.199.6" // 114.55.30.68
var PORT_SERVER : Int = 9090 // 8080
var URL_Server : String = "http://\(IP_Server):\(PORT_SERVER)/XYSystem"
var URL_DATA : String = "http://\(IP_Server):\(PORT_SERVER)/data"

var IP_PT : String = "\(IP_Server)"
var PORT_PT : UInt16 = 8112

var PATH_PRODUCT : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! + "/produtFile/"
var PATH_DATABASE : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! + "/"

var DATABASE_NAME : String = "yy.sqlite3"
var RadarStatus : String = RADARSTATUS_ERROR
    let RADARSTATUS_NORMAL : String = "0"
    let RADARSTATUS_WARN : String = "1"
    let RADARSTATUS_ERROR : String = "2"

var HeartPkgCycle : NSTimeInterval = 4.0
var MAX_PRODUCTCACHE : Int = 30
var ISDEBUGMODE : Bool = true

var CurrentUserVo : UserVo?

var ZeroValue : UInt32 = 0
var BYTE_ZERO : UInt8 = 0

let INITDATABASE : String = "InitDatabase"
let SOCKET : String = "Socket"
let HTTP : String = "Http"
let LOGIN : String = "Login"
    let CURRENTUSERINFO : String = "CurrentUserInfo"
let SUCCESS : String = "Success"
let FAIL : String = "Fail"
let NODATA : String = "无符合条件的产品数据！"
let APP_ACTIVE : String = "app_active"
let APP_STOP : String = "app_stop"

let INSERT : String = "Insert"
let DELETE : String = "Delete"
let UPDATE : String = "Update"
let SELECT : String = "Select"
let RECEIVE : String = "Receive"

let RADARSTATUS : String = "RadarStatus"
let PRODUCTCONFIG : String = "ProductConfig"
let HISTORYPRODUCT : String = "HistoryProduct"
let ELEVATIONLIST : String = "ElevationList"
let PRODUCT : String = "Product"
    let NEWESTDATA : String = "NewestData"
    let CARTOON : String = "Cartoon"
let PRODUCTTYPELIST : String = "ProductTypeList"
    let LEVEL_FIRSTCLASS : Int64 = 0
let SYSTEMCONFIG : String = "SystemConfig"
let ABOUTUS : String = "AboutUs"
let LAWINFO : String = "LawInfo"
let CLAUSEINFO : String = "ClauseInfo"
let VERSIONINFO : String = "VersionInfo"