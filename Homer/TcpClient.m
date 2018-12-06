//
//  TcpClient.m
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import "TcpClient.h"
#import "GCDAsyncSocket.h"
#define TIMEOUT 5000

@interface TcpClient()

//@property (atomic, strong) GCDAsyncSocket *_socket;
@property (nonatomic, strong) NSString *_ipAddr;
@property (nonatomic) int _portNum;

@end

GCDAsyncSocket *_socket;
NSString *devId;
NSMutableDictionary *slaverDict;
NSString *devVer;
NSString *devType;
int chipId;
NSArray *hsbColor;
Boolean devState; // 开关状态
int brightness; // 亮度
int colorTemp; // 色温

@implementation TcpClient

-(id) initWithIp:(NSString *) ipAddr andPort:(int) portNum {
    self._ipAddr = ipAddr;
    self._portNum = portNum;
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    return self;
}

-(id) initWithIp:(NSString *) ipAddr andPort:(int) portNum andQueue:(dispatch_queue_t)queue{
    self._ipAddr = ipAddr;
    self._portNum = portNum;
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    devId = @"";
    slaverDict = [NSMutableDictionary dictionaryWithCapacity:5];
    return self;
}

-(Boolean) connect {
    NSError *err = nil;
    if(![_socket connectToHost:self._ipAddr onPort:self._portNum error:&err])
    {
        NSLog(@"Connect error : %@", err);
        return FALSE;
    } else {
        NSLog(@"Connect success");
        return TRUE;
    }
}

-(void) sendDataAndDisconnect: (NSData *) data {
    if (data == nil) {return;}
    [_socket writeData:data withTimeout:TIMEOUT tag:0];
    [_socket disconnectAfterWriting];
}

-(void) sendData:(NSData *)data {
    if (data == nil) {return;}
    [_socket writeData:data withTimeout:TIMEOUT tag:0];
}

-(NSData *) readData {
    
    NSData *readData = [[NSData alloc]init];
    
    //[_socket readDataWithTimeout:-1 tag:0];
    
    [_socket readDataToData:readData withTimeout:-1 tag:0];
    
    return readData;
}

-(void)disconnect {
    [_socket disconnect];
}

-(void)listenData {
    [_socket readDataWithTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //NSLog(@"Lib didConnectToHost");
    //[sock readDataWithTimeout:-1 tag:0];
}

-(NSString *)getDeviceId {
    return devId;
}

-(NSMutableDictionary *)getSlaverDict {
    return slaverDict;
}

-(NSString *)getDeviceVersion {
    return devVer;
}

-(NSString *)getDeviceType {
    return devType;
}

-(int)getChipId {
    return chipId;
}

-(NSArray *)getHSB {
    return hsbColor;
}

-(Boolean)getDevState {
    return devState;
}

-(int) getBrightness {
    return brightness;
}

-(int) getColorTemp {
    return colorTemp;
}

-(NSDictionary *) getDevInfo {
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSNumber *colorTempNum = [NSNumber numberWithInt:colorTemp];
    NSLog(@"hsb %@", hsbColor);
    NSLog(@"white %d", colorTemp);
    //dict = @{@"hsb":hsbColor, @"white":whiteNum};
    return dict;
}

-(void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //NSLog(@"Lib didReadData");
    //NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    Byte *dataInByte = (Byte *)[data bytes];
    
    //    for(int i = 0; i < [data length]; i++) {
    //        printf("testByte %d ", dataInByte[i]);
    //    }
    
    NSLog(@"[ReadData] %@", data);
    
    if([data length] >= 10) {
        Byte valueType = dataInByte[7];
        Byte valueLength = dataInByte[8];
        // SlaverList
        if(valueType == 0x0F) {
            int length = valueLength;
            if(length == 0) {
            } else {
                NSString *msg = @"";
                
                for (int i = 9; i < 9 + length; i+=3) {
                    Byte slaveByte[4];
                    slaveByte[0] = 0x00;
                    slaveByte[1] = 0x00;
                    slaveByte[2] = dataInByte[i];
                    slaveByte[3] = dataInByte[i+1];
                    int slaverId = 0;
                    slaverId = (int)( ((slaveByte[0] & 0xFF)<<24)
                                     |((slaveByte[1] & 0xFF)<<16)
                                     |((slaveByte[2] & 0xFF)<<8)
                                     |(slaveByte[3] & 0xFF));
                    
                    NSString *slaverIdStr = [NSString stringWithFormat:@"%d", slaverId];
                    NSString *slaverTypeStr = [NSString stringWithFormat:@"%d", dataInByte[i+2]];
                    
                    //msg = [NSString stringWithFormat:@"%@从机ID %d 类型 %@\n", msg, slaverId, [self getSlaverType:dataInByte[i+2]]];
                    
                    //NSLog(@"ID %d, Type %d", slaverId, dataInByte[i+2]);
                    
                    [slaverDict setObject:slaverTypeStr forKey:slaverIdStr];
                    
                }
            }
        }
        // DeviceID
        if(valueType == 0x00) {
            Byte buf[4];
            buf[0] = dataInByte[1];
            buf[1] = dataInByte[2];
            buf[2] = dataInByte[3];
            buf[3] = dataInByte[4];
            
            int deviceId = 0;
            deviceId = (int)( ((buf[0] & 0xFF)<<24)
                             |((buf[1] & 0xFF)<<16)
                             |((buf[2] & 0xFF)<<8)
                             |(buf[3] & 0xFF));
            
            devId = [NSString stringWithFormat:@"%d", deviceId];
            // TODO: 后续是否将deviceID直接改成16进制格式地址
            // devId = [NSString stringWithFormat:@"%08X", deviceId];
            //NSLog(@"DeviceID %@", devId);
        }
        
        if (valueType == 0xF1) {
            Byte buf[5];
            // version
            buf[0] = dataInByte[9];
            buf[1] = dataInByte[10];
            buf[2] = dataInByte[11];
            // devType
            buf[3] = dataInByte[12];
            buf[4] = dataInByte[13];
            
            NSString *deviceVer1;
            deviceVer1 = [NSString stringWithFormat:@"%d", (int)buf[0]];
            NSString *deviceVer2;
            deviceVer2 = [NSString stringWithFormat:@"%d", (int)buf[1]];
            NSString *deviceVer3;
            deviceVer3 = [NSString stringWithFormat:@"%d", (int)buf[2]];
            
            int16_t devTypeNum = 0;
            devTypeNum = (int16_t)(((buf[3] & 0xFF) << 8) | (buf[4] & 0xFF));
            
            devVer = [NSString stringWithFormat:@"%@.%@.%@", deviceVer1, deviceVer2, deviceVer3];
            devType = [NSString stringWithFormat:@"%d", devTypeNum];
        }
        // chipId
        if (valueType == 0xFB) {
            Byte buf[4];
            buf[0] = dataInByte[9];
            buf[1] = dataInByte[10];
            buf[2] = dataInByte[11];
            buf[3] = dataInByte[12];
            
            int tempChipId = 0;
            tempChipId = (int)( ((buf[0] & 0xFF)<<24)
                             |((buf[1] & 0xFF)<<16)
                             |((buf[2] & 0xFF)<<8)
                             |(buf[3] & 0xFF));
            
            chipId = tempChipId;
            //NSLog(@"TcpUtil chipId %d", chipId);
        }
        // hsb
        if (valueType == 0x50) {
            int hStartIndex = 9;
            Byte hBytes[] = {
                dataInByte[hStartIndex],
                dataInByte[hStartIndex + 1],
                dataInByte[hStartIndex + 2],
                dataInByte[hStartIndex + 3]
            };
            
            int sStartIndex = 13;
            Byte sBytes[] = {
                dataInByte[sStartIndex],
                dataInByte[sStartIndex + 1],
                dataInByte[sStartIndex + 2],
                dataInByte[sStartIndex + 3]
            };
            
            int bStartIndex = 17;
            Byte bBytes[] = {
                dataInByte[bStartIndex],
                dataInByte[bStartIndex + 1],
                dataInByte[bStartIndex + 2],
                dataInByte[bStartIndex + 3]
            };
            
            int hVal = [self bytesToIntLE:hBytes] / 100;
            int sVal = [self bytesToIntLE:sBytes] / 100;
            int bVal = [self bytesToIntLE:bBytes] / 100;
            
            NSNumber *hNum = [NSNumber numberWithInt:hVal];
            NSNumber *sNum = [NSNumber numberWithInt:sVal];
            NSNumber *bNum = [NSNumber numberWithInt:bVal];
            NSArray *dataArray = [NSArray arrayWithObjects:hNum, sNum, bNum, nil];
            
            hsbColor = [NSArray arrayWithArray:dataArray];
        }
        // devState
        if (valueType == 0x01) {
            Byte byte = dataInByte[9];
            if (byte == 0x00) {
                devState = NO;
            } else {
                devState = YES;
            }
        }
        // brightness
        if (valueType == 0x53) {
            Byte byte = dataInByte[9];
            brightness = (int)byte;
        }
        // 色温
        if (valueType == 0x52) {
            Byte bytes[] = {
                0,
                0,
                dataInByte[9],
                dataInByte[10]
            };
            colorTemp = [self bytesToIntLE:bytes];
        }
    }
}

// 将一个byte数组（4个byte转一个int）转为int。大端模式（低地址放高位）
- (int) bytesToIntBE: (Byte[])bytes {
    int value = 0;
    value = ((bytes[3] & 0xff)<<24)|
            ((bytes[2] & 0xff)<<16)|
            ((bytes[1] & 0xff)<<8)|
            (bytes[0] & 0xff);
    return value;
}

// 将一个byte数组（4个byte转一个int）转为int。小端模式（低地址放低位）
- (int) bytesToIntLE: (Byte[])bytes {
    int value = 0;
    value = ((bytes[0] & 0xff)<<24)|
            ((bytes[1] & 0xff)<<16)|
            ((bytes[2] & 0xff)<<8)|
            (bytes[3] & 0xff);
    return value;
}


@end
