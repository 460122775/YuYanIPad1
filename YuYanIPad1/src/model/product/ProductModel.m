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
@synthesize zoomValue, radarCoordinate, radarMerPosition, productType, radarPosition;

-(id)init
{
    self = [super init];
    productPaddingLeft = 8;
    productPaddingTop = 5;
    VGap = 8;
    labelWidth = 280;
    self.zoomValue = 1.0;
    _detM = 1;
    iBinNumber = 0;
    iRefBinLen = 0;
    return self;
}

- (void) constNeedCal:(UIImageView*) productImgView
{
    /****  Common sets ****/
    radarCoordinate = CLLocationCoordinate2DMake(fileHeadStruct.addSec.LatitudeV / 360000.0, fileHeadStruct.addSec.LongitudeV / 360000.0);
    self.radarMerPosition= CGPointMake(
                                    0 + EquatorR * (radarCoordinate.longitude * M_PI / 180.0),
                                    0 + EquatorR * log(tan(M_PI_4 + radarCoordinate.latitude * M_PI_2 / 180.0))
                                     );
    cosEle = cos(fileHeadStruct.obserSec.iElevation[0] / 100 * M_PI / 180.0);
    /****  Radial product sets ****/
    iRadius = productImgView.frame.size.height / 2.0 * self.zoomValue;
    rad360 = fileHeadStruct.obserSec.iRadialNum[0] / 360.0;
    switch (fileHeadStruct.obserSec.batch.wavForm[0])
    {
        case '0':
            iBinNumber = fileHeadStruct.obserSec.usRefBinNumber[0];
            iRefBinLen = fileHeadStruct.obserSec.iRefBinLen[0];
            break;
        case '1':
            iBinNumber = fileHeadStruct.obserSec.batch.usDopBinNumber[0];
            iRefBinLen = fileHeadStruct.obserSec.iDopBinLen[0];
            break;
        default:
            if (self.productType == ProductType_V || self.productType == ProductType_W)
            {
                iBinNumber = fileHeadStruct.obserSec.batch.usDopBinNumber[0];
                iRefBinLen = fileHeadStruct.obserSec.iDopBinLen[0];
            }else{
                iBinNumber = fileHeadStruct.obserSec.usRefBinNumber[0];
                iRefBinLen = fileHeadStruct.obserSec.iRefBinLen[0];
            }
            break;
    }
    maxRadarDistance = iBinNumber * iRefBinLen;
    int maxHorDistance = ceil(maxRadarDistance * cosEle / 1000.0);
    // Mercator Coordinate of bounds.
    topMerLatitude = EquatorR * log(tan(maxHorDistance * 1000 / (PolarR + (EquatorR - PolarR) * (90 - radarCoordinate.latitude) / 90.0) / 2
    + radarCoordinate.latitude * M_PI_2 / 180.0 + M_PI_4));
    leftMerLongitude = (maxHorDistance * 1000 * (-1) / (PolarR + (EquatorR - PolarR) * (1 - radarCoordinate.latitude/ 90.0))
                              * cos(radarCoordinate.latitude * M_PI / 180.0) + radarCoordinate.longitude * M_PI / 180.0 )* EquatorR;
    
    
//    CLLocationCoordinate2D topCoordinate = [self getCoordinate:radarCoordinate andDistance:maxHorDistance andAngle:0];
//    self.topMerPosition = [self transToMercatorPosition: topCoordinate];
//    CLLocationCoordinate2D leftCoordinate = [self getCoordinate:radarCoordinate andDistance:maxHorDistance andAngle:270];
//    self.leftMerPosition = [self transToMercatorPosition: leftCoordinate];
    // Mercator Distance, radius.
    double maxMerDistance = 0;
    if (radarMerPosition.x - leftMerLongitude > topMerLatitude - radarMerPosition.y)
    {
        maxMerDistance = leftMerLongitude + (radarMerPosition.x - leftMerLongitude) * 2 - leftMerLongitude;
    }else{
        maxMerDistance = (topMerLatitude - radarMerPosition.y) * 2;
    }
    maxMerDistance = maxMerDistance / 2.0;
    _det = iBinNumber / iRadius;
    // Attention sequence.
    _detM = maxMerDistance / iRadius;
    sizeofRadial = iBinNumber + RadialHeadLength;
}

//-(CLLocationCoordinate2D)getCoordinate:(CLLocationCoordinate2D)coordinate andDistance:(double)distance andAngle:(double)angle
//{
//    return CLLocationCoordinate2DMake(
//                                      distance * 1000 * cos(angle * M_PI / 180.0) / (PolarR + (EquatorR - PolarR) * (90 - coordinate.latitude) / 90.0) * 180 / M_PI + coordinate.latitude,
//                                      distance * 1000 * sin(angle * M_PI / 180.0) / (PolarR + (EquatorR - PolarR) * (90 - coordinate.latitude) / 90.0) * cos(coordinate.latitude * M_PI / 180.0) * 180 / M_PI + coordinate.longitude
//                                      );
//}
//
//-(CGPoint)transToMercatorPosition:(CLLocationCoordinate2D)coordinate
//{
//    return CGPointMake(
//                       0 + EquatorR * (coordinate.longitude * M_PI / 180 - 0),
//                       0 + EquatorR * log(tan(M_PI_4 + coordinate.latitude * M_PI_2 / 180.0))
//                       );
//}

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
    int aaa = maxRadarDistance / _detM * sqrt(2) / 2;
    CGContextMoveToPoint(context, self.radarPosition.x, self.radarPosition.y - maxRadarDistance / _detM);
    CGContextAddLineToPoint(context, self.radarPosition.x, self.radarPosition.y + maxRadarDistance / _detM);
    CGContextMoveToPoint(context, self.radarPosition.x + aaa, self.radarPosition.y - aaa);
    CGContextAddLineToPoint(context, self.radarPosition.x - aaa, self.radarPosition.y + aaa);
    CGContextMoveToPoint(context, self.radarPosition.x + maxRadarDistance / _detM, self.radarPosition.y);
    CGContextAddLineToPoint(context, self.radarPosition.x - maxRadarDistance / _detM, self.radarPosition.y);
    CGContextMoveToPoint(context, self.radarPosition.x + aaa, self.radarPosition.y + aaa);
    CGContextAddLineToPoint(context, self.radarPosition.x - aaa, self.radarPosition.y - aaa);
    CGContextStrokePath(context);
    // Draw circle line.
    for (int i = 1; i <= maxRadarDistance / 50000; i++)
    {
        CGContextAddArc(context, self.radarPosition.x, self.radarPosition.y, (i * 50000) / _detM, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    mapCircleImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(int) getProductRadiaOffset:(int)layer andType:(int) type
{
    switch (type) {
        case ProductType_R:
            return RadialHeadLength;
            break;
            
        case ProductType_V:
            return RadialHeadLength + fileHeadStruct.obserSec.usRefBinNumber[0];
            break;
        
        case ProductType_W:
            return RadialHeadLength + fileHeadStruct.obserSec.usRefBinNumber[0] + fileHeadStruct.obserSec.batch.usDopBinNumber[0];
            break;
            
        case ProductType_HCL:
            return RadialHeadLength + fileHeadStruct.obserSec.usRefBinNumber[0] + fileHeadStruct.obserSec.batch.usDopBinNumber[0] + fileHeadStruct.obserSec.batch.usDopBinNumber[0];
            break;
            
        default:
            return -1;
            break;
    }
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
