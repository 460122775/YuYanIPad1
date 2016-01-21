//
//  RVWDrawData.m
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import "EBDrawData.h"
#import "YuYanIpad1-Swift.h"
#import "NameSpace.h"

@implementation EBDrawData
@synthesize productType;

-(id)init
{
    return [super init];
}

-(id)initWithProductType:(int) _productType
{
    self = [self init];
    self.productType = _productType;
    return self;
}


- (void)initData:(NSData*) data withProductImgView:(UIImageView*) productImgView
{
    [super initData:data withProductImgView:productImgView];
    self.sizeofRadial = self.fileHeadStruct.obserSec.usRefBinNumber[0] * sizeof(unsigned short) + RadialHeadLength;
}

-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data colorArray:(NSMutableArray *)_colorArray
{
    if (data == nil || _colorArray == nil || _colorArray.count == 0) return;
    [self initData:data withProductImgView: productImgView];
    [super getImageData:productImgView andData:data colorArray:_colorArray];
    UIGraphicsBeginImageContext(productImgView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *colorValueArray = nil;
    unsigned short *ushortValue = (unsigned short*)[[data subdataWithRange:NSMakeRange(sizeof(self.fileHeadStruct), data.length - sizeof(self.fileHeadStruct))] bytes];
    unsigned short value = 0;
    int seta = 0;
    int iRb = 0;
    float fAz = 0.0;
    int xMin = self.radarPosition.x - (self.radarMerPosition.x - self.leftMerLongitude) / self._detM;
    int xMax = self.radarPosition.x + (self.radarMerPosition.x - self.leftMerLongitude) / self._detM;
    int yMin = self.radarPosition.y - (self.topMerLatitude - self.radarMerPosition.y) / self._detM;
    int yMax = self.radarPosition.y + (self.topMerLatitude - self.radarMerPosition.y) / self._detM;
    
    // Judge if it is in the productImgView`s Bounds.
    if (yMin < 0)
    {
        yMin = 0;
    }
    if (yMax > productImgView.frame.size.height)
    {
        yMax = productImgView.frame.size.height;
    }
    // Select the drawing bound, according to the radar center relative to the productImgView center.
    if (self.radarPosition.x < productImgView.frame.size.width / 2)
    {
        xMin = self.radarPosition.x;
    }else{
        xMax = self.radarPosition.x;
    }
    // Judge if it is in the productImgView`s Bounds.
    if (xMin < 0)
    {
        xMin = 0;
    }
    if (xMin >= productImgView.frame.size.width)
    {
        xMax = productImgView.frame.size.width - 1;
    }
    
    CLLocationCoordinate2D radarCoordinate1 = CLLocationCoordinate2DMake(self.radarCoordinate.latitude * M_PI / 180, self.radarCoordinate.longitude * M_PI / 180);
    CLLocationCoordinate2D radarCoordinate2;
    float lat1_cos = cos(radarCoordinate1.latitude);
    float lat1_sin = sinf(radarCoordinate1.latitude);
    int xSymmetric = 0;
    for (int x = xMin; x <= xMax; x++)
    {
        int x_x0 = x - self.radarPosition.x;
        xSymmetric = self.radarPosition.x * 2 - x;
        for (int y = yMin; y < yMax; y++)
        {
            int y_y0 = self.radarPosition.y - y;
            radarCoordinate2 = CLLocationCoordinate2DMake(
                                                          2 * atan(exp((self.radarMerPosition.y + y_y0 * self._detM) / EquatorR)) - M_PI_2,
                                                          (self.radarMerPosition.x + x_x0 * self._detM) / EquatorR
                                                          );
            float b = radarCoordinate2.longitude - radarCoordinate1.longitude;
            float lat2_sin = sin(radarCoordinate2.latitude);
            float lat2_cos = cos(radarCoordinate2.latitude);
            float b_sin = sin(b);
            float b_cos = cos(b);
            float s = acos(lat1_sin * lat2_sin + lat1_cos * lat2_cos * b_cos) * EquatorR;
            iRb = s / self.cosEle / self.iRefBinLen;
            if (iRb < self.iBinNumber)
            {
                fAz = atan2(b_sin * lat2_cos,  lat1_cos * lat2_sin - lat1_sin * lat2_cos * b_cos);
                if (fAz < 0)
                {
                    fAz += M_PI * 2;
                }
                // Draw left half of product.
                seta = fAz * 180 / M_PI * self.rad360;
                ushortValue = (unsigned short*)[[data subdataWithRange:NSMakeRange(sizeof(self.fileHeadStruct) + self.sizeofRadial * seta + RadialHeadLength + iRb * sizeof(unsigned short), sizeof(unsigned short))] bytes];
                value = ushortValue[0];
                if (value > 1)
                {
                    value = 2 + (value + self.height) / 100.0;
                    if (value > 255) value = 255;
                }else{
                    value = 0;
                }
                if (value > 1 && value <= 210)
                {
                    colorValueArray = (NSArray*)([_colorArray objectAtIndex:value]);
                    CGContextSetRGBFillColor(context,
                                             [[NSNumber numberWithFloat:[colorValueArray[0] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[1] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[2] floatValue]] floatValue],1.0);
                    CGContextFillRect(context, CGRectMake(x, y, 1, 1));
                    CGContextStrokePath(context);
                }
                // Judge x_Symmetric_point is in the symmetric area, devide the Central axis.
                if (xSymmetric != x && xSymmetric >= 0 && xSymmetric < productImgView.frame.size.width)
                {
                    // Draw right half of product.
                    seta = 359 - seta;
                    ushortValue = (unsigned short*)[[data subdataWithRange:NSMakeRange(sizeof(self.fileHeadStruct) + self.sizeofRadial * seta + RadialHeadLength + iRb * sizeof(unsigned short), sizeof(unsigned short))] bytes];
                    value = ushortValue[0];
                    if (value > 1)
                    {
                        value = 2 + (value + self.height) / 100.0;
                        if (value > 255) value = 255;
                    }else{
                        value = 0;
                    }
                    if (value > 1 && value <= 210)
                    {
                        colorValueArray = (NSArray*)([_colorArray objectAtIndex:value]);
                        CGContextSetRGBFillColor(context,
                                                 [[NSNumber numberWithFloat:[colorValueArray[0] floatValue]] floatValue],
                                                 [[NSNumber numberWithFloat:[colorValueArray[1] floatValue]] floatValue],
                                                 [[NSNumber numberWithFloat:[colorValueArray[2] floatValue]] floatValue],1.0);
                        CGContextFillRect(context, CGRectMake(xSymmetric, y, 1, 1));
                        CGContextStrokePath(context);
                    }
                }
            }
        }
    }
    // Show image...
    productImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
