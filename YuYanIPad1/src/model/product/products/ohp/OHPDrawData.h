//
//  RVWDrawData.h
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductGirdModel.h"
#import "ProductDefine.h"

typedef struct OHPHead
{
    int VOLCnt;     // 体扫个数
    float A;        // Z-R参数
    float b;        // Z-R参数
    float LenOfWin; // 窗口大小
    int maxLayCell; // 径向上所包含的最大窗口数
    float maxOHP;   // 最大1小时的降水量
}tagOHPHead;

@protocol ProductDrawDataProtocol;

@interface OHPDrawData : ProductGirdModel<ProductDrawDataProtocol>

@property (nonatomic, assign) tagOHPHead OHPHeadStruct;

-(id)initWithProductType:(int) _productType;

@end

