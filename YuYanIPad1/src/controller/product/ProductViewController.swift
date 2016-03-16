//
//  ProductViewController.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/18/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProductViewController : UIViewController, ProductLeftViewProtocol, SwitchToolDelegate, ProductViewADelegate, UIImagePickerControllerDelegate
{
    @IBOutlet var topTitleBarView: UIView!
    @IBOutlet var titleBarBgImg: UIImageView!
    @IBOutlet var productContainerView: UIView!
    @IBOutlet var leftControlBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var productViewA : ProductViewA?
    var switchToolView : SwitchToolView?
    var cartoonBarView : CartoonBarView?
    
    var productDicArr : NSMutableArray?
    var currentProductDicArr : NSMutableArray?
    var currentProductDic : NSMutableDictionary?
    var currentProductData : NSData?
    var requestLayer : Int32 = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topTitleBarView.layer.masksToBounds = true
        // Init product view.
        self.productViewA = (NSBundle.mainBundle().loadNibNamed("ProductViewA", owner: self, options: nil) as NSArray).lastObject as? ProductViewA
        self.productViewA!.frame.origin = CGPointMake(0, 0)
        self.productViewA?.userInteractionEnabled = true
        self.productViewA?.productViewADelegate = self
        self.productContainerView.subviews.map { $0.removeFromSuperview() }
        self.productContainerView.addSubview(self.productViewA!)
        // Init tools of the switch at right bottom corner.
        self.switchToolView = (NSBundle.mainBundle().loadNibNamed("SwitchToolView", owner: self, options: nil) as NSArray).lastObject as? SwitchToolView
        self.switchToolView?.switchToolDelegate = self
        self.switchToolView!.frame.origin = CGPointMake(738, 422)
        self.productContainerView.addSubview(self.switchToolView!)
        // Init tools of the cartoon bar at right bottom corner.
        self.cartoonBarView = (NSBundle.mainBundle().loadNibNamed("CartoonBarView", owner: self, options: nil) as NSArray).lastObject as? CartoonBarView
        self.cartoonBarView!.frame.origin = CGPointMake(332, 630)
        self.productContainerView.addSubview(self.cartoonBarView!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveProduct:", name: "\(RECEIVE)\(PRODUCT)", object: nil)
        // Init user location.
        self.productViewA!.setUserLocationVisible(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // Add Observer.
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "receiveDataFromHttp:",
            name: "\(PRODUCT)\(HTTP)\(SELECT)\(SUCCESS)",
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        // Remove Observer.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "\(PRODUCT)\(HTTP)\(SELECT)\(SUCCESS)", object: nil)
    }
    
    var productLeftView : ProductLeftView?
    @IBAction func leftControlBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
        if sender.selected == true
        {
            if self.productLeftView == nil
            {
                self.productLeftView = (NSBundle.mainBundle().loadNibNamed("ProductLeftView", owner: self, options: nil) as NSArray).lastObject as? ProductLeftView
                self.productLeftView?.frame.origin = CGPointMake(-240, 0)
                self.productLeftView?.productLeftViewDelegate = self
                self.view.addSubview(self.productLeftView!)
            }
            self.productLeftView!.segmentControlChanged(self.productLeftView!.segmentControl)
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.topTitleBarView.frame.origin = CGPointMake(240, 0)
                self.topTitleBarView.frame.size = CGSizeMake(580, 48)
                self.productLeftView!.frame.origin = CGPointMake(0, 0)
            }, completion: { (Bool) -> Void in
                self.titleBarBgImg.frame.size = CGSizeMake(522, 48)
            })
            // Set product left view by data.
//            self.productLeftView.setProductLeftViewByData()
        }else{
            self.titleBarBgImg.frame.size = CGSizeMake(762, 48)
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.topTitleBarView.frame = CGRectMake(0, 0, 820, 48)
                self.productLeftView!.frame.origin = CGPointMake(-240, 0)
            })
        }
    }
    
    @IBAction func positionBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
        self.productViewA!.setUserLocationVisible(sender.selected);
    }

    @IBAction func lineBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
    }
    
    @IBAction func camaraBtnClick(sender: UIButton)
    {
        // Save product screen shot into photo album.
        UIGraphicsBeginImageContextWithOptions((self.view.bounds.size), true, 0)
        self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(snapshot, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject)
    {
        if didFinishSavingWithError != nil
        {
            SwiftNotice.showText("产品截图保存失败！")
            return
        }
        SwiftNotice.showText("产品截图已成功保存到您的相册！")
    }
    
    func receiveProduct(notificaiton : NSNotification)
    {
        if self.productLeftView == nil
        {
            return
        }
        var _nameArrTemp : [String]? = (String.init(data: notificaiton.object as! NSData, encoding: NSUTF8StringEncoding)?.componentsSeparatedByString("\\"))!
        if  _nameArrTemp != nil && _nameArrTemp!.count >= 3
        {
            _nameArrTemp![(_nameArrTemp?.count)! - 1] = _nameArrTemp![(_nameArrTemp?.count)! - 1].stringByReplacingOccurrencesOfString("\0", withString: "")
            let productFilePosStr : String = "\(_nameArrTemp![(_nameArrTemp?.count)! - 3])\\\(_nameArrTemp![(_nameArrTemp?.count)! - 2])\\\(_nameArrTemp![(_nameArrTemp?.count)! - 1])"
            SwiftNotice.showText("收到产品［\(productFilePosStr)］")
            self.productLeftView!.setProductAddress(_nameArrTemp![(_nameArrTemp?.count)! - 2], productAddress : productFilePosStr)
            LogModel.getInstance.insertLog("Receive product[\(productFilePosStr)].")
        }
    }
    
    // ProductLeftViewProtocol Protocol.
    func selectedProductControl(selectedProductDic: NSMutableDictionary)
    {
        currentProductDic = selectedProductDic
        if (selectedProductDic.objectForKey("name") as! String).containsString("\\")
        {
            let arr : Array = (selectedProductDic.objectForKey("name") as! String).componentsSeparatedByString("\\")
            selectedProductDic.setObject(arr.last!, forKey: "name")
        }
        self.analyseProduct()
        currentProductData = CacheManageModel.getInstance.getCacheForProductFile(selectedProductDic.objectForKey("name") as! String)
        if currentProductData != nil
        {
            LogModel.getInstance.insertLog("HistoryViewController get product [\(selectedProductDic.objectForKey("name") as! String)] from cache.")
            // Draw product.
            self.drawProduct(self.currentProductData!)
        }else{
            LogModel.getInstance.insertLog("HistoryViewController download selected data:[\(URL_DATA)/\(selectedProductDic.objectForKey("pos_file") as! String)].")
            // Compose url.
            var url : String = "\(URL_DATA)/\(selectedProductDic.objectForKey("pos_file") as! String)"
            url = url.stringByReplacingOccurrencesOfString("\\\\", withString: "/", options: .LiteralSearch, range: nil)
            url = url.stringByReplacingOccurrencesOfString("\\", withString: "/", options: .LiteralSearch, range: nil)
            // Download data.
            Alamofire.request(.GET, url).responseData { response in
                LogModel.getInstance.insertLog("HistoryViewController downloaded selected data:[\(URL_DATA)/\(selectedProductDic.objectForKey("pos_file") as! String)].")
                if response.result.value == nil || response.result.value?.length <= 48
                {
                    // Tell reason to user.
                    SwiftNotice.showText("数据文件下载失败，请检查网络后重试！")
                    return
                }
                // Cache data.
                CacheManageModel.getInstance.addCacheForProductFile(selectedProductDic.objectForKey("name") as! String, data: response.result.value!)
                self.currentProductData = CacheManageModel.getInstance.getCacheForProductFile(selectedProductDic.objectForKey("name") as! String)
                if self.currentProductData == nil
                {
                    // Cache failed, maybe the reason of uncompress failed.
                    // Tell reason to user.
                    SwiftNotice.showText("数据格式解压失败，或不支持此格式！")
                    return
                }else{
                    // Draw product.
                    self.drawProduct(self.currentProductData!)
                }
            }
        }
    }
    
    func analyseProduct()
    {
        if currentProductDic!.valueForKey("level") == nil
        {
            // Set Level for each Product.
            if productDicArr == nil
            {
                productDicArr = ProductUtilModel.getInstance.getProductConfigArr()
            }
            for productConfig in productDicArr!
            {
                if  ((productConfig as! NSDictionary).valueForKey("type") as! NSNumber).longLongValue == (currentProductDic!.valueForKey("type") as! NSNumber).longLongValue
                {
                    currentProductDic!.setValue((productConfig as! NSDictionary).valueForKey("level"), forKey: "level")
                    break
                }
            }
        }
        let level : Int64 = (currentProductDic!.valueForKey("level") as! NSNumber).longLongValue
        let scanMode : Int64 = Int64((currentProductDic!.valueForKey("name") as! NSString).substringWithRange(NSRange(location: 23, length: 3)))!
        // Is VOL && Set SwitchToolView.
        if level == LEVEL_FIRSTCLASS && scanMode >= 0 && scanMode <= 9
        {
            self.switchToolView!.setBtnVisible(false, hideVolBtn: false)
            currentProductDic!.setValue((currentProductDic!.valueForKey("name") as! NSString).substringWithRange(NSRange(location: 16, length: 2)), forKey: "layer")
        }else{
            self.switchToolView!.setBtnVisible(true, hideVolBtn: false)
        }
    }
    
    func drawProduct(data : NSData)
    {
        // Init left view by data.
        self.productLeftView?.setProductLeftViewByData(data)
        // Init top bar by data.
        titleLabel.text = ProductInfoModel.getDataDateString(data) + "  "
            + ProductInfoModel.getDataTimeString(data) + "  "
        if currentProductDic == nil || currentProductDic!.objectForKey("type") == nil
        {
            return
        }
        let type : Int64 = Int64((currentProductDic!.objectForKey("type") as! NSNumber).integerValue)
        if type == ProductType_Z || type == ProductType_V || type == ProductType_W
        {
            titleLabel.text = titleLabel.text! + "[" + (currentProductDic!.objectForKey("mcode") as! String) + "°]"
        }
        // Draw Color.
        self.productViewA?.drawProductImg(self.currentProductDic, data: data)
    }
    
    func initProductInfoByData()
    {
        if currentProductData != nil
        {
            self.productLeftView?.setProductLeftViewByData(currentProductData!)
        }
    }
    
    // ProductViewA Delegate.
    func swipeUpControl()
    {
        self.swipeUpControl()
    }
    
    func swipeDownControl()
    {
        self.switchDownControl()
    }
    
    func swipeLeftControl()
    {
        self.switchLeftControl()
    }
    
    func swipeRightControl()
    {
        self.swipeRightControl()
    }
    
    // SwitchTool Delegate.
    func switchUpControl()
    {
        if currentProductDic == nil
        {
            return
        }
        // Get layer & Get Data.
        var layer = (currentProductDic!.objectForKey("layer") as! NSString).intValue
        if layer >= 0
        {
            // Search from local.
            if currentProductDicArr != nil && currentProductDicArr?.count > 1
            {
                for var i : Int = 0; i < currentProductDicArr?.count; i++
                {
                    if (currentProductDic!.objectForKey("name") as! NSString) ==
                        (currentProductDicArr?.objectAtIndex(i).objectForKey("name") as! NSString)
                    {
                        if i + 1 < currentProductDicArr?.count
                        {
                            currentProductDic = NSMutableDictionary(dictionary: currentProductDicArr?.objectAtIndex(i + 1) as! NSDictionary)
                            self.selectedProductControl(currentProductDic!)
                            return
                        }
                    }
                }
                currentProductDicArr = nil
            }
            requestLayer = ++layer
            ProductUtilModel.getInstance.getDataByLayer(
                (currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 0, length: 15)),
                productType: (currentProductDic!.objectForKey("type") as! NSNumber).intValue,
                layer: requestLayer
            )
        }
    }
    
    func switchDownControl()
    {
        if currentProductDic == nil
        {
            return
        }
        // Get layer & Get Data.
        let layer = (currentProductDic!.objectForKey("layer") as! NSString).intValue
        if layer <= 0
        {
            SwiftNotice.showText("当前已经是最低层了!")
        }else{
            // Search from local.
            if currentProductDicArr != nil && currentProductDicArr?.count > 1
            {
                for var i : Int = 0; i < currentProductDicArr?.count; i++
                {
                    if (currentProductDic!.objectForKey("name") as! NSString) ==
                        (currentProductDicArr?.objectAtIndex(i).objectForKey("name") as! NSString)
                    {
                        if i - 1 >= 0
                        {
                            currentProductDic = NSMutableDictionary(dictionary: currentProductDicArr?.objectAtIndex(i - 1) as! NSDictionary)
                            self.selectedProductControl(currentProductDic!)
                        }
                        return
                    }
                }
                currentProductDicArr = nil
            }
            requestLayer = layer - 1
            ProductUtilModel.getInstance.getDataByLayer(
                (currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 0, length: 15)),
                productType: (currentProductDic!.objectForKey("type") as! NSNumber).intValue,
                layer: requestLayer
            )
        }
    }
    
    func switchLeftControl()
    {
        if currentProductDic == nil
        {
            return
        }
        if currentProductDicArr != nil && currentProductDicArr?.count > 0
        {
            currentProductDicArr = nil
        }
        ProductUtilModel.getInstance.getLastDataByTime(
            (currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 0, length: 15)),
            productType: (currentProductDic!.objectForKey("type") as! NSNumber).intValue,
            mcodeString: currentProductDic!.objectForKey("mcode") as? String
        )
    }
    
    func switchRightControl()
    {
        if currentProductDic == nil
        {
            return
        }
        if currentProductDicArr != nil && currentProductDicArr?.count > 0
        {
            currentProductDicArr = nil
        }
        ProductUtilModel.getInstance.getNextDataByTime(
            (currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 0, length: 15)),
            productType: (currentProductDic!.objectForKey("type") as! NSNumber).intValue,
            mcodeString: currentProductDic!.objectForKey("mcode") as? String
        )
    }
    
    func receiveDataFromHttp(notification : NSNotification?) -> Void
    {
        let resultStr : String = notification!.object?.valueForKey("result") as! String
        if resultStr == FAIL
        {
            // Tell reason of FAIL.
            SwiftNotice.showText("服务端查询失败，请重试!")
            return
        }
        // Show result data.
        currentProductDicArr = (notification!.object?.valueForKey("list") as? NSMutableArray)
        // Tell user the result.
        if currentProductDicArr == nil || currentProductDicArr?.count == 0
        {
            SwiftNotice.showText(NODATA)
            return
        }
        // Press up || down Btn.
        if currentProductDicArr?.count > 1
        {
            for var i : Int = 0; i < currentProductDicArr?.count; i++
            {
                if (currentProductDic!.objectForKey("name") as! NSString) ==
                    (currentProductDicArr?.objectAtIndex(i).objectForKey("name") as! NSString)
                {
                    let layer = (currentProductDic!.objectForKey("layer") as! NSString).intValue
                    // Press up btn.
                    if requestLayer > layer && i + 1 < currentProductDicArr?.count
                    {
                        currentProductDic = NSMutableDictionary(dictionary: currentProductDicArr?.objectAtIndex(i + 1) as! NSDictionary)
                    // Press down btn.
                    }else if requestLayer < layer && i - 1 >= 0{
                        currentProductDic = NSMutableDictionary(dictionary: currentProductDicArr?.objectAtIndex(i - 1) as! NSDictionary)
                    // Not Found.
                    }else{
                        SwiftNotice.showText("当前已经是最高层了!")
                        return
                    }
                    self.selectedProductControl(currentProductDic!)
                    return
                }
            }
            SwiftNotice.showText(NODATA)
            return
        }
        let _selectedProductDic = NSMutableDictionary(dictionary: currentProductDicArr?.objectAtIndex(0) as! NSDictionary)
        self.selectedProductControl(_selectedProductDic)
    }
    
    // CartoonBar Delegate.
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    