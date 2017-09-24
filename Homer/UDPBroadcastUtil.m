//
//  UDPBroadcastUtil.m
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import "UDPBroadcastUtil.h"
#import "GCDAsyncUdpSocket.h"
#import "IOTAddress.h"
#import "DeviceUtils.h"
#import "Device.h"

#define  BROADCAST @"255.255.255.255"
#define  DEVICE_DISCOVER_PORT 1025

@interface UDPBroadcastUtil()

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;

@end

@implementation UDPBroadcastUtil

//static NSMutableDictionary *iotDictionary;
//static GCDAsyncUdpSocket *_udpSocket;

//IOT 设备发现.
-(NSMutableArray*)discoverIOTDevice{
    NSError *error;
    if (_udpSocket == nil){
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    //NSString* data =@"Are you Espressif IOT Smart Device?";
    NSData* broadCastData = [@"Are You Espressif IOT Smart Device?" dataUsingEncoding:NSUTF8StringEncoding];
    
    //允许广播 必须 否则后面无法发送组播和广播
    [_udpSocket enableBroadcast:YES error:&error];
    
    if (nil != error) {
        
        NSLog(@"failed.:%@",[error description]);
        
    }
    //开始接收数据.
    [_udpSocket beginReceiving:&error];
    
    if (nil != error) {
        
        NSLog(@"failed.:%@",[error description]);
        
    }
    
    for (int i =0; i<1; i++) {
        //客户端socket发送广播.
        [_udpSocket sendData:broadCastData toHost:BROADCAST port:DEVICE_DISCOVER_PORT withTimeout:-1 tag:10];
        NSLog(@"send broadcast infi:%@",[error description]);
        //必须要  开始准备接收数据
        
        if (![_udpSocket beginReceiving:&error])
        {
            NSLog(@"Error receiving:.:%@",[error description]);
            
            return nil;
        }
        
    }
    
    return nil;
    
}

#pragma mark -GCDAsyncUdpsocket Delegate

//udp socket 接收消息处理类(回调或者叫委托).
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext

{
    // 在线设备缓存.
    //if(iotDictionary==nil){
    //    iotDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
    //}
    
    NSLog(@"Reciv Data len:%lu",(unsigned long)[data length]);
    
    //NSData 转NSString
    //I'm Plug.18:fe:34:a1:32:c8 192.168.1.10418:fe:34:a1:32:c8
    NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([DeviceUtils isValid:result]){
        
        NSString *deviceTypeStr = [DeviceUtils filterType:result];
        NSString *hostName = [DeviceUtils filterIpAddress:result];
        NSString *BSSID = [DeviceUtils filterBssid:result];
        if([DeviceUtils isMesh:result])
            NSLog(@"device isMesh");
        //NSLog([result stringByAppendingString:BSSID]);
        
        IOTAddress * iotAddress = [IOTAddress alloc];
        [iotAddress setMBSSID:BSSID];
        [iotAddress setMIP:hostName];
        [iotAddress setMDeviceType:deviceTypeStr];
        
        UInt64 time = [[NSDate date] timeIntervalSince1970]*1000;
        
        NSLog(@"find device %@", [iotAddress mDeviceType]);
        
        Device *dev = [[Device alloc]initWithIp:hostName];
        
        
        if(self.searchDelegate != nil) {
            [self.searchDelegate onDeviceSearch:dev];
        }
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            //[self.tableView reloadData];
        //});
    }
    
    
}


- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error

{
    
    NSLog(@"udpSocketDidClose Error:%@",[error description]);
    
}

@end
