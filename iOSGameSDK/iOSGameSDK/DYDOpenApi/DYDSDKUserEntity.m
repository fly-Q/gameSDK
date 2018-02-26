//
//  DYDSDKUserEntity.m
//  Demo_SQL
//
//  Created by 邱明 on 16/12/21.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKUserEntity.h"

@implementation DYDSDKUserEntity

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@", key);
}

@end
