//
//  ProductModel.m
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import "ProductModel.h"
#import "NameSpace.h"


@implementation ProductModel
@synthesize zoomValue, radarCoordinate, radarMerPosition, productType, radarPosition, topMerLatitude,
            leftMerLongitude, maxRadarDistance, iRadius, _det, _detM, height, fileHeadStruct;
-(id)init
{
    self = [super init];
    self.zoomValue = 1;
    return self;
}

- (void) initData:(NSData*) data withProductImgView:(UIImageView*) productImgView
{
    [data getBytes:&(self->fileHeadStruct) range:NSMakeRange(0, sizeof(self.fileHeadStruct))];
    self.radarCoordinate = CLLocationCoordinate2DMake(self.fileHeadStruct.addSec.LatitudeV / 360000.0, self.fileHeadStruct.addSec.LongitudeV / 360000.0);
    self.radarMerPosition= CGPointMake(
                                    0 + EquatorR * (self.radarCoordinate.longitude * M_PI / 180.0),
                                    0 + EquatorR * log(tan(M_PI_4 + self.radarCoordinate.latitude * M_PI_2 / 180.0))
                                     );
}

-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data colorArray: (NSMutableArray *) _colorArray
{
    
}

-(void)clearContent
{
    tagRealFile _temp;
    self.fileHeadStruct = _temp;
    self.radarMerPosition= CGPointMake(0, 0);
    self.radarCoordinate = CLLocationCoordinate2DMake(0, 0);
}

//-(void)drawDistanceCircle:(UIImageView *)mapCircleImgView
//{
//    UIGraphicsBeginImageContext(mapCircleImgView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1);
//    CGContextBeginPath(context);
//    CGContextSetRGBStrokeColor(context, 170 / 256.0, 170 / 256.0, 170 / 256.0, 1.0);
//    // Draw distance line.
//    int aaa = maxRadarDistance / _detM * sqrt(2) / 2;
//    CGContextMoveToPoint(context, self.radarPosition.x, self.radarPosition.y - maxRadarDistance / _detM);
//    CGContextAddLineToPoint(context, self.radarPosition.x, self.radarPosition.y + maxRadarDistance / _detM);
//    CGContextMoveToPoint(context, self.radarPosition.x + aaa, self.radarPosition.y - aaa);
//    CGContextAddLineToPoint(context, self.radarPosition.x - aaa, self.radarPosition.y + aaa);
//    CGContextMoveToPoint(context, self.radarPosition.x + maxRadarDistance / _detM, self.radarPosition.y);
//    CGContextAddLineToPoint(context, self.radarPosition.x - maxRadarDistance / _detM, self.radarPosition.y);
//    CGContextMoveToPoint(context, self.radarPosition.x + aaa, self.radarPosition.y + aaa);
//    CGContextAddLineToPoint(context, self.radarPosition.x - aaa, self.radarPosition.y - aaa);
//    CGContextStrokePath(context);
//    // Draw circle line.
//    for (int i = 1; i <= maxRadarDistance / 50000; i++)
//    {
//        CGContextAddArc(context, self.radarPosition.x, self.radarPosition.y, (i * 50000) / _detM, 0, 2 * M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//    }
//    mapCircleImgView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}
//
//-(int) getProductRadiaOffset:(int)layer andType:(int) type
//{
//    switch (type) {
//        case ProductType_R:
//            return RadialHeadLength;
//            break;
//            
//        case ProductType_V:
//            return RadialHeadLength + fileHeadStruct.obserSec.usRefBinNumber[0];
//            break;
//        
//        case ProductType_W:
//            return RadialHeadLength + fileHeadStruct.obserSec.usRefBinNumber[0] + fileHeadStruct.obserSec.batch.usDopBinNumber[0];
//            break;
//            
//        case ProductType_HCL:
//            return RadialHeadLength + fileHeadStruct.obserSec.usRefBinNumber[0] + fileHeadStruct.obserSec.batch.usDopBinNumber[0] + fileHeadStruct.obserSec.batch.usDopBinNumber[0];
//            break;
//            
//        default:
//            return -1;
//            break;
//    }
//}

//- (CGPoint) getPointByPosition:(CLLocation*) location andFrame:(CGRect)frame
//{
//    // Add offset.
//    CGPoint point = CGPointMake(location.coordinate.longitude + 12,
//                                location.coordinate.latitude - 12);
//    float radarX = fileHeadStruct.addSec.LongitudeV / 360000.0;
//    float radarY = fileHeadStruct.addSec.LatitudeV / 360000.0;
//    // Calculate angle.
//    float angle = sin(point.y * M_PI / 180.0)
//                * sin(radarY * M_PI / 180.0)
//                + cos(point.y * M_PI / 180.0)
//                * cos(radarY * M_PI / 180.0)
//                * cos((radarX - point.x) * M_PI / 180.0);
//    angle = sqrt(1 - angle * angle);
//    if (angle != 0)
//    {
//        angle = cos(radarY * M_PI / 180.0) * sin((radarX - point.x) * M_PI / 180.0) / angle;
//        angle = asin(angle) * 180.0 / M_PI;
//    }
//    if (point.x >= radarX && point.y >= radarY)
//    {
//        angle *= -1;
//    }else if(point.x >= radarX
//             && point.y <= radarY){
//        angle += 180;
//    }else if (point.x <= radarX
//              && point.y <= radarY){
//        angle += 180;
//    }else if(point.x <= radarX
//             && point.y >= radarY){
//        angle = 360 - angle;
//    }
//    
//    // Calculate Distance.
//    float distance = 6371.0
//            * acos(cos(radarY * M_PI / 180.0)
//            * cos(point.y * M_PI / 180.0)
//            * cos((radarX - point.x) * M_PI / 180.0)
//            + sin(radarY * M_PI / 180.0)
//            * sin(point.y * M_PI / 180.0));
//    // Calculate Position.
//    if (angle == 0)
//    {
//        point.x = 0 + centX;
//    }else{
//        point.x = distance / _detM * sin(angle) + centX;
//    }
//    point.y = distance / _detM * cos(angle) + centY;
//    
//    //Test...
////    point.x = 340 + centX;
////    point.y = 380 + centY;
//    return point;
//}
//
//static const float RJ = 6356725;//极半径
//static const float RC = 6378137;//赤道半径
//
//- (CLLocationCoordinate2D)getPositionByPoint:(CGPoint) point
//{
//    float radarX = fileHeadStruct.addSec.LongitudeV / 360000.0;
//    float radarY = fileHeadStruct.addSec.LatitudeV / 360000.0;
//    float r = sqrtf(powf((point.x - centX), 2) + powf((point.y - centY), 2));
//    float distance = r * _detM;
//    //求方位角角度。
//    float azimuth = atan2f((centX - point.x), (point.y - centY)) * 180.0 / M_PI;
//    if (azimuth < 0) azimuth += 360.0;
//    //JWD
//    float dx = distance * sinf(azimuth * M_PI / 180.0);
//    float dy = distance * cosf(azimuth * M_PI / 180.0);
//    float ec = RJ + (RC - RJ) * (90 - radarY) / 90.0;
//    float ed = ec * cosf(radarY * M_PI / 180);
//    
//    float longitude = (dx / ed + radarX * M_PI / 180.0) * 180.0 / M_PI;
//    float latitude = (dy / ec + radarY * M_PI / 180.0) * 180.0 / M_PI;
//    
//    return CLLocationCoordinate2DMake(latitude, longitude);
//}
//
//- (CLLocationCoordinate2D) getRadarCenterPosition
//{
//    return CLLocationCoordinate2DMake(fileHeadStruct.addSec.LatitudeV / 360000.0, fileHeadStruct.addSec.LongitudeV / 360000.0);
//}

@end
