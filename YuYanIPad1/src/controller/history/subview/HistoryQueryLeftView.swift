//
//  HistoryLeftView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/25/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryQueryLeftViewProtocol
{
    func initProductInfoByData()
    func chooseProductControl()
    func returnBackToChoice()
    func selectedProductControl(selectedProductDic : NSMutableDictionary)
    func showElevationChoiceView()
}

class HistoryQueryLeftView : UIView, HistoryResultProtocol
{
    @IBOutlet var segmentControl: UISegmentedControl!
    var historyQueryLeftViewProtocol : HistoryQueryLeftViewProtocol?

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
            if self.historyQueryLeftViewProtocol != nil
            {
                self.historyQueryLeftViewProtocol?.initProductInfoByData()
            }
        }
    }
    
    func showQueryResult(selectProductConfigDir : NSMutableDictionary, startTimeStr : String, endTimeStr : String)
    {
        self.segmentControl.selectedSegmentIndex = 0;
        self.segmentControlChanged(self.segmentControl)
        self.historyResultView?.changResultTitle(selectProductConfigDir, startTimeStr: startTimeStr, endTimeStr: endTimeStr)
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
    
    func setProductViewByProductDic(productDic : NSMutableDictionary)
    {
        self.historyResultView?.setSelectedProductDic(productDic)
    }
    
    func setElevationValue(elevationValue : Float32)
    {
        self.historyResultView?.setElevationValueBtnLb(elevationValue)
    }
    
    // History Result Protocol.
    func chooseProductControl()
    {
        if historyQueryLeftViewProtocol != nil
        {
            historyQueryLeftViewProtocol?.chooseProductControl()
        }
    }
    
    func returnBackToChoice()
    {
        if historyQueryLeftViewProtocol != nil
        {
            historyQueryLeftViewProtocol?.returnBackToChoice()
        }
    }
    
    func selectedProductControl(selectedProductDic: NSMutableDictionary)
    {
        if historyQueryLeftViewProtocol != nil
        {
            historyQueryLeftViewProtocol?.selectedProductControl(selectedProductDic)
        }
    }
    
    func showElevationChoiceView()
    {
        self.historyQueryLeftViewProtocol!.showElevationChoiceView()
    }
}
