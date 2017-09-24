//
//  DeviceUtils.h
//  SlideMenu
//
//  Created by 邱林 on 15/7/19.
//  Copyright (c) 2015年 Aryan Ghassemi. All rights reserved.
//




@interface DeviceUtils:NSObject




//数据格式验证.
+(bool)isValid:(NSString*)data;

//设备类型验证.
+(NSString*)filterType:(NSString*)data;

//IP提取.
+(NSString*) filterIpAddress:(NSString*)data;

//ssid提取.
+(NSString*)  filterBssid:(NSString*)data;


+(bool)isMesh:(NSString*)data;



@end