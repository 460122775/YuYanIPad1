//
//  File.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class SwitchToolView: UIView
{
    @IBOutlet var switchControlBtn: UIButton!
    @IBOutlet var upBtn: UIButton!
    @IBOutlet var upDownImg: UIImageView!
    @IBOutlet var downBtn: UIButton!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var leftRightImg: UIImageView!
    @IBOutlet var rightBtn: UIButton!
    @IBOutlet var buttonContainerV: UIView!
    @IBOutlet var buttonContainerH: UIView!
    
    var _currentProductDic : NSMutableDictionary?
    var productDicArr : NSMutableArray?
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
    }
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect)
    {
        self.buttonContainerV.layer.masksToBounds = true
        self.buttonContainerH.layer.masksToBounds = true
    }
    
    func setCurrentProductDic(currentProductDic : NSMutableDictionary)
    {
        if currentProductDic.valueForKey("level") == nil
        {
            // Set Level for each Product.
            if productDicArr == nil
            {
                productDicArr = ProductUtilModel.getInstance.getProductConfigArr()
            }
            for productConfig in productDicArr!
            {
                if  ((productConfig as! NSDictionary).valueForKey("type") as! NSNumber).longLongValue == (currentProductDic.valueForKey("type") as! NSNumber).longLongValue
                {
                    currentProductDic.setValue((productConfig as! NSDictionary).valueForKey("level"), forKey: "level")
                    break
                }
            }
        }
        let level : Int64 = (currentProductDic.valueForKey("level") as! NSNumber).longLongValue
        let scanMode : Int64 = (currentProductDic.valueForKey("scan_mode") as! NSNumber).longLongValue
        // Is VOL.
        if level == LEVEL_FIRSTCLASS && scanMode >= 0 && scanMode <= 9
        {
            self.setBtnVisible(false, hideVolBtn: false)
            currentProductDic.setValue((currentProductDic.valueForKey("name") as! NSString).substringWithRange(NSRange(location: 16, length: 2)), forKey: "layer")
        }else{
            self.setBtnVisible(true, hideVolBtn: false)
        }
        _currentProductDic = currentProductDic
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        if switchControlBtn.selected == true
        {
            if point.x > 140
            {
                if point.y > 140 || buttonContainerV.hidden == false
                {
                    return true
                }else{
                    return false
                }
            }else{
                if point.y > 140 && buttonContainerH.hidden == false
                {
                    return true
                }else{
                    return false
                }
            }
        }else{
            if point.x > 140 && point.y > 140
            {
                return true
            }else{
                return false
            }
        }
    }
    
    func setBtnVisible(hideLayerBtn : Bool, hideVolBtn : Bool)
    {
        buttonContainerV.hidden = hideLayerBtn
        buttonContainerH.hidden = hideVolBtn
    }
    
    @IBAction func swtichControlBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
        if sender.selected == true
        {
            self.buttonContainerV.frame = CGRectMake(140, 140, 48, 0)
            self.buttonContainerH.frame = CGRectMake(140, 140, 0, 48)
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.buttonContainerV.frame = CGRectMake(140, 0, 48, 140)
                self.buttonContainerH.frame = CGRectMake(0, 140, 140, 48)
            })
        }else{
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.buttonContainerV.frame = CGRectMake(140, 140, 48, 0)
                self.buttonContainerH.frame = CGRectMake(140, 140, 0, 48)
            })
        }
    }
    
    @IBAction func upBtnClick(sender: UIButton)
    {
        if _currentProductDic == nil
        {
            return
        }
        
    }
    
    @IBAction func downBtnClick(sender: UIButton)
    {
        if _currentProductDic == nil
        {
            return
        }
    }
    
    @IBAction func leftBtnClick(sender: UIButton)
    {
        if _currentProductDic == nil
        {
            return
        }
    }
    
    @IBAction func rightBtnClick(sender: UIButton)
    {
        if _currentProductDic == nil
        {
            return
        }
    }
}