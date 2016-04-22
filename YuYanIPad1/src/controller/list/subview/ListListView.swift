//
//  ProductListView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol ListListProtocol
{
    func productSelectControl(productDic : NSMutableDictionary)
}

class ListListView: UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var listListTableView: UITableView!
    
    var ListListTableCellIndentifier : String = "ListListTableCellIndentifier"
    var listDataArr : NSMutableArray?
    var _selectProductDataDic : NSMutableDictionary?
    var listListDelegate : ListListProtocol?

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
        // Set product table view.
        self.listListTableView!.dataSource = self
        self.listListTableView!.delegate = self
        self.listListTableView.layoutMargins = UIEdgeInsetsZero
        self.listListTableView.separatorInset = UIEdgeInsetsZero
        self.initViewByData()
    }
    
    func initViewByData()
    {
        listDataArr = ProductUtilModel.getInstance.getReceivedProductDicArr()
        if listDataArr?.count > 0
        {
            // Must reload data in main queue, or maybe crashed.
            dispatch_async(dispatch_get_main_queue(), {
                self.listListTableView.reloadData()
            });
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.listDataArr != nil
        {
            return self.listDataArr!.count
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
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ListListTableCellIndentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ListListTableCellIndentifier) as UITableViewCell!
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont.systemFontOfSize(13)
            cell!.detailTextLabel?.textColor = UIColor.grayColor()
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.separatorInset = UIEdgeInsetsZero
            cell!.layoutMargins = UIEdgeInsetsZero
        }
        let _productDic : NSMutableDictionary = (self.listDataArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        if _productDic != _selectProductDataDic
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
        if self.listDataArr == nil || self.listDataArr?.count == 0
        {
            return
        }
        _selectProductDataDic = NSMutableDictionary(dictionary: (self.listDataArr?.objectAtIndex(indexPath.row as Int) as? NSDictionary)!)
        self.listListDelegate?.productSelectControl(_selectProductDataDic!)
    }
}
