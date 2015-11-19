//
//  ProductInfoView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit

class ProductInfoView: UIView
{
    @IBOutlet var radarCdLabel: UILabel!
    @IBOutlet var siteNameLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var antennaHeightLabel: UILabel!
    @IBOutlet var maxDistanceLabel: UILabel!
    
    @IBOutlet var scanDateLabel: UILabel!
    @IBOutlet var scanTimeLabel: UILabel!
    @IBOutlet var scanElevationLabel: UILabel!
    @IBOutlet var distanceResolutionLabel: UILabel!
    @IBOutlet var oppositePositionLabel: UILabel!
    @IBOutlet var oppositeDistanceLabel: UILabel!
    
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect : CGRect)
    {
        
    }
    
    func setViewValueByData(data : NSData)
    {
//        data.getBytes(&radarCdLabel.text, range: NSmake)
    }
}
