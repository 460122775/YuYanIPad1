//
//  RHIDrawData.m
//  RadarIPad
//
//  Created by Yachen Dai on 8/12/14.
//  Copyright (c) 2014 Yachen Dai. All rights reserved.
//

#import "RHIDrawData.h"

#define RHIPadding 30
#define NumOfRadial 600
#define DrawElejingdu 90.0/NumOfRadial

@implementation RHIDrawData

@synthesize subType;

static float Xmax = 0.0;
static float Ymax = 20;

-(id)init
{
    self.subType = ProductType_R;
    return [super init];
}

-(void)getImageData:(UIImageView *) productImgView andData:(NSData *) data
{
    //    DLog(@">>>>>>>>Start Draw Product.[%i]", data.length);
    if (!data) return;
    [super getImageData:productImgView andData:data];
    
    sizeofRadial = fileHeadStruct.obserSec.usRefBinNumber[0] + 64;
    int numCut = fileHeadStruct.obserSec.iRadialNum[0];
    nRangbin = fileHeadStruct.obserSec.usRefBinNumber[0];
    
    unsigned short *shortValue = (unsigned short *)[[data subdataWithRange:NSMakeRange(sizeof(fileHeadStruct), data.length - sizeof(fileHeadStruct))] bytes];
    unsigned short value = 0;
    int x_x0 = 0;
    int y_y0 = 0;
    int seta = 0;
    int position = 0;
    float r = 0.0;
    float fAzi = 0.0;
    NSMutableArray *colorDataArray = [ColorModel getCurrentColorDataArray];
    NSArray *colorValueArray = nil;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f], NSFontAttributeName, ProductTextColor, NSForegroundColorAttributeName,nil];
    
    UIGraphicsBeginImageContext(productImgView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0.2, 0.27, 0.55, 1);
    CGContextStrokePath(context);
    
    // Draw Horizontal line.
    int xBlockNum = 6;
    int yBlockNum = 4;
    int blockWidth = (productImgView.frame.size.width - RHIPadding * 2) / xBlockNum;
    int blockHeight = (productImgView.frame.size.height - RHIPadding * 2) / yBlockNum;
    for (int i = 0; i < yBlockNum + 1; i++)
    {
        if (i == 0 || i == yBlockNum)
        {
            CGContextMoveToPoint(context, RHIPadding,
                                 (productImgView.frame.size.height - RHIPadding * 2) - blockHeight * i + RHIPadding);
            CGContextAddLineToPoint(context, productImgView.frame.size.width - RHIPadding,
                                    (productImgView.frame.size.height - RHIPadding * 2) - blockHeight * i + RHIPadding);
        }
        
        // Draw first number...
        if (i == yBlockNum)
        {
            [@"km" drawAtPoint:CGPointMake(Padding - 25, productImgView.frame.size.height - blockHeight * i + Padding - 10) withAttributes:dic];
        }
    }
    
    Xmax = nRangbin * ikuchang / self.zoomValue;
    for (int j = 0; j < xBlockNum + 1; j++)
    {
        if (j == 0)
        {
            CGContextMoveToPoint(context, RHIPadding + blockWidth * j, RHIPadding);
            CGContextAddLineToPoint(context, RHIPadding + blockWidth * j,
                                    (productImgView.frame.size.height - RHIPadding * 2) + RHIPadding);
        }else if (j == xBlockNum){
            CGContextMoveToPoint(context, RHIPadding + (productImgView.frame.size.width - RHIPadding * 2), RHIPadding);
            CGContextAddLineToPoint(context, RHIPadding + (productImgView.frame.size.width - RHIPadding * 2),
                                    (productImgView.frame.size.height - RHIPadding * 2) + RHIPadding);
        }
    }
    
    dataArray = [[NSMutableArray alloc] init];
    int _radialNumber = 0;
    int radialNumberTemp = 0;
    for (int radialnum = 0; radialnum < NumOfRadial; radialnum++)
    {
        dataArray[radialnum] = [[NSMutableArray alloc] init];
    }
    float foreEle = 0.0;
    float currentEle = 0.0;
    float nextEle = 0.0;
    for (int radialnum = 0; radialnum < numCut; radialnum++)
    {
        position = 6 + radialnum * (nRangbin * 3 + 64);
        if(position < data.length - 1)
        {
//            currentEle = charvalue[position / sizeof(unsigned short) - 1] / 100.0;
        }
        if (radialnum > 0 && radialnum < numCut - 1)
        {
            position = 6 + (radialnum + 1) * (nRangbin * 3 + 64);
            if(position < data.length - 1)
            {
                nextEle = shortValue[position / sizeof(unsigned short) - 1] / 100.0;
            }
            if (foreEle > nextEle && currentEle < nextEle)
            {
                currentEle = (foreEle + nextEle) / 2;
            }
            if (foreEle < nextEle && currentEle < foreEle)
            {
                currentEle = (foreEle + nextEle) / 2;
            }
        }
        _radialNumber = currentEle / DrawElejingdu;
        int index = 0;
        if (radialnum > 0)
        {
            if (radialNumberTemp < (_radialNumber - 1))
            {
                for (int i = radialNumberTemp + 1; i < _radialNumber; i++)
                {
                    dataArray[i] = dataArray[_radialNumber];
                }
            }else if (radialNumberTemp > _radialNumber + 1){
                for (int i = radialNumber + 1; i < radialNumberTemp; i++)
                {
                    dataArray[i] = dataArray[_radialNumber];
                }
            }
        }
        for (int rangebinnum = 0; rangebinnum < nRangbin; rangebinnum++)
        {
            switch (self.subType)
            {
                case ProductType_R:
                    index = 64 + radialnum * (nRangbin * 3 + 64) + rangebinnum;
                    break;
                case ProductType_V:
                    index = 64 + radialnum * (nRangbin * 3 + 64) + nRangbin + rangebinnum;
                    break;
                case ProductType_W:
                    index = 64 + radialnum * (nRangbin * 3 + 64) + nRangbin * 2 + rangebinnum;
                    break;
                default:
                    break;
            }
            position = index;
            if (position < data.length - sizeof(fileHeadStruct))
            {
//                dataArray[_radialNumber][rangebinnum] = shortValue[position / sizeof(unsigned short) - 1];
            }
        }
    }
    
    // Show image...
    productImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)getProductInfo:(UIView *) productInfoView TitleLabel:(UILabel*)titleLabel Data:(NSData *) data
{
    [data getBytes:&fileHeadStruct range:NSMakeRange(0, sizeof(fileHeadStruct))];
    
    for(UIView *view in [productInfoView subviews])
    {
        [view removeFromSuperview];
    }
    
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop, labelWidth, 20)];
    [productNameLabel setTextColor:ProductTextColor];
    [productNameLabel setText:[NSString stringWithFormat:@"产品名称：基本反射率(Z) ［%.2f°］", fileHeadStruct.obserSec.iElevation[0] / 100.f]];
    [productInfoView addSubview:productNameLabel];
    
    UILabel *radarTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + 20 + VGap, labelWidth, 20)];
    [radarTypeLabel setTextColor:ProductTextColor];
    [radarTypeLabel setText:[NSString stringWithFormat:@"雷达型号：%s", fileHeadStruct.addSec.RadarType]];
    [productInfoView addSubview:radarTypeLabel];
    
    UILabel *siteNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 2, labelWidth, 20)];
    [siteNameLabel setTextColor:ProductTextColor];
    [siteNameLabel setText:[NSString stringWithFormat:@"站点名称：%s", fileHeadStruct.addSec.Station]];
    [productInfoView addSubview:siteNameLabel];
    
    UILabel *siteLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 3, labelWidth, 20)];
    [siteLongitudeLabel setTextColor:ProductTextColor];
    [siteLongitudeLabel setText:[NSString stringWithFormat:@"站点经度：E %li°%li′%li″",
                                 fileHeadStruct.addSec.LongitudeV/360000,
                                 (fileHeadStruct.addSec.LongitudeV / 100) % 3600 / 60,
                                 (fileHeadStruct.addSec.LongitudeV / 100) % 60]];
    [productInfoView addSubview:siteLongitudeLabel];
    
    UILabel *siteLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 4, labelWidth, 20)];
    [siteLatitudeLabel setTextColor:ProductTextColor];
    [siteLatitudeLabel setText:[NSString stringWithFormat:@"站点纬度：N %li°%li′%li″",
                                fileHeadStruct.addSec.LatitudeV/360000,
                                (fileHeadStruct.addSec.LatitudeV / 100) % 3600 / 60,
                                (fileHeadStruct.addSec.LatitudeV / 100) % 60]];
    [productInfoView addSubview:siteLatitudeLabel];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 5, labelWidth, 20)];
    [heightLabel setTextColor:ProductTextColor];
    [heightLabel setText:[NSString stringWithFormat:@"天线海拔：%.f m", fileHeadStruct.addSec.Height/1000.0f]];
    [productInfoView addSubview:heightLabel];
    
    UILabel *maxDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 6, labelWidth, 20)];
    [maxDistanceLabel setTextColor:ProductTextColor];
    [maxDistanceLabel setText:[NSString stringWithFormat:@"最大测距：%i km", fileHeadStruct.obserSec.iRefBinLen[0] * fileHeadStruct.obserSec.usRefBinNumber[0]/1000]];
    [productInfoView addSubview:maxDistanceLabel];
    
    UILabel *distancePixLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 7, labelWidth, 20)];
    [distancePixLabel setTextColor:ProductTextColor];
    [distancePixLabel setText:[NSString stringWithFormat:@"距离分辨率：%i m", fileHeadStruct.obserSec.iRefBinLen[0]]];
    [productInfoView addSubview:distancePixLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(productPaddingLeft, productPaddingTop + (20 + VGap) * 8, labelWidth, 20)];
    [dateLabel setTextColor:ProductTextColor];
    [dateLabel setText:[NSString stringWithFormat:@"日       期：%04i/%02i/%02i  %02i:%02i:%02i",
                        fileHeadStruct.obserSec.iObsStartTimeYear,
                        fileHeadStruct.obserSec.iObsStartTimeMonth,
                        fileHeadStruct.obserSec.iObsStartTimeDay,
                        fileHeadStruct.obserSec.iObsStartTimeHour,
                        fileHeadStruct.obserSec.iObsStartTimeMinute,
                        fileHeadStruct.obserSec.iObsStartTimeSecond]];
    [productInfoView addSubview:dateLabel];
}


@end
