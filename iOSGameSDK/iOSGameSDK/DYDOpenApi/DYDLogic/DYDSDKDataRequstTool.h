//
//  DYDSDKDataRequstTool.h
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/4.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYDSDKUserEntity.h"

@interface DYDSDKDataRequstTool : NSObject

/**
 * 请求弹友数据
 * 1、type：friends：相互关注，fans：我的粉丝
 */
+ (void)sdk_get_friendsDataWithType:(NSString *)type perPage:(NSInteger)perPage page:(NSInteger)page;

//手机号码登陆
+ (void)sdk_loginWithPhone:(NSString *)phone password:(NSString *)password loginSuccess:(void(^)(DYDSDKUserEntity *user))loginSuccess failure:(void(^)())failure;

//发送验证码
+ (void)sdk_getPhoneCodeWithType:(NSString *)type phone:(NSString *)phone success:(void(^)())success failure:(void(^)())failure;

//修改密码
+ (void)sdk_modifyPasswordWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode loginSuccess:(void(^)(DYDSDKUserEntity *user))loginSuccess failure:(void(^)())failure;

//根据手机号注册账号
+ (void)sdk_registerWithPhone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password nickName:(NSString *)nickName success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure;

//游客登录
+ (void)sdk_registerVisitorWithDeviceId:(NSString *)deviceId success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure;

//升级游客账号到已有的账号
+ (void)sdk_updateAccountWithAccount:(NSString *)account password:(NSString *)password type:(NSString *)type success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure;

//注册一个新账号并且绑定到已有的游客账号
+ (void)sdk_updateNewAccountWithPhone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure;

//验证登录的token
+ (void)sdk_verifyTokenWithSuccess:(void(^)(DYDSDKUserEntity *user, NSInteger code))success failure:(void(^)())failure;

//退出登录
+ (void)sdk_logoutAccountSuccess:(void(^)(NSInteger code))success failure:(void(^)())failure;

//上传角色信息
+ (void)sdk_uploadRoleDataWithRoleId:(NSString *)roleId
                            roleName:(NSString *)roleName
                           roleLevel:(NSString *)roleLevel
                          roleZoneId:(NSString *)roleZoneId
                        roleZoneName:(NSString *)roleZoneName
                         roleBalance:(NSString *)roleBalance
                        roleVipLevel:(NSString *)roleVipLevel
                       rolePartyName:(NSString *)rolePartyName
                           roleScene:(NSString *)roleScene
                             roleExp:(NSString *)roleExp
                             success:(void(^)())success
                             failure:(void(^)())failure;

//上传对战信息
+ (void)sdk_uploadBattleDataWithRoleId:(NSString *)roleId
                                 stage:(NSString *)stage
                                zoneId:(NSString *)zoneId
                              zoneName:(NSString *)zoneName
                              battleNo:(NSString *)battleNo
                            starNumber:(NSString *)starNumber
                             isSuccess:(NSString *)isSuccess
                                  mode:(NSString *)mode
                                   exp:(NSString *)exp
                                 gains:(NSString *)gains
                               success:(void(^)())success
                               failure:(void(^)())failure;


//根据token登录账号
+ (void)sdk_loginWithToken:(NSString *)token loginSuccess:(void(^)(DYDSDKUserEntity *user))loginSuccess failure:(void(^)())failure;

@end
