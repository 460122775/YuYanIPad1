//
//  RHIDrawData.h
//  RadarIPad
//
//  Created by Yachen Dai on 8/12/14.
//  Copyright (c) 2014 Yachen Dai. All rights reserved.
//

#import "ProductModel.h"

@protocol ProductDrawDataProtocol;

@interface RHIDrawData : ProductModel<ProductDrawDataProtocol>{
    NSMutableDictionary *dataDic;
    NSMutableArray *dataArray;
    int radialNumber;
}

@property(nonatomic, assign) int subType;

@end
