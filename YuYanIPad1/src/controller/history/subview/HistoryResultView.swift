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
    func showLastPage()
    func showNextPage()
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
    
    var refreshFooter : SDRefreshFooterView?
    var refreshHeader : SDRefreshHeaderView?
    var totalRowCount : NSInteger = 0
    var noUseCount : NSInteger = 0
    
    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var elevationChooseBtn: UIButton!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var resultTableView: UITableView!
    
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
//                self.totalRowCount += 3
//                self.noUseCount = 3
                self.delegate?.showLastPage()
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
//            self.totalRowCount += 2;
//            self.noUseCount = 2
            self.delegate?.showNextPage()
            self.resultTableView.reloadData()
            self.refreshFooter?.endRefreshing()
        });
    }
    
    func changResultTitle(_currentProductConfigDic : NSMutableDictionary, startTimeStr : String, endTimeStr : String)
    {
        // Clear.
        self.setHistoryQueryResultArr(nil)
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
    
    func setHistoryQueryResultArr(historyQueryResultArr : NSMutableArray?)
    {
        resultArr = historyQueryResultArr
        if resultArr == nil || resultArr?.count == 0
        {
            self.elevationChooseBtn.hidden = true
            self.elevationChooseBtn.enabled = false
            self.totalRowCount = 0
            self.noUseCount = 0
        }else{
            // Only for first class product.
            if (self.currentProductConfigDic!.valueForKey("level") as! NSNumber).intValue == 0
            {
                self.elevationChooseBtn.hidden = false
                self.elevationChooseBtn.enabled = true
            }
            self.totalRowCount = (resultArr?.count)!
        }        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.resultTableView.reloadData()
        });
    }
    
    func setSelectedProductDic(productDic : NSMutableDictionary)
    {
        _selectedProductDic = productDic
        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.resultTableView.reloadData()
        })
    }
    
    func getQueryResultArr() -> NSMutableArray?
    {
        return resultArr
    }
    
    // Operate handler.
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
    
    /************** Table view delegate.  ***********/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.totalRowCount
//        if resultArr != nil
//        {
//            return resultArr!.count
//        }else{
//            return 0
//        }
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
        if indexPath.row < noUseCount
        {
            return cell!
        }
        let _productDic : NSMutableDictionary = (resultArr?.objectAtIndex(indexPath.row as Int - noUseCount) as? NSMutableDictionary)!
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
        _selectedProductDic = NSMutableDictionary(dictionary: (resultArr?.objectAtIndex(indexPath.row as Int  - noUseCount) as? NSDictionary)!)
        self.delegate?.selectedProductControl(_selectedProductDic!)
    }
}