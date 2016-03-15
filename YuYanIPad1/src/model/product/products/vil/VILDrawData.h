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

typedef struct VILHead
{
    int CloudType;  // 云的性质
    float a;        // M-Z关系式中对应的a
    float b;        // M-Z关系式中对应的b
    float maxRan;   // 某次体扫数据文件所对应的最大探测距离
    float LenOfWin; // 计算时选取的VIL窗口大小
    float maxLayCell;   // 径向上最大窗口数
    float maxVIL;   // 当前探测范围内最大的垂直累积液态含水量
}tagVILHead;

@protocol ProductDrawDataProtocol;

@interface VILDrawData : ProductGirdModel<ProductDrawDataProtocol>

@property (nonatomic, assign) tagVILHead VILHeadStruct;

-(id)initWithProductType:(int) _productType;

@end

