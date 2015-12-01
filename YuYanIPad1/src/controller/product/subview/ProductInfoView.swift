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
        var radarCd : String = ""
        data.getBytes(&radarCd, range: NSMakeRange(2, 20))
        radarCdLabel.text = radarCd
        var siteName : String = ""
        data.getBytes(&siteName, range: NSMakeRange(42, 20))
        siteNameLabel.text = siteName
        
        var longitude : Int32 = 0
        data.getBytes(&longitude, range: NSMakeRange(142, 4))
        longitudeLabel.text = "N \(longitude / 360000)°\((longitude / 100) % 3500 / 60)′\((longitude / 100) % 60)″"
        
        var latitude : Int32 = 0
        data.getBytes(&latitude, range: NSMakeRange(146, 4))
        latitudeLabel.text = "N \(latitude / 360000)°\((latitude / 100) % 3500 / 60)′\((latitude / 100) % 60)″"
        
        var antennaHeight : Int32 = 0
        data.getBytes(&antennaHeight, range: NSMakeRange(150, 4))
        antennaHeightLabel.text = "\(antennaHeight / 1000) m"
        
        var iRefBinLen : u_short = 0
        data.getBytes(&iRefBinLen, range: NSMakeRange(826, 2))
        var usRefBinNumber : u_short = 0
        data.getBytes(&usRefBinNumber, range: NSMakeRange(646, 2))
        let maxDistance : Float32 = Float32(iRefBinLen) * Float32(usRefBinNumber) / 1000.0
        maxDistanceLabel.text = "\(maxDistance) km"
        
        scanDateLabel.text = ProductInfoModel.getDataDateString(data) 
        scanTimeLabel.text = ProductInfoModel.getDataTimeString(data)
        
        distanceResolutionLabel.text = "\(iRefBinLen) m"
        
//        data.getBytes(&scanElevationLabel.text, range: NSMakeRange(2, 20))
//        data.getBytes(&oppositePositionLabel.text, range: NSMakeRange(2, 20))
//        data.getBytes(&oppositeDistanceLabel.text, range: NSMakeRange(2, 20))
    }
}
