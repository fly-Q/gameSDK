//
//  DYDLoginHeader.h
//  DYD_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYDSDKCallBackDelegate.h"
#import "DYDSDKUserEntity.h"

@interface DYDLoginHeader : NSObject

/**
 *  第一弹登录模块初始化
 */
+ (void)dyd_initializeWithAppId:(NSString *)appId appKey:(NSString *)appKey;

/**
 * 自动检测上次登录的账号
 * 注：
 *  1、检测登录失效会自动弹出登录界面，同时给予回调
 *  2、使用该方法需先注册登录模块，使用方法dyd_initializeWithAppId:
 */
+ (void)dyd_checkLoginUserWithLoginSuccess:(void(^)(DYDSDKUserEntity *loginUserE))loginSuccess loginFailure:(void(^)(DYDSDKCheckUserResult checkResult))loginFailure;

/**
 * 设置模块回调代理
 * 注：
 *  1、重复调用只保留最后一个进行回调
 */
+ (void)dyd_setCallBackDelegate:(id<DYDSDKCallBackDelegate>)delegate;

/**
 * 处理第一弹客户端登录
 */
+ (BOOL)dyd_handleDiyidanAppLoginWithUrl:(NSURL *)url;

/**
 * 开始登录界面
 */
+ (void)dyd_login;

/**
 * 退出登录
 */
+ (void)dyd_logout;

/**
 * 获取当前登录的用户信息
 */
+ (DYDSDKUserEntity *)dyd_getCurrentUser;

/**
 * 获取用户的token  如果没有登录，返回结果nil
 */
+ (NSString *)dyd_getToken;

/**
 * 验证登录用户的token是否有效
 * 验证结果result：为YES时表示登录有效。userE是对应的用户信息，token无效时为nil。
 */
+ (void)dyd_verifyTokenSuccess:(void(^)(BOOL result, DYDSDKUserEntity *userE))success failure:(void(^)())failure;

/**
 * 上传用户闯关/对战信息
 * @param roleId 当前登录的玩家角色ID，若无，可传入userid
 * @param zoneId 当前登录的游戏区服ID，必须为数字，且不能为0，若无，传入1
 * @param zoneName 当前登录的游戏区服名称，不能为空，不能为null，若无，传入游戏名称+”1区”
 * @param mode 闯关模式, 直接传模式名。常见的有"普通模式"、"精英模式"。若无不同模式的区分，传入"普通模式"即可
 * @param stage 关卡名，以 "章节名+关卡数字" 表示。如，"黑暗森林5-3"。 如果为对战，则传入 "对战类型"，如 "大峡谷3v3"
 * @param battleNo 唯一标识此次闯关/对战的编号, 不能为空
 * @param starNumber 所获星级，标识此次闯关表现, 以"start*数字"表示。如 "star*0" 表示0星, "star*3" 表示3星。若无星级，则根据游戏情况直接返回评级结果, 如"SS级"、"失败"
 * @param isSuccess 是否闯关成功, true表示成功, false表示失败
 * @param exp 此次闯关所获经验值, 无经验则为0, 扣经验则为负
 * @param gains 此次闯关掉落/损失的物品, "物品名+数字,物品名-数字"来表示，中间用英文逗号分隔。如"水晶+3,卷轴+2"。若为对战，则需要把对战荣誉也传上来，如"水晶+3,排位+2,排位-2,MVP,5杀,超鬼"
 */
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
                               failure:(void(^)())failure;

/**
 * 上传角色信息
 * @param roleId 当前登录的玩家角色ID，若无，可传入userid
 * @param roleName 当前登录的玩家角色名，不能为空，不能为null，若无，传入”游戏名称+username”
 * @param roleLevel 当前登录的玩家角色等级，且不能为0，若无，传入1
 * @param roleZoneId 当前登录的游戏区服ID，且不能为0，若无，传入1
 * @param roleZoneName 当前登录的游戏区服名称，不能为空，不能为null，若无，传入游戏名称+”1区”
 * @param roleBalance 当前用户游戏币余额，若无，传入0
 * @param roleVipLevel 当前用户VIP等级，若无，传入0
 * @param rolePartyName 当前用户所属帮派，不能为空，不能为null，若无，传入”无帮派”
 * @param roleScene 当前场景: enterServer，levelUp，createRole
 * @param roleExp 当前登录的玩家角色经验值，最小值为0
 */
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
                             failure:(void(^)())failure;

/**
 * 悬浮球跳转（显示悬浮功能菜单）
 */
+ (void)dyd_showSuspensionFunctionMenu;

@end
