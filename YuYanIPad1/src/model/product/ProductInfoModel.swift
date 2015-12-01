//
//  ProductInfoModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 11/20/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit

class ProductInfoModel: NSObject {

    static func getDataDateString(data : NSData) -> String
    {
        var year : CUnsignedShort = 0
        var month : CUnsignedShort = 0
        var day : CUnsignedShort = 0
        let offset : Int = 204
        data.getBytes(&year, range: NSMakeRange(offset, sizeof(CUnsignedShort)))
        data.getBytes(&month, range: NSMakeRange(offset + 2, sizeof(CUnsignedShort)))
        data.getBytes(&day, range: NSMakeRange(offset + 4, sizeof(CUnsignedShort)))
        var dateStr : String = "\(year)"
        if month < 10
        {
            dateStr = dateStr.stringByAppendingString("-0\(month)")
        }else{
            dateStr = dateStr.stringByAppendingString("-\(month)")
        }
        if day < 10
        {
            return dateStr.stringByAppendingString("-0\(day)")
        }else{
            return dateStr.stringByAppendingString("-\(day)")
        }
    }
    
    static func getDataTimeString(data : NSData) -> String
    {
        var headlen : Int16 = 0
        var hour : CUnsignedShort = 0
        var minute : CUnsignedShort = 0
        var second : CUnsignedShort = 0
        let offeset : Int = 210

        data.getBytes(&headlen, range: NSMakeRange(0, 2))
        data.getBytes(&hour, range: NSMakeRange(offeset, sizeof(CUnsignedShort)))
                hour = hour.littleEndian
        data.getBytes(&minute, range: NSMakeRange(offeset + 2, sizeof(CUnsignedShort)))
        data.getBytes(&second, range: NSMakeRange(offeset + 4, sizeof(CUnsignedShort)))
        
        var timeStr : String = ""
        if hour < 10
        {
            timeStr = timeStr.stringByAppendingString("0\(hour)")
        }else{
            timeStr = timeStr.stringByAppendingString("\(hour)")
        }
        if minute < 10
        {
            timeStr = timeStr.stringByAppendingString(":0\(minute)")
        }else{
            timeStr = timeStr.stringByAppendingString(":\(minute)")
        }
        if second < 10
        {
            return timeStr.stringByAppendingString(":0\(second)")
        }else{
            return timeStr.stringByAppendingString(":\(second)")
        }
    }
}

