//
//  TcpClient.h
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Slaver.h"

@interface TcpClient : NSObject

-(id)initWithIp:(NSString *)ipAddr andPort:(int) portNum;

-(id)initWithIp:(NSString *) ipAddr andPort:(int) portNum andQueue:(dispatch_queue_t)queue;

-(Boolean) connect;

-(void)sendDataAndDisconnect:(NSData *) data;

-(void)sendData:(NSData *)data;

-(NSMutableArray *)searchSlavers;

-(NSData *) readData;

-(void)disconnect;

-(void)listenData;

-(NSString *)getDeviceId;

-(NSMutableDictionary *)getSlaverDict;

-(NSString *)getDeviceVersion;

-(NSString *)getDeviceType;

-(int)getChipId;

-(NSArray *)getHSB;

-(Boolean)getDevState;

-(NSDictionary *)getDevInfo;

-(int) getBrightness;

-(int) getColorTemp;

@end
