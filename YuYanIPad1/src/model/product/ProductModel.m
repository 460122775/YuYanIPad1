//
//  ProductModel.m
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel
@synthesize zoomValue, centX, centY, productType;

-(id)init
{
    self = [super init];
    productPaddingLeft = 8;
    productPaddingTop = 5;
    VGap = 8;
    labelWidth = 280;
    self.zoomValue = 1.0;
    _detM = 1;
    return self;
}

- (void) constNeedCal:(UIImageView*) productImgView
{
    iRadius = productImgView.frame.size.height / 2.0 * self.zoomValue;
    rad360 = fileHeadStruct.obserSec.iRadialNum[0] / 360.0;
    switch (fileHeadStruct.obserSec.batch.wavForm[0]) {
        case '0':
            _det = fileHeadStruct.obserSec.usRefBinNumber[0] / iRadius;
            _detM = fileHeadStruct.obserSec.usRefBinNumber[0] * fileHeadStruct.obserSec.iRefBinLen[0] / iRadius;
            ikuchang = fileHeadStruct.obserSec.iRefBinLen[0];
            maxDistance = fileHeadStruct.obserSec.usRefBinNumber[0] * fileHeadStruct.obserSec.iRefBinLen[0];
            sizeofRadial = fileHeadStruct.obserSec.usRefBinNumber[0] + 64;
            break;
        case '1':
            _det = fileHeadStruct.obserSec.batch.usDopBinNumber[0] / iRadius;
            _detM = fileHeadStruct.obserSec.batch.usDopBinNumber[0] * fileHeadStruct.obserSec.iDopBinLen[0] / iRadius;
            ikuchang = fileHeadStruct.obserSec.iDopBinLen[0];
            maxDistance = fileHeadStruct.obserSec.batch.usDopBinNumber[0] * fileHeadStruct.obserSec.iDopBinLen[0];
            sizeofRadial = fileHeadStruct.obserSec.batch.usDopBinNumber[0] + 64;
            break;
        default:
            if (self.productType == ProductType_V || self.productType == ProductType_W)
            {
                _det = fileHeadStruct.obserSec.batch.usDopBinNumber[0] / iRadius;
                _detM = fileHeadStruct.obserSec.batch.usDopBinNumber[0] * fileHeadStruct.obserSec.iDopBinLen[0] / iRadius;
                ikuchang = fileHeadStruct.obserSec.iDopBinLen[0];
                maxDistance = fileHeadStruct.obserSec.batch.usDopBinNumber[0] * fileHeadStruct.obserSec.iDopBinLen[0];
                sizeofRadial = fileHeadStruct.obserSec.batch.usDopBinNumber[0] + 64;
            }else{
                _det = fileHeadStruct.obserSec.usRefBinNumber[0] / iRadius;
                _detM = fileHeadStruct.obserSec.usRefBinNumber[0] * fileHeadStruct.obserSec.iRefBinLen[0] / iRadius;
                ikuchang = fileHeadStruct.obserSec.iRefBinLen[0];
                maxDistance = fileHeadStruct.obserSec.usRefBinNumber[0] * fileHeadStruct.obserSec.iRefBinLen[0];
                sizeofRadial = fileHeadStruct.obserSec.usRefBinNumber[0] + 64;
            }
            break;
    }
    
}

-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data colorArray: (NSMutableArray *) _colorArray
{
    [data getBytes:&fileHeadStruct range:NSMakeRange(0, sizeof(fileHeadStruct))];
    [self constNeedCal:productImgView];
}

-(void)drawDistanceCircle:(UIImageView *)mapCircleImgView
{
    UIGraphicsBeginImageContext(mapCircleImgView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 170 / 256.0, 170 / 256.0, 170 / 256.0, 1.0);
    // Draw distance line.
    int aaa = maxDistance / _detM * sqrt(2) / 2;
    CGContextMoveToPoint(context, self.centX, self.centY - maxDistance / _detM);
    CGContextAddLineToPoint(context, self.centX, self.centY + maxDistance / _detM);
    CGContextMoveToPoint(context, self.centX + aaa, self.centY - aaa);
    CGContextAddLineToPoint(context, self.centX - aaa, self.centY + aaa);
    CGContextMoveToPoint(context, self.centX + maxDistance / _detM, self.centY);
    CGContextAddLineToPoint(context, self.centX - maxDistance / _detM, self.centY);
    CGContextMoveToPoint(context, self.centX + aaa, self.centY + aaa);
    CGContextAddLineToPoint(context, self.centX - aaa, self.centY - aaa);
    CGContextStrokePath(context);
    // Draw circle line.
    for (int i = 1; i <= maxDistance / 50000; i++)
    {
        CGContextAddArc(context, self.centX, self.centY, (i * 50000) / _detM, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    mapCircleImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

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

- (float)getDetM
{
    return _detM;
}

@end
