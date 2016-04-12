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
    var locationManager : CLLocationManager?
    var currentProductDic : NSMutableDictionary?
    var currentColorDataArray : NSMutableArray?
    var currentProductModel : ProductModel?
    var currentProductData : NSData?
    var currentColorImg : UIImage?
    var currentLocation : CLLocationCoordinate2D?
    
    var radarPosition : CGPoint!
    var productImgBounds : MGLCoordinateBounds!
    var lastZoomValue : Double = 0
    var isFirstTime : Bool = true
    
    var pinchGesture : UIPinchGestureRecognizer?
    var panGesture : UIPanGestureRecognizer?
    var swipeRightGesture : UISwipeGestureRecognizer?
    var swipeLeftGesture : UISwipeGestureRecognizer?
    var swipeUpGesture : UISwipeGestureRecognizer?
    var swipeDownGesture : UISwipeGestureRecognizer?
    
    let ZOOM : Double = 8
    
    required init?(coder : NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func drawRect(rect: CGRect)
    {
        // Set Map View.
//        RMConfiguration.sharedInstance().accessToken = "pk.eyJ1IjoiZGFpeWFjaGVuIiwiYSI6ImJWOVQxREEifQ.FZG-Svwggu-ykrXu7rEhyg"
//        self.mapView.tileSource = RMMapboxSource(mapID: "daiyachen.k71impl7")
        self.mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.mapView.zoomLevel = ZOOM
        self.mapView.delegate = self
        self.mapView.rotateEnabled = false
        self.mapView.pitchEnabled = false
        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(30.666667,104.066667),animated:true)
        // Set default location.
        radarPosition = CGPointMake(self.productImgVIew.frame.width / 2, self.productImgVIew.frame.height / 2)
        self.initGestureReconizer(true)
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool)
    {
        // Change detM & reDraw product.
        if self.mapView.zoomLevel != lastZoomValue
        {
            lastZoomValue = self.mapView.zoomLevel
//            productImgBounds = self.mapView.convertRect(CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height), toCoordinateBoundsFromView: self.mapView)
//            if self.currentProductModel != nil
//            {
//                self.currentProductModel?.setDetM(productImgBounds.sw, andNE: productImgBounds.ne, andHeight: Float(self.productImgVIew.frame.size.height))
//            }
//            self.currentProductModel?.getImageData(self.productImgVIew, andData: self.currentProductData!, colorArray: self.currentColorDataArray)
        }
    }
    
    func initGestureReconizer(isAddGestureReconizer : Bool)
    {
        if isAddGestureReconizer == true
        {
            // Drag.
//            if panGesture == nil
//            {
//                panGesture = UIPanGestureRecognizer(target: self, action: #selector(ProductViewA.handlePanGesture(_:)))
//                panGesture!.minimumNumberOfTouches = 1
//                panGesture!.maximumNumberOfTouches = 1
//            }
//            self.productImgVIew.addGestureRecognizer(panGesture!)
            // To Right.
            if swipeRightGesture == nil
            {
                swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeLRGesture(_:)))
                swipeRightGesture!.numberOfTouchesRequired = 2
            }
            self.mapView.addGestureRecognizer(swipeRightGesture!)
            // To Left
            if swipeLeftGesture == nil
            {
                swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeLRGesture(_:)))
                swipeLeftGesture!.numberOfTouchesRequired = 2
                swipeLeftGesture!.direction = UISwipeGestureRecognizerDirection.Left
            }
            self.mapView.addGestureRecognizer(swipeLeftGesture!)
            // To Up.
            if swipeUpGesture == nil
            {
                swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeUDGesture(_:)))
                swipeUpGesture!.numberOfTouchesRequired = 2
                swipeUpGesture!.direction = UISwipeGestureRecognizerDirection.Up

            }
            self.mapView.addGestureRecognizer(swipeUpGesture!)
            // To Down.
            if swipeDownGesture == nil
            {
                swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductViewA.handleSwipeUDGesture(_:)))
                swipeDownGesture!.numberOfTouchesRequired = 2
                swipeDownGesture!.direction = UISwipeGestureRecognizerDirection.Down
            }
            self.mapView.addGestureRecognizer(swipeDownGesture!)
        }else{
//            self.productImgVIew.removeGestureRecognizer(panGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeRightGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeLeftGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeUpGesture!)
            self.productImgVIew.removeGestureRecognizer(swipeDownGesture!)
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
                // Mapbox 1.x use this line of code to move.
                //self.mapView.moveBy(CGSizeMake(self.toLocation.x - translation.x, self.toLocation.y - translation.y))
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
            self.productImgVIew.image = currentProductModel?.getImageData(self.productImgVIew.frame.size, andData: currentProductData, colorArray: self.currentColorDataArray)
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
    
    func mapViewRegionIsChanging(mapView: MGLMapView)
    {
        if self.currentProductModel != nil
        {
            let _radarPosition = mapView.convertCoordinate((self.currentProductModel?.radarCoordinate)!, toPointToView: mapView)
            // Zoom.
            if self.mapView.zoomLevel != lastZoomValue
            {
                let zoomOffset = CGFloat(pow(2, self.mapView.zoomLevel - lastZoomValue))
                let widthOffset = zoomOffset * self.productImgVIew.frame.size.width
                let heightOffset = zoomOffset * self.productImgVIew.frame.size.height
                self.productImgVIew.frame = CGRectMake(
                    _radarPosition.x - widthOffset / 2,
                    _radarPosition.y - heightOffset / 2,
                    widthOffset,
                    heightOffset
                )
                lastZoomValue = self.mapView.zoomLevel
                // Pan.
            }else{
                self.productImgVIew.frame.origin = CGPointMake(
                    _radarPosition.x - self.productImgVIew.frame.width / 2,
                    _radarPosition.y - self.productImgVIew.frame.height / 2
                )
            }
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
            currentColorImg = _data.image
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
        }
        currentProductModel?.clearContent()
        // Reset current config.
        self.productImgVIew.frame.size = CGSizeMake(self.mapView.frame.size.width * 1, self.mapView.frame.size.height * 1)
        self.currentProductModel?.radarPosition = CGPointMake(self.productImgVIew.frame.width / 2, self.productImgVIew.frame.height / 2)
        self.currentProductModel?.initData(data, withProductImgView: self.productImgVIew)
        self.currentProductModel?.setDetMByMaxRadarDistance()
        let img = self.currentProductModel?.getImageData(self.productImgVIew.frame.size, andData: self.currentProductData!, colorArray: self.currentColorDataArray)
        if isFirstTime
        {
            self.mapView?.setCenterCoordinate((self.currentProductModel?.radarCoordinate)!, animated: false)
            isFirstTime = false
        }
        // Set size of radar image by map`s detM.
        let currentRadarImgDetM = self.currentProductModel?.getDetM()
        self.productImgBounds = self.mapView.convertRect(CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height), toCoordinateBoundsFromView: self.mapView)
        self.currentProductModel?.setDetM(self.productImgBounds.sw, andNE: self.productImgBounds.ne, andHeight: Float(self.productImgVIew.frame.size.height))
        let newRadarImgDetM = self.currentProductModel?.getDetM()
        // Refresh view.
        dispatch_async(dispatch_get_main_queue(), {
            self.colorImgView.image = self.currentColorImg
            self.colorContainerView.hidden = false
            self.productImgVIew.image = img
            self.productImgVIew.frame.size = CGSizeMake(
                self.productImgVIew.frame.size.width * CGFloat(currentRadarImgDetM! / newRadarImgDetM!) ,
                self.productImgVIew.frame.size.height * CGFloat(currentRadarImgDetM! / newRadarImgDetM!))
            // Set to the same origin.
            self.mapViewRegionIsChanging(self.mapView)
        })
        print("05:" + String(NSDate().timeIntervalSince1970))
    }
    
    func clearProductView()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.productImgVIew.image = nil
            self.colorImgView.image = nil
            self.colorContainerView.hidden = false
        })
    }
    
    var updateMapCenterByLocation : Bool = false
    func setUserLocationVisible(visible : Bool, _updateMapCenterByLocation : Bool)
    {
        updateMapCenterByLocation = _updateMapCenterByLocation
        if self.locationManager == nil
        {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            self.locationManager?.distanceFilter = 500
            self.locationManager?.requestWhenInUseAuthorization()
        }
        if visible == true || updateMapCenterByLocation
        {
            self.locationManager?.startUpdatingLocation()
        }else{
            self.locationManager?.stopUpdatingLocation()
        }
        if visible == false && self.currentProductModel != nil
        {
            self.currentLocation = self.currentProductModel?.radarCoordinate
            self.mapView.setCenterCoordinate((self.currentProductModel?.radarCoordinate)!, animated: false)
            self.mapViewRegionIsChanging(self.mapView)
        }
        self.mapView.showsUserLocation = visible
    }
    
    func saveCurrentLocation()
    {
        currentLocation = self.mapView.centerCoordinate
    }
    
    func setMapCenerByCurrentLocation()
    {
        if currentLocation != nil && self.mapView != nil
        {
            self.mapView.setCenterCoordinate(currentLocation!, animated: false)
        }
    }
    
    // CLLocationManagerDelegate.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if updateMapCenterByLocation == true
        {
            updateMapCenterByLocation = false
            self.mapView.setCenterCoordinate((locations[0].coordinate), animated: false)
            currentLocation = self.mapView.centerCoordinate
            locationManager?.stopUpdatingLocation()
            self.mapViewRegionIsChanging(self.mapView)
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

//    func setMapByCoordinateBounds(radarMerPos : CGPoint, radarCoordinate : CLLocationCoordinate2D, productImgView : UIImageView, detM : CGFloat)
//    {
//        var swLa : CLLocationDegrees = CLLocationDegrees(radarMerPos.y - productImgVIew.frame.size.height / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
//        swLa = 180 / M_PI * (2 * atan(exp(swLa * M_PI / 180)) - M_PI / 2)
//        let swLo : CLLocationDegrees = CLLocationDegrees(radarMerPos.x - productImgVIew.frame.size.width / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
//        var neLa : CLLocationDegrees = CLLocationDegrees(radarMerPos.y + productImgVIew.frame.size.height / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
//        neLa = 180 / M_PI * (2 * atan(exp(neLa * M_PI / 180)) - M_PI / 2)
//        let neLo : CLLocationDegrees = CLLocationDegrees(radarMerPos.x + productImgVIew.frame.size.width / 2 * detM) / CLLocationDegrees(EquatorR) / M_PI * 180.0
//        self.mapView.zoomWithLatitudeLongitudeBoundsSouthWest(CLLocationCoordinate2DMake(swLa, swLo), northEast: CLLocationCoordinate2DMake(neLa, neLo), animated: false)
//    }
}