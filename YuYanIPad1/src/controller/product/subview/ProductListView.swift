//
//  ProductListView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol ProductListProtocol
{
    func productSelectControl(productType : Int32, productPosFile : String?)
}

class ProductListView: UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var scanNameLabel: UILabel!
    @IBOutlet var scanTimeLabel: UILabel!
    @IBOutlet var productListTableView: UITableView!
    
    var ProductListTableCellIndentifier : String = "ProductListTableCellIndentifier"
    var productArr : NSMutableArray?
    var _selectProductConfigDic : NSMutableDictionary?
    var productListDelegate : ProductListProtocol?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
        // Set product table view.
        self.productListTableView!.dataSource = self
        self.productListTableView!.delegate = self
        self.productListTableView.layoutMargins = UIEdgeInsetsZero
        self.productListTableView.separatorInset = UIEdgeInsetsZero
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductListView.initViewByProductTypeListData), name: "\(PRODUCTTYPELIST)\(SELECT)\(SUCCESS)", object: nil)
        // Get data.
        initViewByProductTypeListData()
    }
    
    internal func initViewByProductTypeListData()
    {
        // Attention !!! Do not clear self.productArr, it is only a reference.
        self.productArr = ProductUtilModel.getInstance.getNewestProductList()
        if self.productArr == nil || self.productArr!.count == 0
        {
            return
        }
        self._selectProductConfigDic = (self.productArr?.objectAtIndex(0) as? NSMutableDictionary)!
        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.productListTableView.reloadData()
        });
    }
    
    func getSelectProductConfigForCartoon() -> NSMutableDictionary?
    {
        // Attention !!! Do not clear self.productArr, it is only a reference.
        self.productArr = ProductUtilModel.getInstance.getNewestProductList()
        if self.productArr == nil || self.productArr!.count == 0
        {
            return nil
        }
        if self._selectProductConfigDic == nil
        {
            self._selectProductConfigDic = (self.productArr?.objectAtIndex(0) as? NSMutableDictionary)!
            // Must reload data in main queue, or maybe crashed.
            dispatch_async(dispatch_get_main_queue(), {
                self.productListTableView.reloadData()
            });
        }
        return _selectProductConfigDic
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if productArr != nil
        {
            return productArr!.count
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
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ProductListTableCellIndentifier) as UITableViewCell!
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ProductListTableCellIndentifier) as UITableViewCell!
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.font = UIFont.systemFontOfSize(13)
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.separatorInset = UIEdgeInsetsZero
            cell!.layoutMargins = UIEdgeInsetsZero
        }
        let _productDic : NSMutableDictionary = (productArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        if _productDic != _selectProductConfigDic
        {
            cell!.contentView.backgroundColor = UIColor.clearColor();
            cell!.textLabel?.textColor = UIColor.whiteColor()
        }else{
            cell!.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
            cell!.textLabel?.textColor = UIColor.blackColor()
        }
        cell!.textLabel?.text = (_productDic.objectForKey("cname") as! String) + "（" + (_productDic.objectForKey("ename") as! String) + "）"
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
        }
        _selectProductConfigDic = (productArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
        cell.textLabel?.textColor = UIColor.blackColor()
        LogModel.getInstance.insertLog("用户点击了：" + (_selectProductConfigDic!.objectForKey("cname") as! String) + "（" + (_selectProductConfigDic!.objectForKey("ename") as! String) + "）")
        if (_selectProductConfigDic!.objectForKey("name") as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            self.productListDelegate?.productSelectControl((_selectProductConfigDic?.objectForKey("type") as! NSNumber).intValue, productPosFile: nil)
        }else{
//            SwiftNotice.showText("\(_selectProductConfigDic!.objectForKey("name") as! String)")
            if productListDelegate != nil
            {
                self.productListDelegate?.productSelectControl((_selectProductConfigDic?.objectForKey("type") as! NSNumber).intValue,
                                                               productPosFile: _selectProductConfigDic!.objectForKey("pos_file") as? String)
            }
        }
    }
}
