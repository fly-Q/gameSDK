//
//  DYDLoginHeader.m
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDLoginHeader.h"
#import "DYDDataManager.h"
#import "DYDSettingHeader.h"
#import "DYDSDKLoginBaseView.h"
#import "DYDSDKWelcomeBackView.h"
#import "DYDMachineKeyStore.h"
#import "DYDSDKNetworkTool.h"
#import "DYDDBManager.h"
#import "DYDSDKSuspensionButton.h"
#import "DYDSDKFunctionMenuView.h"
#import "DYDSDKDataRequstTool.h"

@implementation DYDLoginHeader

+ (void)registerDYDWithAppId:(NSString *)appId
{
    return;
    dispatch_async(dispatch_get_main_queue(), ^{//加异步向游戏让行
        [self beginWithAppId:appId];
    });
}

/**
 *  第一弹登录模块初始化
 */
+ (void)dyd_initializeWithAppId:(NSString *)appId appKey:(NSString *)appKey
{
    //保存appid
    [DYDDataManager shareDYDDataManager].gs_appId = appId;
    [DYDDataManager shareDYDDataManager].gs_appKey = appKey;
    //生成scheme
    if (![[DYDMachineKeyStore sharedInstance] isMachineKeyExsit]) {
        [[DYDMachineKeyStore sharedInstance] createAndStoreMachinKey];
    }
    [DYDDataManager shareDYDDataManager].deviceId = [[DYDMachineKeyStore sharedInstance] getMachineKey];
    [DYDDataManager shareDYDDataManager].loginUser = [DYDDBManager currentUser];//取出上次登录的用户
    [DYDSDKNetworkTool dyd_loadCookies];
}

/**
 * 自动检测上次登录的账号
 * 注：
 *  1、检测登录失效会自动弹出登录界面，同时给予回调
 *  2、使用该方法需先注册登录模块，使用方法dyd_initializeWithAppId:
 */
+ (void)dyd_checkLoginUserWithLoginSuccess:(void(^)(DYDSDKUserEntity *loginUserE))loginSuccess loginFailure:(void(^)(DYDSDKCheckUserResult checkResult))loginFailure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DYDDataManager shareDYDDataManager].loginUser = [DYDDBManager currentUser];//取出上次登录的用户
        //开始检测登陆状态
        //1、有上次登录用户，验证登录信息
        //2、没有上次登录信息，显示登录界面
        if ([DYDDataManager shareDYDDataManager].loginUser) {
            //有登录用户
            if ([DYDDataManager shareDYDDataManager].loginUser.userType == DYDSDKUserTypeAnonymous) {
                //匿名用户
                [DYDSDKDataRequstTool sdk_verifyTokenWithSuccess:^(DYDSDKUserEntity *user, NSInteger code) {
                    if (code == 200) {
                        //账号登录有效,欢迎界面，提示升级
                        [DYDDataManager shareDYDDataManager].loginUser = user;
                        DYDSDKWelcomeBackView *view = [DYDSDKWelcomeBackView creatWelcomeBackViewWithVisitorName:[DYDDataManager shareDYDDataManager].loginUser.nickName avatar:[DYDDataManager shareDYDDataManager].loginUser.avatar callBack:^{
                            //点击了切换账号
                            
                            //1、退出当前的账号
                            //2、切换到登录界面
                            [self dyd_logout];
                            DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                            [baseView showWithType:DYDSDKShowViewTypeLogin];
                            
                            //3、登录新的账号
                            
                        }];
                        [view insertToWindow];
                        
                        DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                        [baseView showWithType:DYDSDKShowViewTypeAccountUpdate];
                        
                        //回调成功
                        if (loginSuccess) {
                            loginSuccess(user);
                        }else{
                            
                        }
                        
                    }else{
                        //登录已失效
                        DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                        [baseView showWithType:DYDSDKShowViewTypeLogin];
                        [DYDDataManager shareDYDDataManager].loginUser = nil;//登录的用户置空
                        
                        //登录失败回调
                        if (loginFailure) {
                            loginFailure(DYDSDKCheckUserResultInvalidToken);
                        }else{
                            
                        }
                    }
                } failure:^{
                    //验证失败，什么也不做（要不，欢迎一下？）
                    DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                    [baseView showWithType:DYDSDKShowViewTypeLogin];
                    [DYDDataManager shareDYDDataManager].loginUser = nil;//登录的用户置空
                    
                    //登录失败回调
                    if (loginFailure) {
                        loginFailure(DYDSDKCheckUserResultNetError);
                    }else{
                        
                    }
                }];
            }else{
                [DYDSDKDataRequstTool sdk_verifyTokenWithSuccess:^(DYDSDKUserEntity *user, NSInteger code) {
                    if (code == 200) {
                        //账号登录有效,欢迎界面
                        [DYDDataManager shareDYDDataManager].loginUser = user;
                        DYDSDKWelcomeBackView *view = [DYDSDKWelcomeBackView creatWelcomeBackViewWithVisitorName:[DYDDataManager shareDYDDataManager].loginUser.nickName avatar:[DYDDataManager shareDYDDataManager].loginUser.avatar callBack:^{
                            //点击了切换账号
                            
                            //1、退出当前的账号
                            //2、切换到登录界面
                            [self dyd_logout];
                            DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                            [baseView showWithType:DYDSDKShowViewTypeLogin];
                            
                            //3、登录新的账号
                            
                        }];
                        [view insertToWindow];
                        
                        //登录成功回调
                        if (loginSuccess) {
                            loginSuccess(user);
                        }else{
                            
                        }
                        
                    }else{
                        //登录已失效
                        DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                        [baseView showWithType:DYDSDKShowViewTypeLogin];
                        [DYDDataManager shareDYDDataManager].loginUser = nil;//登录的用户置空
                        
                        //Token失效回调
                        if (loginFailure) {
                            loginFailure(DYDSDKCheckUserResultInvalidToken);
                        }else{
                            
                        }
                        
                    }
                } failure:^{
                    //验证失败，什么也不做（要不，欢迎一下？）
                    [DYDDataManager shareDYDDataManager].loginUser = nil;//登录的用户置空
                    
                    //登录失败网络错误
                    if (loginFailure) {
                        loginFailure(DYDSDKCheckUserResultNetError);
                    }else{
                        
                    }
                }];
            }
        }else{
            DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
            [baseView showWithType:DYDSDKShowViewTypeLogin];
            [DYDDataManager shareDYDDataManager].loginUser = nil;//登录的用户置空
            
            //没有历史用户登录
            if (loginFailure) {
                loginFailure(DYDSDKCheckUserResultNoUser);
            }else{
                
            }
        }
    });
}

+ (void)beginWithAppId:(NSString *)appId
{
    //保存appid
    [DYDDataManager shareDYDDataManager].gs_appId = appId;
    //生成scheme
    if (![[DYDMachineKeyStore sharedInstance] isMachineKeyExsit]) {
        [[DYDMachineKeyStore sharedInstance] createAndStoreMachinKey];
    }
    [DYDDataManager shareDYDDataManager].deviceId = [[DYDMachineKeyStore sharedInstance] getMachineKey];
    [DYDDataManager shareDYDDataManager].loginUser = [DYDDBManager currentUser];//取出上次登录的用户
    [DYDSDKNetworkTool dyd_loadCookies];
    
    //开始检测登陆状态
    //1、有上次登录用户，验证登录信息
    //2、没有上次登录信息，显示登录界面
    if ([DYDDataManager shareDYDDataManager].loginUser) {
        //有登录用户
        if ([DYDDataManager shareDYDDataManager].loginUser.userType == DYDSDKUserTypeAnonymous) {
            //匿名用户
            [DYDSDKDataRequstTool sdk_verifyTokenWithSuccess:^(DYDSDKUserEntity *user, NSInteger code) {
                if (code == 200) {
                    //账号登录有效,欢迎界面，提示升级
                    
                    DYDSDKWelcomeBackView *view = [DYDSDKWelcomeBackView creatWelcomeBackViewWithVisitorName:[DYDDataManager shareDYDDataManager].loginUser.nickName avatar:[DYDDataManager shareDYDDataManager].loginUser.avatar callBack:^{
                        //点击了切换账号
                        
                        //1、退出当前的账号
                        //2、切换到登录界面
                        [self dyd_logout];
                        DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                        [baseView showWithType:DYDSDKShowViewTypeLogin];
                        
                        //3、登录新的账号
                        
                    }];
                    [view insertToWindow];
                    
                    DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                    [baseView showWithType:DYDSDKShowViewTypeAccountUpdate];
                }else{
                    //登录已失效
                    DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                    [baseView showWithType:DYDSDKShowViewTypeLogin];
                }
            } failure:^{
                //验证失败，什么也不做（要不，欢迎一下？）
            }];
        }else{
            [DYDSDKDataRequstTool sdk_verifyTokenWithSuccess:^(DYDSDKUserEntity *user, NSInteger code) {
                if (code == 200) {
                    //账号登录有效,欢迎界面
                    DYDSDKWelcomeBackView *view = [DYDSDKWelcomeBackView creatWelcomeBackViewWithVisitorName:[DYDDataManager shareDYDDataManager].loginUser.nickName avatar:[DYDDataManager shareDYDDataManager].loginUser.avatar callBack:^{
                        //点击了切换账号
                        
                        //1、退出当前的账号
                        //2、切换到登录界面
                        [self dyd_logout];
                        DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                        [baseView showWithType:DYDSDKShowViewTypeLogin];
                        
                        //3、登录新的账号
                        
                    }];
                    [view insertToWindow];
                }else{
                    //登录已失效
                    DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
                    [baseView showWithType:DYDSDKShowViewTypeLogin];
                }
            } failure:^{
                //验证失败，什么也不做（要不，欢迎一下？）
            }];
        }
    }else{
        DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
        [baseView showWithType:DYDSDKShowViewTypeLogin];
    }
}

/**
 * 是否安装了第一弹，返回值YES，安装了第一弹，为NO，未安装第一弹
 */
+ (BOOL)dydInstallStatus
{
    if (DYDSystemVersion < 9) {
        //9一下的系统，不需要判定scheme白名单
//        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        BOOL res = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"diyidanOpenApiV1://"]];
        return res;
    }else{
        //9或者9以上,判定scheme 白名单
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        if ([[info objectForKey:@"LSApplicationQueriesSchemes"] containsObject:@"diyidanOpenApiV1"]) {
            BOOL res = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"diyidanOpenApiV1://"]];
            return res;
        }else{
            NSLog(@"info.plist未信任第一弹的scheme--diyidanOpenApiV1");
            return NO;
        }
    }
    return NO;
}

#pragma mark - 公共方法
/**
 * 设置模块回调代理
 */
+ (void)dyd_setCallBackDelegate:(id<DYDSDKCallBackDelegate>)delegate
{
    [DYDDataManager shareDYDDataManager].dyd_delegate = delegate;
}

/**
 * 登录账号
 */
+ (void)dyd_login
{
    DYDSDKLoginBaseView *baseView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
    [baseView showWithType:DYDSDKShowViewTypeLogin];
}

/**
 * 退出登录
 */
+ (void)dyd_logout
{
    //清空内存的数据
    [DYDDataManager shareDYDDataManager].loginUser = nil;
    //清除数据库中的登录用户
    [DYDDBManager insertUsersTable:nil];
    
    [DYDSDKDataRequstTool sdk_logoutAccountSuccess:^(NSInteger code) {
        if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
            if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_logoutResult:)]) {
                [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_logoutResult:YES];
            }else{
                NSLog(@"未实现代理方法'dyd_logoutResult:'");
            }
        }else{
            NSLog(@"未设置回调代理");
        }
    } failure:^{
        if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
            if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_logoutResult:)]) {
                [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_logoutResult:NO];
            }else{
                NSLog(@"未实现代理方法'dyd_logoutResult:'");
            }
        }else{
            NSLog(@"未设置回调代理");
        }
    }];
}

/**
 * 获取当前登录的用户信息
 */
+ (DYDSDKUserEntity *)dyd_getCurrentUser
{
    return [DYDDataManager shareDYDDataManager].loginUser;
}

/**
 * 获取用户的token  如果没有登录，返回结果nil
 */
+ (NSString *)dyd_getToken
{
    if ([DYDDataManager shareDYDDataManager].loginUser) {
        return [DYDDataManager shareDYDDataManager].loginUser.token;
    }else{
        return nil;
    }
}

/**
 * 验证登录用户的token是否有效
 * 验证结果result：为YES时表示登录有效。userE是对应的用户信息。failure回调可能是网络原因
 */
+ (void)dyd_verifyTokenSuccess:(void(^)(BOOL result, DYDSDKUserEntity *userE))success failure:(void(^)())failure
{
    [DYDSDKDataRequstTool sdk_verifyTokenWithSuccess:^(DYDSDKUserEntity *user, NSInteger code) {
        if (code == 200) {
            success(YES, user);
        }else{
            success(NO, user);
        }
    } failure:^{
        failure();
    }];
}


+ (void)dyd_uploadBattleDataWithRoleId:(NSString *)roleId
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
    [DYDSDKDataRequstTool sdk_uploadBattleDataWithRoleId:roleId stage:stage zoneId:zoneId zoneName:zoneName battleNo:battleNo starNumber:starNumber isSuccess:isSuccess mode:mode exp:exp gains:gains success:success failure:failure];
}

+ (void)dyd_uploadRoleDataWithRoleId:(NSString *)roleId
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
    [DYDSDKDataRequstTool sdk_uploadRoleDataWithRoleId:roleId roleName:roleName roleLevel:roleLevel roleZoneId:roleZoneId roleZoneName:roleZoneName roleBalance:roleBalance roleVipLevel:roleVipLevel rolePartyName:rolePartyName roleScene:roleScene roleExp:roleExp success:success failure:failure];
}

/**
 * 处理第一弹客户端登录
 */
+ (BOOL)dyd_handleDiyidanAppLoginWithUrl:(NSURL *)orignUrl
{
//    NSString *url = orignUrl.absoluteString;
    id  passValue = [[UIPasteboard generalPasteboard] valueForPasteboardType:DYDSDKDYDPassValureKey];
    if (passValue && passValue) {
        NSString *passValureStr = [NSKeyedUnarchiver unarchiveObjectWithData:passValue];
        NSData *passValureData = [passValureStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *passValureDic = [NSJSONSerialization JSONObjectWithData:passValureData options:NSJSONReadingMutableContainers error:nil];
        [UIPasteboard removePasteboardWithName:DYDSDKDYDPassValureKey];//清除上次的数据
        NSLog(@"passValureDic = %@", passValureDic);
        if ([passValureDic[@"requestType"] isEqualToString:@"login"]) {
            //是登录的跳转
            NSNumber *code = passValureDic[@"code"];
            if (code.intValue == 200) {
                //表示登录成功
                NSLog(@"gameToken = %@", passValureDic[@"gameToken"]);
                NSString *token = [passValureDic objectForKey:@"gameToken"];
                if (token) {
                    //token存在
                    [DYDSDKDataRequstTool sdk_loginWithToken:token loginSuccess:^(DYDSDKUserEntity *user) {
                        if (user) {
                            //登录成功有用户信息
                            [[NSNotificationCenter defaultCenter] postNotificationName:DYDAppLoginSuccessNotificate object:user];
                        }
                    } failure:^{

                    }];
                }else{
                    NSLog(@"登录失败，没有token");
                }

            } else if (code.intValue == 300) {
                //表示用户取消
            } else {
                //其他情况, 没有成功
            }
        } else {
            //不是登录, 未知
        }
//        NSLog(@"passValureDic = %@", passValureDic);
//        NSLog(@"gameToken = %@", passValureDic[@"token"]);
        return YES;
    } else {
        return NO;
    }
}

/**
 * 悬浮球跳转（显示悬浮功能菜单）
 */
+ (void)dyd_showSuspensionFunctionMenu
{
    if (![DYDDataManager shareDYDDataManager].loginUser) {
        //没有登录用户
        NSLog(@"没有用户登录");
        return;
    }
    //显示功能菜单界面
    DYDSDKFunctionMenuView *menuView = [DYDSDKFunctionMenuView sdk_creatFunctionMenuView];
    [menuView showInView:nil];
}

@end
