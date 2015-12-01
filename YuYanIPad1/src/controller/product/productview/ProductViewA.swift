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
    }
}