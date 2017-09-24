//
//  Slaver.h
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Slaver : NSObject

-(id)initWithId:(NSString *)slaverId AndType:(NSString *)slaverType;

-(NSString *) getType;

-(NSString *) getId;

@end
