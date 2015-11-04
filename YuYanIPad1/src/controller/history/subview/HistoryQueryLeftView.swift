//
//  HistoryLeftView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class HistoryQueryLeftView : UIView, HistoryResultProtocol
{
    @IBOutlet var segmentControl: UISegmentedControl!
    var historyResultProtocolDelegate : HistoryResultProtocol?

    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
    }
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    var historyResultView : HistoryResultView?
    var productInfoView : ProductInfoView?
    @IBAction func segmentControlChanged(sender: UISegmentedControl)
    {
        if self.segmentControl.selectedSegmentIndex == 0
        {
            if self.historyResultView == nil
            {
                self.historyResultView = (NSBundle.mainBundle().loadNibNamed("HistoryResultView", owner: self, options: nil) as NSArray).lastObject as? HistoryResultView
                self.historyResultView?.frame.origin = CGPointMake(15, 50)
                self.historyResultView?.delegate = self
            }
            if self.productInfoView != nil
            {
                self.productInfoView?.removeFromSuperview()
            }
            self.addSubview(self.historyResultView!)
        }else{
            if self.productInfoView == nil
            {
                self.productInfoView = (NSBundle.mainBundle().loadNibNamed("ProductInfoView", owner: self, options: nil) as NSArray).lastObject as? ProductInfoView
                self.productInfoView?.frame.origin = CGPointMake(15, 50)
            }
            if self.historyResultView != nil
            {
                self.historyResultView?.removeFromSuperview()
            }
            self.addSubview(self.productInfoView!)
        }
    }
    
    func showQueryResult()
    {
        self.segmentControl.selectedSegmentIndex = 0;
        self.segmentControlChanged(self.segmentControl)
    }
    
    // History Result Protocol.
    func chooseProductControl()
    {
        if historyResultProtocolDelegate != nil
        {
            historyResultProtocolDelegate?.chooseProductControl()
        }
    }
    
    func returnBackToChoice()
    {
        if historyResultProtocolDelegate != nil
        {
            historyResultProtocolDelegate?.returnBackToChoice()
        }
    }
}
