//
//  HomerSearchDelegate.h
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@protocol HomerSearchDelegate <NSObject>

-(void) onDeviceSearch:(Device *) result;

@end


@protocol HomerConnectDelegate <NSObject>

-(void) onDeviceConnect:(Device *)result;

@end