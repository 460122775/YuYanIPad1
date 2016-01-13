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

@end

@interface ProductModel: NSObject<ProductDrawDataProtocol>{
    int productPaddingTop;
    int productPaddingLeft;
    int VGap;
    int labelWidth;
    float cosEle;       // 仰角的cos值
    double topMerLatitude; // 上边界莫卡托纬度坐标
    double leftMerLongitude;// 左边界莫卡托经度坐标
    int sizeofRadial;   // 径向大小
    int maxRadarDistance;    // 最大测距
    int iBinNumber;     // 距离库数
    int iRefBinLen;     // 距离库长
    float iRadius;      // view.width * 0.5
    float _det;         // 一个像素点代表的距离库数
    float _detM;        // Real distance of each pix.
    float rad360;       // 一个径向代表的角度数，一般为（360度／ 360个 ＝ 1度）。
    float height;       // 天线海拔
    tagRealFile fileHeadStruct;
}

@property (nonatomic, assign) int zoomValue;
@property (nonatomic, assign) int productType;
@property (nonatomic, assign) CGPoint radarPosition;
@property (nonatomic, assign) CLLocationCoordinate2D radarCoordinate;
@property (nonatomic, assign) CGPoint radarMerPosition;
//@property (nonatomic, assign) CGPoint topMerPosition;
//@property (nonatomic, assign) CGPoint leftMerPosition;

- (void) drawDistanceCircle:(UIImageView *) productImgView;
- (void) constNeedCal:(UIImageView *) productImgView;
//- (CGPoint) getPointByPosition:(CLLocation*) point andFrame:(CGRect)frame;
//- (CLLocationCoordinate2D) getPositionByPoint:(CGPoint) point;
//- (CLLocationCoordinate2D) getRadarCenterPosition;
- (float)getDetM;

@end
