//
//  HistoryResultView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryRainResultProtocol
{
    func returnBackToChoice()
    func queryHistoryByRain(startTimeStr : String, endTimeStr : String)
}

class HistoryRainResultView : UIView, UITableViewDelegate, UITableViewDataSource
{
    var delegate : HistoryRainResultProtocol?
    var startTimeStr : String?
    var endTimeStr : String?
    var currentPageVo : PageVo = PageVo()
    var _selectedProductDic : NSMutableDictionary?
    var currentProductConfigDic : NSMutableDictionary?
    var resultArr : NSMutableArray?
    var ResultListTableCellIndentifier : String = "RainResultCellIndentifier"

    var refreshFooter : SDRefreshFooterView?
    var refreshHeader : SDRefreshHeaderView?
    var totalRowCount : NSInteger = 0
    
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var resultTableView: UITableView!
    var showRainDataByDate : Bool = true
    let dateFormatter = NSDateFormatter()
    let RainType_None : String = "没雨"
    let RainType_Small : String = "有雨"
    let RainType_Heavy : String = "大雨"
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        // Set product table view.
        self.resultTableView!.dataSource = self
        self.resultTableView!.delegate = self
        self.resultTableView.layoutMargins = UIEdgeInsetsZero
        self.resultTableView.separatorInset = UIEdgeInsetsZero
        
        self.setupHeader()
        self.setupFooter()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(HistoryRainResultView.receiveRainDataOfHour(_:)),
            name: "\(HISTORYRAIN_HOUR)\(SELECT)\(SUCCESS)",
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(HistoryRainResultView.receiveRainDataOfDate(_:)),
            name: "\(HISTORYRAIN_DATE)\(SELECT)\(SUCCESS)",
            object: nil)
    }
    
    func setupHeader()
    {
        if self.refreshHeader == nil
        {
            self.refreshHeader = SDRefreshHeaderView()
        }
        // 默认是在navigationController环境下，如果不是在此环境下，请设置 
        self.refreshHeader!.isEffectedByNavigationController = false
        self.refreshHeader!.addToScrollView(self.resultTableView)
        self.refreshHeader!.beginRefreshingOperation = {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (CLongLong)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                if self.currentPageVo.currentPage > 1
                {
                    self.requestRainData(self.currentPageVo.currentPage - 1)
                }
                self.resultTableView.reloadData()
                self.refreshHeader?.endRefreshing()
            });
        };
        // 进入页面自动加载一次数据
        self.refreshHeader!.autoRefreshWhenViewDidAppear()
    }
    
    func setupFooter()
    {
        if self.refreshFooter == nil
        {
            self.refreshFooter = SDRefreshFooterView()
        }
        self.refreshFooter!.addToScrollView(self.resultTableView)
        self.refreshFooter!.addTarget(self, refreshAction: #selector(HistoryResultView.footerRefresh))
    }
    
    func footerRefresh()
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (CLongLong)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            var totalPage = self.currentPageVo.totalNumber / self.currentPageVo.pageSize
            if self.currentPageVo.totalNumber % self.currentPageVo.pageSize != 0
            {
                totalPage += 1
            }
            if self.currentPageVo.currentPage < totalPage
            {
                self.requestRainData(self.currentPageVo.currentPage + 1)
            }
            self.resultTableView.reloadData()
            self.refreshFooter?.endRefreshing()
        });
    }
    
    func requestRainData(currentPage : Int32)
    {
        self.currentPageVo.currentPage = currentPage
        if showRainDataByDate
        {
            ProductUtilModel.getInstance.getHistoryRainDataByDate(self.startTimeStr!, endTimeStr: self.endTimeStr!, currentPage: self.currentPageVo.currentPage)
        }else{
            ProductUtilModel.getInstance.getHistoryRainDataByHour(self.startTimeStr!, endTimeStr: self.endTimeStr!, currentPage: self.currentPageVo.currentPage)
        }
    }
    
    func queryByDateResultControl(startTimeStr : String, endTimeStr : String)
    {
        // Clear view.
        self.resultArr?.removeAllObjects()
        dispatch_async(dispatch_get_main_queue(), {
            self.resultTableView.reloadData()
        });
        // Save records.
        self.showRainDataByDate = true
        self.startTimeStr = ((startTimeStr as NSString).substringWithRange(NSRange(location: 0, length: 10)) as String).stringByAppendingString(" 00:00:00")
        self.endTimeStr = ((endTimeStr as NSString).substringWithRange(NSRange(location: 0, length: 10)) as String).stringByAppendingString(" 23:59:59")
        changResultTitle(self.startTimeStr!, endTimeStr: self.endTimeStr!)
        self.currentPageVo.totalNumber = 0
        // Query.
        self.requestRainData(1)
    }
    
    func queryByHourResultControl(startTimeStr : String, endTimeStr : String)
    {
        // Clear view.
        self.resultArr?.removeAllObjects()
        dispatch_async(dispatch_get_main_queue(), {
            self.resultTableView.reloadData()
        });
        // Save records.
        self.showRainDataByDate = false
        self.startTimeStr = ((startTimeStr as NSString).substringWithRange(NSRange(location: 0, length: 13)) as String).stringByAppendingString(":00:00")
        self.endTimeStr = ((endTimeStr as NSString).substringWithRange(NSRange(location: 0, length: 13)) as String).stringByAppendingString(":59:59")
        changResultTitle(self.startTimeStr!, endTimeStr: self.endTimeStr!)
        self.currentPageVo.totalNumber = 0
        // Query.
        self.requestRainData(1)
    }
    
    func receiveRainDataOfHour(notification : NSNotification?) -> Void
    {
        self.showRainDataByDate = false
        let resultStr : String = notification!.object?.valueForKey("result") as! String
        if resultStr == FAIL
        {
            // Tell reason of FAIL.
            SwiftNotice.showText("服务端查询失败，请重试!")
            return
        }
        // Show result data.
        resultArr = (notification!.object?.valueForKey("list") as? NSMutableArray)
        // Tell user the result.
        if resultArr == nil || resultArr?.count == 0
        {
            SwiftNotice.showText(NODATA)
            return
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH时"
        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.resultTableView.reloadData()
        });
    }
    
    func receiveRainDataOfDate(notification : NSNotification?) -> Void
    {
        self.showRainDataByDate = true
        let resultStr : String = notification!.object?.valueForKey("result") as! String
        if resultStr == FAIL
        {
            // Tell reason of FAIL.
            SwiftNotice.showText("服务端查询失败，请重试!")
            return
        }
        // Show result data.
        resultArr = (notification!.object?.valueForKey("list") as? NSMutableArray)
        // Tell user the result.
        if resultArr == nil || resultArr?.count == 0
        {
            SwiftNotice.showText(NODATA)
            return
        }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.resultTableView.reloadData()
        });
    }
    
    func changResultTitle(startTimeStr : String, endTimeStr : String)
    {
        // Clear.
        self.startTimeStr = startTimeStr
        self.endTimeStr = endTimeStr
        startTimeLabel.text = "从 " + startTimeStr
        endTimeLabel.text = "到 " + endTimeStr
    }
    
    func getQueryResultArr() -> NSMutableArray?
    {
        return resultArr
    }
    
    // Operate handler.
    @IBAction func returnBtnClick(sender: UIButton)
    {
        if delegate != nil
        {
            delegate?.returnBackToChoice()
            resultArr = nil
            _selectedProductDic = nil
        }
    }
    
    /************** Table view delegate.  ***********/
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
        return 40
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
        let rainType = (_productDic.objectForKey("rainType") as! NSNumber).intValue
        if rainType == 0
        {
            cell!.textLabel?.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval((_productDic.objectForKey("startTime") as! NSNumber).longLongValue))) + "\t\t" + RainType_None
        }else if rainType == 1{
            cell!.textLabel?.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval((_productDic.objectForKey("startTime") as! NSNumber).longLongValue))) + "\t\t" + RainType_Small
        }else if rainType == 2{
            cell!.textLabel?.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval((_productDic.objectForKey("startTime") as! NSNumber).longLongValue))) + "\t\t" + RainType_Heavy
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var arry = tableView.visibleCells;
        for i in 0 ..< arry.count
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
        if cell.textLabel?.text == nil
        {
            return
        }
        // Rain data by date.
        if showRainDataByDate
        {
            self.delegate?.queryHistoryByRain((((cell.textLabel?.text)! as NSString).substringWithRange(NSRange(location: 0, length: 10)) as String).stringByAppendingString(" 00:00:00"),
                                              endTimeStr: (((cell.textLabel?.text)! as NSString).substringWithRange(NSRange(location: 0, length: 10)) as String).stringByAppendingString(" 23:59:59"))
        // Rain data by hour.
        }else{
            self.delegate?.queryHistoryByRain((((cell.textLabel?.text)! as NSString).substringWithRange(NSRange(location: 0, length: 13)) as String).stringByAppendingString(" :00:00"),
                                              endTimeStr: (((cell.textLabel?.text)! as NSString).substringWithRange(NSRange(location: 0, length: 13)) as String).stringByAppendingString(":59:59"))
        }
    }
}