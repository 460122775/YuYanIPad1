//
//  ProductGirdModel.h
//  YuYanIPad1
//
//  Created by Yachen Dai on 1/19/16.
//  Copyright © 2016 cdyw. All rights reserved.
//

#import "ProductModel.h"
#import "NameSpace.h"

@interface ProductGirdModel : ProductModel

@property (nonatomic, assign) float windowSize; // Unit : km.
@property (nonatomic, assign) int maxWindowCount;   // Count of windows

@end
