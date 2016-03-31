//
//  ProductRadialModel.h
//  YuYanIPad1
//
//  Created by Yachen Dai on 1/19/16.
//  Copyright © 2016 cdyw. All rights reserved.
//

#import "ProductModel.h"
#import "NameSpace.h"

@interface ProductRadialModel : ProductModel{
  
}

@property (nonatomic, assign) float _detM;        // Real distance of each pix.
@property (nonatomic, assign) double topMerLatitude; // 上边界莫卡托纬度坐标
@property (nonatomic, assign) double leftMerLongitude;// 左边界莫卡托经度坐标
@property (nonatomic, assign) CGRect imgBounds;   // 径向大小
@property (nonatomic, assign) int sizeofRadial;   // 径向大小
@property (nonatomic, assign) int iBinNumber;     // 距离库数
@property (nonatomic, assign) int iRefBinLen;     // 距离库长
@property (nonatomic, assign) float rad360;       // 一个径向代表的角度数，一般为（360度／ 360个 ＝ 1度）。
@property (nonatomic, assign) float cosEle;       // 仰角的cos值

@end
