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
}

class HistoryResultView : UIView
{
    var delegate : HistoryResultProtocol?
    var historyProductData : NSMutableArray?
    var currentPageVo : PageVo?
    var selectedProductDic : NSMutableDictionary?
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "setViewByHistoryProductData:",
            name: "\(HISTORYPRODUCT)\(SELECT)\(SUCCESS)",
            object: nil)
    }
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
    }
    
    func setViewByHistoryProductData(notification : NSNotification?) -> Void
    {
        let resultStr : String = notification!.valueForKey("result") as! String
        if resultStr == FAIL
        {
            
        }else{
            
        }
    }
    
    @IBAction func returnBtnClick(sender: UIButton)
    {
        if delegate != nil
        {
            delegate?.returnBackToChoice()
        }
    }
}