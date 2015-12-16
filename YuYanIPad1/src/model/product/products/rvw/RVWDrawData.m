//
//  RVWDrawData.m
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//

#import "RVWDrawData.h"

@implementation RVWDrawData

-(id)init
{
    return [super init];
}
//
//-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data
//{
////    DLog(@">>>>>>>>Start Draw Product.[%i]", data.length);
//    if (!data) return;
//    [super getImageData:productImgView andData:data];
//    unsigned char *charvalue = (unsigned char *)[[data subdataWithRange:NSMakeRange(sizeof(fileHeadStruct), data.length - sizeof(fileHeadStruct))] bytes];
//    unsigned char value = 0;
//    int x_x0 = 0;
//    int y_y0 = 0;
//    int seta = 0;
//    int position = 0;
//    float r = 0.0;
//    float fAzi = 0.0;
//    NSMutableArray *colorDataArray = [ColorModel getCurrentColorDataArray];
//    NSArray *colorValueArray = nil;
//    UIGraphicsBeginImageContext(productImgView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (int x = 0; x < productImgView.frame.size.width; x++)
//    {
//        x_x0 = x - self.centX;
//        for (int y = 0; y < productImgView.frame.size.height; y++)
//        {
//            y_y0 = self.centY - y;
//            r = sqrt(x_x0 * x_x0 + y_y0 * y_y0);
//            if (r <= iRadius)
//            {
//                fAzi = atan2(x_x0, y_y0) * 180.0 / M_PI;
//                if (fAzi < 0) fAzi += 360.0;
//                seta = fAzi * rad360;
//                position = sizeofRadial * seta + 64 + (int)(r * _det);
//                if(position < data.length - 1)
//                {
//                    value = charvalue[position / sizeof(unsigned char) - 1];
//                }
//
//                if (value > 255) value = 255;
//                if (value > 1)
//                {
//                    colorValueArray = (NSArray*)([colorDataArray objectAtIndex:value]);
//                    CGContextSetRGBFillColor(context,
//                                             [(NSString*)colorValueArray[0] floatValue],
//                                             [(NSString*)colorValueArray[1] floatValue],
//                                             [(NSString*)colorValueArray[2] floatValue], 1.0);
//                    CGContextFillRect(context, CGRectMake(x, y, 1, 1));
//                    CGContextStrokePath(context);
//                }else{
////                    CGContextSetRGBFillColor(context, 0, 0, 0, 1.0);
////                    CGContextFillRect(context, CGRectMake(x, y, 1, 1));
////                    CGContextStrokePath(context);
//                }
//            }
//        }
//    }
//    // Show image...
//    productImgView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}
//
//-(void)getProductInfo:(UIView *) productInfoView TitleLabel:(UILabel*)titleLabel Data:(NSData *) data
//{
//    [data getBytes:&fileHeadStruct range:NSMakeRange(0, sizeof(fileHeadStruct))];
//    
//    for(UIView *view in [productInfoView subviews])
//    {
//        [view removeFromSuperview];
//    }
//    
//    UILabel *radarTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop, labelWidth, 20)];
//    [radarTypeLabel setTextColor:ProductTextColor];
//    [radarTypeLabel setText:[NSString stringWithFormat:@"雷达型号：%s", fileHeadStruct.addSec.RadarType]];
//    [productInfoView addSubview:radarTypeLabel];
//    
//    UILabel *siteNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 1, labelWidth, 20)];
//    [siteNameLabel setTextColor:ProductTextColor];
//    [siteNameLabel setText:[NSString stringWithFormat:@"站点名称：%s", fileHeadStruct.addSec.Station]];
//    [productInfoView addSubview:siteNameLabel];
//    
//    UILabel *siteLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 2, labelWidth, 20)];
//    [siteLongitudeLabel setTextColor:ProductTextColor];
//    [siteLongitudeLabel setText:[NSString stringWithFormat:@"站点经度：E %i°%i′%i″",
//                                 fileHeadStruct.addSec.LongitudeV/360000,
//                                 (fileHeadStruct.addSec.LongitudeV / 100) % 3600 / 60,
//                                 (fileHeadStruct.addSec.LongitudeV / 100) % 60]];
//    [productInfoView addSubview:siteLongitudeLabel];
//    
//    UILabel *siteLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 3, labelWidth, 20)];
//    [siteLatitudeLabel setTextColor:ProductTextColor];
//    [siteLatitudeLabel setText:[NSString stringWithFormat:@"站点纬度：N %i°%i′%i″",
//                                fileHeadStruct.addSec.LatitudeV/360000,
//                                (fileHeadStruct.addSec.LatitudeV / 100) % 3600 / 60,
//                                (fileHeadStruct.addSec.LatitudeV / 100) % 60]];
//    [productInfoView addSubview:siteLatitudeLabel];
//    
//    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 4, labelWidth, 20)];
//    [heightLabel setTextColor:ProductTextColor];
//    [heightLabel setText:[NSString stringWithFormat:@"天线海拔：%.f m", fileHeadStruct.addSec.Height/1000.0f]];
//    [productInfoView addSubview:heightLabel];
//    
//    UILabel *maxDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 5, labelWidth, 20)];
//    [maxDistanceLabel setTextColor:ProductTextColor];
//    [maxDistanceLabel setText:[NSString stringWithFormat:@"最大测距：%i km", fileHeadStruct.obserSec.iRefBinLen[0] * fileHeadStruct.obserSec.usRefBinNumber[0]/1000]];
//    [productInfoView addSubview:maxDistanceLabel];
//    
//    UILabel *distancePixLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 6, labelWidth, 20)];
//    [distancePixLabel setTextColor:ProductTextColor];
//    [distancePixLabel setText:[NSString stringWithFormat:@"距离分辨率：%i m", fileHeadStruct.obserSec.iRefBinLen[0]]];
//    [productInfoView addSubview:distancePixLabel];
//    
//    
////    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 8, labelWidth, 20)];
////    [dateLabel setTextColor:ProductTextColor];
//    [titleLabel setTextColor:ProductTextColor];
//    [titleLabel setText:[NSString stringWithFormat:@"%04i-%02i-%02i %02i:%02i:%02i",
//                        fileHeadStruct.obserSec.iObsStartTimeYear,
//                        fileHeadStruct.obserSec.iObsStartTimeMonth,
//                        fileHeadStruct.obserSec.iObsStartTimeDay,
//                        fileHeadStruct.obserSec.iObsStartTimeHour,
//                        fileHeadStruct.obserSec.iObsStartTimeMinute,
//                        fileHeadStruct.obserSec.iObsStartTimeSecond]];
//    switch(self.productInfo.productType)
//    {
//        case ProductType_R:[titleLabel setText:[NSString stringWithFormat:@"%@   基本反射率(Z) ［%.2f°］", titleLabel.text, fileHeadStruct.obserSec.iElevation[0] / 100.f]];break;
//        case ProductType_V:[titleLabel setText:[NSString stringWithFormat:@"%@   基本反射率(V) ［%.2f°］", titleLabel.text, fileHeadStruct.obserSec.iElevation[0] / 100.f]];break;
//        case ProductType_W:[titleLabel setText:[NSString stringWithFormat:@"%@   基本反射率(W) ［%.2f°］", titleLabel.text, fileHeadStruct.obserSec.iElevation[0] / 100.f]];break;
//    }
//}



@end
