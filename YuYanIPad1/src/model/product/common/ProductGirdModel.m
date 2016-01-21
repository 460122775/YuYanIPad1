//
//  ProductGirdModel.m
//  YuYanIPad1
//
//  Created by Yachen Dai on 1/19/16.
//  Copyright © 2016 cdyw. All rights reserved.
//

#import "ProductGirdModel.h"

@implementation ProductGirdModel

-(id)init
{
    self = [super init];
//    self._detM = 1;
//    self.iBinNumber = 0;
//    self.iRefBinLen = 0;
    return self;
}

- (void)initData:(NSData*) data withProductImgView:(UIImageView*) productImgView
{
    [super initData:data withProductImgView:productImgView];
//    cosEle = cos(self.fileHeadStruct.obserSec.iElevation[0] / 100 * M_PI / 180.0);
//    /****  Radial product sets ****/
//    self.iRadius = productImgView.frame.size.height / 2.0 * self.zoomValue;
//    self.rad360 = self.fileHeadStruct.obserSec.iRadialNum[0] / 360.0;
//    switch (self.fileHeadStruct.obserSec.batch.wavForm[0])
//    {
//        case '0':
//            self.iBinNumber = self.fileHeadStruct.obserSec.usRefBinNumber[0];
//            self.iRefBinLen = self.fileHeadStruct.obserSec.iRefBinLen[0];
//            break;
//        case '1':
//            self.iBinNumber = self.fileHeadStruct.obserSec.batch.usDopBinNumber[0];
//            self.iRefBinLen = self.fileHeadStruct.obserSec.iDopBinLen[0];
//            break;
//        default:
//            if (self.productType == ProductType_V || self.productType == ProductType_W)
//            {
//                self.iBinNumber = self.fileHeadStruct.obserSec.batch.usDopBinNumber[0];
//                self.iRefBinLen = self.fileHeadStruct.obserSec.iDopBinLen[0];
//            }else{
//                self.iBinNumber = self.fileHeadStruct.obserSec.usRefBinNumber[0];
//                self.iRefBinLen = self.fileHeadStruct.obserSec.iRefBinLen[0];
//            }
//            break;
//    }
//    self.maxRadarDistance = self.iBinNumber * self.iRefBinLen;
//    int maxHorDistance = ceil(self.maxRadarDistance * self.cosEle / 1000.0);
//    // Mercator Coordinate of bounds.
//    self.topMerLatitude = EquatorR * log(tan(maxHorDistance * 1000 / (PolarR + (EquatorR - PolarR) * (90 - self.radarCoordinate.latitude) / 90.0) / 2
//                                             + self.radarCoordinate.latitude * M_PI_2 / 180.0 + M_PI_4));
//    self.leftMerLongitude = (maxHorDistance * 1000 * (-1) / (PolarR + (EquatorR - PolarR) * (1 - self.radarCoordinate.latitude/ 90.0))
//                             * cos(self.radarCoordinate.latitude * M_PI / 180.0) + self.radarCoordinate.longitude * M_PI / 180.0 )* EquatorR;
//    // Mercator Distance, radius.
//    double maxMerDistance = 0;
//    if (self.radarMerPosition.x - self.leftMerLongitude > self.topMerLatitude - self.radarMerPosition.y)
//    {
//        maxMerDistance = self.leftMerLongitude + (self.radarMerPosition.x - self.leftMerLongitude) * 2 - self.leftMerLongitude;
//    }else{
//        maxMerDistance = (self.topMerLatitude - self.radarMerPosition.y) * 2;
//    }
//    maxMerDistance = maxMerDistance / 2.0;
//    self._det = self.iBinNumber / self.iRadius;
//    // Attention sequence.
//    self._detM = maxMerDistance / self.iRadius;
//    self.sizeofRadial = self.iBinNumber + RadialHeadLength;
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
    [super getImageData:productImgView andData:data colorArray:_colorArray];
    [super.productModelDelegate setMapCenter: self.radarCoordinate];
}

-(void)clearContent
{
//    self._detM = 1;
//    self.iBinNumber = 0;
//    self.iRefBinLen = 0;
    [super clearContent];
}

@end
