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
    func historyQueryControl(selectProductConfigDir : NSMutableDictionary, startTimeStr : String, endTimeStr : String)
    func chooseProductControl()
    func timeBtnClick()
    func queryHistoryData()
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
        if ProductUtilModel.getInstance.getProductConfigArr().count == 0
        {
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: #selector(HistoryChoiceView.setViewByProductConfig(_:)),
                name: "\(PRODUCTCONFIG)\(SELECT)\(SUCCESS)",
                object: nil)
        }else{
            if ProductUtilModel.getInstance.isGetProductConfigArr() == false
            {
                return
            }
            self._selectProductConfigDir = ProductUtilModel.getInstance.getProductConfigArr().objectAtIndex(0) as? NSMutableDictionary
            setProductBtnByVo(self._selectProductConfigDir)
        }
        self.preciseTimeBtnClick(self.preciseTimeBtn_halfAnHour)
    }
    
    func setViewByProductConfig(notification : NSNotification?)
    {
        if ProductUtilModel.getInstance.isGetProductConfigArr() == false
        {
            return
        }
        self._selectProductConfigDir = ProductUtilModel.getInstance.getProductConfigArr().objectAtIndex(0) as? NSMutableDictionary
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
        self.endTime = NSDate()
        if sender == preciseTimeBtn_halfAnHour
        {
            self.startTime = self.endTime?.dateByAddingTimeInterval(-0.5 * 60 * 60)
        }else if sender == preciseTimeBtn_oneHour{
            self.startTime = self.endTime?.dateByAddingTimeInterval(-1 * 60 * 60)
        }else if sender == preciseTimeBtn_twoHour{
            self.startTime = self.endTime?.dateByAddingTimeInterval(-2 * 60 * 60)
        }else if sender == preciseTimeBtn_fourHour{
            self.startTime = self.endTime?.dateByAddingTimeInterval(-4 * 60 * 60)
        }else if sender == preciseTimeBtn_eightHour{
            self.startTime = self.endTime?.dateByAddingTimeInterval(-8 * 60 * 60)
        }else if sender == preciseTimeBtn_sixHour{
            self.startTime = self.endTime?.dateByAddingTimeInterval(-6 * 60 * 60)
        }else if sender == preciseTimeBtn_twelveHour{
            self.startTime = self.endTime?.dateByAddingTimeInterval(-12 * 60 * 60)
        }else if sender == preciseTimeBtn_oneDay{
            self.startTime = self.endTime?.dateByAddingTimeInterval(-24 * 60 * 60)
        }
        startTimeBtn.setTitle(self.dateFormatter!.stringFromDate(self.startTime!), forState: UIControlState.Normal)
        endTimeBtn.setTitle(self.dateFormatter!.stringFromDate(self.endTime!), forState: UIControlState.Normal)
    }
    
    @IBAction func startTimeBtnClick(sender : UIButton)
    {
        if delegate != nil
        {
            startTimeBtn.tag = 1
            endTimeBtn.tag = 0
            delegate?.timeBtnClick()
        }
    }
    
    @IBAction func endTimeBtnClick(sender : UIButton)
    {
        if delegate != nil
        {
            startTimeBtn.tag = 0
            endTimeBtn.tag = 1
            delegate?.timeBtnClick()
        }
    }
    
    func setDateTime(date : NSDate)
    {
        if startTimeBtn.tag == 1
        {
            self.startTime = date
            startTimeBtn.tag = 0
            startTimeBtn.setTitle(self.dateFormatter!.stringFromDate(self.startTime!), forState: UIControlState.Normal)
        }else if endTimeBtn.tag == 1{
            self.endTime = date
            endTimeBtn.tag = 0
            endTimeBtn.setTitle(self.dateFormatter!.stringFromDate(self.endTime!), forState: UIControlState.Normal)
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
            delegate?.historyQueryControl(self._selectProductConfigDir!, startTimeStr: (startTimeBtn.titleLabel?.text)!, endTimeStr: (endTimeBtn.titleLabel?.text)!) 
        }
        self.delegate?.queryHistoryData()
        // Get Data.
        
    }
}