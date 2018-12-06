//
//  TcpUtil.h
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TcpUtil : NSObject

+(NSString *) getDeviceIDWithIp:(NSString *) devIp;

+(Boolean) setDev:(NSString *)devHost ColortoRed:(Byte)r Green:(Byte)g Blue:(Byte)b White:(Byte)w;

+(Boolean) setDev:(NSString *)devHost ColorH:(uint32_t)h S:(uint32_t)s B:(uint32_t)b;

+(Boolean) setDev:(NSString *)devHost AlarmMode:(Byte)mode;

+(Boolean) deleteSlaver:(NSString *)devHost;

+(Boolean) setDev:(NSString *)devHost AllowJoinSlaver:(Byte)isAllow;

+(Boolean) saveParam:(NSString *)devHost;

+(Boolean) playSound:(NSString *)devHost WithAction:(Byte *)action;

+(Boolean) setDev:(NSString *)devHost RegularAlarmMode:(Byte)isOn Hour:(Byte)hour Minute:(Byte)minute;

+(Boolean) setDev:(NSString *)devHost MasterMode:(Byte)isIn;

+(NSMutableDictionary *)getSlaverDict:(NSString *)devHost;

+(NSString *) getDeviceId:(NSString *)devHost;

+(NSString *) getDeviceVersion:(NSString *)devHost;

+(NSString *) getDeviceType:(NSString *)devHost;

/**
 *  设置定时任务
 *
 *  @param devHost     设备IP
 *  @param regularId   定时任务ID
 *  @param regularType 定时任务类型
 *  @param startTimeS  定时开始时间，四字节byte，单位s
 *  @param loopTimeS   定时循环时间，四字节byte，单位s
 *
 *  @return 成功YES 失败NO
 */
+(Boolean) setDev:(NSString *)devHost
        regularId:(Byte)regularId
      regularType:(Byte)regularType
       startTimeS:(Byte *)startTimeS
        loopTimeS:(Byte *)loopTimeS;

// 20170909: 色温接口
+(Boolean) setDev:(NSString *)devHost ColorTemperature:(uint16_t)value;

// 设置白灯和彩灯亮度
+(Boolean) setDev:(NSString *)devHost :(Byte)brightness;

// 20180902: 场景接口
+(Boolean) setDev:(NSString *)devHost
            Scene:(Byte)mode
            Speed:(Byte)speed
       Brightness:(Byte)brightness
         ColorNum:(int)colorNum
           Colors:(NSMutableArray*)colors;

// 20181127: 场景调试接口
+(Boolean)setDev:(NSString *)devHost SceneType:(Byte)mode;

// Auth:
+(Boolean) writeAuth:(NSString *)devHost WithChipId:(int)chipId;

+(Boolean) cleanAuth:(NSString *)devHost;

+(int) getChipIDWithIp:(NSString *) devHost;

+(NSArray *)getHSB:(NSString *)devHost;

+(Boolean) getDevState:(NSString *)devHost;

+(NSDictionary *) getDevInfo:(NSString *)devHost;

+(int) getBrightness:(NSString *)devHost;

+(int) getColorTemp:(NSString *)devHost;

@end
