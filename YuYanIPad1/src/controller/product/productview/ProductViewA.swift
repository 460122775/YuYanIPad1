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

protocol ProductViewADelegate
{
    func swipeUpControl()
    func swipeDownControl()
    func swipeLeftControl()
    func swipeRightControl()
}

class ProductViewA: UIView, MGLMapViewDelegate, CLLocationManagerDelegate
{
//    var mapView : RMMapView!

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var productContainerView: UIView!
    @IBOutlet var productImgVIew: UIImageView!
    @IBOutlet var distanceCircleImgView: UIImageView!
    @IBOutlet var colorImgView: UIImageView!
    @IBOutlet var colorContainerView: ColorBarHorizontalView!

    var productViewADelegate : ProductViewADelegate?
    var currentProductDic : NSMutableDictionary?
    var currentColorDataArray : NSMutableArray?
    var currentProductModel : ProductModel?
    var currentProductData : NSData?
    var radarPosition : CGPoint!
    
    var locationManager : CLLocationManager?
    var currentLocation : CLLocationCoordinate2D?
    
    var pinchGesture : UIPinchGestureRecognizer?
    var panGesture : UIPanGestureRecognizer?
    var swipeRightGesture : UISwipeGestureRecognizer?
    var swipeLeftGesture : UISwipeGestureRecognizer?
    var swipeUpGesture : UISwipeGestureRecognizer?
    var swipeDownGesture : UISwipeGestureRecognizer?
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect)
    {
        // Set Map View.
//        RMConfiguration.sharedInstance().accessToken = "pk.eyJ1IjoiZGFpeWFjaGVuIiwiYSI6ImJWOVQxREEifQ.FZG-Svwggu-ykrXu7rEhyg"
//        self.mapView = RMMapView(frame: self.bounds)
//        self.mapView.tileSource = RMMapboxSource(mapID: "daiyachen.k71impl7")
//        self.mapView = MGLMapView(frame: self.bounds)
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.mapView.zoomLevel = 10
        self.mapView.delegate = self
        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(39.915168,116.403875),animated:true)
//        self.mapContainerView.addSubview(mapView)
//        self.mapView.zoom = 8
        // Set default location.
        radarPosition = CGPointMake(self.productImgVIew.frame.width / 2, self.productImgVIew.frame.height / 2)
        self.initGestureReconizer(true)
    }
    
    func initGestureReconizer(isAddGestureReconizer : Bool)
    {
        if isAddGestureReconizer == true
        {
            // Zoom.
            if pinchGesture == nil
            {
                pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ProductViewA.handlePinchGesture(_:)))
            }
            self.productImgVIew.addGestureRecognizer(pinchGesture!)
            // Drag.
            if panGesture == nil
            {
                panGesture = UIPanGestureRecognizer(target: self, action: #selector(ProductViewA.handlePanGesture(_:)))
                panGesture!.minimumNumberOfTouches = 1
                panGesture!.maximumNumberOfTouches = 1
            }
            self.productImgVIew.addGestureRecognizer(panGesture!)
            // To Right.
            if swipeRightGesture == nil
            {
                swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeLRGesture(_:)))
                swipeRightGesture!.numberOfTouchesRequired = 2
            }
            self.productImgVIew.addGestureRecognizer(swipeRightGesture!)
            // To Left
            if swipeLeftGesture == nil
            {
                swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeLRGesture(_:)))
                swipeLeftGesture!.numberOfTouchesRequired = 2
                swipeLeftGesture!.direction = UISwipeGestureRecognizerDirection.Left
            }
            self.productImgVIew.addGestureRecognizer(swipeLeftGesture!)
            // To Up.
            if swipeUpGesture == nil
            {
                swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeUDGesture(_:)))
                swipeUpGesture!.numberOfTouchesRequired = 2
                swipeUpGesture!.direction = UISwipeGestureRecognizerDirection.Up

            }
            self.productImgVIew.addGestureRecognizer(swipeUpGesture!)
            // To Down.
            if swipeDownGesture == nil
            {
                swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeUDGesture(_:)))
                swipeDownGesture!.numberOfTouchesRequired = 2
                swipeDownGesture!.direction = UISwipeGestureRecognizerDirection.Down
            }
            self.productImgVIew.addGestureRecognizer(swipeDownGesture!)
        }else{
            self.productImgVIew.removeGestureRecognizer(pinchGesture!)
            self.productImgVIew.removeGestureRecognizer(panGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeRightGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeLeftGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeUpGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeDownGesture!)
        }
    }
    
    func handlePinchGesture(sender: UIPinchGestureRecognizer)
    {
        if currentProductModel == nil
        {
            return
        }
        // Pinch finished.
        if sender.state == UIGestureRecognizerState.Ended
        {
            let factor = sender.scale
            if factor > 1
            {
                // Zoom out.
                self.currentProductModel?.zoomValue += Double(0.4 * factor)
            }else{
                // Zoom in.
                self.currentProductModel?.zoomValue -= Double(0.4 * (1 - factor) * 6)
            }
            if self.currentProductModel?.zoomValue > 10
            {
                self.currentProductModel?.zoomValue = 10
            }else if self.currentProductModel?.zoomValue < 0.6{
                self.currentProductModel?.zoomValue = 1
            }
            self.drawProductImg(self.currentProductDic, data: self.currentProductData!)
        }
    }
    
    var fromLocation : CGPoint!
    var toLocation : CGPoint!
    func handlePanGesture(sender: UIPanGestureRecognizer)
    {
        if currentProductDic == nil || currentProductData == nil || currentColorDataArray == nil
        {
            return
        }
        
        let translation : CGPoint = sender.locationInView(self)
        if sender.state == UIGestureRecognizerState.Changed
        {
            UIView.animateWithDuration(0.1) { () -> Void in
                self.productImgVIew.frame.origin = CGPointMake(translation.x - self.fromLocation.x, translation.y - self.fromLocation.y)
            
//                self.mapView.moveBy(CGSizeMake(self.toLocation.x - translation.x, self.toLocation.y - translation.y))
                self.toLocation = translation
            }
        }else if sender.state == UIGestureRecognizerState.Began{
            fromLocation = translation
            toLocation = translation
        }else if sender.state == UIGestureRecognizerState.Ended && sender.state != UIGestureRecognizerState.Failed{
            self.radarPosition.x += self.productImgVIew.frame.origin.x
            self.radarPosition.y += self.productImgVIew.frame.origin.y
            self.productImgVIew.frame.origin = CGPointMake(0, 0)
            currentProductModel?.radarPosition.x = radarPosition.x
            currentProductModel?.radarPosition.y = radarPosition.y
            currentProductModel?.getImageData(self.productImgVIew, andData: currentProductData, colorArray: self.currentColorDataArray)
            // Set map bounds.
//            self.setMapByCoordinateBounds(
//                (self.currentProductModel?.radarMerPosition)!,
//                radarCoordinate: (self.currentProductModel?.radarCoordinate)!,
//                productImgView: self.productImgVIew,
//                detM: CGFloat((self.currentProductModel?._detM)!)
//            )
        }
    }
    
    func handleSwipeLRGesture(sender: UISwipeGestureRecognizer)
    {
        let direction = sender.direction
        if direction == UISwipeGestureRecognizerDirection.Left
        {
            productViewADelegate?.swipeLeftControl()
        }else if direction == UISwipeGestureRecognizerDirection.Right{
            productViewADelegate?.swipeRightControl()
        }
    }
    
    func handleSwipeUDGesture(sender: UISwipeGestureRecognizer)
    {
        let direction = sender.direction
        if direction == UISwipeGestureRecognizerDirection.Up
        {
            productViewADelegate?.swipeUpControl()
        }else if direction == UISwipeGestureRecognizerDirection.Down{
            productViewADelegate?.swipeDownControl()
        }
    }
    
    func drawProductImg(_productDic : NSMutableDictionary?, data : NSData)
    {
        if _productDic == nil
        {
            self.colorContainerView.hidden = true
            self.productContainerView.userInteractionEnabled = false
            return
        }
        // Draw Color & create color data array.
        if currentProductDic == nil ||
            ((currentProductDic?.objectForKey("type") as! NSNumber).intValue != (_productDic?.objectForKey("type") as! NSNumber).intValue)
        {
            let _data =  ColorModel.drawColorImg(_productDic?.objectForKey("colorFile") as! String, colorImgView: colorImgView)
            self.colorImgView.image = _data.image
            self.colorContainerView.hidden = false
            if currentColorDataArray != nil
            {
                currentColorDataArray?.removeAllObjects()
            }
            currentColorDataArray = _data.colorDataArray
            if currentColorDataArray == nil || currentColorDataArray?.count == 0
            {
                SwiftNotice.showNoticeWithText(NoticeType.error, text: "该产品的色标配置出错，无法显示图像！", autoClear: true, autoClearTime: 3)
                return
            }
        }
        // Attention this line !!! 
        currentProductDic = _productDic
        currentProductData = data
        // Get current product model.
        if currentProductModel == nil || currentProductModel?.productType != (_productDic?.objectForKey("type") as! NSNumber).intValue
        {
            currentProductModel = ProductFactory.getModelByType((_productDic?.objectForKey("type") as! NSNumber).longLongValue)
        }
        // Not Support.
        if currentProductModel == nil
        {
            SwiftNotice.showNoticeWithText(NoticeType.error, text: "对不起，暂时不支持此产品！", autoClear: true, autoClearTime: 3)
            return
        }else{
            currentProductModel?.clearContent()
            radarPosition = CGPointMake(self.productImgVIew.frame.width / 2, self.productImgVIew.frame.height / 2)
            currentProductModel?.radarPosition = radarPosition!
            currentProductModel?.initData(data, withProductImgView: self.productImgVIew)
        }
        print("05:" + String(NSDate().timeIntervalSince1970))
        currentProductModel?.getImageData(self.productImgVIew, andData: data, colorArray: self.currentColorDataArray)
        // Set map bounds.
        self.mapView?.setCenterCoordinate((self.currentProductModel?.radarCoordinate)!, animated: true)
        self.setMapByCoordinateBounds((self.currentProductModel?.radarMerPosition)!, radarCoordinate: (self.currentProductModel?.radarCoordinate)!, productImgView: self.productImgVIew, detM: CGFloat((self.currentProductModel?._detM)!))
        self.productContainerView.userInteractionEnabled = true
    }
    
    var updateMapCenterByLocation : Bool = false
    func setUserLocationVisible(visible : Bool, _updateMapCenterByLocation : Bool)
    {
        updateMapCenterByLocation = _updateMapCenterByLocation
        if locationManager == nil
        {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager?.distanceFilter = 500
            locationManager?.requestWhenInUseAuthorization()
        }
        if visible == true || updateMapCenterByLocation
        {
            locationManager?.startUpdatingLocation()
        }else{
            locationManager?.stopUpdatingLocation()
        }
        if currentLocation != nil
        {
            self.mapView.showsUserLocation = visible
        }
    }
    
    func saveCurrentLocation()
    {
        currentLocation = self.mapView.centerCoordinate
    }
    
    func setMapCenerByCurrentLocation()
    {
//        self.mapView.setCenterCoordinate(currentLocation!, animated: false)
    }
    
    // CLLocationManagerDelegate.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations[0].coordinate
        if updateMapCenterByLocation == true
        {
            updateMapCenterByLocation = false
//            self.mapView.setCenterCoordinate((currentLocation)!, animated: true)
            locationManager?.stopUpdatingLocation()
        }
    }
    
//    func getMapCenterCoordinate(productModel : ProductModel?) -> CLLocationCoordinate2D
//    {
//        let posDis : CGPoint = CGPointMake(self.productImgVIew.frame.size.width / 2 - (productModel?.radarPosition.x)!,
//                                            self.productImgVIew.frame.size.height / 2 - (productModel?.radarPosition.y)!)
//        let centerMerPositon : CGPoint = CGPointMake(posDis.x * CGFloat(productModel!._detM) + (productModel?.radarMerPosition.x)!,
//                                            (productModel?.radarMerPosition.y)! - posDis.y * CGFloat(productModel!._detM))
//        let x : Double = Double(centerMerPositon.x) / Double(EquatorR) / M_PI * 180
//        var y : Double = Double(centerMerPositon.y) / Double(EquatorR) / M_PI * 180
//        y = 180 / M_PI * (2 * atan(exp(y * M_PI / 180)) - M_PI / 2)
//        return CLLocationCoordinate2DMake(y, x)
//    }

//    func setMapByMerBounds(radarMerPos : CGPoint, radarCoordinate : CLLocationCoordinate2D, productImgView : UIImageView, detM : CGFloat)
//    {
//        let swLa : CLLocationDegrees = CLLocationDegrees(radarMerPos.y - productImgVIew.frame.size.height / 2 * detM)
//        let swLo : CLLocationDegrees = CLLocationDegrees(radarMerPos.x - productImgVIew.frame.size.width / 2 * detM)
//        let neLa : CLLocationDegrees = CLLocationDegrees(radarMerPos.y + productImgVIew.frame.size.height / 2 * detM)
//        let neLo : CLLocationDegrees = CLLocationDegrees(radarMerPos.x + productImgVIew.frame.size.width / 2 * detM)
//        self.mapView?.setProjectedConstraintsSouthWest(RMProjectedPointMake(swLo, swLa), northEast: RMProjectedPointMake(neLo, neLa))
//        self.mapView?.setProjectedBounds(RMProjectedRectMake(Double(swLo), Double(swLa), Double(neLo - swLo) / 1000, Double(neLa - swLa) / 1000), animated: false)
//    }

    func setMapByCoordinateBounds(radarMerPos : CGPoint, radarCoordinate : CLLocationCoordinate2D, productImgView : UIImageView, detM : CGFloat)
    {
        var swLa : CLLocationDegrees = CLLocationDegrees(radarMerPos.y - productImgVIew.frame.size.height / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
        swLa = 180 / M_PI * (2 * atan(exp(swLa * M_PI / 180)) - M_PI / 2)
        let swLo : CLLocationDegrees = CLLocationDegrees(radarMerPos.x - productImgVIew.frame.size.width / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
        var neLa : CLLocationDegrees = CLLocationDegrees(radarMerPos.y + productImgVIew.frame.size.height / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
        neLa = 180 / M_PI * (2 * atan(exp(neLa * M_PI / 180)) - M_PI / 2)
        let neLo : CLLocationDegrees = CLLocationDegrees(radarMerPos.x + productImgVIew.frame.size.width / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
//        self.mapView.zoomWithLatitudeLongitudeBoundsSouthWest(CLLocationCoordinate2DMake(swLa, swLo), northEast: CLLocationCoordinate2DMake(neLa, neLo), animated: false)
    }
}