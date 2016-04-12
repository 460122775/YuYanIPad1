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
    func getLockFlag() -> Bool
    // Press progress btn.
    func drawProductAtNo(playIndex : Int)
}

class CartoonBarView: UIView
{
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var sliderBgImg: UIImageView!
    @IBOutlet var sliderBtn: UIButton!
    @IBOutlet var preBtn: UIButton!
    @IBOutlet var controlBtn: UIButton!
    @IBOutlet var buttonContainerView: UIView!
    
    var cartoonBarDelegate : CartoonBarDelegate?
    var currentIndex : Int = 1 // From 1..
    var cartoonTimer : NSTimer!
    var isPlaying : Bool = false
    var totalCount : Int = 0
    
    let MAX_SliderX : CGFloat = 352
    let MIN_SliderX : CGFloat = 62
    
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
            if point.x > 450 && point.y > 0
            {
                return true
            }else{
                return false
            }
        }
    }
    
    func playCartoon(_totalCount : Int, _currentIndex : Int = 1)
    {
        if _currentIndex > _totalCount
        {
            return
        }
        self.totalCount = _totalCount
        self.currentIndex = _currentIndex - 1
        self.sliderBtnClick(self.sliderBtn)
    }
    
    func stopCartoon()
    {
        if self.controlBtn.selected == true
        {
            self.controlBtnClick(self.controlBtn)
        }
    }
    
    func getIndexBySliderX() -> Int
    {
        return Int((self.sliderBtn.frame.origin.x - MIN_SliderX) / (MAX_SliderX - MIN_SliderX) * CGFloat(self.totalCount - 1)) + 1
    }
    
    func setSliderXByIndex(_index : Int)
    {
        self.sliderBtn.frame.origin.x = (MAX_SliderX - MIN_SliderX) / CGFloat(self.totalCount - 1) * CGFloat(_index - 1) + MIN_SliderX
    }
    
    @IBAction func controlBtnClick(sender: UIButton)
    {
        // Start playing...
        if sender.selected == false
        {
            self.currentIndex = 0
            self.totalCount = 0
            self.setSliderXByIndex(1)
            sender.selected = true
            self.buttonContainerView.frame = CGRectMake(450, 0, 0, 48)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.buttonContainerView.frame = CGRectMake(0, 0, 450, 48)
            })
            self.sliderBtn.selected = true
            self.cartoonBarDelegate?.prepareCartoonData()
        // Stop playing...
        }else{
            sender.selected = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.buttonContainerView.frame = CGRectMake(450, 0, 0, 48)
            })
            self.sliderBtn.selected = false
            self.sliderBtnClick(self.sliderBtn)
        }
    }
    
    @IBAction func sliderBtnClick(sender: UIButton)
    { 
        if isDragging == true
        {
            // Draw product.
            let _index = self.getIndexBySliderX()
            if _index != self.currentIndex
            {
                self.currentIndex = _index
                self.cartoonBarDelegate?.drawProductAtNo(self.currentIndex)
            }
            isDragging = false
            if self.currentIndex == self.totalCount
            {
                self.sliderBtnClick(self.sliderBtn)
            }
            return
        }
        dispatch_async(dispatch_get_main_queue(), {
            // something
            sender.selected = !sender.selected
            // Playing...
            if sender.selected == false
            {
                // If while it is the end -> replay.
                if self.currentIndex == self.totalCount
                {
                    sender.selected = true
                    self.playCartoon(self.totalCount)
                    return
                }
                self.isPlaying = true
                self.backBtn.enabled = false
                self.preBtn.enabled = false
                self.cartoonTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(CartoonBarView.onCartoonTimer(_:)), userInfo: nil, repeats: true)
                self.cartoonTimer.fire()
            }else{
                if self.cartoonTimer != nil
                {
                    self.cartoonTimer.invalidate()
                }
                self.isPlaying = false
                self.backBtn.enabled = true
                self.preBtn.enabled = true
            }
        })
    }
    
    var isDragging : Bool = false
    @IBAction func sliderBtnDrag(sender: UIButton, forEvent event: UIEvent)
    {
        if self.currentIndex > self.totalCount || self.totalCount == 0 || self.cartoonBarDelegate?.getLockFlag() == false
        {
            return
        }
        isDragging = true
        // Update slider`s position.
        let touches : NSSet = event.allTouches()!
        let touch : UITouch = (touches.anyObject() as! UITouch)
        sender.frame.origin.x += touch.locationInView(sender).x - touch.previousLocationInView(sender).x
        if sender.frame.origin.x < MIN_SliderX
        {
            sender.frame.origin.x = MIN_SliderX
        }else if sender.frame.origin.x > MAX_SliderX{
            sender.frame.origin.x = MAX_SliderX
        }
    }
    
    func onCartoonTimer(timer : NSTimer)
    {
        // Stop while dragging slider.
        if isDragging == true
        {
            return
        }
        if self.cartoonBarDelegate?.getLockFlag() == true && self.currentIndex + 1 <= self.totalCount
        {
            // Refresh the slider block`s position.
            self.currentIndex += 1
            self.setSliderXByIndex(self.currentIndex)
            if self.currentIndex == self.totalCount
            {
                self.sliderBtnClick(self.sliderBtn)
            }
            self.cartoonBarDelegate?.drawProductAtNo(self.currentIndex)
        }
    }
    
    @IBAction func multipleBackBtnClick(sender: UIButton)
    {
        
    }
    
    @IBAction func backBtnClick(sender: UIButton)
    {
        if self.currentIndex <= 1 || self.currentIndex > self.totalCount || self.totalCount == 0
        {
            return
        }
        self.currentIndex -= 1
        self.setSliderXByIndex(self.currentIndex)
        self.cartoonBarDelegate?.drawProductAtNo(self.currentIndex)
    }
    
    @IBAction func preBtnClick(sender: UIButton)
    {
        if self.currentIndex == self.totalCount || self.currentIndex > self.totalCount || self.totalCount == 0
        {
            return
        }
        self.currentIndex += 1
        self.setSliderXByIndex(self.currentIndex)
        self.cartoonBarDelegate?.drawProductAtNo(self.currentIndex)
    }
    
    @IBAction func multiplePreBtnClick(sender: UIButton)
    {
        
    }
}