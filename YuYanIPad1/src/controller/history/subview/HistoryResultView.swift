//
//  HistoryResultView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryResultProtocol
{
    func chooseProductControl()
    func returnBackToChoice()
    func selectedProductControl(selectedProductDic : NSMutableDictionary)
    func showElevationChoiceView()
}

class HistoryResultView : UIView, UITableViewDelegate, UITableViewDataSource
{
    var delegate : HistoryResultProtocol?
    var startTimeStr : String?
    var endTimeStr : String?
    var currentPageVo : PageVo?
    var _selectedProductDic : NSMutableDictionary?
    var currentProductConfigDic : NSMutableDictionary?
    var resultArr : NSMutableArray?
    var ResultListTableCellIndentifier : String = "ResultListTableCellIndentifier"
    var ELEVATIONCHOOSE_ALL : String = "全部"
    
    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var elevationChooseBtn: UIButton!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var resultTableView: UITableView!
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "setViewByHistoryProductData:",
            name: "\(HISTORYPRODUCT)\(SELECT)\(SUCCESS)",
            object: nil)
    }
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        // Set product table view.
        self.resultTableView!.dataSource = self
        self.resultTableView!.delegate = self
//        self.resultTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ResultListTableCellIndentifier)
        self.resultTableView.layoutMargins = UIEdgeInsetsZero
        self.resultTableView.separatorInset = UIEdgeInsetsZero
    }
    
    func changResultTitle(_currentProductConfigDic : NSMutableDictionary, startTimeStr : String, endTimeStr : String)
    {
        self.currentProductConfigDic = _currentProductConfigDic
        self.startTimeStr = startTimeStr
        self.endTimeStr = endTimeStr
        productTitleLabel.text = (_currentProductConfigDic.objectForKey("cname") as! String) + "（" + (_currentProductConfigDic.objectForKey("ename") as! String) + "）"
        startTimeLabel.text = "从 " + startTimeStr
        endTimeLabel.text = "到 " + endTimeStr
        if (self.currentProductConfigDic!.valueForKey("level") as! NSNumber).intValue == 0
        {
            self.elevationChooseBtn.hidden = false
            self.elevationChooseBtn.enabled = true
            self.elevationChooseBtn.titleLabel?.text = ELEVATIONCHOOSE_ALL
        }
    }
    
    func setElevationValueBtnLb(elevationValue : Float32)
    {
        if elevationValue >= 0
        {
            self.elevationChooseBtn.setTitle(String(format: "%.2f°", elevationValue), forState: UIControlState.Normal)
        }else{
            self.elevationChooseBtn.setTitle(ELEVATIONCHOOSE_ALL, forState: UIControlState.Normal)
        }
    }
    
    func setViewByHistoryProductData(notification : NSNotification?) -> Void
    {
        self.elevationChooseBtn.hidden = true
        self.elevationChooseBtn.enabled = false
        let resultStr : String = notification!.object?.valueForKey("result") as! String
        if resultStr == FAIL
        {
            // Tell reason of FAIL.
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "服务器查询失败，请联系管理员！", autoClear: true, autoClearTime: 2)
        }else{
            // Show result data.
            resultArr = (notification!.object?.valueForKey("list") as? NSMutableArray)
            // Tell user the result.
            if resultArr == nil || resultArr?.count == 0
            {
                SwiftNotice.showNoticeWithText(NoticeType.info, text: "当前条件下未查询到数据！", autoClear: true, autoClearTime: 2)
                return
            }
            // Only for first class product.
            if (self.currentProductConfigDic!.valueForKey("level") as! NSNumber).intValue == 0
            {
                self.elevationChooseBtn.hidden = false
                self.elevationChooseBtn.enabled = true
            }
            // Must reload data in main queue, or maybe crashed.
            dispatch_async(dispatch_get_main_queue(), {
                self.resultTableView.reloadData()
            });
        }
    }
    
    func setSelectedProductDic(productDic : NSMutableDictionary)
    {
        _selectedProductDic = productDic
        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.resultTableView.reloadData()
        });
    }
    
    @IBAction func elevationBtnClick(sender: UIButton)
    {
        self.delegate!.showElevationChoiceView()
    }
    
    @IBAction func returnBtnClick(sender: UIButton)
    {
        if delegate != nil
        {
            delegate?.returnBackToChoice()
            resultArr = nil
            currentPageVo = nil
            _selectedProductDic = nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if resultArr != nil
        {
            return resultArr!.count
        }else{
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 39
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ResultListTableCellIndentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ResultListTableCellIndentifier) as UITableViewCell!
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont.systemFontOfSize(13)
            cell!.detailTextLabel?.textColor = UIColor.grayColor()
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.separatorInset = UIEdgeInsetsZero
            cell!.layoutMargins = UIEdgeInsetsZero
        }
        let _productDic : NSMutableDictionary = (resultArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        if _productDic != _selectedProductDic
        {
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.textLabel?.textColor = UIColor.whiteColor()
        }else{
            cell!.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
            cell!.textLabel?.textColor = UIColor.blackColor()
        }
        cell!.textLabel?.text = (_productDic.objectForKey("name") as! NSString).substringToIndex(15)
        cell!.detailTextLabel?.text = (_productDic.objectForKey("mcode") as! String)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var arry = tableView.visibleCells;
        for(var i = 0; i < arry.count; i++)
        {
            let _cell : UITableViewCell = arry[i] ;
            _cell.contentView.backgroundColor = UIColor.clearColor();
            _cell.textLabel?.textColor = UIColor.whiteColor()
            _cell.detailTextLabel?.textColor = UIColor.grayColor()
        }
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        if resultArr == nil
        {
            return
        }
        _selectedProductDic = NSMutableDictionary(dictionary: (resultArr?.objectAtIndex(indexPath.row as Int) as? NSDictionary)!)
        self.delegate?.selectedProductControl(_selectedProductDic!)
    }
}