//
//  Header.h
//  HomerLib
//
//  Created by 邱林 on 16/6/3.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Slaver.h"

@interface Device : NSObject

-(id)initWithIp:(NSString *)devIp;

/**
 *  获取主设备IP
 *
 *  @return 返回设备IP地址
 */
-(NSString *) getIp;

/**
 *  获取主设备ID
 *
 *  @return 返回设备ID
 */
-(NSString *) getId;

/**
 *  控制主设备灯光颜色
 *
 *  @param r 红色参数
 *  @param g 绿色参数
 *  @param b 蓝色参数
 *  @param w 白色参数，辅助亮度调试
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) controlColorLampRed:(Byte)r Green:(Byte)g  Blue:(Byte)b White:(Byte)w;

/**
 *  控制主设备灯光颜色
 *
 *  @param h 色相参数
 *  @param s 饱和度参数
 *  @param b 亮度参数
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) controlColorH:(uint32_t)h S:(uint32_t)s B:(uint32_t)b;

/**
 *  控制主设备色温颜色
 *
 *  @param value 色温参数，0表示关闭
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) controlColorTemperature:(uint16_t)value;

/**
 *  控制灯光亮度
 *
 *  @param brightness 亮度参数，0~100等级
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) setColorBrightness:(Byte)value;

/**
 *  设置警戒模式
 *
 *  @param isAlarm 是否进入警戒
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) setAlarmMode:(Boolean)isAlarm;

/**
 *  删除主控上的子设备
 *
 *  @param slaverId 子设备ID
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) deleteSlaver:(NSString *)slaverId;

/**
 *  保存配置参数
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) saveParam;

/**
 *  允许添加子设备
 *
 *  @param isAllow 是否允许添加
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) allowJoinSlaver:(Boolean)isAllow;

/**
 *  控制主设备响门铃
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) playDoorRing;

/**
 *  在家、离家模式
 *
 *  @param isIn 在家离家模式
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) masterMode:(Boolean)isIn;

/**
 *  获取主控上的子设备列表
 *
 *  @return 返回子设备数组，数组内对象为Slaver对象
 */
-(NSMutableArray *) getSlaverList;

typedef NS_ENUM(NSInteger, eRegularType) {
    AlarmOn,
    AlarmOff,
    LightOn,
    LightOff,
    Clock
};

typedef NS_ENUM(NSInteger, eRegularAction) {
    Once,
    EachHour,
    EachDay,
    EachMinute,
    EachFiveMinute
};

/**
 *  设定设备定时动作，每个定时任务对应一个ID，根据ID来识别具体定时任务
 *
 *  @param regularId     定时任务ID
 *  @param regularType   定时任务类型
 *  @param regularAction 定时任务执行条件
 *  @param actionTime    定时任务初始触发时间
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) setRegular:(Byte)regularId
                 Type:(eRegularType)regularType
               Action:(eRegularAction)regularAction
                 Time:(NSDate*)actionTime;

/**
 *  取消设定的定时动作
 *
 *  @param regularId 定时任务ID
 *
 *  @return 成功YES 失败NO
 */
-(Boolean) disableRegular:(Byte)regularId;

/**
 *  获取设备版本
 *
 *  @return 返回设备版本
 */
-(NSString *) getVersion;

/**
 *  获取设备类型
 *
 *  @return 返回设备类型
 */
-(NSString *) getDevType;

/**
 *  开始固件升级
 *  @param version   固件版本
 *  @param type      设备类型
 *
 *  @return 成功返回YES 失败NO
 */
-(Boolean) firmwareUpdateFromFirm:(NSString *)version andType:(NSString *)type;

/**
 *  恢复出厂设置
 *
 *  @return 成功返回YES 失败NO
 */
-(Boolean) resetFactaury;

@end
