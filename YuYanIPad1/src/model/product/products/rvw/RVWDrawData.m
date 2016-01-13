//
//  RVWDrawData.m
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import "RVWDrawData.h"
#import "YuYanIpad1-Swift.h"
#import "NameSpace.h"

@implementation RVWDrawData
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

-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data colorArray:(NSMutableArray *)_colorArray
{
//    DLog(@">>>>>>>>Start Draw Product.[%i]", data.length);
    if (data == nil || _colorArray == nil || _colorArray.count == 0) return;
    [super getImageData:productImgView andData:data colorArray:_colorArray];
    UIGraphicsBeginImageContext(productImgView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *colorValueArray = nil;
    unsigned char *charvalue = (unsigned char *)[[data subdataWithRange:NSMakeRange(sizeof(fileHeadStruct), data.length - sizeof(fileHeadStruct))] bytes];
    uint value = 0;
    int seta = 0;
    int position = 0;
    float r = 0.0;
    float fAz = 0.0;
    int xMin = self.radarPosition.x - (self.radarMerPosition.x - leftMerLongitude) / _detM;
    int xMax = self.radarPosition.x + (self.radarMerPosition.x - leftMerLongitude) / _detM;
    int yMin = self.radarPosition.y - (topMerLatitude - self.radarMerPosition.y) / _detM;
    int yMax = self.radarPosition.y + (topMerLatitude - self.radarMerPosition.y) / _detM;
    
    CLLocationCoordinate2D radarCoordinate1 = CLLocationCoordinate2DMake(self.radarCoordinate.latitude * M_PI / 180, self.radarCoordinate.longitude * M_PI / 180);
    CLLocationCoordinate2D radarCoordinate2;
    float lat1_cos = cos(radarCoordinate1.latitude);
    float lat1_sin = sinf(radarCoordinate1.latitude);
    int xHalf = (xMax - xMin) / 2;
    int xLeft = xMax;
    xMax = xMin + xHalf;
    for (int x = xMin; x < xMax; x++)
    {
        int x_x0 = x - self.radarPosition.x;
        for (int y = yMin; y < yMax; y++)
        {
            int y_y0 = self.radarPosition.y - y;
            radarCoordinate2 = CLLocationCoordinate2DMake(
                                                          2 * atan(exp((self.radarMerPosition.y + y_y0 * _detM) / EquatorR)) - M_PI_2,
                                                          (self.radarMerPosition.x + x_x0 * _detM) / EquatorR
                                                          );
            float b = radarCoordinate2.longitude - radarCoordinate1.longitude;
            float lat2_sin = sin(radarCoordinate2.latitude);
            float lat2_cos = cos(radarCoordinate2.latitude);
            float b_sin = sin(b);
            float b_cos = cos(b);
            float s = acos(lat1_sin * lat2_sin + lat1_cos * lat2_cos * b_cos) * EquatorR;
            r = s / cosEle;
            if (r <= maxRadarDistance)
            {
                fAz = atan2(b_sin * lat2_cos,  lat1_cos * lat2_sin - lat1_sin * lat2_cos * b_cos);
                if (fAz < 0)
                {
                    fAz += M_PI * 2;
                }
                // Draw left half of product.
                seta = fAz * 180 / M_PI * rad360;
                position = sizeofRadial * seta + RadialHeadLength + r / iRefBinLen;
                value = charvalue[position / sizeof(unsigned char) - 1];
                if (value > 1)
                {
                    colorValueArray = (NSArray*)([_colorArray objectAtIndex:value]);
                    CGContextSetRGBFillColor(context,
                                             [[NSNumber numberWithFloat:[colorValueArray[0] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[1] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[2] floatValue]] floatValue],1.0);
                    CGContextFillRect(context, CGRectMake(x, y, 1, 1));
                    CGContextStrokePath(context);
                }
                // Draw right half of product.
                seta = 360 * rad360 - seta;
                position = sizeofRadial * seta + RadialHeadLength + r / iRefBinLen;
                value = charvalue[position / sizeof(unsigned char) - 1];
                if (value > 1)
                {
                    colorValueArray = (NSArray*)([_colorArray objectAtIndex:value]);
                    CGContextSetRGBFillColor(context,
                                             [[NSNumber numberWithFloat:[colorValueArray[0] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[1] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[2] floatValue]] floatValue],1.0);
                    CGContextFillRect(context, CGRectMake(xLeft - (x - xMin) - 1, y, 1, 1));
                    CGContextStrokePath(context);
                }
            }
        }
    }
    // Show image...
    productImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
