//
//  ProductView.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 3/20/15.
//  Copyright (c) 2015 cdyw. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

class ProductViewA: UIView, MGLMapViewDelegate
{
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var productImgVIew: UIImageView!
    @IBOutlet var distanceCircleImgView: UIImageView!
    @IBOutlet var colorImgView: UIImageView!
    
    var currentProductDic : NSMutableDictionary?
    var currentColorDataArray : NSMutableArray?
    var currentProductModel : ProductModel?
    var currentProductData : NSData?
    var radarPointX : Int32 = 0
    var radarPointY : Int32 = 0
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect)
    {
        self.mapView.styleURL = NSURL(string: "mapbox://styles/daiyachen/cih5ysabn0035bnm5ahtdnokf")
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.mapView.allowsRotating = false

        // set the map's center coordinate
        self.mapView.setCenterCoordinate(
            CLLocationCoordinate2D(latitude: 30.67, longitude: 104.06),
            zoomLevel: 12, animated: false)
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        radarPointX = Int32(self.productImgVIew.frame.width) / 2
        radarPointY = Int32(self.productImgVIew.frame.height) / 2
    }
    
    func drawProductImg(_productDic : NSMutableDictionary?, data : NSData)
    {
        if _productDic == nil
        {
            return
        }
        // Draw Color & create color data array.
        if currentProductDic == nil ||
            ((currentProductDic?.objectForKey("type") as! NSNumber).intValue != (_productDic?.objectForKey("type") as! NSNumber).intValue)
        {
            let data =  ColorModel.drawColorImg((_productDic?.objectForKey("type") as! NSNumber).intValue, colorImgView: colorImgView)
            self.colorImgView.image = data.image
            if currentColorDataArray != nil
            {
                currentColorDataArray?.removeAllObjects()
            }
            currentColorDataArray = data.colorDataArray
        }
        // Attention this line !!! 
        currentProductDic = _productDic
        // Draw Product data.
        if currentColorDataArray == nil || currentColorDataArray?.count == 0
        {
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "该产品的色标配置出错，无法显示图像！", autoClear: true, autoClearTime: 3)
            return
        }
//        SwiftNotice.showText("\(currentProductDic?.objectForKey("name") as! String)")
        // Draw Product Data.
        if currentProductModel == nil || currentProductModel?.productType != (_productDic?.objectForKey("type") as! NSNumber).intValue
        {
            currentProductModel = ProductFactory.getModelByType((_productDic?.objectForKey("type") as! NSNumber).longLongValue)
        }
        // Not Support.
        if currentProductModel == nil
        {
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "对不起，暂时不支持此产品！", autoClear: true, autoClearTime: 3)
        }else{
            currentProductModel?.centX = radarPointX
            currentProductModel?.centY = radarPointY
            currentProductModel?.getImageData(self.productImgVIew, andData: data, colorArray: self.currentColorDataArray)
        }
    }
    
    // -- MGLMapViewDelegate
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool
    {
        return true
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool)
    {
        
    }
}