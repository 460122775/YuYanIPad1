//
//  ProductListView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ProductListView: UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var scanNameLabel: UILabel!
    @IBOutlet var scanTimeLabel: UILabel!
    @IBOutlet var productListTableView: UITableView!
    var ProductListTableCellIndentifier : String = "ProductListTableCellIndentifier"
    var productArr : NSMutableArray?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
        // Set product table view.
        self.productListTableView!.dataSource = self
        self.productListTableView!.delegate = self
        self.productListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ProductListTableCellIndentifier)
        if #available(iOS 8.0, *) {
            self.productListTableView.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
        self.productListTableView.separatorInset = UIEdgeInsetsZero

        // Add Listener.
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "getProductTypeListControl", name: "\(PRODUCTTYPELIST)\(SELECT)\(SUCCESS)", object: nil)
        // Get data.
        getProductTypeListControl()
    }
    
    internal func getProductTypeListControl()
    {
        productArr = ProductModel.getInstance.getProductList()
        if productArr!.count == 0
        {
            return
        }
        self.productListTableView.reloadData()
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
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(ProductListTableCellIndentifier, forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.clearColor();
        let _productDic : NSMutableDictionary = (productArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        cell.textLabel?.text = (_productDic.objectForKey("cname") as! String) + "（" + (_productDic.objectForKey("ename") as! String) + "）"
        cell.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
        return cell
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
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.contentView.backgroundColor = UIColor(red: 4/255.0, green: 178/255.0, blue: 217/255.0, alpha: 1)
        cell.textLabel?.textColor = UIColor.blackColor()
        let _productDic : NSMutableDictionary = (productArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
        LogModel.getInstance.insertLog("用户点击了：" + (_productDic.objectForKey("cname") as! String) + "（" + (_productDic.objectForKey("ename") as! String) + "）")
//        self.delegate?.getSelectedProduct(
//            (productArr?.objectAtIndex(indexPath.row as Int) as? NSMutableDictionary)!
//        )
    }
}
