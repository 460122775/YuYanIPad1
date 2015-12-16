//
//  ProductDefine.h
//  RadarIPad
//
//  Created by Yachen Dai on 12/6/13.
//  Copyright (c) 2013 Yachen Dai. All rights reserved.
//


/*! \file basefilehead_fl.h
 \brief
 \ingroup GRSGroup
 
 \version 1.0
 \author lava_sdb
 \date 2008/09/06
 
 \b modify log:
 \arg \c version 1.00,lava_sdb,2008/09/06 Create
 \arg \c version 1.01,lava_sdb,2008/10/29 增加了命名空间
 
 \ingroup GRSInterface
 */

#ifndef _HEADER_FLBaseFileHead_20080906
#define _HEADER_FLBaseFileHead_20080906


#pragma pack(1)

#pragma -mark 实时数据站址参数段


typedef struct _REAL_ADDR_SECTION  //【160】
{
    short int HeadLen;  //!< 文件头长度 1266 【2】
    union{
        char RadarType[20];    //!< 雷达型号  【20】
        char Nation[20];    //!< 国名  【20】
    };
    char Province[20];     //!< 省名  【20】
    char Station[20];   //!< 站点名  【20】   历史版本：区名
    union{
        char StationNo[20]; //!< 站点编号  【20】 历史版本：区站名
        char SectionSta[20]; //!< 区站名  【20】
    };
    union{
        unsigned char FileVer;//文件版本，见顶端联合体定义
        char Type[20];	 //!< 文件格式版本号 [4 - 7]存放数据来源 【20】
    };
    union{
        struct{
            char ScanModeName[20];  //!<  雷达扫描名称 【20】    FILE_VER_XFL使用
            char Reserve2[20];   //!< 保留 【20】    历史版本：Latitude[20] 格式N35度30'15"
        };
        struct{
            char Longitude[20];  //!< 格式E15度32'12"  【20】
            char Latitude[20];   //!< 格式N35度30'15"  【20】
        };
    };
    int LongitudeV; //!< 天线所在径度的数值表示，单位取1／360000度(东经为整，西径为负)   **  【4】
    int LatitudeV;  //!< 天线所在纬度的数值表示，单位取1／360000度(北纬为正，南纬为负)   **  【4】
    int Height;	 //!< 天线所在的海拔高度，以mm为单位                                **  【4】
    short int Elevation; //!< 测站四周地物的最大仰角(以百分之一度为单位)  【2】
    short int Elevation1; //!< 测站的最佳观测仰角(地物回波强度10dbz)，以百分之一度为单位  【2】
    union{
        short int Reserve3;  //!< 保留 【2】    历史版本：Category 站点编号
        short int Category;  //!< 站点编号  【2】
    };
    
}REAL_ADDR_SEC,tagRealAddrSec;


#pragma -mark 雷达性能参数段
typedef struct _REAL_CAPABILITY_SECTION // 【40】
{
    unsigned short int   iAntennaPlus;	//!< 天线增益,以0.01dB为计数单位  【2】
    unsigned short int   iVBeamwidth;		//!< 垂直波束宽度 单位取百分之一度      **  【2】
    unsigned short int   iHBeamwidth;	//!< 水平波束宽度  单位取百分之一度     **  【2】
    unsigned short int   iPolarzation;	/*! 极化状况  【2】
                                         - 0：为水平极化；
                                         - 1：垂直极化；
                                         - 2：为双极化（双偏振）；
                                         - 3：为圆偏振；
                                         - 4：其它
                                         */
    unsigned int	iWaveLength;			//!< 波长，以微米为单位          **  【2】
    unsigned int	 iPeakPower;	//!< 雷达峰值功率，以瓦为单位  【4】
    union{
        unsigned short int   iSidelobeLevel;	//!< 第一旁瓣电平，取绝对值（单位取百分之一dB）  【2】
        unsigned short int   iLogExtent; //!< 对数接收机动态范围，以百分之一dB为单位  【2】
    };
    
    unsigned short int   iLinearExtent; //!< 线性接收机动态范围，以百分之一dB为单位  【2】
    unsigned short int   iAGCDelayAmount; //!< AGC延迟量，以微秒为单位  【2】
    unsigned short int   iLogMinObsPower; //!< 对数接收机最小可测功率，以百分之一dbmw为单位  【2】
    unsigned short int   iLinearMinObsPower; //!< 线性接收机最小可测功率，以百分之一dbmw为单位  【2】
    unsigned short int   iNoiseThr;  //!< 噪声消除的量化阀值（0-255）  【2】
    unsigned short int   iClutterRejectionThr;    //!< 多普勒杂波消除阀值，单位db  【2】
    unsigned short int   iSQIThreshold;       //!< SQI阀值（0-1）：实际值乘1000  【2】
    unsigned short int   iVProcessMode; /*! 速度处理方式   【2】
                                         0:无速度处理；
                                         1:PPI；
                                         2:FFT；
                                         */
    unsigned short int   iCluProcessMode; /*! 地物处理方式  【2】
                                           - 0:无地物处理；
                                           - 1:地物杂波图扣除法；
                                           - 2:滤波器处理；
                                           - 3:滤波器＋地物杂波图法；
                                           - 4:谱分析法
                                           */
    unsigned short int   iIntensityGangway;   /*! 强度估算距离订正方式 【2】
                                               - 1:对数;
                                               - 2:线性
                                               */
    unsigned short int   iRangeReduction;    //!< 【2】
}REAL_CAPABILITY_SEC,tagRealCapabilitySec;

#pragma -mark 批处理模式结构体
struct _BATCH_SCAN  // 【92】
{
    unsigned short int scanmode;  /*! 雷达扫描模式:  【2】
                                   - 在风灵系统下：[0,255]降雨模式 [256,511] 晴空模式
                                   - 在大船项目下：
                                   - XX6,	"0"RHI晴空，"1"RHI降雨"
                                   "2"PPI晴空，"3"PPI降雨
                                   "4"VOL晴空，"5"VOL降雨
                                   - XX2,		"0"体扫强度（兼容），"1"体扫速度（兼容）,
                                   "2"PPI强度（兼容），"3"PPI速度（兼容）,
                                   "4"体扫强度（气象），"5"体扫速度（气象）,
                                   "6"PPI强度（气象），"7"PPI速度（气象）,
                                   */
    char wavForm[30];		/*! spare[2 - 31], 存储体扫各层的扫描方式  【30】
                             - 0 lcs 模式（R）
                             - 1 lcd 模式（V、W）
                             - 2 hcd( RVW )
                             - 3
                             - 4 batch 模式( RVW )
                             */
    unsigned short int usDopBinNumber[30]; //!< 各层的多普勒距离库数，usDopBinNumber  【60】
};


#pragma -mark 实时数据观察参数段
typedef struct _REAL_OBSERVATION_SECTION  // 【1066】
{
    unsigned short int iProductNumber;	/*! 产品编号 <0>        **  【2】
                                         - 0:PPI1
                                         - 1:RHI
                                         - 2:立体扫描
                                         - 3.反射率
                                         - 4.速度
                                         - 5.谱宽
                                         */
    
    unsigned short int   iScanCutNum;	//!< 立体扫描层数（PHI扫描填零，PPI扫描时填1）<2> **  【2】
    unsigned short int   iObsStartTimeYear;		//!< 观测开始时间 年（4位数如2000）	<4>  【2】
    unsigned short int   iObsStartTimeMonth;		//!< 观测开始时间 月（01-12）<6>  【2】
    unsigned short int   iObsStartTimeDay;		//!< 观测开始时间 日（01-31）  【2】
    unsigned short int   iObsStartTimeHour;		//!< 观测开始时间 小时（00-23）  【2】
    unsigned short int   iObsStartTimeMinute;		//!< 观测开始时间 分（00-59）  【2】
    unsigned short int   iObsStartTimeSecond;		//!< 观测开始时间 秒（00-59）  【2】
    unsigned int        iGPSStartTime;		//!< 开始GPS时间(无GPS填零)  【4】
    unsigned short int   iCalibrate;	/*! 定标情况  【2】
                                         - 0:没有定标
                                         - 1:自动定标
                                         - 2:一周内人工定标
                                         - 3:一月内人工定标
                                         */
    unsigned short int   iIntensityIntNum;		//!< 强度积分次数  【2】
    unsigned short int   iVSample;			//!< 速度处理样本数  【2】
    union  // 【120】
    {
        unsigned int id[30];				//!< ID 号，仅对体扫产品有用  【120】
        float parame[30];                   //产品的参数  【120】
    };
    
    unsigned char cObsEssential[30];		/*! 观测要素            **  【30】
                                             - 1:单强度
                                             - 2:单速度（单PRF）
                                             - 3:速度+谱宽（单PRF）
                                             - 4:单速度（双PRF）
                                             - 5:速度+谱宽（双PRF）
                                             - 6:强度+速度（单PRF）
                                             - 7:强度+速度（双PRF）
                                             - 8:三要素（单PRF）
                                             - 9:三要素（双PRF）
                                             - 10：四要素（ConR + R + V + W，单PRF）
                                             - 11：四要素（ConR + R + V + W，双PRF）
                                             */
    unsigned char cVDeblurring[30];		/*! 速度退模糊  【30】
                                         - 0.无退模糊处理；
                                         - 1.软件退模糊；
                                         - 2.双PRF退模糊；
                                         - 3.批式退模糊；
                                         - 4.批式加软件退模糊；
                                         - 5.双PRF退模糊；
                                         - 6.双PRF+软件退模糊
                                         */
    unsigned short int   iFirstKindPRF[30];	//!< 各层第一种脉冲重复频率*，计数单位1/10HZ  【60】
    unsigned short int   iSecondKindPRF[30];	//!< 各层第二种脉冲重复频率*，计数单位1/10HZ  【60】
    unsigned short int   iPulseWidth[30];	//!< 各层脉冲宽度(1/100微秒)      **  【60】
    unsigned short int   iMaxObsVel[30];		//!< 各层的最大可测速度；单位：厘米/秒  【60】
    unsigned short int   usRefBinNumber[30];		//!< 各层的反射率距离库数，usRefBinNumber  【60】
    unsigned short int   iRadialNum[30];	//!< 各层采样的径向数   各层径向数相同   **  【60】
    
    union // 【60】
    {
        unsigned short int   iBinNumber[30];		//!< 各层每个径向上的库数（或数据数）    **  【60】
        unsigned short int   iDopBinLen[30]; //!< 各层多普勒库长（或每个数据代表的长度）***，以米为单位   **  【60】
    };
    unsigned short int   iRefBinLen[30];		//!< 各层反射率库长（或每个数据代表的长度）***，以米为单位   **  【60】
    unsigned short int   iFirstBinDis[30];		//!< 各层径向上的第一个库（或数据）的开始距离（以米为单位）  **  【60】
    unsigned int   iPPIStartPos[30] ;  //!< 各层PPI 在文件中开始的位置(字节，含文件头)        **  【120】
    short int iElevation[30];		/*!  各层的仰角，单位1/100度    **  【60】
                                     - 做PPI时
                                     -# 仅在第一层填写仰角数。
                                     - 做RHI时
                                     -# 第一层填写方位数
                                     -# 第二层填写RHI的最低仰角
                                     -# 第三层填写RHI的最高仰角
                                     */
    char cDataArrayMode;		/*! 一个径向中的数据排列方式      ** 【1】
                                 - 11按库排列：库中先速度后强度（两要素）
                                 - 12按库排列：库中先强度后速度（两要素）
                                 - 13按库排列：库中先速度后谱宽（两要素）
                                 - 14按库排列：库中先速度后强度再谱宽
                                 - 15按库排列：库中先强度后速度再谱宽
                                 - 21按要素排列：单强度,地物滤波( ConR )
                                 - 22按要素排列：单速度( V )
                                 - 23按要素排列：先强度后速度( ConR + V )
                                 - 24按要素排列：先速度后强度( V + ConR )
                                 - 25按要素排列：先速度后谱宽( V + W )
                                 - 26按要素排列：先速度后强度再谱宽( V + ConR + W )
                                 - 27按要素排列：先强度后速度再谱宽( ConR + V + W )
                                 - 31 346-S, 按要素排列:  ConR
                                 - 32 346-S, 按要素排列:  R
                                 - 33 346-S, 按要素排列:  ConR + R
                                 - 34 346-S, 按要素排列:  ConR + V + W
                                 - 35 346-S, 按要素排列:  R + V + W
                                 - 36 346-S, 按要素排列:  ConR + R + V + W
                                 */
    unsigned char cRByteCount;	/*! 一个强度数据占用的字节数，百位数表示  【1】
                                 - 是否有符号位，
                                 -#  Oxx：表示不无符号位；
                                 -# 1xx：表示有符号位
                                 */
    unsigned char cVByteCount;	/*! 一个速度数据占用的字节数，百位数表示是否有符号位  【1】
                                 - Oxx：表示无符号位；
                                 - 1xx：表示有符号位。
                                 */
    unsigned char cWByteCount;	/*! 一个谱宽数据占用的字节数，百位数表示是否有符号位  【1】
                                 - 0:表示不无符号位；
                                 - 1:表示有符号位。
                                 */
    short int iRNoEchoCode;	//!< 强度：无回波的代表码        **  【2】
    short int iVNoEchoCode;		//!< 速度：无回波的代表码  【2】
    short int iWNoEchoCode;		//!< 谱宽：无回波的代表码  【2】
    short int iRMinIncrement;	//!< 数据中的强度最小增量01000  【2】
    short int iVMinIncrement;		//!< 数据中的速度最小增量*1000  【2】
    short int iWMinIncrement;		//!< 数据中的谱宽最小增量*1000  【2】
    short int iRef0;		//!< 强度：如果用无符号类型数表示，填写代表零的数值  【2】
    short int iVel0;		//!< 速度：如果用无符号类型数表示，填写代表零的数值  【2】
    short int iWid0;		//!< 谱宽：如果用无符号类型数表示，填写代表零的数值  【2】
    unsigned short int   iObsEndTimeYear;	//!< 观测结束时间，年(四位数)  【2】
    unsigned short int   iObsEndTimeMonth;	//!< 观测结束时间，月(1-12)  【2】
    unsigned short int   iObsEndTimeDay;	//!< 观测结束时间，日(1-31)  【2】
    unsigned short int   iObsEndTimeHour;	//!< 观测结束时间，时(00-23)  【2】
    unsigned short int   iObsEndTimeMinute;	//!< 观测结束时间，分(00-59)  【2】
    unsigned short int   iObsEndTimeSecond;	//!< 观测结束时间，秒(00-59)  【2】
    unsigned int        iGPSEndTime;	//!< GPS时间(无GPS填零)  【4】
    unsigned short int   iStructSize;	//!< 应写注结构(1)数组的大小。 【2】
    union  // 【100】
    {
        char spare[100];  // 【100】
        struct _BATCH_SCAN batch;  // 【92】
    };
}REAL_OBSER_SEC,tagRealObserSec;


#pragma -mark 雷达产品数据文件文件头
typedef struct _REAL_FILE  // 【1266】
{
    tagRealAddrSec addSec;	//!< 站址参数段  【160】
    tagRealCapabilitySec capabilitySec; //!< 性能参数段  【40】
    tagRealObserSec obserSec;	//!< 观察参数段  【1066】
}tagRealFile;
#pragma pack()

#endif




