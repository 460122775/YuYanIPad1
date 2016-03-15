//
//  HistoryChoiceView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit


protocol HistoryElevationChoiceProtocol
{
    func elevationChooseControl(elevationValue : Float32)
    func returnBackToResult()
}

class HistoryElevationChoiceView : UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var elevationTableView: UITableView!
    var delegate : HistoryElevationChoiceProtocol?
    var elevationArr  = [Float32]()
    var currentElevationValue : Float32 = -1
    let ElevationChoiceTableCellIndentifier : String = "elevationChoiceTableCellIndentifier"
    var ELEVATIONCHOOSE_ALL : String = "全部"
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
        // Set product table view.
        self.elevationTableView.dataSource = self
        self.elevationTableView.delegate = self
        self.elevationTableView.layoutMargins = UIEdgeInsetsZero
        self.elevationTableView.separatorInset = UIEdgeInsetsZero
        // Set notification for receiving elevation list.
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "receiveElevationData:",
            name: "\(ELEVATIONLIST)\(SELECT)\(SUCCESS)",
            object: nil)
    }
    
    func setCurrentElevationValueByMcode(mcode : String?)
    {
        if mcode == nil
        {
            self.currentElevationValue = -1
        }else{
            self.currentElevationValue = Float32(mcode!.substringFromIndex((mcode!.rangeOfString("-")?.endIndex)!))!
        }
    }
    
    func receiveElevationData(notification : NSNotification?) -> Void
    {
        let resultStr : String = notification!.object?.valueForKey("result") as! String
        if resultStr == FAIL
        {
            // Tell reason of FAIL.
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "服务器查询失败，请联系管理员！", autoClear: true, autoClearTime: 2)
        }else{
            // Show result data.
            let _elevationArr = (notification!.object?.valueForKey("list") as? NSMutableArray)
            // Tell user the result.
            if _elevationArr == nil || _elevationArr?.count == 0
            {
                SwiftNotice.showNoticeWithText(NoticeType.info, text: "当前条件下未查询到数据！", autoClear: true, autoClearTime: 2)
                return
            }
            var _elevationValue : String?
            var tempElevationValue : Float32 = 0
            self.elevationArr.removeAll()
            var i : Int = 0, j : Int = 0
            var flag : Bool = false
            for i = 0; i < _elevationArr?.count; i++
            {
                _elevationValue = (_elevationArr?.objectAtIndex(i) as? String)!
                tempElevationValue = Float32(_elevationValue!.substringFromIndex((_elevationValue!.rangeOfString("-")?.endIndex)!))!
                for j = 0, flag = false; j < elevationArr.count; j++
                {
                    if self.elevationArr[j] > tempElevationValue
                    {
                        self.elevationArr.insert(tempElevationValue, atIndex: j)
                        flag = true
                        break
                    }
                }
                if !flag
                {
                    self.elevationArr.insert(tempElevationValue, atIndex: j)
                }
            }
            // Must reload data in main queue, or maybe crashed.
            dispatch_async(dispatch_get_main_queue(), {
                self.elevationTableView.reloadData()
            });
        }
    }
    
    func selectElevationData()
    {
        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.elevationTableView.reloadData()
        });
    }
    
    @IBAction func returnBtnClick(sender: UIButton)
    {
        if delegate != nil
        {
            delegate?.returnBackToResult()
            self.elevationArr.removeAll()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return self.elevationArr.count + 1
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
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ElevationChoiceTableCellIndentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ElevationChoiceTableCellIndentifier) as UITableViewCell!
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont.systemFontOfSize(13)
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.separatorInset = UIEdgeInsetsZero
            cell!.layoutMargins = UIEdgeInsetsZero
        }
        if (indexPath.row as Int) == 0
        {
            cell!.textLabel?.text = self.ELEVATIONCHOOSE_ALL
            self.setCellColor(cell!, selected: (self.currentElevationValue < 0))
        }else{
            self.setCellColor(cell!, selected: self.elevationArr[(indexPath.row as Int) - 1] == currentElevationValue)
            cell!.textLabel?.text = String(self.elevationArr[(indexPath.row as Int) - 1])
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.row as Int) == 0
        {
            currentElevationValue = -1
        }else if self.elevationArr.count > 0{
            currentElevationValue = self.elevationArr[(indexPath.row as Int) - 1]
        }
        self.delegate?.elevationChooseControl(currentElevationValue)
    }
    
    func setCellColor(cell : UITableViewCell, selected : Bool)
    {
        if selected == false
        {
            cell.contentView.backgroundColor = UIColor.clearColor();
            cell.textLabel?.textColor = UIColor.whiteColor()
        }else{
            cell.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
            cell.textLabel?.textColor = UIColor.blackColor()
        }
    }

}