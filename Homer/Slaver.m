//
//  Slaver.m
//  HomerLib
//
//  Created by 邱林 on 16/6/25.
//  Copyright © 2016年 com.pro.ios.mylib. All rights reserved.
//

#import "Slaver.h"


@interface Slaver()

@property (nonatomic,strong) NSString *_id;

@property (nonatomic,strong) NSString *_type;

@end

@implementation Slaver

-(id)initWithId:(NSString *)slaverId AndType:(NSString *)slaverType {
    self = [super init];
    
    self._id = slaverId;
    self._type = slaverType;
    
    return self;
}

-(NSString *) getId {
    return self._id;
}

-(NSString *) getType {
    return self._type;
}

@end
