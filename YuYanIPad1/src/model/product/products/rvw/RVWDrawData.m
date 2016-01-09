//
//  RVWDrawData.m
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import "RVWDrawData.h"
#import "YuYanIpad1-Swift.h"

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
    unsigned char *charvalue = (unsigned char *)[[data subdataWithRange:NSMakeRange(sizeof(fileHeadStruct), data.length - sizeof(fileHeadStruct))] bytes];
    uint value = 0;
    int x_x0 = 0;
    int y_y0 = 0;
    int seta = 0;
    int position = 0;
    float r = 0.0;
    float fAzi = 0.0;
    NSArray *colorValueArray = nil;
    UIGraphicsBeginImageContext(productImgView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int x = 0; x < productImgView.frame.size.width; x++)
    {
        x_x0 = x - self.centX;
        for (int y = 0; y < productImgView.frame.size.height; y++)
        {
            y_y0 = self.centY - y;
            r = sqrt(x_x0 * x_x0 + y_y0 * y_y0);
            if (r <= iRadius)
            {
                fAzi = atan2(x_x0, y_y0) * 180.0 / M_PI;
                if (fAzi < 0) fAzi += 360.0;
                seta = fAzi * rad360;
                position = sizeofRadial * seta + 64 + (int)(r * _det);
                if(position < data.length - 1)
                {
                    value = charvalue[position / sizeof(unsigned char) - 1];
                }

                if (value > 255) value = 255;
                if (value > 1)
                {
                    colorValueArray = (NSArray*)([_colorArray objectAtIndex:value]);
                    CGContextSetRGBFillColor(context,
                                             [[NSNumber numberWithFloat:[colorValueArray[0] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[1] floatValue]] floatValue],
                                             [[NSNumber numberWithFloat:[colorValueArray[2] floatValue]] floatValue],1.0);
                    CGContextFillRect(context, CGRectMake(x, y, 1, 1));
                    CGContextStrokePath(context);
                }else{
//                    CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
//                    CGContextFillRect(context, CGRectMake(x, y, 1, 1));
//                    CGContextStrokePath(context);
                }
            }
        }
    }
    // Show image...
    productImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
