//
//  DBModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 11/11/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit
import SQLite

class DBModel: NSObject
{
    class func initDB()
    {
        do{
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let db = try Connection("\(path)/db/yy.sqlite3")
            
            // Init color_info table.
            let colorTable = Table("color_info")
            try db.run(colorTable.create { t in
                t.column(Expression<Int64>("colorId"), primaryKey: true)
                t.column(Expression<String?>("fileName"))
                t.column(Expression<Int64>("colorType"))
                t.column(Expression<Int64>("productType"), unique: true)
                t.column(Expression<String?>("scaleStr"))
                t.column(Expression<String?>("unitStr"))
                t.column(Expression<String?>("rgbnStr"))
                t.column(Expression<Int64>("enable"))
            })
            
            // Init product_config table.
            let productConfigTable = Table("product_config")
            try db.run(productConfigTable.create { t in
                t.column(Expression<Int64>("id"), primaryKey: true)
                t.column(Expression<String?>("ename"))
                t.column(Expression<String?>("cname"))
                t.column(Expression<Int64>("type"), unique: true)
                t.column(Expression<Int64>("enableIPadQuery"))
                t.column(Expression<Int64>("enableIPadMovie"))
                t.column(Expression<Int64>("enableIPadCut"))
                t.column(Expression<Int64>("typeOfCut"))
                t.column(Expression<Int64>("typeOfMultiLayer"))
                t.column(Expression<Int64>("productOrder"))
                t.column(Expression<Int64>("level"))
                t.column(Expression<Int64>("colorId"))
                t.column(Expression<String?>("colorFile"))
            })
        }catch let error as NSError{
            LogModel.getInstance.insertLog("Database Error. [err:\(error)]")
        }
    }
    
    class func insertColor(colorArr : NSMutableArray)
    {
        do{
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let db = try Connection("\(path)/db/yy.sqlite3")
            let colorTable = Table("color_info")
            
            let colorId = Expression<Int64>("colorId")
            let fileName = Expression<String?>("fileName")
            let colorType = Expression<Int64>("colorType")
            let productType = Expression<Int64>("productType")
            let scaleStr = Expression<String?>("scaleStr")
            let unitStr = Expression<String?>("unitStr")
            let rgbnStr = Expression<String?>("rgbnStr")
            let enable = Expression<Int64>("enable")
            
            for colorDic in colorArr
            {
                try db.run(colorTable.insert(
                    colorId <- ((colorDic as! NSMutableDictionary).objectForKey("colorId") as! Int64),
                    fileName <- ((colorDic as! NSMutableDictionary).objectForKey("fileName") as! String),
                    colorType <- ((colorDic as! NSMutableDictionary).objectForKey("colorType") as! Int64),
                    productType <- ((colorDic as! NSMutableDictionary).objectForKey("productType") as! Int64),
                    scaleStr <- ((colorDic as! NSMutableDictionary).objectForKey("scaleStr") as! String),
                    unitStr <- ((colorDic as! NSMutableDictionary).objectForKey("unitStr") as! String),
                    rgbnStr <- ((colorDic as! NSMutableDictionary).objectForKey("rgbnStr") as! String),
                    enable <- ((colorDic as! NSMutableDictionary).objectForKey("enable") as! Int64)
                ))
            }
        }catch let error as NSError{
            LogModel.getInstance.insertLog("Database Error. [err:\(error)]")
        }
    }
    
    class func deleteAllColor()
    {
        do{
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let db = try Connection("\(path)/db/yy.sqlite3")
            let colorTable = Table("color_info")
            try db.run(colorTable.delete())
        }catch let error as NSError{
            LogModel.getInstance.insertLog("Database Error. [err:\(error)]")
        }
    }
    
    class func selectColor(_productType : Int32) -> NSMutableDictionary?
    {
        do{
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
            let db = try Connection("\(path)/db/yy.sqlite3")
            let colorTable = Table("color_info")
            
            let colorId = Expression<Int64>("colorId")
            let fileName = Expression<String?>("fileName")
            let colorType = Expression<Int64>("colorType")
            let productType = Expression<Int64>("productType")
            let scaleStr = Expression<String?>("scaleStr")
            let unitStr = Expression<String?>("unitStr")
            let rgbnStr = Expression<String?>("rgbnStr")
            let enable = Expression<Int64>("enable")
            
            for color in db.prepare(colorTable.filter(productType == Int64(_productType)).limit(1))
            {
                let colorDic : NSMutableDictionary = NSMutableDictionary()
                colorDic.setValue(NSNumber(longLong: color[colorId]), forKey: "colorId")
                colorDic.setValue(NSNumber(longLong: color[productType]), forKey: "productType")
                colorDic.setValue(NSNumber(longLong: color[colorType]), forKey: "colorType")
                colorDic.setValue(NSNumber(longLong: color[enable]), forKey: "enable")
                colorDic.setValue(color[fileName], forKey: "fileName")
                colorDic.setValue(color[scaleStr], forKey: "scaleStr")
                colorDic.setValue(color[unitStr], forKey: "unitStr")
                colorDic.setValue(color[rgbnStr], forKey: "rgbnStr")
                return colorDic
            }
        }catch let error as NSError{
            LogModel.getInstance.insertLog("Database Error. [err:\(error)]")
        }
        return nil
    }
    
}
