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

@optional
-(void)setDetM:(CLLocationCoordinate2D) swCoordinate andNE:(CLLocationCoordinate2D) neCoordinate andHeight: (float) height;

@end

@interface ProductModel: NSObject<ProductDrawDataProtocol>{
  
}

@property (nonatomic, assign) int maxRadarDistance;    // 最大测距
@property (nonatomic, assign) double zoomValue;
@property (nonatomic, assign) int productType;
@property (nonatomic, assign) float iRadius;      // view.width * 0.5
@property (nonatomic, assign) float height;       // 天线海拔
@property (nonatomic, assign) tagRealFile fileHeadStruct;
@property (nonatomic, assign) CGPoint radarPosition;
@property (nonatomic, assign) CLLocationCoordinate2D radarCoordinate;
@property (nonatomic, assign) CGPoint radarMerPosition;

//- (void) drawDistanceCircle:(UIImageView *) productImgView;
+(NSMutableArray*)getSinArr;
+(NSMutableArray*)getCosArr;

- (void) initData:(NSData*) data withProductImgView:(UIImageView*) productImgView;
//- (CGPoint) getPointByPosition:(CLLocation*) point andFrame:(CGRect)frame;
//- (CLLocationCoordinate2D) getPositionByPoint:(CGPoint) point;
//- (CLLocationCoordinate2D) getRadarCenterPosition;
//- (float)getDetM;

@end
