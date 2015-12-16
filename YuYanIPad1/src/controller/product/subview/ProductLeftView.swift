//
//  ProductLeftView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ProductLeftView: UIView
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
    
    var productListView : ProductListView?
    var productInfoView : ProductInfoView?
    @IBAction func segmentControlChanged(sender: UISegmentedControl)
    {
        if self.segmentControl.selectedSegmentIndex == 0
        {
            if self.productListView == nil
            {
                self.productListView = (NSBundle.mainBundle().loadNibNamed("ProductListView", owner: self, options: nil) as NSArray).lastObject as? ProductListView
                self.productListView?.frame.origin = CGPointMake(15, 50)
            }
            if self.productInfoView != nil
            {
                self.productInfoView?.removeFromSuperview()
            }
            self.addSubview(self.productListView!)
        }else{
            if self.productInfoView == nil
            {
                self.productInfoView = (NSBundle.mainBundle().loadNibNamed("ProductInfoView", owner: self, options: nil) as NSArray).lastObject as? ProductInfoView
                self.productInfoView?.frame.origin = CGPointMake(15, 50)
            }
            if self.productListView != nil
            {
                self.productListView?.removeFromSuperview()
            }
            self.addSubview(self.productInfoView!)
        }
    }
    
    func setProductLeftViewByData(data : NSData)
    {
        if self.segmentControl.selectedSegmentIndex == 1
        {
            if self.productInfoView != nil
            {
                self.productInfoView?.setViewValueByData(data)
            }
        }
    }
    
    func setProductAddress(productEname : String, productAddress : String)
    {
        if self.productListView == nil
        {
            return
        }else{
            self.productListView!.setProductAddress(productEname, productAddress: productAddress)
        }
    }
}
