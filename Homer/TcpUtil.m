//
//  TcpUtil.m
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import "TcpUtil.h"
#import "TcpClient.h"
#import "GCDAsyncSocket.h"
#define SERVERPORT 8800

@implementation TcpUtil

TcpClient *client;

+(NSString *) getDeviceIDWithIp:(NSString *)devHost {
    
    NSString *devId = @"devId";
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x00,  // 7
        0x00,  // 8
        0xA5   // 9
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(1);
    
    devId = [client getDeviceId];
    
    [client disconnect];
    
    return devId;
    
}

+(NSString *) getDeviceVersion:(NSString *)devHost {
    NSString *devVersion = @"";
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0xF1,  // 7
        0x00,  // 8
        0xA5   // 9
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(1);
    
    devVersion = [client getDeviceVersion];
    
    [client disconnect];
    
    return devVersion;
}

+(NSString *) getDeviceType:(NSString *)devHost {
    NSString *devType = @"";
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0xF1,  // 7
        0x00,  // 8
        0xA5   // 9
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(1);
    
    devType = [client getDeviceType];
    
    [client disconnect];
    
    return devType;
}

+(Boolean) setDev:(NSString *)devHost ColortoRed:(Byte)r Green:(Byte)g Blue:(Byte)b White:(Byte)w {
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x05,  // 7
        0x04,  // 8
        r,     // 9
        g,     // 10
        b,     // 11
        w,     // 12
        0xA5   // 13
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) setDev:(NSString *)devHost ColorH:(uint32_t)h S:(uint32_t)s B:(uint32_t)b {
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x50,  // 7
        0x0C,  // 8
        (Byte)(h >> 24),
        (Byte)(h >> 16),
        (Byte)(h >> 8),
        (Byte)(h >> 0),
        (Byte)(s >> 24),
        (Byte)(s >> 16),
        (Byte)(s >> 8),
        (Byte)(s >> 0),
        (Byte)(b >> 24),
        (Byte)(b >> 16),
        (Byte)(b >> 8),
        (Byte)(b >> 0),
        0xA5
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) setDev:(NSString *)devHost ColorTemperature:(uint16_t)value {
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x52,  // 7
        0x02,  // 8
        (Byte)(value >> 8),
        (Byte)(value >> 0),
        0xA5
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) setDev:(NSString *)devHost AlarmMode:(Byte)mode {
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x21,  // 7
        0x01,  // 8
        mode,  // 9
        0xA5   // 10
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(NSMutableDictionary *)getSlaverDict:(NSString *)devHost {
    if(devHost == nil) { return nil; }
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x0f,  // 7
        0x00,  // 8
        0xA5,  // 9
    };
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(2);
    
    NSMutableDictionary *slaverDict = [client getSlaverDict];
    
    [client disconnect];
    
    return slaverDict;
}

+(Boolean) setDev:(NSString *)devHost MasterMode:(Byte)isIn {
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x23,  // 7
        0x01,  // 8
        isIn,  // 9
        0xA5   // 10
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) playSound:(NSString *)devHost WithAction:(Byte *)action {
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x23,  // 7
        0x01,  // 8
        action[0],  // 9
        action[1], // 10
        0xA5   // 11
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) setDev:(NSString *)devHost RegularAlarmMode:(Byte)isOn Hour:(Byte)hour Minute:(Byte)minute {
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x22,  // 7
        0x03,  // 8
        minute,  // 9
        hour,    // 10
        isOn,    // 11
        0xA5     // 12
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) saveParam:(NSString *)devHost {
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0xFA,  // 7
        0x00,  // 8
        0xA5   // 9
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) setDev:(NSString *)devHost AllowJoinSlaver:(Byte)isAllow {
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x12,  // 7
        0x01,  // 8
        isAllow,  // 9
        0xA5   // 10
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) setDev:(NSString *)devHost
        regularId:(Byte)regularId
      regularType:(Byte)regularType
       startTimeS:(Byte *)startTimeS
        loopTimeS:(Byte *)loopTimeS
{
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x22,  // 7
        0x0A,  // 8
        regularId,  // 9
        regularType, // 10
        startTimeS[0], // 11
        startTimeS[1], // 12
        startTimeS[2], // 13
        startTimeS[3], // 14
        loopTimeS[0],  // 15
        loopTimeS[1],  // 16
        loopTimeS[2],  // 17
        loopTimeS[3],  // 18
        0xA5   // 19
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean)setDev:(NSString *)devHost :(Byte)brightness {
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x53,  // 7
        0x01,  // 8
        brightness,
        0xA5
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean)setDev:(NSString *)devHost Scene:(Byte)mode Speed:(Byte)speed Brightness:(Byte)brightness ColorNum:(int)colorNum Colors:(NSMutableArray *)colors {
    
    if([colors count] != 7) {
        NSLog(@"情景颜色数量不对");
        return false;
    }
    
    if(colorNum > 7) {
        NSLog(@"颜色配置数量不对");
        return  false;
    }
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x54,  // 7
        0x12,  // 8
        mode,  // 模式
        speed, // 速度，单位100ms
        brightness, // 亮度, 0-100
        (Byte)colorNum, // 颜色数量, 0-7
        (Byte)((int)colors[0] >> 24),
        (Byte)((int)colors[0] >> 16),
        (Byte)((int)colors[1] >> 24),
        (Byte)((int)colors[1] >> 16),
        (Byte)((int)colors[2] >> 24),
        (Byte)((int)colors[2] >> 16),
        (Byte)((int)colors[3] >> 24),
        (Byte)((int)colors[3] >> 16),
        (Byte)((int)colors[4] >> 24),
        (Byte)((int)colors[4] >> 16),
        (Byte)((int)colors[5] >> 24),
        (Byte)((int)colors[5] >> 16),
        (Byte)((int)colors[6] >> 24),
        (Byte)((int)colors[6] >> 16),
        0xA5
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    NSLog(@"%@", sendData);
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean)setDev:(NSString *)devHost SceneType:(Byte)mode {

    NSData *sendData;
    
    // 轻音乐
    if(mode == 0x01) {
        Byte bytes[] = {
            0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x54, 0x12,
            0x01, 0x01, 0x64, 0x01, 0xf0, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0xA5
        };
        
        sendData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    }
    
    // 三色跳变
    else if (mode == 0x02) {
        Byte bytes[] = {
            0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x54, 0x12,
            0x03, 0x02, 0x64, 0x03, 0x00, 0x00, 0x78, 0x00, 0xf0,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0xA5
        };
        
        sendData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    }
    
    // 七色频闪
    else if (mode == 0x03) {
        Byte bytes[] = {
            0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x54, 0x12,
            0x04, 0x05, 0x64, 0x07, 0x00, 0x00, 0x18, 0x00, 0x3c,
            0x00, 0x78, 0x00, 0xb4, 0x00, 0xf0, 0x00, 0x18, 0x01,
            0xA5
        };
        
        sendData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    }
    
    // 七彩渐变
    else if (mode == 0x04) {
        Byte bytes[] = {
            0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x54, 0x12,
            0x02, 0x01, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0xA5
        };
        
        sendData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    }
    
    // 七彩跳变
    else if (mode == 0x05) {
        Byte bytes[] = {
            0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x54, 0x12,
            0x03, 0x05, 0x64, 0x07, 0x00, 0x00, 0x18, 0x00, 0x3c,
            0x00, 0x78, 0x00, 0xb4, 0x00, 0xf0, 0x00, 0x18, 0x01,
            0xA5
        };
        
        sendData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    }
    
    else {
        return false;
    }
    
    NSLog(@"%@", sendData);
    
    return [self sendDev:devHost WithData:sendData];
}

// Auth
+(Boolean) writeAuth:(NSString *)devHost WithChipId:(int)chipId {
    int key = 0xA109891B;
    int signature = 0;
    signature |= (chipId >> 13);
    signature |= (chipId << (32-13));
    signature ^= key;
    
    Byte signatureInByte[4];
    signatureInByte[0] = (Byte) ((signature>>24) & 0xFF);
    signatureInByte[1] = (Byte) ((signature>>16)& 0xFF);
    signatureInByte[2] = (Byte) ((signature>>8)&0xFF);
    signatureInByte[3] = (Byte) (signature & 0xFF);
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0xFB,  // 7
        0x04,  // 8
        signatureInByte[0], // 9
        signatureInByte[1], // 10
        signatureInByte[2], // 11
        signatureInByte[3], // 12
        0xA5   // 13
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    return [self sendDev:devHost WithData:sendData];
}

+(Boolean) cleanAuth:(NSString *)devHost {
    return [self writeAuth:devHost WithChipId:0];
}

+(int) getChipIDWithIp:(NSString *)devHost {
    int chipID = 0;
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0xFB,  // 7
        0x00,  // 8
        0xA5   // 9
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(1);
    
    chipID = [client getChipId];
    
    [client disconnect];
    
    return chipID;
}

+(NSArray *) getHSB:(NSString *)devHost {
    NSArray *hsbArray = [[NSArray alloc] init];
    
    Byte byte[] = {
        0x5A,  // 0
        0x00,  // 1
        0x00,  // 2
        0x00,  // 3
        0x00,  // 4
        0x00,  // 5
        0x00,  // 6
        0x50,  // 7
        0x00,  // 8
        0xA5   // 9
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(1);
    
    hsbArray = [client getHSB];
    
    [client disconnect];
    
    return hsbArray;
}

+(Boolean)getDevState:(NSString *)devHost {
    Byte byte[] = {
        0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0xA5
    };
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte length:sizeof(byte)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(1);
    
    return [client getDevState];
}

+(NSDictionary *) getDevInfo:(NSString *)devHost {
    if(devHost == nil) {return nil;}
    
    dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
    
    client = [[TcpClient alloc]initWithIp:devHost andPort:SERVERPORT andQueue:serialQueue];
    
    [client connect];
    
    [client listenData];
    
    Byte devStateBytes[] = {
        0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0xA5
    };
    [self sendData:client With:devStateBytes];
    
    sleep(1);
    
    Byte hsbBytes[] = {
        0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x50, 0x00, 0xA5
    };
    [self sendData:client With:hsbBytes];
    
    sleep(1);
    
    return [client getDevInfo];
}

+(int) getBrightness:(NSString *)devHost {
    Byte bytes[] = {
        0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x53, 0x00, 0xA5
    };
    NSData *sendData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    
    [self readDev:devHost WithData:sendData];
    
    sleep(1);
    
    return [client getBrightness];
}

// Common function

+(Boolean) sendDev:(NSString *)devHost WithData:(NSData *)data {
    
    if(devHost == nil) { return NO; }
    
    dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"[SendData] %@", data);
    
    client = [[TcpClient alloc]initWithIp:devHost andPort:SERVERPORT andQueue:serialQueue];
    
    [client connect];
    
    [client sendDataAndDisconnect:data];
    
    return YES;
}

+(Boolean) readDev:(NSString *)devHost WithData:(NSData *)data {
    
    if(devHost == nil) {return NO;}
    
    dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"[SendForRead] %@", data);
    
    client = [[TcpClient alloc]initWithIp:devHost andPort:SERVERPORT andQueue:serialQueue];
    
    [client connect];
    
    [client listenData];
    
    [client sendData:data];
    
    return YES;
}

+(Boolean) sendData: (TcpClient *)client With:(Byte *)bytes {
    NSData *sendData = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
    [client sendData:sendData];
    return YES;
}

@end
