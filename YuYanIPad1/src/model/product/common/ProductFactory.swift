//
//  ProductFactory.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 15/12/9.
//  Copyright © 2015年 cdyw. All rights reserved.
//

import UIKit

class ProductFactory: NSObject {

    static func getModelByType(productType : Int64) -> ProductModel?
    {
        switch productType
        {
            case ProductType_Z : return RVWDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_V : return RVWDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_W : return RVWDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_EB : return EBDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_ET : return EBDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_CAPPI: return CAPPIDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_MAXREF: return RVWDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_OHP: return OHPDrawData(productType: (NSNumber(longLong: productType).intValue))
            case ProductType_VIL: return VILDrawData(productType: (NSNumber(longLong: productType).intValue))
            default: return nil;
        }
    }
    
}
