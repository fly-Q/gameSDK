//
//  DYDDBManager.h
//  Demo_SQL
//
//  Created by Simba on 16/12/22.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DYDSDKUserEntity;

@interface DYDDBManager : NSObject
/** userid相同会覆盖, 游客模式请插入nil */
+ (void)insertUsersTable:(DYDSDKUserEntity *)user;
+ (void)deleteUsersTableByUserId:(NSString *)userId;
+ (DYDSDKUserEntity *)searchUsersTableByUserId:(NSString *)userId;
+ (DYDSDKUserEntity *)currentUser;
+ (NSArray <DYDSDKUserEntity *> *)loginUserArr;

@end
