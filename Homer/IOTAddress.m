//
//  IOTAddress.m
//  SlideMenu
//
//  Created by 邱林 on 15/6/29.
//  Copyright (c) 2015年 Aryan Ghassemi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import  "IOTAddress.h"
@implementation IOTAddress 
- (NSString *) getSSID{
    return self.mSSID;
}

- (NSString *) getBSSID{
    return self.mBSSID;
}

- (NSString *) getIP{
    return self.mIP;
}

- (NSString *) getDeviceType{
    
    return self.mDeviceType;
}
@end