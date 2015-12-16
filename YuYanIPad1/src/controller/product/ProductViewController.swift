//
//  ProductViewController.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/18/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ProductViewController : UIViewController
{
    @IBOutlet var topTitleBarView: UIView!
    @IBOutlet var titleBarBgImg: UIImageView!
    @IBOutlet var productContainerView: UIView!
    @IBOutlet var leftControlBtn: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var productViewA : ProductViewA?
    var switchToolView : SwitchToolView?
    var cartoonBarView : CartoonBarView?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.topTitleBarView.layer.masksToBounds = true
        // Init product view.
        self.productViewA = (NSBundle.mainBundle().loadNibNamed("ProductViewA", owner: self, options: nil) as NSArray).lastObject as? ProductViewA
        self.productViewA!.frame.origin = CGPointMake(0, 0)
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
    }

    @IBAction func lineBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
    }
    
    @IBAction func camaraBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
    }
    
    func receiveProduct(notificaiton : NSNotification)
    {
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    