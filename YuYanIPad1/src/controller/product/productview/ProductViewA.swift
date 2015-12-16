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
    }
    
    func drawProductImg(_productDic : NSMutableDictionary?)
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
            return
        }
        SwiftNotice.showText("\(currentProductDic?.objectForKey("name") as! String)")
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