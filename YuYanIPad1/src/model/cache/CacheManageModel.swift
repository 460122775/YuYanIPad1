//
//  CacheManageModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 11/12/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit
import Alamofire

class CacheManageModel: NSObject
{
    var dateformatter : NSDateFormatter?
    let CACHEDPRODUCTNAME : String = "CachedProductName"
    
    class var getInstance : CacheManageModel
    {
        struct Static
        {
            static let instance : CacheManageModel = CacheManageModel()
        }
        return Static.instance
    }
    
    override init()
    {
//        print(">>>>>>>> path_product : \(PATH_PRODUCT)")
        do
        {
            try NSFileManager.defaultManager().createDirectoryAtPath(PATH_PRODUCT, withIntermediateDirectories: true, attributes: nil)
            LogModel.getInstance.insertLog("CacheManageModel: Create Directory [\(PATH_PRODUCT)].")
        }catch let error as NSError{
            LogModel.getInstance.insertLog("CacheManageModel: Create Directory ERROR[\(error)].")
        }
        dateformatter = NSDateFormatter()
        dateformatter?.dateFormat = "YYYYMMDDHHmmssSSSS"
    }
    
    func addCacheForProductFile(productName : String, data _data : NSData)
    {
        // Save ProductData into file.
        _data.writeToFile(PATH_PRODUCT, atomically: false)
        // Save Product data address into NSUserDefaults.
        var cachedProductNameArr : NSMutableArray? = NSUserDefaults.standardUserDefaults().valueForKey(CACHEDPRODUCTNAME) as? NSMutableArray
        if cachedProductNameArr == nil
        {
            cachedProductNameArr = NSMutableArray()
        }
        cachedProductNameArr?.addObject(productName)
        NSUserDefaults.standardUserDefaults().setValue(cachedProductNameArr, forKey: CACHEDPRODUCTNAME)
        NSUserDefaults.standardUserDefaults().synchronize()
        // Remove cache data beyond max count.
        
    }
    
    func getCacheForProductFile(productName : String) -> NSData?
    {
        let cachedProductNameArr : NSMutableArray? = NSUserDefaults.standardUserDefaults().valueForKey(CACHEDPRODUCTNAME) as? NSMutableArray
        if cachedProductNameArr == nil
        {
            return nil
        }else{
            for dataAddress in cachedProductNameArr!
            {
                if dataAddress as! String == productName
                {
                    let data : NSData? = NSData(contentsOfFile:"\(PATH_PRODUCT)\(productName)")
                    if data == nil
                    {
                        cachedProductNameArr?.removeObject(dataAddress)
                    }
                    return data
                }
            }
        }
        return nil
    }
    
    func clearCacheForProductFile()
    {
        do
        {
            // If cached product file directory exists.
            if NSFileManager.defaultManager().fileExistsAtPath(PATH_PRODUCT) == true
            {
                // Clear directory of caching product file.
                try NSFileManager.defaultManager().removeItemAtPath(PATH_PRODUCT)
                try NSFileManager.defaultManager().createDirectoryAtPath(PATH_PRODUCT, withIntermediateDirectories: true, attributes: nil)
            }
        }catch let error as NSError{
            LogModel.getInstance.insertLog("CacheManageModel clear cache for product file ERROR [\(error)].")
        }
    }
    
    func addCacheForPicture()
    {
        
    }
    
    func addCacheForAudio()
    {
        
    }
    
    func deleteCacheProductFile()
    {
    
    }
    
    func deleteCacheForCache()
    {
        
    }
    
    func deleteCacheForAudio()
    {
        
    }
    
    func selectStorage() -> Int32
    {
        return 0
    }  
    
}
