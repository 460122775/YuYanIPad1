//
//  ConfigView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/26/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ConfigView : UIView
{
    @IBOutlet var mapFileSizeLabel: UILabel!
    @IBOutlet var clearMapCacheBtn: UIButton!
    @IBOutlet var productSizeLabel: UILabel!
    @IBOutlet var clearProductCacheBtn: UIButton!
    @IBOutlet var productCacheLineImg: UIImageView!
    @IBOutlet var productCacheConfigImg: UIImageView!
    @IBOutlet var saveConfigBtn: UIButton!
    
    override init(frame : CGRect)
    {
        super.init(frame:frame)
    }
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect : CGRect)
    {
        super.drawRect(rect)
    }
    
    func setViewByData()
    {
        productSizeLabel.text = "\(Double(CacheManageModel.getInstance.getCacheSizeForProductFile()) / 1000.00)" + "  /  " + "1024000  KB"
    }
    
    @IBAction func clearProductFileCache(sender: AnyObject)
    {
        CacheManageModel.getInstance.clearCacheForProductFile()
        setViewByData()
    }
}