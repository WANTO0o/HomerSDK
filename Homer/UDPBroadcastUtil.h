//
//  UDPBroadcastUtil.h
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomerSearchDelegate.h"

@interface UDPBroadcastUtil : NSObject

@property (nonatomic,strong) id<HomerSearchDelegate> searchDelegate;

-(NSMutableArray*)discoverIOTDevice;

@end
