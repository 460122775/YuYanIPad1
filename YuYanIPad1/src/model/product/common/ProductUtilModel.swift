//
//  ProductModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/10/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import UIKit
import SQLite

class ProductUtilModel : NSObject {
    
    var _productConfigArr : NSMutableArray = []
    var _currentScanName : String = ""
    var _currentScanTime : String = ""
    var _productTypeList = []
    var _productArr : NSMutableArray = []

    class var getInstance : ProductUtilModel
    {
        struct Static {
            static let instance : ProductUtilModel = ProductUtilModel()
        }
        return Static.instance
    }
    
    internal func selectProductConfigFromLocal()
    {
        if NSUserDefaults.standardUserDefaults().objectForKey(INITDATABASE) != nil
        {
            do{
                var _productConfigDicTemp : NSMutableDictionary? = nil
                self._productConfigArr.removeAllObjects()
                let db = try Connection("\(PATH_DATABASE)\(DATABASE_NAME)")
                let productConfig = Table("product_config")
                for config in db.prepare(productConfig)
                {
                    _productConfigDicTemp = NSMutableDictionary()
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("id")]), forKey: "id")
                    _productConfigDicTemp?.setValue(config[Expression<String?>("ename")], forKey: "ename")
                    _productConfigDicTemp?.setValue(config[Expression<String?>("cname")], forKey: "cname")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("type")]), forKey: "type")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("enableIPadQuery")]), forKey: "enableIPadQuery")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("enableIPadMovie")]), forKey: "enableIPadMovie")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("enableIPadCut")]), forKey: "enableIPadCut")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("typeOfCut")]), forKey: "typeOfCut")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("typeOfMultiLayer")]), forKey: "typeOfMultiLayer")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("productOrder")]), forKey: "productOrder")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("level")]), forKey: "level")
                    _productConfigDicTemp?.setValue(NSNumber(longLong: config[Expression<Int64>("colorId")]), forKey: "colorId")
                    _productConfigDicTemp?.setValue(config[Expression<String?>("colorFile")], forKey: "colorFile")
                    self._productConfigArr.addObject(_productConfigDicTemp!)
                }
                LogModel.getInstance.insertLog("Get product config count : \(self._productConfigArr.count)")
                ProductUtilModel.getInstance.initProductByProductConfig()
                NSNotificationCenter.defaultCenter().postNotificationName("\(PRODUCTCONFIG)\(SELECT)\(SUCCESS)", object: self._productConfigArr)
            }catch let error as NSError{
                LogModel.getInstance.insertLog("Database Error. [err:\(error)]")
            }
        }
    }
    
    internal func selectProductConfig()
    {
        let url = NSURL(string: "\(URL_Server)/ios/selectProductConfigForQuery")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            let productConfigDir : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            self._productConfigArr = productConfigDir.objectForKey("list") as! NSMutableArray
            LogModel.getInstance.insertLog("Get product config count : \(self._productConfigArr.count)")
            ProductUtilModel.getInstance.initProductByProductConfig()
            NSNotificationCenter.defaultCenter().postNotificationName("\(PRODUCTCONFIG)\(SELECT)\(SUCCESS)", object: self._productConfigArr)
        })
        task.resume()
    }
    
    internal func getProductConfigArr() -> NSMutableArray
    {
        return _productConfigArr
    }
    
    internal func isGetProductConfigArr() -> Bool
    {
        if _productConfigArr.count == 0
        {
            return false
        }else{
            return true
        }
    }
    
    internal func productScanInfoReceived(productScanInfoData _infoData : NSData?)
    {
        if _infoData == nil || _infoData!.length <= 24
        {
            return
        }
        _currentScanName = String.init(data: (_infoData?.subdataWithRange(NSMakeRange(20, (_infoData?.length)! - 20 - 4)))!, encoding: NSUTF8StringEncoding)!
        LogModel.getInstance.insertLog("ProductModel received scan name :[\(_currentScanName)]")
    }
    
    internal func productTypeListReceived(productListData _listData : NSData?)
    {
        if _listData == nil || _listData!.length <= 24
        {
            return
        }
        let productTypeStr = String.init(data: (_listData?.subdataWithRange(NSMakeRange(20, (_listData?.length)! - 20 - 4)))!, encoding: NSUTF8StringEncoding)
        _productTypeList = productTypeStr!.componentsSeparatedByString(",")
        LogModel.getInstance.insertLog("ProductModel received product type :[\(_productTypeList)]")
        initProductByProductConfig()
        if _productArr.count > 0
        {
            NSNotificationCenter.defaultCenter().postNotificationName("\(PRODUCTTYPELIST)\(SELECT)\(SUCCESS)", object: self._productTypeList)
        }
    }
    
    internal func initProductByProductConfig()
    {
        // Reset productArr by new product type.
        if _productTypeList.count == 0 || _productConfigArr.count == 0
        {
            return
        }
        _productArr.removeAllObjects()
        var _productDic : NSMutableDictionary
        var _productConfigDic : NSMutableDictionary
        for var i = 0; i < _productTypeList.count; i++
        {
            for var j = 0; j < _productConfigArr.count; j++
            {
                _productConfigDic = (_productConfigArr.objectAtIndex(j) as? NSMutableDictionary)!
                if Int64(_productConfigDic.valueForKey("type") as! Int) == (_productTypeList.objectAtIndex(i) as! NSString).longLongValue
                {
                    _productDic = NSMutableDictionary()
                    _productDic.setValue(_productTypeList.objectAtIndex(i), forKey: "type")
                    _productDic.setValue(_productConfigDic.objectForKey("cname") as! String, forKey: "cname")
                    _productDic.setValue(_productConfigDic.objectForKey("ename") as! String, forKey: "ename")
                    _productDic.setValue(_productConfigDic.objectForKey("level"), forKey: "level")
                    _productDic.setValue("", forKey: "name")
                    _productArr.addObject(_productDic)
                    break
                }
            }
        }
    }
    
    internal func getProductList() -> NSMutableArray
    {
        return _productArr
    }
    
    internal func getHistoryData(startTime : NSTimeInterval, endTime _endTime: NSTimeInterval,
        productType _productType : Int32, currentPage _currentPage : Int32)
    {
        let _pageVo : PageVo = PageVo()
        _pageVo.currentPage = _currentPage
        let _productVo : ProductVo = ProductVo()
        _productVo.type = _productType
        let urlStr : NSString = "\(URL_Server)/ios/product/selectProductByTypeInPeriod?startTime=\(Int64(1451578200))&endTime=\(Int64(1453255670))&pageVo=\(_pageVo.getJsonStr())&productVo=\(_productVo.getJsonStr())"
//        let urlStr : NSString = "\(URL_Server)/ios/product/selectProductByTypeInPeriod?startTime=\(Int64(startTime))&endTime=\(Int64(_endTime))&pageVo=\(_pageVo.getJsonStr())&productVo=\(_productVo.getJsonStr())"
        LogModel.getInstance.insertLog("\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
//            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            NSNotificationCenter.defaultCenter().postNotificationName("\(HISTORYPRODUCT)\(SELECT)\(SUCCESS)", object: NSMutableDictionary(dictionary: resultDic))
        })
        task.resume()
    }
    
    internal func productNameToDicControl(productNameStr : String) -> NSMutableDictionary?
    {
        // Reset productArr by new product type.
        if _productTypeList.count == 0 || _productConfigArr.count == 0
        {
            return nil
        }
        let productNameArr : [String] = productNameStr.componentsSeparatedByString("\\")
        if productNameArr.count >= 3
        {
            var _productDic : NSMutableDictionary?
            var _productConfigDic : NSMutableDictionary
            for var i = 0; i < _productConfigArr.count; i++
            {
                _productConfigDic = (_productConfigArr.objectAtIndex(i) as? NSMutableDictionary)!
                if _productConfigDic.valueForKey("ename") as! String == productNameArr[productNameArr.count - 2]
                {
                    _productDic = NSMutableDictionary()
                    _productDic!.setValue(_productConfigDic.objectForKey("type"), forKey: "type")
                    _productDic!.setValue(_productConfigDic.objectForKey("cname") as! String, forKey: "cname")
                    _productDic!.setValue(_productConfigDic.objectForKey("ename") as! String, forKey: "ename")
                    _productDic!.setValue(_productConfigDic.objectForKey("level"), forKey: "level")
                    _productDic!.setValue(productNameStr, forKey: "pos_file")
                    _productDic!.setValue(productNameArr[productNameArr.count - 1], forKey: "name")
                    _productDic!.setValue((productNameArr[productNameArr.count - 1] as NSString).substringWithRange(NSRange(location: 23, length: 3)), forKey: "scan_mode")
                    _productDic!.setValue((_productConfigDic.objectForKey("type") as! NSNumber).stringValue + "-"
                        + productNameArr[productNameArr.count - 1].componentsSeparatedByString("_")[2], forKey: "mcode")
                    _productArr.addObject(_productDic!)
                    break
                }
            }
            return _productDic
        }else{
            return nil
        }
    }
    
    internal func getDateTimeFormatStringFromAddress(pos_file : String) -> String?
    {
        let productNameArr : [String] = pos_file.componentsSeparatedByString("\\")
        if productNameArr.count >= 3
        {
            let nameStr = productNameArr[3] as NSString
            return  nameStr.substringWithRange(NSMakeRange(0, 4)) + "-" +
                    nameStr.substringWithRange(NSMakeRange(4, 2)) + "-" +
                    nameStr.substringWithRange(NSMakeRange(6, 2)) + "  " +
                    nameStr.substringWithRange(NSMakeRange(9, 2)) + ":" +
                    nameStr.substringWithRange(NSMakeRange(11, 2)) + ":" +
                    nameStr.substringWithRange(NSMakeRange(13, 2))
        }else{
            return nil
        }
    }
}
