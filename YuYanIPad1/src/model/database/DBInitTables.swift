//
//  DBInitTables.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 11/23/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit

class DBInitTables: NSObject {
    class func initColorInfoTables() -> String
    {
        let sqlStr_colorInfo : String = "CREATE TABLE 'color_info' (  'colorId' INTEGER NOT NULL PRIMARY KEY autoincrement,  'fileName' text NOT NULL,  'colorType' INTEGER NOT NULL DEFAULT '1',  'productType' INTEGER NOT NULL,  'unitStr' text NOT NULL,  'scaleStr' text NOT NULL,  'rgbnStr' text NOT NULL,  'enable' INTEGER NOT NULL DEFAULT '1');"
        return sqlStr_colorInfo
    }
    
    class func initProductConfigTable() -> String
    {
        let sqlStr_productConfig : String = "CREATE TABLE 'product_config' (  'id' INTEGER NOT NULL PRIMARY KEY autoincrement,  'ename' text NOT NULL DEFAULT '',  'cname' text NOT NULL,  'type' INTEGER NOT NULL,  'enableApply' INTEGER NOT NULL DEFAULT '0',  'enableTimeApply' INTEGER NOT NULL DEFAULT '0',  'enableIPadQuery' INTEGER NOT NULL DEFAULT '0',  'enableQuery' INTEGER NOT NULL DEFAULT '0',  'enableIPadMovie' INTEGER NOT NULL DEFAULT '0',  'enableMovie' INTEGER NOT NULL DEFAULT '0',  'productOrder' INTEGER NOT NULL DEFAULT '0',  'enableIPadCut' INTEGER NOT NULL DEFAULT '0',  'typeOfCut' INTEGER NOT NULL DEFAULT '-1',  'typeOfMultiLayer' INTEGER NOT NULL DEFAULT '-1',  'level' INTEGER NOT NULL DEFAULT '2',  'colorFile' text NOT NULL,  'colorId' INTEGER NOT NULL);"
        return sqlStr_productConfig
    }
    
    class func initSystemInfoTable() -> String
    {
        let sqlStr_systemInfo : String = "CREATE TABLE 'system_info' (  'id' INTEGER NOT NULL PRIMARY KEY autoincrement,  'channel' text NOT NULL,  'content' text NOT NULL);"
        return sqlStr_systemInfo
    }
}
