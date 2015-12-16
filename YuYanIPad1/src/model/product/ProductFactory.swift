//
//  ProductFactory.swift
//  YuYanIPad1
//
//  Created by Yachen Dai on 15/12/9.
//  Copyright © 2015年 cdyw. All rights reserved.
//

import UIKit

class ProductFactory: NSObject {

    func getModelByType(productType : Int64) -> ProductModel?
    {
        switch productType
        {
            case ProductType_Z : return RVWDrawData()
            case ProductType_V : return RVWDrawData()
            case ProductType_W : return RVWDrawData()
            default: return nil;
        }
    }
    
}
