//
//  HistoryViewController.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HistoryViewController : UIViewController, HistoryChoiceProtocol, HistoryChoiceOfProductProtocol, HistoryQueryLeftViewProtocol, HSDatePickerViewControllerDelegate, SwitchToolDelegate, ProductViewADelegate, HistoryElevationChoiceProtocol
{
    @IBOutlet var topTitleBarView: UIView!
    @IBOutlet var titleBarBgImg: UIImageView!
    @IBOutlet var productContainerView: UIView!
    @IBOutlet var historyLeftViewContainer: UIView!
    @IBOutlet var leftControlBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var productViewA : ProductViewA?
    var switchToolView : SwitchToolView?
    var cartoonBarView : CartoonBarView?
    var historyChoiceView : HistoryChoiceView?
    var historyElevationChoiceView : HistoryElevationChoiceView?
    
    var productConfigDicArr : NSMutableArray?
    var currentProductDicArr : NSMutableArray?
    var currentProductDic : NSMutableDictionary?
    var currentProductConfigDic : NSMutableDictionary?
    var currentProductData : NSData?
    var startTimeStr : String?
    var endTimeStr : String?
    var requestLayer : Int32 = -1
    var switchFlag : Bool = true
    var switchTimer:NSTimer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topTitleBarView.layer.masksToBounds = true
        self.leftControlBtn.selected = true
        // Init product view.
        self.productViewA = (NSBundle.mainBundle().loadNibNamed("ProductViewA", owner: self, options: nil) as NSArray).lastObject as? ProductViewA
        self.productViewA?.productViewADelegate = self
        self.productViewA!.frame.origin = CGPointMake(0, 0)
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
        // Init main choice view.
        self.historyChoiceView = (NSBundle.mainBundle().loadNibNamed("HistoryChoiceView", owner: self, options: nil) as NSArray).lastObject as? HistoryChoiceView
        self.historyChoiceView!.frame.origin = CGPointMake(0, 0)
        self.historyLeftViewContainer.addSubview(self.historyChoiceView!)
        self.historyChoiceView?.delegate = self
        switchTimer = NSTimer.scheduledTimerWithTimeInterval(3,
            target:self, selector:Selector("onSwitchTimer"),
            userInfo:nil, repeats:false)
        // Init user location.
        self.productViewA!.setUserLocationVisible(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if ProductUtilModel.getInstance.isGetProductConfigArr() == false
        {
            ProductUtilModel.getInstance.selectProductConfig()
        }
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
    
    @IBAction func leftControlBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
        if sender.selected == true
        {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.topTitleBarView.frame.origin = CGPointMake(240, 0)
                self.topTitleBarView.frame.size = CGSizeMake(522, 48)
                self.historyLeftViewContainer.frame.origin = CGPointMake(0, 0)
                }, completion: { (Bool) -> Void in
                    self.titleBarBgImg.frame.size = CGSizeMake(464, 48)
            })
        }else{
            self.titleBarBgImg.frame.size = CGSizeMake(704, 48)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.topTitleBarView.frame = CGRectMake(0, 0, 762, 48)
                self.historyLeftViewContainer.frame.origin = CGPointMake(-240, 0)
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
        UIGraphicsBeginImageContext((self.view?.bounds.size)!)
        self.view?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let imageTemp : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(imageTemp, nil, "screenShotsComplete", nil)
    }
    
    func screenShotsComplete()
    {
        SwiftNotice.showText("产品截图已经保存到您的相册！")
    }
    
    // History Choice Protocol.
    var historyQueryLeftView : HistoryQueryLeftView?
    func historyQueryControl(_selectProductConfigDir : NSMutableDictionary, startTimeStr _startTimeStr : String, endTimeStr _endTimeStr : String)
    {
        self.currentProductConfigDic = _selectProductConfigDir
        self.startTimeStr = _startTimeStr
        self.endTimeStr = _endTimeStr
        self.historyChoiceView?.removeFromSuperview()
        if self.historyQueryLeftView == nil
        {
            self.historyQueryLeftView = (NSBundle.mainBundle().loadNibNamed("HistoryQueryLeftView", owner: self, options: nil) as NSArray).lastObject as? HistoryQueryLeftView
            self.historyQueryLeftView?.historyQueryLeftViewProtocol = self
        }
        self.historyLeftViewContainer.addSubview(self.historyQueryLeftView!)
        self.historyQueryLeftView?.showQueryResult(_selectProductConfigDir, startTimeStr: _startTimeStr, endTimeStr: _startTimeStr)
    }
    
    var datePickerController : HSDatePickerViewController?
    func timeBtnClick()
    {
        if datePickerController == nil
        {
            datePickerController = HSDatePickerViewController()
            datePickerController?.delegate = self
        }
        self.presentViewController(datePickerController!, animated: true, completion: nil)
    }
    
    // History Choice of Product Protocol.
    func getSelectedProduct(productConfigVo : NSMutableDictionary)
    {
        self.historyLeftViewContainer?.subviews.map { $0.removeFromSuperview() }
        self.historyLeftViewContainer.addSubview(self.historyChoiceView!)
        self.historyChoiceView?.setProductBtnByVo(productConfigVo)
    }
    
    func analyseProduct()
    {
        if currentProductDic!.objectForKey("level") == nil
        {
            // Set Level for each Product.
            if productConfigDicArr == nil
            {
                productConfigDicArr = ProductUtilModel.getInstance.getProductConfigArr()
            }
            for productConfig in productConfigDicArr!
            {
                if  ((productConfig as! NSDictionary).objectForKey("type") as! NSNumber).longLongValue == (currentProductDic!.objectForKey("type") as! NSNumber).longLongValue
                {
                    currentProductDic!.setValue((productConfig as! NSDictionary).objectForKey("level"), forKey: "level")
                    break
                }
            }
        }
        let level : Int64 = (currentProductDic!.objectForKey("level") as! NSNumber).longLongValue
        let scanMode : Int64 = Int64((currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 23, length: 3)))!
        // Is VOL && Set SwitchToolView.
        if level == LEVEL_FIRSTCLASS && scanMode >= 0 && scanMode <= 9
        {
            self.switchToolView!.setBtnVisible(false, hideVolBtn: false)
            
            currentProductDic!.setValue((currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 16, length: 2)), forKey: "layer")
        }else{
            self.switchToolView!.setBtnVisible(true, hideVolBtn: false)
        }
    }
    
    func drawProduct(data : NSData)
    {
        // Init left view by data.
        self.historyQueryLeftView?.setProductLeftViewByData(data)
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
        if self.currentProductDic?.objectForKey("colorFile") == nil
        {
            self.currentProductDic?.setValue(self.historyChoiceView?._selectProductConfigDir?.objectForKey("colorFile"), forKey: "colorFile")
        }
        self.productViewA?.drawProductImg(self.currentProductDic, data: data)
    }
    
    // HistoryQueryLeftView Protocol.
    func initProductInfoByData()
    {
        if currentProductData != nil
        {
            self.historyQueryLeftView?.setProductLeftViewByData(currentProductData!)
        }
    }
    
    var historyChoiceOfProductView : HistoryChoiceOfProductView?
    func chooseProductControl()
    {
        self.historyChoiceView?.removeFromSuperview()
        if self.historyChoiceOfProductView == nil
        {
            self.historyChoiceOfProductView = (NSBundle.mainBundle().loadNibNamed("HistoryChoiceOfProductView", owner: self, options: nil) as NSArray).lastObject as? HistoryChoiceOfProductView
            self.historyChoiceOfProductView?.delegate = self
        }
        self.historyLeftViewContainer.addSubview(self.historyChoiceOfProductView!)
    }
    
    func returnBackToChoice()
    {
        self.historyLeftViewContainer?.subviews.map { $0.removeFromSuperview() }
        self.historyLeftViewContainer.addSubview(self.historyChoiceView!)
    }
    
    func selectedProductControl(selectedProductDic: NSMutableDictionary)
    {
        self.switchFlag = true
        currentProductDic = selectedProductDic
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

    var elevationView : HistoryElevationChoiceView?
    func showElevationChoiceView()
    {
        self.historyQueryLeftView?.removeFromSuperview()
        if self.elevationView == nil
        {
            self.elevationView = (NSBundle.mainBundle().loadNibNamed("HistoryElevationChoiceView", owner: self, options: nil) as NSArray).lastObject as? HistoryElevationChoiceView
            self.elevationView?.delegate = self
        }
        self.historyLeftViewContainer.addSubview(self.elevationView!)
        if self.currentProductDic == nil
        {
            self.elevationView?.setCurrentElevationValueByMcode(nil)
        }else{
            self.elevationView?.setCurrentElevationValueByMcode(self.currentProductDic!.objectForKey("mcode") as? String)
        }
        ProductUtilModel.getInstance.getElevationData(
            (self.historyChoiceView?.startTime?.timeIntervalSince1970)!,
            endTime: (self.historyChoiceView?.endTime?.timeIntervalSince1970)!,
            productType: Int32((currentProductConfigDic!.objectForKey("type") as! NSNumber).intValue)
        )
    }
    
    // HistoryElevationChoice View Protocol.
    func elevationChooseControl(elevationValue : Float32)
    {
        self.historyQueryLeftView?.setElevationValue(elevationValue)
        ProductUtilModel.getInstance.getHistoryData(
            (self.historyChoiceView?.startTime?.timeIntervalSince1970)!,
            endTime: (self.historyChoiceView?.endTime?.timeIntervalSince1970)!,
            productType: Int32((currentProductConfigDic!.objectForKey("type") as! NSNumber).intValue),
            currentPage: 1,
            mcode: (elevationValue < 0) ? nil : (String(format: "%i", (currentProductConfigDic!.objectForKey("type") as! NSNumber).intValue) + "-" + String(format: "%.2f", elevationValue))
        )
        self.returnBackToResult()
    }
    
    func returnBackToResult()
    {
        self.elevationView?.removeFromSuperview()
        self.historyLeftViewContainer.addSubview(self.historyQueryLeftView!)
    }
    
    // ProductViewA Delegate.
    func swipeUpControl()
    {
        self.switchUpControl()
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
        self.switchRightControl()
    }
    
    // HSDatePickerViewControllerDelegate
    func hsDatePickerPickedDate(date: NSDate!)
    {
        print("\(date)")
        self.historyChoiceView!.setDateTime(date)
    }
    
    func hsDatePickerDidDismissWithQuitMethod(method: HSDatePickerQuitMethod)
    {
        
    }
    
    func hsDatePickerWillDismissWithQuitMethod(method: HSDatePickerQuitMethod)
    {
        
    }
    
    // SwitchTool Delegate.
    func onSwitchTimer()
    {
        self.switchFlag = true
        self.switchTimer.invalidate()
    }
    
    func switchUpControl()
    {
        if !switchFlag || currentProductDic == nil
        {
            return
        }
        // Get layer & Get Data.
        var layer = (currentProductDic!.objectForKey("layer") as! NSString).intValue
        if layer >= 0
        {
            self.switchFlag = false
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
            self.switchTimer.fire()
        }
    }
    
    func switchDownControl()
    {
        if !switchFlag || currentProductDic == nil
        {
            return
        }
        // Get layer & Get Data.
        let layer = (currentProductDic!.objectForKey("layer") as! NSString).intValue
        if layer <= 0
        {
            SwiftNotice.showText("当前已经是第低层了!")
        }else{
            self.switchFlag = false
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
            self.switchTimer.fire()
        }
    }
    
    func switchLeftControl()
    {
        if !switchFlag || currentProductDic == nil
        {
            return
        }
        switchFlag = false
        if currentProductDicArr != nil && currentProductDicArr?.count > 0
        {
            currentProductDicArr = nil
        }
        ProductUtilModel.getInstance.getLastDataByTime(
            (currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 0, length: 15)),
            productType: (currentProductDic!.objectForKey("type") as! NSNumber).intValue,
            mcodeString: (currentProductDic!.objectForKey("mcode") as! NSString!) as String
        )
        self.switchTimer.fire()
    }
    
    func switchRightControl()
    {
        if !switchFlag || currentProductDic == nil
        {
            return
        }
        switchFlag = false
        if currentProductDicArr != nil && currentProductDicArr?.count > 0
        {
            currentProductDicArr = nil
        }
        ProductUtilModel.getInstance.getNextDataByTime(
            (currentProductDic!.objectForKey("name") as! NSString).substringWithRange(NSRange(location: 0, length: 15)),
            productType: (currentProductDic!.objectForKey("type") as! NSNumber).intValue,
            mcodeString: (currentProductDic!.objectForKey("mcode") as! NSString!) as String
        )
        self.switchTimer.fire()
    }
    
    func receiveDataFromHttp(notification : NSNotification?) -> Void
    {
        let resultStr : String = notification!.object?.valueForKey("result") as! String
        self.switchFlag = true
        self.switchTimer.invalidate()
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    