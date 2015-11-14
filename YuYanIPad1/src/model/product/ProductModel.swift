//
//  ProductModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 9/10/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import UIKit

class ProductModel : NSObject {
    
    var _productConfigArr : NSMutableArray = []
    var _currentScanName : String = ""
    var _currentScanTime : String = ""
    var _productTypeList = []
    var _productArr : NSMutableArray = []

    class var getInstance : ProductModel
    {
        struct Static {
            static let instance : ProductModel = ProductModel()
        }
        return Static.instance
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
            ProductModel.getInstance.initProductByProductConfig()
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
        let urlStr : NSString = "\(URL_Server)/ios/selectProductByTypeInPeriod?startTime=\(Int64(1442815200))&endTime=\(Int64(1442822400))&pageVo=\(_pageVo.getJsonStr())&productVo=\(_productVo.getJsonStr())"
//        let urlStr : NSString = "\(URL_Server)/ios/selectProductByTypeInPeriod?startTime=\(Int64(startTime))&endTime=\(Int64(_endTime))&pageVo=\(_pageVo.getJsonStr())&productVo=\(_productVo.getJsonStr())"
        LogModel.getInstance.insertLog("\(urlStr)")
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if response == nil || data == nil
            {
                return
            }
            let resultDic : NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
//            LogModel.getInstance.insertLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
            NSNotificationCenter.defaultCenter().postNotificationName("\(HISTORYPRODUCT)\(SELECT)\(SUCCESS)", object: resultDic)
        })
        task.resume()
    }
}
