//
//  IOTAddress.h
//  SlideMenu
//
//  Created by 邱林 on 15/6/29.
//  Copyright (c) 2015年 Aryan Ghassemi. All rights reserved.
//

@interface IOTAddress:NSObject


    @property (strong , nonatomic) NSString *mSSID;

    @property (strong , nonatomic) NSString *mBSSID;

    @property (strong , nonatomic) NSString *mIP;

    @property (strong , nonatomic) NSString *mDeviceType;


- (NSString *) getSSID;

- (NSString *) getBSSID;

- (NSString *) getIP;

- (NSString *) getDeviceType;





@end
