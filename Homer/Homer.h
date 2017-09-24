//
//  Homer.h
//  Homer
//
//  Created by 邱林 on 16/8/18.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ESPTouchResult.h"
//#import "ESPTouchDelegate.h"
#import "HomerSearchDelegate.h"
#import "Slaver.h"
#import "Device.h"


@interface Homer : NSObject

/* 辅助功能，用于获取手机当前的SSID */
-(NSString *) getSsid;

/*
 * 进行设备智能连接
 * @param apSsid wifi SSID名
 * @param apPwd wifi密码
 * @param timeoutMillisecond 超时时间(it should be >= 15000+6000)
 * @param resultDelegate 连接结果委托
 */
-(void) connectWithApSsid:(NSString *)apSsid
                 andApPwd:(NSString *)apPwd
    andTimeoutMillisecond:(int)timeoutMillisecond
              andDelegate:(NSObject<HomerConnectDelegate> *)resultDelegate;

/* 取消智能连接 */
-(void) cancelSmartConnect;

/*
 * 搜索设备
 * @param searchDelegate 设备搜索结果委托
 */
-(void) beginSearchDeviceWithDelegate: (NSObject<HomerSearchDelegate> *) searchDelegate;

@end
