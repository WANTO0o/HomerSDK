//
//  Homer.m
//  Homer
//
//  Created by 邱林 on 16/8/18.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import "Homer.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ESPTouchTask.h"
#import "UDPBroadcastUtil.h"


// only support ipV4 at the moment
#define IP_LEN 4

ESPTouchTask *_esptouchTask;

@implementation Homer

- (id)init
{
    self = [super init];
    if (self)
    {
        _esptouchTask = nil;
    }
    return self;
}

-(NSString *) getSsid {
    NSDictionary *netInfo = [self fetchNetInfo];
    NSString * ssidStr = [netInfo objectForKey:@"SSID"];
    return ssidStr;
}

//- (ESPTouchResult *)connectWithApSsid:(NSString *)apSsid andApPwd:(NSString *)apPwd andTimeoutMillisecond:(int) timeoutMillisecond andResultDelegate:(NSObject<ESPTouchDelegate> *)resultDelegate
//{
//    NSDictionary *netInfo = [self fetchNetInfo];
//    NSString *bssid = [netInfo objectForKey:@"BSSID"];
//    
//    _esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:bssid andApPwd:apPwd andIsSsidHiden:FALSE andTimeoutMillisecond:timeoutMillisecond];
//    if(resultDelegate != nil)
//    {
//        [_esptouchTask setEsptouchDelegate:resultDelegate];
//    }
//    
//    ESPTouchResult * esptouchResult = [_esptouchTask executeForResult];
//    
//    return esptouchResult;
//
//}

-(void) connectWithApSsid: (NSString *)apSsid andApPwd: (NSString *)apPwd andTimeoutMillisecond: (int) timeoutMillisecond andDelegate:(NSObject<HomerConnectDelegate> *)resultDelegate
{
    NSDictionary *netInfo = [self fetchNetInfo];
    NSString *bssid = [netInfo objectForKey:@"BSSID"];
    NSObject<ESPTouchDelegate> *espTouchDelegate;
    
    _esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:bssid andApPwd:apPwd andIsSsidHiden:FALSE andTimeoutMillisecond:timeoutMillisecond];
    
    [_esptouchTask setEsptouchDelegate:espTouchDelegate];
    
    ESPTouchResult * esptouchResult = [_esptouchTask executeForResult];
    
    if(resultDelegate != nil)
    {
        NSString *deviceIp = [self descriptionInetAddrByData:[esptouchResult ipAddrData]];
        Device *dev = [[Device alloc]initWithIp:deviceIp];
        [resultDelegate onDeviceConnect:dev];
    }
}

-(void) cancelSmartConnect {
    if(_esptouchTask != nil) {
        [_esptouchTask interrupt];
    }
}

-(void)beginSearchDeviceWithDelegate:(NSObject<HomerSearchDelegate> *) searchDelegate {
    UDPBroadcastUtil* udpUtil = [[UDPBroadcastUtil alloc]init];
    udpUtil.searchDelegate = searchDelegate;
    [udpUtil discoverIOTDevice];
}


// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

- (NSString *) descriptionInetAddrByData: (NSData *) inetAddrData
{
    Byte inetAddrBytes[IP_LEN];
    [inetAddrData getBytes:inetAddrBytes length:IP_LEN];
    // hard coding
    return [NSString stringWithFormat:@"%d.%d.%d.%d",inetAddrBytes[0],inetAddrBytes[1],inetAddrBytes[2],inetAddrBytes[3]];
}

@end
