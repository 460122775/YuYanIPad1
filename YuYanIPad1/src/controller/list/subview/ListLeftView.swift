//
//  ProductLeftView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol ListLeftViewProtocol
{
    func chooseProductFromLeftList(selectedProductDic: NSMutableDictionary?)
    func initProductInfoByData()
}

class ListLeftView: UIView, ListListProtocol
{
    @IBOutlet var segmentControl: UISegmentedControl!
 
    override init(frame: CGRect)
    {
        super.init(frame:frame)
    }
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }

    var listListView : ListListView?
    var productInfoView : ProductInfoView?
    var listLeftViewDelegate : ListLeftViewProtocol?

    @IBAction func segmentControlChanged(sender: UISegmentedControl)
    {
        if self.segmentControl.selectedSegmentIndex == 0
        {
            if self.listListView == nil
            {
                self.listListView = (NSBundle.mainBundle().loadNibNamed("ListListView", owner: self, options: nil) as NSArray).lastObject as? ListListView
                self.listListView?.frame.origin = CGPointMake(15, 50)
                self.listListView?.listListDelegate = self
            }
            if self.productInfoView != nil
            {
                self.productInfoView?.removeFromSuperview()
            }
            self.addSubview(self.listListView!)
        }else{
            if self.productInfoView == nil
            {
                self.productInfoView = (NSBundle.mainBundle().loadNibNamed("ProductInfoView", owner: self, options: nil) as NSArray).lastObject as? ProductInfoView
                self.productInfoView?.frame.origin = CGPointMake(15, 50)
            }
            if self.listListView != nil
            {
                self.listListView?.removeFromSuperview()
            }
            self.addSubview(self.productInfoView!)
            if self.listLeftViewDelegate != nil
            {
                self.listLeftViewDelegate?.initProductInfoByData()
            }
        }
    }
    
    func setProductLeftViewByData(data : NSData)
    {
        if self.segmentControl == nil
        {
            return
        }
        if self.segmentControl.selectedSegmentIndex == 1
        {
            if self.productInfoView != nil
            {
                self.productInfoView?.setViewValueByData(data)
            }
        }
    }
    
    func refreshListTable()
    {
        if self.listListView != nil
        {
            self.listListView?.initViewByData()
        }
    }
    
    // ListListProtocol
    func productSelectControl(productDic : NSMutableDictionary)
    {
        if self.listLeftViewDelegate != nil
        {
            self.listLeftViewDelegate?.chooseProductFromLeftList(productDic)
        }
    }
}
