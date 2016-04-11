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
    func productSelectControl(productName : String)
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
//        self.productListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ProductListTableCellIndentifier)
        self.productListTableView.layoutMargins = UIEdgeInsetsZero
        self.productListTableView.separatorInset = UIEdgeInsetsZero

        // Add Listener.
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductListView.getProductTypeListControl), name: "\(PRODUCTTYPELIST)\(SELECT)\(SUCCESS)", object: nil)
        // Get data.
        getProductTypeListControl()
    }
    
    internal func getProductTypeListControl()
    {
        productArr = ProductUtilModel.getInstance.getProductList()
        if productArr!.count == 0
        {
            return
        }
        // Must reload data in main queue, or maybe crashed.
        dispatch_async(dispatch_get_main_queue(), {
            self.productListTableView.reloadData()
        });
    }
    
    func getSelectProductConfigForCartoon() -> NSMutableDictionary?
    {
        if ProductUtilModel.getInstance.getProductList().count == 0
        {
            return nil
        }else if productArr == nil{
            productArr = ProductUtilModel.getInstance.getProductList()
        }
        if _selectProductConfigDic == nil
        {
            _selectProductConfigDic = (productArr?.objectAtIndex(0) as? NSMutableDictionary)!
            // Must reload data in main queue, or maybe crashed.
            dispatch_async(dispatch_get_main_queue(), {
                self.productListTableView.reloadData()
            });
        }
        return _selectProductConfigDic
    }
    
    func setProductAddress(productEname : String, productAddress : String)
    {
        if self.productArr == nil
        {
            return
        }else{
            var _productDic : NSMutableDictionary?
            for i in 0 ..< productArr!.count
            {
                 _productDic = (productArr?.objectAtIndex(i) as? NSMutableDictionary)!
                if _productDic?.objectForKey("ename") as! String == productEname
                {
                    _productDic?.setObject(productAddress, forKey: "name")
                }
            }
        }
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
//            SwiftNotice.showText("未收集到该产品!")
            ProductUtilModel.getInstance.getNewestDataByType((_selectProductConfigDic?.objectForKey("type") as! NSNumber).intValue)
        }else{
//            SwiftNotice.showText("\(_selectProductConfigDic!.objectForKey("name") as! String)")
            if productListDelegate != nil
            {
                self.productListDelegate?.productSelectControl(_selectProductConfigDic!.objectForKey("name") as! String)
            }
        }
    }
}
