//
//  CacheManageModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 11/12/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit
import Alamofire
import SSZipArchive

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
        if _data.length == 0
        {
            return
        }else if _data.length > 48 && productName.lowercaseString.hasSuffix(".zdb"){
            let productName = productName.stringByReplacingOccurrencesOfString(".zdb", withString: "")
            try! _data.subdataWithRange(NSMakeRange(48, (_data.length) - 48)).gunzippedData().writeToFile(PATH_PRODUCT + productName, atomically: false)
        }else if productName.lowercaseString.hasSuffix(".zip"){
            _data.writeToFile(PATH_PRODUCT + productName, atomically: false)
            // Unzip
            SSZipArchive.unzipFileAtPath(PATH_PRODUCT + productName, toDestination: PATH_PRODUCT)
            try! NSFileManager.defaultManager().removeItemAtPath(PATH_PRODUCT + productName)
        }else{
            _data.writeToFile(PATH_PRODUCT + productName, atomically: false)
        }
        // Show if file is exist.
//        let filemanager:NSFileManager = NSFileManager()
//        let files = filemanager.enumeratorAtPath(PATH_PRODUCT)
//        while let file = files?.nextObject() {
//            print(file)
//        }
        // Save Product data address into NSUserDefaults.
//        NSUserDefaults.standardUserDefaults().setValue(productName, forKey: CACHEDPRODUCTNAME + productName)
//        NSUserDefaults.standardUserDefaults().synchronize()
        // Remove cache data beyond max count.
        
    }
    
    func getCacheForProductFile(_productName : String) -> NSData?
    {
        // Get product data file which has already decompressed.
        var productName = _productName.stringByReplacingOccurrencesOfString(".zdb", withString: "")
        productName = productName.stringByReplacingOccurrencesOfString(".zip", withString: "")
        return NSData(contentsOfFile:"\(PATH_PRODUCT)\(productName)")
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
    
    // Get size of cached product data file, and the unit is Byte.
    func getCacheSizeForProductFile() -> Int64
    {
        if NSFileManager.defaultManager().fileExistsAtPath(PATH_PRODUCT)
        {
            let files = NSFileManager().enumeratorAtPath(PATH_PRODUCT)
            while let file = files?.nextObject()
            {
                print("\(file)")
            }
            return NSFileManager.defaultManager().folderSizeAtPath(PATH_PRODUCT)
        }
        return 0;
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

extension NSFileManager {
    func fileSizeAtPath(path: String) -> Int64 {
        do {
            let fileAttributes = try attributesOfItemAtPath(path)
            let fileSizeNumber = fileAttributes[NSFileSize]
            let fileSize = fileSizeNumber?.longLongValue
            return fileSize!
        } catch {
            print("error reading filesize, NSFileManager extension fileSizeAtPath")
            return 0
        }
    }
    
    func folderSizeAtPath(path: String) -> Int64 {
        var size : Int64 = 0
        do {
            let files = try subpathsOfDirectoryAtPath(path)
            for i in 0 ..< files.count {
                size += fileSizeAtPath(path + files[i])
            }
        } catch {
            print("error reading directory, NSFileManager extension folderSizeAtPath")
        }
        return size
    }
}
