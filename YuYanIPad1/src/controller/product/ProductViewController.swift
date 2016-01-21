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

class ProductViewController : UIViewController, ProductLeftViewProtocol
{
    @IBOutlet var topTitleBarView: UIView!
    @IBOutlet var titleBarBgImg: UIImageView!
    @IBOutlet var productContainerView: UIView!
    @IBOutlet var leftControlBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var productViewA : ProductViewA?
    var switchToolView : SwitchToolView?
    var cartoonBarView : CartoonBarView?
    
    var currentProductDic : NSMutableDictionary?
    var currentProductData : NSData?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topTitleBarView.layer.masksToBounds = true
        // Init product view.
        self.productViewA = (NSBundle.mainBundle().loadNibNamed("ProductViewA", owner: self, options: nil) as NSArray).lastObject as? ProductViewA
        self.productViewA!.frame.origin = CGPointMake(0, 0)
        self.productViewA?.userInteractionEnabled = true
        self.productContainerView.subviews.map { $0.removeFromSuperview() }
        self.productContainerView.addSubview(self.productViewA!)
        // Init tools of the switch at right bottom corner.
        self.switchToolView = (NSBundle.mainBundle().loadNibNamed("SwitchToolView", owner: self, options: nil) as NSArray).lastObject as? SwitchToolView
        self.switchToolView!.frame.origin = CGPointMake(738, 422)
        self.productContainerView.addSubview(self.switchToolView!)
        // Init tools of the cartoon bar at right bottom corner.
        self.cartoonBarView = (NSBundle.mainBundle().loadNibNamed("CartoonBarView", owner: self, options: nil) as NSArray).lastObject as? CartoonBarView
        self.cartoonBarView!.frame.origin = CGPointMake(332, 630)
        self.productContainerView.addSubview(self.cartoonBarView!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveProduct:", name: "\(RECEIVE)\(PRODUCT)", object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
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
                self.topTitleBarView.frame.size = CGSizeMake(522, 48)
                self.productLeftView!.frame.origin = CGPointMake(0, 0)
            }, completion: { (Bool) -> Void in
                self.titleBarBgImg.frame.size = CGSizeMake(464, 48)
            })
            // Set product left view by data.
//            self.productLeftView.setProductLeftViewByData()
        }else{
            self.titleBarBgImg.frame.size = CGSizeMake(704, 48)
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.topTitleBarView.frame = CGRectMake(0, 0, 762, 48)
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
        UIGraphicsBeginImageContext((self.productViewA?.mapView.bounds.size)!)
        self.productViewA?.mapView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let imageTemp : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(imageTemp, nil, "screenShotsComplete", nil)
    }
    
    func screenShotsComplete()
    {
        SwiftNotice.showNoticeWithText(NoticeType.success, text: "产品截图保存成功！", autoClear: true, autoClearTime: 3)
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
    
    // HistoryQueryLeftView Protocol.
    func selectedProductControl(selectedProductDic: NSMutableDictionary)
    {
        currentProductDic = selectedProductDic
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
                    SwiftNotice.showNoticeWithText(NoticeType.error, text: "数据文件下载失败，请检查网络后重试！", autoClear: true, autoClearTime: 3)
                    return
                }
                // Cache data.
                CacheManageModel.getInstance.addCacheForProductFile(selectedProductDic.objectForKey("name") as! String, data: response.result.value!)
                self.currentProductData = CacheManageModel.getInstance.getCacheForProductFile(selectedProductDic.objectForKey("name") as! String)
                if self.currentProductData == nil
                {
                    // Cache failed, maybe the reason of uncompress failed.
                    // Tell reason to user.
                    SwiftNotice.showNoticeWithText(NoticeType.error, text: "数据格式解压失败，或不支持此格式！", autoClear: true, autoClearTime: 3)
                    return
                }else{
                    // Draw product.
                    self.drawProduct(self.currentProductData!)
                }
            }
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
        self.switchToolView?.setCurrentProductDic(self.currentProductDic!)
    }
    
    func initProductInfoByData()
    {
        if currentProductData != nil
        {
            self.productLeftView?.setProductLeftViewByData(currentProductData!)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    