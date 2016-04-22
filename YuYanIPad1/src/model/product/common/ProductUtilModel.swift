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
    // Use for the table of ProductListView.
    var _productTypeList = []
    var _newestProductArr : NSMutableArray = []
    var _receivedProductArr : NSMutableArray = []
    
    let MAXRECEIVEPRODUCTCOUNT : Int = 30
    let dateFormatter = NSDateFormatter()

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
                for config in try db.prepare(productConfig)
                {
                    if NSNumber(longLong: config[Expression<Int64>("enableIPadQuery")]) == 1
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
        if _newestProductArr.count > 0
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
        _newestProductArr.removeAllObjects()
        var _productDic : NSMutableDictionary?
        var _productConfigDic : NSMutableDictionary?
        
        for i in 0 ..< _productTypeList.count
        {
            for j in 0 ..< _productConfigArr.count
            {
                _productConfigDic = (_productConfigArr.objectAtIndex(j) as? NSMutableDictionary)!
                if Int64(_productConfigDic!.valueForKey("type") as! Int) == (_productTypeList.objectAtIndex(i) as! NSString).longLongValue
                {
                    _productDic = NSMutableDictionary()
                    _productDic!.setValue(NSNumber(int:(_productTypeList.objectAtIndex(i) as! NSString).intValue), forKey: "type")
                    _productDic!.setValue(_productConfigDic!.objectForKey("cname") as! String, forKey: "cname")
                    _productDic!.setValue(_productConfigDic!.objectForKey("ename") as! String, forKey: "ename")
                    _productDic!.setValue(_productConfigDic!.objectForKey("colorFile") as! String, forKey: "colorFile")
                    _productDic!.setValue(_productConfigDic!.objectForKey("level"), forKey: "level")
                    _productDic!.setValue("", forKey: "name")
                    _newestProductArr.addObject(_productDic!)
                    break
                }
            }
        }
        _productDic = nil
        _productConfigDic = nil
    }
    
    func receiveProductFromSocketControl(productPosFile : String)
    {
//        LogModel.getInstance.insertLog("Receive product from socket: [\(productPosFile)].")
        let _productDic = self.getProductConfigByProductDataName(productPosFile)
        if _productDic != nil
        {
            self.setNewestProductAddress(_productDic?.objectForKey("ename") as! String, productAddress: _productDic?.objectForKey("pos_file") as! String)
            self._receivedProductArr.insertObject(_productDic!, atIndex: 0)
            if self._receivedProductArr.count > MAXRECEIVEPRODUCTCOUNT
            {
                self._receivedProductArr.removeLastObject()
            }
            NSNotificationCenter.defaultCenter().postNotificationName("\(RECEIVE)\(SOCKET)\(PRODUCT)", object: _productDic)
        }
    }
    
    func getReceivedProductDicArr() -> NSMutableArray
    {
        return _receivedProductArr
    }

    func setNewestProductAddress(productEname : String, productAddress : String)
    {
        var _productDic : NSMutableDictionary?
        for i in 0 ..< _newestProductArr.count
        {
            _productDic = (_newestProductArr.objectAtIndex(i) as? NSMutableDictionary)!
            if _productDic?.objectForKey("ename") as! String == productEname
            {
                _productDic?.setObject(productAddress, forKey: "name")
            }
        }
        _productDic = nil
    }
    
    // Get newest product data from product type list.
    internal func getNewestProductList() -> NSMutableArray
    {
        return _newestProductArr
    }
    
    internal func getElevationData(startTime : NSTimeInterval, endTime _endTime: NSTimeInterval,
        productType _productType : Int32)
    {
        let _productVo : ProductVo = ProductVo()
        _productVo.type = _productType
//        let urlStr : NSString = "\(URL_Server)/ios/product/selectElevationByTypeInPeriod?startTime=\(Int64(1451577600))&endTime=\(Int64(1451584800))&productVo=\(_productVo.getJsonStr())"
        let urlStr : NSString = "\(URL_Server)/ios/product/selectElevationByTypeInPeriod?startTime=\(Int64(startTime))&endTime=\(Int64(_endTime))&productVo=\(_productVo.getJsonStr())"
        LogModel.getInstance.insertLog("\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            NSNotificationCenter.defaultCenter().postNotificationName("\(ELEVATIONLIST)\(SELECT)\(SUCCESS)", object: NSMutableDictionary(dictionary: resultDic))
        })
        task.resume()
    }
    
    internal func getHistoryData(startTime : NSTimeInterval, endTime _endTime: NSTimeInterval,
        productType _productType : Int32, currentPage _currentPage : Int32, mcode _mcode : String?)
    {
        let _pageVo : PageVo = PageVo()
        _pageVo.currentPage = _currentPage
        let _productVo : ProductVo = ProductVo()
        _productVo.type = _productType
        if _mcode != nil
        {
            _productVo.mcode = _mcode!
        }
//        let urlStr : NSString = "\(URL_Server)/ios/product/selectProductByTypeInPeriod?startTime=\(Int64(1451577600))&endTime=\(Int64(1451584800))&pageVo=\(_pageVo.getJsonStr())&productVo=\(_productVo.getJsonStr())"
        let urlStr : NSString = "\(URL_Server)/ios/product/selectProductByTypeInPeriod?startTime=\(Int64(startTime))&endTime=\(Int64(_endTime))&pageVo=\(_pageVo.getJsonStr())&productVo=\(_productVo.getJsonStr())"
        LogModel.getInstance.insertLog("\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            
            NSNotificationCenter.defaultCenter().postNotificationName("\(HISTORYPRODUCT)\(SELECT)\(SUCCESS)", object: NSMutableDictionary(dictionary: resultDic))
        })
        task.resume()
    }
    
    internal func getNewestDataByType(_productType : Int32)
    {
        let urlStr : NSString = "\(URL_Server)/ios/product/selectLastDataByPage?type=\(_productType)"
        LogModel.getInstance.insertLog("\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            let resultStr : String = resultDic.valueForKey("result") as! String
            if resultStr == SUCCESS
            {
                let productArr = (resultDic.valueForKey("list") as? NSMutableArray)
                // Tell user the result.
                if productArr != nil && productArr?.count > 0
                {
                    let productDic = productArr?.objectAtIndex(0) as! NSDictionary
                    LogModel.getInstance.insertLog("Receive product from HTTP : [\(productDic)].")
                    let _selectedProductDic = self.getProductConfigByProductDataName(productDic.objectForKey("pos_file") as! String)
                    if _selectedProductDic != nil
                    {
                        _selectedProductDic!.setObject(productDic.objectForKey("file_size")!, forKey: "file_size")
                        _selectedProductDic!.setObject(productDic.objectForKey("id")!, forKey: "id")
                        _selectedProductDic!.setObject(productDic.objectForKey("layer")!, forKey: "layer")
                        _selectedProductDic!.setObject(productDic.objectForKey("mcode")!, forKey: "mcode")
                        _selectedProductDic!.setObject(productDic.objectForKey("name")!, forKey: "name")
                        _selectedProductDic!.setObject(productDic.objectForKey("pos_file")!, forKey: "pos_file")
                        _selectedProductDic!.setObject(productDic.objectForKey("scan_mode")!, forKey: "scan_mode")
                        _selectedProductDic!.setObject(productDic.objectForKey("time")!, forKey: "time")
                        _selectedProductDic!.setObject(productDic.objectForKey("type")!, forKey: "type")
                        self.setNewestProductAddress(_selectedProductDic?.objectForKey("ename") as! String, productAddress: productDic.objectForKey("pos_file") as! String)
                        NSNotificationCenter.defaultCenter().postNotificationName("\(NEWESTDATA)\(HTTP)\(SELECT)\(SUCCESS)",
                            object: NSMutableDictionary(dictionary: _selectedProductDic!))
                    }
                }
            }
        })
        task.resume()
    }
    
    internal func getDataByLayer(timeStr : String,
        productType _productType : Int32, layer _layer : Int32)
    {
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let time = dateFormatter.dateFromString(timeStr)!.timeIntervalSince1970
        let urlStr : NSString = "\(URL_Server)/ios/product/selectSameVolProduct?time=\(Int64(time))&type=\(_productType)&layer=\(_layer)"
        LogModel.getInstance.insertLog("\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            NSNotificationCenter.defaultCenter().postNotificationName("\(PRODUCT)\(HTTP)\(SELECT)\(SUCCESS)",
                object: NSMutableDictionary(dictionary: resultDic))
        })
        task.resume()
    }
    
    internal func getNextDataByTime(timeStr : String,
        productType _productType : Int32, mcodeString _mcodeStr : String?)
    {
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let time = dateFormatter.dateFromString(timeStr)!.timeIntervalSince1970 + 1
        let urlStr : NSString = "\(URL_Server)/ios/product/selectSameMcodeProduct?time=\(Int64(time))&type=\(_productType)&count=\(-1)&mcode=\((_mcodeStr! as NSString))"
        LogModel.getInstance.insertLog("\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("\(PRODUCT)\(HTTP)\(SELECT)\(SUCCESS)",
                object: NSMutableDictionary(dictionary: resultDic))
        })
        task.resume()
    }
    
    internal func getLastDataByTime(timeStr : String,
        productType _productType : Int32, mcodeString _mcodeStr : String?)
    {
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let time = dateFormatter.dateFromString(timeStr)!.timeIntervalSince1970 - 1
        let urlStr : NSString = "\(URL_Server)/ios/product/selectSameMcodeProduct?time=\(Int64(time))&type=\(_productType)&count=\(1)&mcode=\((_mcodeStr! as NSString))"
        LogModel.getInstance.insertLog("\(timeStr)=\(time)>>>\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("\(PRODUCT)\(HTTP)\(SELECT)\(SUCCESS)",
                object: NSMutableDictionary(dictionary: resultDic))
        })
        task.resume()
    }
    
    internal func getLastDataForCartoon(timeStr : String,
        productType _productType : Int32, mcodeString _mcodeStr : String?)
    {
        var time = Int64(1)
        if timeStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            time = Int64(NSDate().timeIntervalSince1970) + Int64(1)
        }else{
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            time = Int64(dateFormatter.dateFromString(timeStr)!.timeIntervalSince1970) + Int64(1)
        }
        let urlStr : NSString = "\(URL_Server)/ios/product/selectSameMcodeProduct?time=\(Int64(time))&type=\(_productType)&count=\(8)&mcode=\((_mcodeStr! as NSString))"
        LogModel.getInstance.insertLog("\(timeStr)=\(time)>>>\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("\(CARTOON)\(HTTP)\(SELECT)\(SUCCESS)",
                object: NSMutableDictionary(dictionary: resultDic))
        })
        task.resume()
    }
    
    
    // Util tools.
    internal func getProductConfigByProductDataName(productNameStr : String) -> NSMutableDictionary?
    {
        if _productConfigArr.count == 0
        {
            return nil
        }
        var productNameArr : [String] = productNameStr.stringByReplacingOccurrencesOfString("\0", withString: "").componentsSeparatedByString("\\")
        if productNameArr.count == 1
        {
            productNameArr.insert((productNameArr[productNameArr.count - 1] as NSString).substringWithRange(NSRange(location: 0, length: 8)), atIndex: 0)
            productNameArr.insert((productNameArr[productNameArr.count - 1] as NSString).substringWithRange(NSRange(location: 19, length: 3)), atIndex: 1)
        }
        if productNameArr.count >= 3
        {
            while productNameArr.count > 3
            {
                productNameArr.removeFirst()
            }
            var _productDic : NSMutableDictionary?
            var _productConfigDic : NSMutableDictionary
            for i in 0 ..< _productConfigArr.count
            {
                _productConfigDic = (_productConfigArr.objectAtIndex(i) as? NSMutableDictionary)!
                if _productConfigDic.valueForKey("ename") as! String == productNameArr[productNameArr.count - 2]
                {
                    _productDic = NSMutableDictionary()
                    _productDic!.setValue(_productConfigDic.objectForKey("type"), forKey: "type")
                    _productDic!.setValue(_productConfigDic.objectForKey("cname") as! String, forKey: "cname")
                    _productDic!.setValue(_productConfigDic.objectForKey("ename") as! String, forKey: "ename")
                    _productDic!.setValue(_productConfigDic.objectForKey("colorFile"), forKey: "colorFile")
                    _productDic!.setValue(productNameArr.joinWithSeparator("\\"), forKey: "pos_file")
                    _productDic!.setValue(productNameArr[productNameArr.count - 1], forKey: "name")
                    _productDic!.setValue((productNameArr[productNameArr.count - 1] as NSString).substringWithRange(NSRange(location: 23, length: 3)), forKey: "scan_mode")
                    _productDic!.setValue((_productConfigDic.objectForKey("type") as! NSNumber).stringValue + "-"
                        + productNameArr[productNameArr.count - 1].componentsSeparatedByString("_")[2], forKey: "mcode")
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
