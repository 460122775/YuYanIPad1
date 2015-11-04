//
//  HistoryChoiceView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit


protocol HistoryChoiceProtocol
{
    func historyQueryControl()
    func chooseProductControl()
    func chooseTimeControl()
}

class HistoryChoiceView : UIView
{
    var delegate : HistoryChoiceProtocol?
    
    @IBOutlet var productChooseBtn: UIButton!
    @IBOutlet var preciseTimeBtn_halfAnHour: UIButton!
    @IBOutlet var preciseTimeBtn_oneHour: UIButton!
    @IBOutlet var preciseTimeBtn_twoHour: UIButton!
    @IBOutlet var preciseTimeBtn_fourHour: UIButton!
    @IBOutlet var preciseTimeBtn_sixHour: UIButton!
    @IBOutlet var preciseTimeBtn_eightHour: UIButton!
    @IBOutlet var preciseTimeBtn_twelveHour: UIButton!
    @IBOutlet var preciseTimeBtn_oneDay: UIButton!
    @IBOutlet var startTimeBtn: UIButton!
    @IBOutlet var endTimeBtn: UIButton!
    
    var _selectProductConfigDir : NSMutableDictionary?
    var dateFormatter : NSDateFormatter?
    var startTime : NSDate?
    var endTime : NSDate?
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
        self.startTime = NSDate()
        self.endTime = NSDate()
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter!.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
        if ProductModel.getInstance.getProductConfigArr().count == 0
        {
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "setViewByProductConfig",
                name: "\(PRODUCTCONFIG)\(SELECT)\(SUCCESS)",
                object: nil)
        }else{
            if ProductModel.getInstance.isGetProductConfigArr() == false
            {
                return
            }
            self._selectProductConfigDir = ProductModel.getInstance.getProductConfigArr().objectAtIndex(0) as? NSMutableDictionary
            setProductBtnByVo(self._selectProductConfigDir)
        }
    }
    
    func setViewByProductConfig(notification : NSNotification?)
    {
        if ProductModel.getInstance.isGetProductConfigArr() == false
        {
            return
        }
        self._selectProductConfigDir = ProductModel.getInstance.getProductConfigArr().objectAtIndex(0) as? NSMutableDictionary
        if notification == nil
        {
            setProductBtnByVo(self._selectProductConfigDir)
        }
    }
    
    func setProductBtnByVo(_selectProductConfigDir : NSMutableDictionary?)
    {
        if _selectProductConfigDir != self._selectProductConfigDir
        {
            self._selectProductConfigDir = _selectProductConfigDir
        }
        productChooseBtn.setTitle(
            (self._selectProductConfigDir!.objectForKey("cname") as! String) + "（" + (self._selectProductConfigDir!.objectForKey("ename") as! String) + "）",
            forState: UIControlState.Normal)
    }
    
    @IBAction func productSelectControl(sender : UIButton)
    {
        if delegate != nil
        {
            delegate?.chooseProductControl()
        }
    }
    
    @IBAction func preciseTimeBtnClick(sender: UIButton)
    {
        self.startTime = NSDate()
        if sender == preciseTimeBtn_halfAnHour
        {
            self.endTime = self.startTime?.dateByAddingTimeInterval(0.5 * 60 * 60)
        }else if sender == preciseTimeBtn_oneHour{
            self.endTime = self.startTime?.dateByAddingTimeInterval(1 * 60 * 60)
        }else if sender == preciseTimeBtn_twoHour{
            self.endTime = self.startTime?.dateByAddingTimeInterval(2 * 60 * 60)
        }else if sender == preciseTimeBtn_fourHour{
            self.endTime = self.startTime?.dateByAddingTimeInterval(4 * 60 * 60)
        }else if sender == preciseTimeBtn_eightHour{
            self.endTime = self.startTime?.dateByAddingTimeInterval(8 * 60 * 60)
        }else if sender == preciseTimeBtn_sixHour{
            self.endTime = self.startTime?.dateByAddingTimeInterval(6 * 60 * 60)
        }else if sender == preciseTimeBtn_twelveHour{
            self.endTime = self.startTime?.dateByAddingTimeInterval(12 * 60 * 60)
        }else if sender == preciseTimeBtn_oneDay{
            self.endTime = self.startTime?.dateByAddingTimeInterval(24 * 60 * 60)
        }
        startTimeBtn.setTitle(self.dateFormatter!.stringFromDate(self.startTime!), forState: UIControlState.Normal)
        endTimeBtn.setTitle(self.dateFormatter!.stringFromDate(self.endTime!), forState: UIControlState.Normal)
    }
    
    @IBAction func startTimeBtnClick(sender : UIButton)
    {
        if delegate != nil
        {
            delegate?.chooseTimeControl()
        }
    }
    
    @IBAction func endTimeBtnClick(sender : UIButton)
    {
        if delegate != nil
        {
            delegate?.chooseTimeControl()
        }
    }
    
    @IBAction func queryBtnClick(sender : UIButton)
    {
        // If NULL.
        if self._selectProductConfigDir == nil
        {
            return
        }
        // Change left view.
        if delegate != nil
        {
            delegate?.historyQueryControl()
        }
        print(self.startTime,self.endTime)
        // Get Data.
        ProductModel.getInstance.getHistoryData(
            self.startTime!.timeIntervalSince1970,
            endTime: self.endTime!.timeIntervalSince1970,
            productType: Int32((self._selectProductConfigDir!.objectForKey("type")?.integerValue)!),
            currentPage: Int32.init(1)
        )
//        ProductModel.getInstance.getHistoryData(
//            self.startTime!.timeIntervalSince1970,
//            endTime: self.endTime!.timeIntervalSince1970,
//            productType: Int32((self._selectProductConfigDir!.objectForKey("type")?.integerValue)!,
//            currentPage: Int32(1))
//        )
    }
    
}