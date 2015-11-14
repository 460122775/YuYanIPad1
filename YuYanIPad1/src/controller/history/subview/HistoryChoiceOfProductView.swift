//
//  HistoryChoiceOfProductView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryChoiceOfProductProtocol
{
    func getSelectedProduct(productConfigVo : NSMutableDictionary)
    func returnBackToChoice()
}

class HistoryChoiceOfProductView : UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var productTableView : UITableView!
    
    var delegate : HistoryChoiceOfProductProtocol?
    var _productConfigArr : NSMutableArray?
    var _selectProductConfigDic : NSMutableDictionary?
    let ProductTableCellIndentifier : String = "ProductTableCellIndentifier"
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
        // Set product table view.
        self.productTableView!.dataSource = self
        self.productTableView!.delegate = self
//        self.productTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ProductTableCellIndentifier)
        self.productTableView.layoutMargins = UIEdgeInsetsZero
        self.productTableView.separatorInset = UIEdgeInsetsZero
        // Get product table view data & reset the view.
        if ProductModel.getInstance.getProductConfigArr().count == 0
        {
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "setViewByProductConfig",
                name: "\(PRODUCTCONFIG)\(SELECT)\(SUCCESS)",
                object: nil)
        }else{
            setViewByProductConfig(nil)
        }
    }
    
    func setViewByProductConfig(notification : NSNotification?)
    {
        _productConfigArr = ProductModel.getInstance.getProductConfigArr()
        if _productConfigArr == nil || _productConfigArr!.count == 0
        {
            return
        }
        _selectProductConfigDic = _productConfigArr?.objectAtIndex(0) as! NSMutableDictionary
        self.productTableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if _productConfigArr != nil
        {
            return _productConfigArr!.count
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
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ProductTableCellIndentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ProductTableCellIndentifier) as UITableViewCell!
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont.systemFontOfSize(13)
            cell!.detailTextLabel?.textColor = UIColor.grayColor()
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.separatorInset = UIEdgeInsetsZero
            cell!.layoutMargins = UIEdgeInsetsZero
        }
        let _productConfigDic : NSMutableDictionary = (_productConfigArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        if _productConfigDic != _selectProductConfigDic
        {
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.textLabel?.textColor = UIColor.whiteColor()
        }else{
            cell!.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
            cell!.textLabel?.textColor = UIColor.blackColor()
        }
        cell!.textLabel?.text = (_productConfigDic.objectForKey("cname") as! String) + "（" + (_productConfigDic.objectForKey("ename") as! String) + "）"
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
        }
        _selectProductConfigDic = (_productConfigArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
        cell.textLabel?.textColor = UIColor.blackColor()
        self.delegate?.getSelectedProduct(_selectProductConfigDic!)
    }
    
    @IBAction func returnBtnClick(sender: UIButton)
    {
        self.delegate?.returnBackToChoice()
    }
    
}