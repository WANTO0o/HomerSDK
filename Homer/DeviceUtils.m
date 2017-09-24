//
//  DeviceUtils.m
//  SlideMenu
//
//  Created by 邱林 on 15/7/19.
//  Copyright (c) 2015年 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceUtils.h"

#define DEVICE_PATTERN_TYPE  @"^I'm ((\\w)+( )*)+\\."
#define  DEVICE_PATTERN_BSSID @"([0-9a-fA-F]{2}:){5}([0-9a-fA-F]{2} )"
#define  DEVICE_PATTERN_IP  @"(\\d+\\.){3}(\\d+)$"

@implementation DeviceUtils
//数据格式验证.
+(bool)isValid:(NSString*)data{
    
    NSString *str =[DEVICE_PATTERN_TYPE stringByAppendingString:DEVICE_PATTERN_BSSID];
    NSString *DEVICE_PATTERN = [str stringByAppendingString:DEVICE_PATTERN_IP];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DEVICE_PATTERN];
    BOOL isValid = [predicate evaluateWithObject:data];
    return isValid;
}

//设备类型验证.
+(NSString*)filterType:(NSString*)data{
    
    NSArray *aArray = [data componentsSeparatedByString:@"."];
    
    NSArray *aArray1 =  [aArray[0] componentsSeparatedByString:@" "];
    return aArray1[1];
}

//IP提取.

+(NSString*) filterIpAddress:(NSString*)data
{
    NSArray *aArray = [data componentsSeparatedByString:@" "];
    return aArray[aArray.count - 1];
}

//ssid提取.
+(NSString*)  filterBssid:(NSString*)data
{
    
    NSArray *aArray = [data componentsSeparatedByString:@"."];
    NSArray *aArray1 =  [aArray[1] componentsSeparatedByString:@" "];
    return aArray1[0];
    
}

+(bool)isMesh:(NSString*)data
{
    return [data containsString:@"with mesh"];
}

@end