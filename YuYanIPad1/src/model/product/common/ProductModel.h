//
//  ProductModel.h
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProductDefine.h"
#import <CoreLocation/CoreLocation.h>

@protocol ProductDrawDataProtocol <NSObject>

@required

-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data colorArray: (NSMutableArray *) _colorArray;
-(void)clearContent;

@end


@protocol ProductModelProtocol <NSObject>

-(void)setMapCenter:(CLLocationCoordinate2D) radarCoordinate;

@end

@interface ProductModel: NSObject<ProductDrawDataProtocol>{
  
}

@property (nonatomic, assign) double topMerLatitude; // 上边界莫卡托纬度坐标
@property (nonatomic, assign) double leftMerLongitude;// 左边界莫卡托经度坐标
@property (nonatomic, assign) int maxRadarDistance;    // 最大测距
@property (nonatomic, assign) int zoomValue;
@property (nonatomic, assign) int productType;
@property (nonatomic, assign) float iRadius;      // view.width * 0.5
@property (nonatomic, assign) float _det;         // 一个像素点代表的距离库数
@property (nonatomic, assign) float _detM;        // Real distance of each pix.
@property (nonatomic, assign) float height;       // 天线海拔
@property (nonatomic, assign) tagRealFile fileHeadStruct;
@property (nonatomic, assign) CGPoint radarPosition;
@property (nonatomic, assign) CLLocationCoordinate2D radarCoordinate;
@property (nonatomic, assign) CGPoint radarMerPosition;
@property (nonatomic, assign) id<ProductModelProtocol> productModelDelegate;

//- (void) drawDistanceCircle:(UIImageView *) productImgView;
- (void) initData:(NSData*) data withProductImgView:(UIImageView*) productImgView;
//- (CGPoint) getPointByPosition:(CLLocation*) point andFrame:(CGRect)frame;
//- (CLLocationCoordinate2D) getPositionByPoint:(CGPoint) point;
//- (CLLocationCoordinate2D) getRadarCenterPosition;
//- (float)getDetM;

@end
