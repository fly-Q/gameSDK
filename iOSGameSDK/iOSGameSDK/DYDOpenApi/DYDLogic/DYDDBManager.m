//
//  DYDDBManager.m
//  Demo_SQL
//
//  Created by Simba on 16/12/22.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDDBManager.h"
#import "FMDB.h"
#import "DYDSDKUserEntity.h"
#import <objc/runtime.h>

static FMDatabase *dyd_dataBase = nil;
static NSString *dbFileName = @"dydTable.sqlite";

@implementation DYDDBManager

+ (void)initialize
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [filePath stringByAppendingPathComponent:dbFileName];
    NSLog(@"数据库路径\n%@", dbPath);
    dyd_dataBase = [FMDatabase databaseWithPath:dbPath];
    if (![dyd_dataBase open]) {
        NSLog(@"数据库打开失败");
    }

    //建表...
    [self createUserDataTable];
}
//创建表
+ (void)createTable:(const NSString *)tableName sql:(NSString *)sql
{
    if ([dyd_dataBase open]) {
        BOOL res = [dyd_dataBase executeUpdate:sql];
        if (!res) {
            NSLog(@"error when creating db table :%@", tableName);
        }
        //        [_db close];
    }
}
//插入记录
+ (void)insertTable:(const NSString *)tableName sql:(NSString *)sql
{
    if ([dyd_dataBase open]) {
        BOOL res = [dyd_dataBase executeUpdate:sql];
        if (!res) {
            NSLog(@"error when updating db table :%@", tableName);
        }
        //        [_db close];
    }
}
//删除记录
+ (void)clearTable:(const NSString *)tableName sql:(NSString *)sql
{
    if ([dyd_dataBase open]) {
        BOOL res = [dyd_dataBase executeUpdate:sql];
        if (!res) {
             NSLog(@"error to delete db data :%@", tableName);
        }
        //        [_db close];
    }
}
//删表
+ (BOOL)deleteTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![dyd_dataBase executeUpdate:sql]) {
        NSLog(@"Delete %@ error!", tableName);
        return NO;
    }
    return YES;
}
//清空表
+ (BOOL)eraseTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![dyd_dataBase executeUpdate:sql]) {
        NSLog(@"Erase %@ error!", tableName);
        return NO;
    }
    return YES;
}
//删除数据库
+ (void)cleanDataBase
{
    BOOL success;
    NSError *error;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbFileName]) {
        [dyd_dataBase close];
        success = [fileManager removeItemAtPath:dbFileName error:&error];
        if (!success) {
            NSLog(@"Failed to delete old database file with message %@", [error localizedDescription]);
        }
    }
}

//**************************************************************************//
/** 字典转json */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{

    if (jsonString == nil) {

        return nil;

    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData

                                                        options:NSJSONReadingMutableContainers

                                                          error:&err];

    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
+ (NSDictionary*)getDictionaryFromObject_Ext:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        id value = nil;

        @try {
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            value = [self getObjectInternal_Ext:[obj valueForKey:propName]];
            if(value != nil) {
                [dic setObject:value forKey:propName];
            }
        }
        @catch (NSException *exception) {
            //[self logError:exception];
            NSLog(@"%@",exception);
        }

    }
    free(props);
    return dic;
}
+ (id)getObjectInternal_Ext:(id)obj
{
    if(!obj
       || [obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }

    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal_Ext:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }

    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal_Ext:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getDictionaryFromObject_Ext:obj];
}
//**************************************************************************//


//------------------用户数据-------------------unknow表示是游客模式 //
+ (void)createUserDataTable
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_userData (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, unknown INTEGER, userId TEXT, userJson TEXT)"];
    [self createTable:@"t_userData" sql:sql];
}
+ (void)insertUsersTable:(DYDSDKUserEntity *)user
{
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[self getDictionaryFromObject_Ext:user]];
    NSString *userJson = [self dictionaryToJson:userDic];
    if ([dyd_dataBase open]) {

        //游客模式
        if (user == nil) {
            BOOL res1 = [dyd_dataBase executeUpdate:@"DELETE FROM t_userData WHERE unknown = 1"];
            if (!res1) {
                NSLog(@"error to delete db data :t_userData");
            }
            BOOL res2 = [dyd_dataBase executeUpdateWithFormat:@"INSERT INTO t_userData (unknown, userId, userJson) VALUES (1, %@, %@)", [NSString stringWithFormat:@"%llu", user.userId], userJson];
            if (!res2) {
                NSLog(@"error when updating db table :t_userData");
            }

        } else {
            BOOL res1 = [dyd_dataBase executeUpdateWithFormat:@"DELETE FROM t_userData WHERE userId = %@", [NSString stringWithFormat:@"%llu", user.userId]];
            if (!res1) {
                NSLog(@"error to delete db data :t_userData");
            }

            BOOL res2 = [dyd_dataBase executeUpdateWithFormat:@"INSERT INTO t_userData (unknown, userId, userJson) VALUES (0, %@, %@)", [NSString stringWithFormat:@"%llu", user.userId], userJson];
            if (!res2) {
                NSLog(@"error when updating db table :t_userData");
            }
        }
    }
}
+ (void)deleteUsersTableByUserId:(NSString *)userId
{
    if ([dyd_dataBase open]) {
        BOOL res = [dyd_dataBase executeUpdateWithFormat:@"DELETE FROM t_userData WHERE userId = %@", userId];
        if (!res) {
            NSLog(@"error to delete db data :t_userData");
        }
    }
}
+ (DYDSDKUserEntity *)searchUsersTableByUserId:(NSString *)userId
{
    DYDSDKUserEntity *user = [[DYDSDKUserEntity alloc] init];
    if ([dyd_dataBase open]) {
        FMResultSet *set = [dyd_dataBase executeQueryWithFormat:@"SELECT * FROM t_userData WHERE userId = %@", userId];
        while (set.next) {
            NSString *userJson = [set stringForColumn:@"userJson"];
            NSDictionary *userDic = [self dictionaryWithJsonString:userJson];
            [user setValuesForKeysWithDictionary:userDic];
        }
    }
    return user;
}
+ (DYDSDKUserEntity *)currentUser
{
    DYDSDKUserEntity *user = [[DYDSDKUserEntity alloc] init];
    if ([dyd_dataBase open]) {
        NSMutableArray *list = [NSMutableArray array];
        NSMutableArray *unKnows = [NSMutableArray array];
        FMResultSet *set = [dyd_dataBase executeQuery:@"SELECT * FROM t_userData"];
        while (set.next) {
            NSString *userJson = [set stringForColumn:@"userJson"];
            NSDictionary *userDic = [self dictionaryWithJsonString:userJson];
            [user setValuesForKeysWithDictionary:userDic];
            if (user && [user isKindOfClass:[DYDSDKUserEntity class]]) {
                [list addObject:user];
            }

            int unknow = [set intForColumn:@"unknown"];
            [unKnows addObject:[NSNumber numberWithInt:unknow]];
        }
        NSNumber *un = [unKnows lastObject];
        if (un.intValue == 1) {
            [dyd_dataBase close];
            return nil;
        }
        user = [list lastObject];
    }
    return user;
}
+ (NSArray <DYDSDKUserEntity *> *)loginUserArr
{
    NSMutableArray *list = [NSMutableArray array];
    if ([dyd_dataBase open]) {
        FMResultSet *set = [dyd_dataBase executeQueryWithFormat:@"SELECT * FROM t_userData"];
        while (set.next) {
            NSString *json = [set stringForColumn:@"userJson"];
            NSDictionary *dic = [self dictionaryWithJsonString:json];
            DYDSDKUserEntity *user = [DYDSDKUserEntity new];
            [user setValuesForKeysWithDictionary:dic];
            if (user && [user isKindOfClass:[DYDSDKUserEntity class]]) {
                [list addObject:dic];
            }
        }
    }
    return list;
}


@end
