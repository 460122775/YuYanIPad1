//
//  CartoonBarView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol CartoonBarDelegate
{
    // Press play btn.
    func prepareCartoonData()
    // Press progress btn.
    func drawProductAtNo()
}

class CartoonBarView: UIView
{
    @IBOutlet var multipleBackBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var sliderBgImg: UIImageView!
    @IBOutlet var sliderBtn: UIButton!
    @IBOutlet var preBtn: UIButton!
    @IBOutlet var multiplePreBtn: UIButton!
    @IBOutlet var controlBtn: UIButton!
    @IBOutlet var buttonContainerView: UIView!
    
    var cartoonBarDelegate : CartoonBarDelegate?
    var currentPage : Int32 = 1 // From 1..
    
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
        super.drawRect(rect)
        self.buttonContainerView.layer.masksToBounds = true
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool
    {
        if controlBtn.selected == true
        {
            if point.x > 0 && point.y > 0
            {
                return true
            }else{
                return false
            }
        }else{
            if point.x > 546 && point.y > 0
            {
                return true
            }else{
                return false
            }
        }
    }
    
    @IBAction func controlBtnClick(sender: UIButton)
    {
        sender.selected = !sender.selected
        if sender.selected == true
        {
            self.buttonContainerView.frame = CGRectMake(546, 0, 0, 48)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.buttonContainerView.frame = CGRectMake(0, 0, 546, 48)
            })
        }else{
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.buttonContainerView.frame = CGRectMake(546, 0, 0, 48)
            })
        }
    }
    
    @IBAction func sliderBtnClick(sender: UIButton)
    {
        if isDragging == false
        {
            sender.selected = !sender.selected
        }
    }
    
    var isDragging : Bool = false
    @IBAction func sliderBtnDrag(sender: UIButton, forEvent event: UIEvent)
    {
        isDragging = true
        let touches : NSSet = event.allTouches()!
        let touch : UITouch = (touches.anyObject() as! UITouch)
        sender.frame.origin.x += touch.locationInView(sender).x - touch.previousLocationInView(sender).x
        if sender.frame.origin.x < 110
        {
            sender.frame.origin.x = 110
        }else if sender.frame.origin.x > 400{
            sender.frame.origin.x = 400
        }
//            (event.allTouches().anyObject() as UITouch).locationInView(self) as CGPoint
//            event.allTouches().anyObject().locationInView(self).x
    }

    @IBAction func multipleBackBtnClick(sender: UIButton)
    {
        
    }
    
    @IBAction func backBtnClick(sender: UIButton)
    {
        
    }
    
    @IBAction func preBtnClick(sender: UIButton)
    {
        
    }
    
    @IBAction func multiplePreBtnClick(sender: UIButton)
    {
        
    }
}