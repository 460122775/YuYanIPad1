//
//  ColorModel.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 12/4/15.
//  Copyright © 2015 cdyw. All rights reserved.
//

import UIKit
import SQLite

class ColorModel: NSObject {
    
    class func getColorData(colorFile : String) -> NSMutableDictionary?
    {
        if NSUserDefaults.standardUserDefaults().objectForKey(INITDATABASE) != nil
        {
            do{
                // Get color data from database.
                var colorDic : NSMutableDictionary? = nil
                let db = try Connection("\(PATH_DATABASE)\(DATABASE_NAME)")
                let colorTable = Table("color_info")
                // Fetch data from db.
                for color in try db.prepare(colorTable.filter(
                    (Expression<String?>("fileName") == colorFile) && (Expression<Int64>("enable") == 1)).limit(1))
                {
                    colorDic = NSMutableDictionary()
                    colorDic!.setValue(NSNumber(longLong: color[Expression<Int64>("colorId")]), forKey: "colorId")
                    colorDic!.setValue(NSNumber(longLong: color[Expression<Int64>("productType")]), forKey: "productType")
                    colorDic!.setValue(NSNumber(longLong: color[Expression<Int64>("colorType")]), forKey: "colorType")
                    colorDic!.setValue(NSNumber(longLong: color[Expression<Int64>("enable")]), forKey: "enable")
                    colorDic!.setValue(color[Expression<String?>("fileName")], forKey: "fileName")
                    colorDic!.setValue(color[Expression<String?>("scaleStr")], forKey: "scaleStr")
                    colorDic!.setValue(color[Expression<String?>("unitStr")], forKey: "unitStr")
                    colorDic!.setValue(color[Expression<String?>("rgbnStr")], forKey: "rgbnStr")
                    return colorDic!
                }
                LogModel.getInstance.insertLog("Get color info from database : \(colorDic)")
                return nil
            }catch let error as NSError{
                LogModel.getInstance.insertLog("ColorModel: Database Error. [err:\(error)]")
                return nil
            }
        }else{
            return nil
        }
    }
    
    class func drawColorImg(colorFile : String, colorImgView : UIImageView) -> (image : UIImage?, colorDataArray : NSMutableArray?)
    {
        // Get color data.
        let colorDic : NSMutableDictionary? = getColorData(colorFile)
        var rgbnArr : [NSString] = (colorDic?.objectForKey("rgbnStr") as! NSString).componentsSeparatedByString(",")
        let scaleArr : [String] = (colorDic?.objectForKey("scaleStr") as! String).componentsSeparatedByString(",")
        let unitStr : String? = colorDic?.objectForKey("unitStr") as? String
        let colorType : Int32 = (colorDic?.objectForKey("colorType") as! NSNumber).intValue
        if rgbnArr.count == 0 || scaleArr.count == 0
        {
            return (nil, nil)
        }
        // Defination.
        let paddingLeft : CGFloat = 10
        var paddingRight : CGFloat = 5 + 30 + 10   // gap + unit width + paddingRight
        let paddingTop : CGFloat = 8
        let paddingButtom : CGFloat = 10
        let boundWidth : CGFloat = colorImgView.frame.width - paddingLeft - paddingRight
        let boundHeight : CGFloat = colorImgView.frame.height - paddingTop - paddingButtom
        var blockWidth : CGFloat = 0
        // Get context.
        UIGraphicsBeginImageContext(colorImgView.frame.size)
        let context : CGContextRef? =  UIGraphicsGetCurrentContext()//获取画笔上下文
        CGContextSetAllowsAntialiasing(context, true) //抗锯齿设置
        // Draw unit.
        if unitStr != nil || unitStr?.isEmpty.boolValue == false
        {
            unitStr!.drawInRect(CGRectMake(colorImgView.frame.width - paddingRight, paddingTop + 2, 60, boundHeight - 4), withAttributes: [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(15),
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ])
        }else{
            paddingRight = paddingLeft
        }
        if colorType == 1
        {
            blockWidth = (colorImgView.frame.width - paddingLeft - paddingRight - 10) / CGFloat(scaleArr.count - 1)
            for i in 0 ..< scaleArr.count - 1
            {
                // Draw color.
                CGContextSetFillColorWithColor(context,
                    UIColor(red:CGFloat(rgbnArr[4 + i * 4].floatValue / 256.0), green: CGFloat(rgbnArr[4 + i * 4 + 1].floatValue / 256.0), blue: CGFloat(rgbnArr[4 + i * 4 + 2].floatValue / 256.0), alpha: 0.6).CGColor)
                CGContextFillRect(context, CGRectMake(paddingLeft + 1 + CGFloat(i) * blockWidth, paddingTop + 1, blockWidth - 1, boundHeight - 9));
                // Draw scale.
                scaleArr[i].drawInRect(CGRectMake(2 + blockWidth * CGFloat(i), boundHeight + 3, blockWidth, 10), withAttributes: [
                    NSFontAttributeName : UIFont.systemFontOfSize(10),
                    NSForegroundColorAttributeName: UIColor.whiteColor()
                    ])
                // Draw line.
                CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
                CGContextMoveToPoint(context, paddingLeft + CGFloat(i) * blockWidth + 0.5, paddingTop)
                CGContextAddLineToPoint(context, paddingLeft + CGFloat(i) * blockWidth + 0.5, paddingTop + boundHeight - 8)
                CGContextStrokePath(context)
            }
            // Draw last scale.
            scaleArr[scaleArr.count - 1].drawInRect(CGRectMake(2 + blockWidth * CGFloat(scaleArr.count - 1), boundHeight + 3, blockWidth, 10), withAttributes: [
                NSFontAttributeName : UIFont.systemFontOfSize(10),
                NSForegroundColorAttributeName: UIColor.whiteColor()
            ])
        }else if colorType == 2{
            blockWidth = (colorImgView.frame.width - paddingLeft - paddingRight - 10) / CGFloat(scaleArr.count)
            for i in 0 ..< scaleArr.count
            {
                // Draw color.
                CGContextSetFillColorWithColor(context,
                    UIColor(red:CGFloat(rgbnArr[i * 4].floatValue / 256.0), green: CGFloat(rgbnArr[i * 4 + 1].floatValue / 256.0), blue: CGFloat(rgbnArr[i * 4 + 2].floatValue / 256.0), alpha: 0.6).CGColor)
                CGContextFillRect(context, CGRectMake(paddingLeft + 1 + CGFloat(i) * blockWidth, paddingTop + 0.5, blockWidth - 1, boundHeight - 9));
                // Draw scale.
                scaleArr[i].drawInRect(CGRectMake(paddingLeft + blockWidth * CGFloat(i), boundHeight + 3, blockWidth, 10), withAttributes: [
                    NSFontAttributeName : UIFont.systemFontOfSize(10),
                    NSForegroundColorAttributeName: UIColor.whiteColor()
                    ])
                // Draw line.
                CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
                CGContextMoveToPoint(context, paddingLeft + CGFloat(i) * blockWidth + 0.5, paddingTop)
                CGContextAddLineToPoint(context, paddingLeft + CGFloat(i) * blockWidth + 0.5, paddingTop + boundHeight - 8)
                CGContextStrokePath(context)
            }
        }
        // Draw bounds.
        let radius : CGFloat = 3
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 1) //设置画笔宽度
        CGContextMoveToPoint(context, boundWidth, boundHeight - 5)  // 开始坐标右边开始
        CGContextAddArcToPoint(context, boundWidth, boundHeight, boundWidth - 5, boundHeight, radius)  // 右下角角度
        CGContextAddArcToPoint(context, paddingLeft, boundHeight, paddingLeft, boundHeight - 5, radius) // 左下角角度
        CGContextAddArcToPoint(context, paddingLeft, paddingTop, boundWidth - 5, paddingTop, radius) // 左上角
        CGContextAddArcToPoint(context, boundWidth, paddingTop, boundWidth, boundHeight - 5, radius) // 右上角
        CGContextClosePath(context)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke) //根据坐标绘制路径
        // Finish drawing.
        let colorImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Create colorArray.
        let colorDataArray : NSMutableArray = NSMutableArray()
        var colorDataTempArray : NSArray? = nil
        for i : Int in 0 ..< rgbnArr.count / 4
        {
            // Create color array of 256 length.
            for _ : Int32 in 0 ..< rgbnArr[i * 4 + 3].intValue
            {
                colorDataTempArray = NSArray(objects:
                    NSNumber(float: rgbnArr[i * 4 + 0].floatValue / 256.0),
                    NSNumber(float: rgbnArr[i * 4 + 1].floatValue / 256.0),
                    NSNumber(float: rgbnArr[i * 4 + 2].floatValue / 256.0)
                )
                colorDataArray.addObject(colorDataTempArray!)
            }
        }
        return (colorImg, colorDataArray)
    }
}
