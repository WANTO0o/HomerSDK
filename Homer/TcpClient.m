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

-(void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //NSLog(@"Lib didReadData");
    NSString *aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    Byte *dataInByte = (Byte *)[data bytes];
    
    //    for(int i = 0; i < [data length]; i++) {
    //        printf("testByte %d ", dataInByte[i]);
    //    }
    
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
    }
}

@end
