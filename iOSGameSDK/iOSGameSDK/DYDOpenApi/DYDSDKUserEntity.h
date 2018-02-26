//
//  DYDSDKUserEntity.h
//  Demo_SQL
//
//  Created by 邱明 on 16/12/21.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DYDSDKUserType) {
    DYDSDKUserTypeAnonymous = 101,         //匿名用户
    DYDSDKUserTypeMobileUnComplete = 110,  //手机号未完成
    DYDSDKUserTypeMobileComplete = 113,    //手机号完成
    DYDSDKUserTypePhoneComplete = 111,     //手机号完成
    DYDSDKUserTypePhoneFromAnonymous = 114,//从匿名用户转化
    DYDSDKUserTypeEmailPass = 112,         //邮箱
    DYDSDKUserTypeOauth = 120,             //第三方授权
    DYDSDKUserTypeCMS = 102,               //管理系统
};

@interface DYDSDKUserEntity : NSObject

/** 账号 */
@property (nonatomic, copy) NSString * account;
/** 头像 */
@property (nonatomic, copy) NSString * avatar;
/** 昵称 */
@property (nonatomic, copy) NSString * nickName;
/** token */
@property (nonatomic, copy) NSString * token;
/** 用户的Id */
@property (nonatomic, assign) long long userId;
/** 用户账号类型 */
@property (nonatomic, assign) NSInteger userType;

@end
