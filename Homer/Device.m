//
//  Device.m
//  HomerLib
//
//  Created by 邱林 on 16/6/3.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import "Device.h"
#import "TcpClient.h"
#import "TcpUtil.h"
#import "ESP_ByteUtil.h"

@interface Device()

@property (nonatomic,strong) NSString *deviceIp;

@property (nonatomic,strong) NSString *deviceId;

@end

@implementation Device

-(id) initWithIp:(NSString *)devIp {
    self = [super init];
    
    self.deviceIp = devIp;
    self.deviceId = @"";
    
    return self;
}

-(NSString *) getIp {
    return self.deviceIp;
}

-(NSString *) getId {
    return [TcpUtil getDeviceIDWithIp:self.deviceIp];
}

-(NSString *) getVersion {
    return [TcpUtil getDeviceVersion:self.deviceIp];
}

-(NSString *) getDevType {
    return [TcpUtil getDeviceType:self.deviceIp];
}

-(Boolean) controlColorLampRed:(Byte)r Green:(Byte)g  Blue:(Byte)b White:(Byte)w {
    return [TcpUtil setDev:self.deviceIp ColortoRed:r Green:g Blue:b White:w];
}

-(Boolean) controlColorH:(uint32_t)h S:(uint32_t)s B:(uint32_t)b {
    uint32_t newH = h * 100;
    return [TcpUtil setDev:self.deviceIp ColorH:newH S:s B:b];
}

-(Boolean) controlColorTemperature:(uint16_t)value {
    return [TcpUtil setDev:self.deviceIp ColorTemperature:value];
}

-(Boolean) setColorBrightness:(Byte)value {
    return [TcpUtil setDev:self.deviceIp :value];
}

-(Boolean) setAlarmMode:(Boolean) isAlarm {
    if(isAlarm) {
        return [TcpUtil setDev:self.deviceIp AlarmMode:0x01];
    } else {
        return [TcpUtil setDev:self.deviceIp AlarmMode:0x00];
    }
}

-(NSMutableArray *) getSlaverList {
    NSMutableDictionary *slaverDict = [TcpUtil getSlaverDict:self.deviceIp];
    
    NSMutableArray *slaverArray = [NSMutableArray arrayWithCapacity:5];
    
    for (NSString *key in slaverDict) {
        NSString *value = [slaverDict objectForKey:key];
        Slaver *slaver = [[Slaver alloc] initWithId:key AndType:value];
        [slaverArray addObject:slaver];
    }
    
    return slaverArray;
}

-(Boolean) deleteSlaver:(NSString *)slaverId {
    return FALSE;
}

-(Boolean) saveParam {
    return [TcpUtil saveParam:self.deviceIp];
}

-(Boolean) allowJoinSlaver:(Boolean)isAllow {
    Byte action = isAllow == TRUE ? 0xFF : 0x00;
    return [TcpUtil setDev:self.deviceIp AllowJoinSlaver:action];
}

-(Boolean) playDoorRing {
    Byte action[] = {0x01, 0x04};
    return [TcpUtil playSound:self.deviceIp WithAction:action];
}

-(Boolean) setRegularAlarm:(Boolean)isOn InHour:(int)hour Minute:(int)minute {
    Byte action = isOn == TRUE ? 0x01 : 0x00;
    return [TcpUtil setDev:self.deviceIp RegularAlarmMode:action Hour:(int)hour Minute:(int)minute];
}

-(Boolean) cancelRegularAlarm {
    return [TcpUtil setDev:self.deviceIp RegularAlarmMode:0x01 Hour:0xFF Minute:0xFF];
}

-(Boolean) masterMode:(Boolean)isIn {
    Byte action = isIn == TRUE ? 0x01 : 0x00;
    return [TcpUtil setDev:self.deviceIp MasterMode:action];
}

-(Boolean) setRegular:(Byte)regularId
                 Type:(eRegularType)regularType
               Action:(eRegularAction)regularAction
                 Time:(NSDate *)actionTime {
    
    Byte regularTypeByte = 0x00;
    Byte startTimeByte[4];
    Byte loopTimeByte[] = {0x00, 0x00, 0x00, 0x00};
    
    switch (regularType) {
        case AlarmOn:
            regularTypeByte = 0x00;
            break;
        case AlarmOff:
            regularTypeByte = 0x01;
            break;
        case LightOff:
            regularTypeByte = 0x02;
            break;
        case LightOn:
            regularTypeByte = 0x03;
            break;
        case Clock:
            regularTypeByte = 0x04;
            break;
        default:
            return NO;
    }
    
    switch (regularAction) {
        case Once:
            loopTimeByte[0] = 0x00;
            loopTimeByte[1] = 0x00;
            loopTimeByte[2] = 0x00;
            loopTimeByte[3] = 0x00;
            break;
        case EachHour:
            loopTimeByte[0] = 0x00;
            loopTimeByte[1] = 0x00;
            loopTimeByte[2] = 0x0E;
            loopTimeByte[3] = 0x10;
            break;
        case EachDay:
            loopTimeByte[0] = 0x00;
            loopTimeByte[1] = 0x01;
            loopTimeByte[2] = 0x51;
            loopTimeByte[3] = 0x80;
            break;
        case EachMinute:
            loopTimeByte[0] = 0x00;
            loopTimeByte[1] = 0x00;
            loopTimeByte[2] = 0x00;
            loopTimeByte[3] = 0x3C;
            break;
        case EachFiveMinute:
            loopTimeByte[0] = 0x00;
            loopTimeByte[1] = 0x00;
            loopTimeByte[2] = 0x01;
            loopTimeByte[3] = 0x2C;
            break;
        default:
            loopTimeByte[0] = 0x00;
            loopTimeByte[1] = 0x00;
            loopTimeByte[2] = 0x00;
            loopTimeByte[3] = 0x00;
            break;
    }
    
    //long actionTimeInMs = actionTime.timeIntervalSince1970;
    int secondsSinceEpoch =[[NSDate date] timeIntervalSince1970];
    //startTimeByte = [ESP_ByteUtil convertInt32ToByte:(secondsSinceEpoch)];
    Byte value[4];
    value[0] = (secondsSinceEpoch >> 24) & 0xFF;
    value[1] = (secondsSinceEpoch >> 16) & 0xFF;
    value[2] = (secondsSinceEpoch >> 8)  & 0xFF;
    value[3] = secondsSinceEpoch & 0xFF;
    
    Boolean res;
    res = [TcpUtil setDev:self.deviceIp regularId:regularId regularType:regularTypeByte startTimeS:startTimeByte loopTimeS:loopTimeByte];
    
    return res;
}

-(Boolean) disableRegular:(Byte)regularId {
    Byte startTimeByte[4] = {0xFF, 0xFF, 0xFF, 0xFF };
    Byte loopTimeByte[4] = {0x00, 0x00, 0x00, 0x00};
    return [TcpUtil setDev:self.deviceIp regularId:regularId regularType:0x00 startTimeS:startTimeByte loopTimeS:loopTimeByte];
}

// Auth
-(Boolean) writeAuthWithChipId:(int)chipId {
    return [TcpUtil writeAuth:self.deviceIp WithChipId:chipId];
}

-(Boolean) cleanAuth{
    return [TcpUtil cleanAuth:self.deviceIp];
}
@end
