//
//  DYDSDKDataRequstTool.m
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/4.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKDataRequstTool.h"
#import "DYDSDKNetworkTool.h"
#import "DYDSDKMessagePopupView.h"

@implementation DYDSDKDataRequstTool

/**
 * 请求弹友数据
 * 1、type：friends：相互关注，fans：我的粉丝
 */
+ (void)sdk_get_friendsDataWithType:(NSString *)type perPage:(NSInteger)perPage page:(NSInteger)page
{
    [DYDSDKNetworkTool dydsdk_get_connectWebWithUrl:@"users/friends" parameter:@{@"type" : type, @"perPage" : @(perPage).stringValue, @"page" : @(page).stringValue} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

//手机号码登陆
+ (void)sdk_loginWithPhone:(NSString *)phone password:(NSString *)password loginSuccess:(void(^)(DYDSDKUserEntity *user))loginSuccess failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"users/login" parameter:@{@"account" : phone, @"password" : password} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            //成功,合成model，回调
            NSArray *userAry = [object objectForKey:@"userList"];
            if (userAry.count > 0) {
                //存在用户
                NSDictionary *userDic = [userAry firstObject];
                DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
                [userE setValuesForKeysWithDictionary:userDic];
                if (loginSuccess) {
                    loginSuccess(userE);
                }
            }else{
                [DYDSDKMessagePopupView dydsdk_showMessage:@"登录发生错误" center:CGPointZero inView:nil];
                if (failure) {
                    failure();
                }
            }
            
        }else{
            NSString *message = [otherData objectForKey:@"message"];
            if (message && [message isKindOfClass:[NSString class]]) {
                [DYDSDKMessagePopupView dydsdk_showMessage:message center:CGPointZero inView:nil];
            }else{
                [DYDSDKMessagePopupView dydsdk_showMessage:@"登录错误" center:CGPointZero inView:nil];
            }
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"登录发生错误" center:CGPointZero inView:nil];
        if (failure) {
            failure();
        }
    }];
}


//type:1、resetpass忘记密码 2、register注册新账号
+ (void)sdk_getPhoneCodeWithType:(NSString *)type phone:(NSString *)phone success:(void(^)())success failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"sms" parameter:@{@"source" : type, @"mobile" : phone} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code != 200) {
            //不是200
            [DYDSDKMessagePopupView dydsdk_showMessage:[otherData objectForKey:@"message"] center:CGPointZero inView:nil];
        }else{
            if (success) {
                success();
            }
        }
    } failure:^(NSError *error) {
        
        [DYDSDKMessagePopupView dydsdk_showMessage:@"验证码发送失败！" center:CGPointZero inView:nil];
    }];
}


+ (void)sdk_modifyPasswordWithPhone:(NSString *)phone password:(NSString *)password smsCode:(NSString *)smsCode loginSuccess:(void(^)(DYDSDKUserEntity *user))loginSuccess failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_put_connectWebWithUrl:@"users/forgetpass" parameter:@{@"mobile" : phone, @"newPass" : password, @"smsCode" : smsCode, @"appChannel" : @"ios"} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            //修改成功，返回一个User
            NSArray *userAry = [object objectForKey:@"userList"];
            if (userAry.count > 0) {
                NSDictionary *userDic = [userAry firstObject];
                DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
                [userE setValuesForKeysWithDictionary:userDic];
                if (loginSuccess) {
                    loginSuccess(userE);
                }
            }else{
                if (loginSuccess) {
                    loginSuccess(nil);
                }
            }
        }else{
            [DYDSDKMessagePopupView dydsdk_showMessage:[otherData objectForKey:@"message"] center:CGPointZero inView:nil];
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"修改失败！" center:CGPointZero inView:nil];
    }];
}


+ (void)sdk_registerWithPhone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password nickName:(NSString *)nickName success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"users/register" parameter:@{@"mobile" : phone, @"password" : password, @"smsCode" : smsCode, @"nickName" : nickName} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code != 200) {
            //没有成功
            NSString *message = [otherData objectForKey:@"message"];
            [DYDSDKMessagePopupView dydsdk_showMessage:message center:CGPointZero inView:nil];
            return ;
        }
        NSArray *userList = [object objectForKey:@"userList"];
        if (userList.count > 0) {
            //有注册用户
            NSDictionary *userDic = [userList firstObject];
            DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
            [userE setValuesForKeysWithDictionary:userDic];
            if (success) {
                success(userE);
            }
        }else{
            if (success) {
                success(nil);
            }
        }
    } failure:^(NSError *error) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"注册失败" center:CGPointZero inView:nil];
        if (failure) {
            failure();
        }
    }];
}


+ (void)sdk_registerVisitorWithDeviceId:(NSString *)deviceId success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"users/register" parameter:@{@"deviceId": deviceId} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code != 200) {
            //没有成功
            NSString *message = [otherData objectForKey:@"message"];
            [DYDSDKMessagePopupView dydsdk_showMessage:message center:CGPointZero inView:nil];
            return ;
        }
        NSArray *userList = [object objectForKey:@"userList"];
        if (userList.count > 0) {
            //有注册用户
            NSDictionary *userDic = [userList firstObject];
            DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
            [userE setValuesForKeysWithDictionary:userDic];
            if (success) {
                success(userE);
            }
        }else{
            if (success) {
                success(nil);
            }
        }
    } failure:^(NSError *error) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"注册失败" center:CGPointZero inView:nil];
        if (failure) {
            failure();
        }
    }];
}



+ (void)sdk_updateAccountWithAccount:(NSString *)account password:(NSString *)password type:(NSString *)type success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"users/login" parameter:@{@"account" : account, @"password" : password, @"type" : type} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            NSArray *userList = [object objectForKey:@"userList"];
            if (userList.count > 0) {
                //有注册用户
                NSDictionary *userDic = [userList firstObject];
                DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
                [userE setValuesForKeysWithDictionary:userDic];
                if (success) {
                    success(userE);
                }
            }else{
                if (success) {
                    success(nil);
                }
            }
        }else{
            NSString *message = [otherData objectForKey:@"message"];
            [DYDSDKMessagePopupView dydsdk_showMessage:message center:CGPointZero inView:nil];
        }
    } failure:^(NSError *error) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"账号绑定失败" center:CGPointZero inView:nil];
        if (failure) {
            failure();
        }
    }];
}


+ (void)sdk_updateNewAccountWithPhone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password success:(void(^)(DYDSDKUserEntity *user))success failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_put_connectWebWithUrl:@"users/register" parameter:@{@"mobile" : phone, @"password" : password, @"smsCode" : smsCode} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            NSArray *userList = [object objectForKey:@"userList"];
            if (userList.count > 0) {
                //有注册用户
                NSDictionary *userDic = [userList firstObject];
                DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
                [userE setValuesForKeysWithDictionary:userDic];
                if (success) {
                    success(userE);
                }
            }else{
                if (success) {
                    success(nil);
                }
            }
        }else{
            NSString *message = [otherData objectForKey:@"message"];
            [DYDSDKMessagePopupView dydsdk_showMessage:message center:CGPointZero inView:nil];
        }
    } failure:^(NSError *error) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"账号绑定失败" center:CGPointZero inView:nil];
        if (failure) {
            failure();
        }
    }];
}

//验证账号登录状况。200：只有在200的情况下才是登录有效，非200转到登录页面，failure时不做任何处理（网络错误）
+ (void)sdk_verifyTokenWithSuccess:(void(^)(DYDSDKUserEntity *user, NSInteger code))success failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_get_connectWebWithUrl:@"users/token" parameter:nil success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code != 200) {
            //转到登录页面
            success(nil, code);
        }else{
            //新的user信息
            NSArray *userList = [object objectForKey:@"userList"];
            if (userList.count > 0) {
                //有注册用户
                NSDictionary *userDic = [userList firstObject];
                DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
                [userE setValuesForKeysWithDictionary:userDic];
                if (success) {
                    success(userE, code);
                }
            }else{
                if (success) {
                    success(nil, code);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

//退出登录
+ (void)sdk_logoutAccountSuccess:(void(^)(NSInteger code))success failure:(void(^)())failure
{
    [DYDSDKNetworkTool dydsdk_delete_connectWebWithUrl:@"users/login" parameter:nil success:^(id object, NSInteger code, NSDictionary *otherData) {
        [DYDSDKNetworkTool dyd_removeCookies];
        if (success) {
            success(code);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}



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
                             failure:(void(^)())failure
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:roleId forKey:@"roleId"];
    [paraDic setValue:roleName forKey:@"roleName"];
    [paraDic setValue:roleLevel forKey:@"roleLevel"];
    [paraDic setValue:roleZoneId forKey:@"zoneId"];
    [paraDic setValue:roleZoneName forKey:@"zoneName"];
    [paraDic setValue:roleBalance forKey:@"balance"];
    [paraDic setValue:roleVipLevel forKey:@"vipLevel"];
    [paraDic setValue:rolePartyName forKey:@"partyName"];
    [paraDic setValue:roleScene forKey:@"scene"];
    [paraDic setValue:roleExp forKey:@"roleExp"];
    
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"users/role" parameter:paraDic success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            if (success) {
                success();
            }
        }else{
            NSString *message = [otherData objectForKey:@"message"];
            if (message && [message isKindOfClass:[NSString class]]) {
#if DEBUG
                NSLog(@"%@", message);
#endif
            }
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
#if DEBUG
        NSLog(@"上传角色信息失败");
#endif
        if (failure) {
            failure();
        }
    }];
}


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
                               failure:(void(^)())failure
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:roleId forKey:@"roleId"];
    [paraDic setValue:stage forKey:@"stage"];
    [paraDic setValue:zoneId forKey:@"zoneId"];
    [paraDic setValue:zoneName forKey:@"zoneName"];
    [paraDic setValue:battleNo forKey:@"battleNo"];
    [paraDic setValue:starNumber forKey:@"starNumber"];
    [paraDic setValue:isSuccess forKey:@"isSuccess"];
    [paraDic setValue:mode forKey:@"mode"];
    [paraDic setValue:exp forKey:@"exp"];
    [paraDic setValue:gains forKey:@"gains"];
    
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"users/battle" parameter:paraDic success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            if (success) {
                success();
            }
        }else{
            NSString *message = [otherData objectForKey:@"message"];
            if (message && [message isKindOfClass:[NSString class]]) {
#if DEBUG
                NSLog(@"%@", message);
#endif
            }
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
#if DEBUG
        NSLog(@"上传战斗信息失败");
#endif
        if (failure) {
            failure();
        }
    }];
}

//第三方授权登陆
+ (void)sdk_loginWithToken:(NSString *)token loginSuccess:(void(^)(DYDSDKUserEntity *user))loginSuccess failure:(void(^)())failure
{
    if (token == nil) {
        NSLog(@"token不能为空");
        return;
    }
    [DYDSDKNetworkTool dydsdk_post_connectWebWithUrl:@"users/login" parameter:@{@"token" : token} success:^(id object, NSInteger code, NSDictionary *otherData) {
        if (code == 200) {
            //成功,合成model，回调
            NSArray *userAry = [object objectForKey:@"userList"];
            if (userAry.count > 0) {
                //存在用户
                NSDictionary *userDic = [userAry firstObject];
                DYDSDKUserEntity *userE = [DYDSDKUserEntity new];
                [userE setValuesForKeysWithDictionary:userDic];
                if (loginSuccess) {
                    loginSuccess(userE);
                }
            }else{
                [DYDSDKMessagePopupView dydsdk_showMessage:@"登录发生错误" center:CGPointZero inView:nil];
                if (failure) {
                    failure();
                }
            }
            
        }else{
            NSString *message = [otherData objectForKey:@"message"];
            if (message && [message isKindOfClass:[NSString class]]) {
                [DYDSDKMessagePopupView dydsdk_showMessage:message center:CGPointZero inView:nil];
            }else{
                [DYDSDKMessagePopupView dydsdk_showMessage:@"登录错误" center:CGPointZero inView:nil];
            }
            if (failure) {
                failure();
            }
        }
    } failure:^(NSError *error) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"登录发生错误" center:CGPointZero inView:nil];
        if (failure) {
            failure();
        }
    }];
}

@end
