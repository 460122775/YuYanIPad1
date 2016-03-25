//
//  ProductRadialModel.m
//  YuYanIPad1
//
//  Created by Yachen Dai on 1/19/16.
//  Copyright © 2016 cdyw. All rights reserved.
//

#import "ProductRadialModel.h"

@implementation ProductRadialModel
@synthesize sizeofRadial, iBinNumber, iRefBinLen, rad360, cosEle;

-(id)init
{
    self = [super init];
    self._detM = 1;
    self.iBinNumber = 0;
    self.iRefBinLen = 0;
    return self;
}

- (void)initData:(NSData*) data withProductImgView:(UIImageView*) productImgView
{
    [super initData:data withProductImgView:productImgView];
    cosEle = cos(self.fileHeadStruct.obserSec.iElevation[0] / 100 * M_PI / 180.0);
    /****  Radial product sets ****/
    self.iRadius = productImgView.frame.size.height / 2.0 * self.zoomValue;
    self.rad360 = self.fileHeadStruct.obserSec.iRadialNum[0] / 360.0;
    switch (self.fileHeadStruct.obserSec.batch.wavForm[0])
    {
        case '0':
            self.iBinNumber = self.fileHeadStruct.obserSec.usRefBinNumber[0];
            self.iRefBinLen = self.fileHeadStruct.obserSec.iRefBinLen[0];
            break;
        case '1':
            self.iBinNumber = self.fileHeadStruct.obserSec.batch.usDopBinNumber[0];
            self.iRefBinLen = self.fileHeadStruct.obserSec.iDopBinLen[0];
            break;
        default:
            if (self.productType == ProductType_V || self.productType == ProductType_W)
            {
                self.iBinNumber = self.fileHeadStruct.obserSec.batch.usDopBinNumber[0];
                self.iRefBinLen = self.fileHeadStruct.obserSec.iDopBinLen[0];
            }else{
                self.iBinNumber = self.fileHeadStruct.obserSec.usRefBinNumber[0];
                self.iRefBinLen = self.fileHeadStruct.obserSec.iRefBinLen[0];
            }
            break;
    }
    self.maxRadarDistance = self.iBinNumber * self.iRefBinLen;
    int maxHorDistance = ceil(self.maxRadarDistance * self.cosEle / 1000.0);
    // Mercator Coordinate of bounds.
    self.topMerLatitude = EquatorR * log(tan(maxHorDistance * 1000 / (PolarR + (EquatorR - PolarR) * (90 - self.radarCoordinate.latitude) / 90.0) / 2
                                        + self.radarCoordinate.latitude * M_PI_2 / 180.0 + M_PI_4));
    self.leftMerLongitude = EquatorR * (((maxHorDistance * (-1000)) / ((PolarR + (EquatorR - PolarR) * (1 - self.radarCoordinate.latitude / 90.0)) * cos(self.radarCoordinate.latitude * M_PI / 180)) + self.radarCoordinate.longitude * M_PI / 180));
//    float dx = (maxHorDistance * (-1000));
//    float ec = (PolarR + (EquatorR - PolarR) * (1 - self.radarCoordinate.latitude / 90.0));
//    float ed = (ec * cos(self.radarCoordinate.latitude * M_PI / 180));
//    float BJD = (dx / ed  * 180.0 / M_PI + self.radarCoordinate.longitude);
//    self.leftMerLongitude = EquatorR * (BJD * M_PI / 180);
    // Mercator Distance, radius.
    double maxMerDistance = 0;
    if (self.radarMerPosition.x - self.leftMerLongitude > self.topMerLatitude - self.radarMerPosition.y)
    {
        maxMerDistance = self.leftMerLongitude + (self.radarMerPosition.x - self.leftMerLongitude) * 2 - self.leftMerLongitude;
    }else{
        maxMerDistance = (self.topMerLatitude - self.radarMerPosition.y) * 2;
    }
    maxMerDistance = maxMerDistance / 2.0;
    self._det = self.iBinNumber / self.iRadius;
    // Attention sequence.
    self._detM = maxMerDistance / self.iRadius;
    self.height = self.fileHeadStruct.addSec.Height / 1000.0;
}

-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data colorArray: (NSMutableArray *) _colorArray
{
    [super getImageData:productImgView andData:data colorArray:_colorArray];
}

-(void)clearContent
{
    self._detM = 1;
    self.iBinNumber = 0;
    self.iRefBinLen = 0;
    [super clearContent];
}

-(int) getProductRadiaOffset:(int)layer andType:(int) type
{
    switch (type) {
        case ProductType_R:
            return RadialHeadLength;
            break;
            
        case ProductType_V:
            return RadialHeadLength + self.fileHeadStruct.obserSec.usRefBinNumber[0];
            break;
            
        case ProductType_W:
            return RadialHeadLength + self.fileHeadStruct.obserSec.usRefBinNumber[0] + self.fileHeadStruct.obserSec.batch.usDopBinNumber[0];
            break;
            
        case ProductType_HCL:
            return RadialHeadLength + self.fileHeadStruct.obserSec.usRefBinNumber[0] + self.fileHeadStruct.obserSec.batch.usDopBinNumber[0]
                    + self.fileHeadStruct.obserSec.batch.usDopBinNumber[0];
            break;
            
        default:
            return -1;
            break;
    }
}

@end
