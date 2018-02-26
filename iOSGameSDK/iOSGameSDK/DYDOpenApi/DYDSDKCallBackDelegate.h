//
//  DYDSDKCallBackDelegate.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/26.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DYDSDKUserEntity;

typedef NS_ENUM(NSUInteger, DYDSDKLoginResult) {
    DYDSDKLoginResultSuccess,       //登录成功
    DYDSDKLoginResultCancel,        //用户取消
    DYDSDKLoginResultFailure,       //失败
    DYDSDKLoginResultInvalidToken,  //自动检测登录token无效视为失败
    DYDSDKLoginResultNoUser,        //自动检测登录无历史用户
};

//自动检测登录结果
typedef NS_ENUM(NSUInteger, DYDSDKCheckUserResult) {
    DYDSDKCheckUserResultNoUser,         //没有登录过用户
    DYDSDKCheckUserResultInvalidToken,   //登录失效，重新登录
    DYDSDKCheckUserResultNetError,       //网络问题
};

@protocol DYDSDKCallBackDelegate <NSObject>

/**
 * 登录回调
 * @param result 登录的结果回调
 * @param userE 登录的用户，登录失败为nil
 * 注：
 *  1、回调条件
 *   1.1 登录账号
 *   1.2 注册完成
 *   1.3 游客登录
 *   1.4 游客绑定已有第一弹账号
 *   1.5 游客绑定注册的新号
 *   1.6 第一弹客户端登录
 *  2、登录失败，界面不会消失，不回调
 *  3、登录中途关闭登录界面回调失败
 */
- (void)dyd_loginFinishWithResult:(DYDSDKLoginResult)result userE:(DYDSDKUserEntity *)userE;

/**
 * 退出登录第一弹账号
 * @param result 为YES，退出成功。为NO，退出登录失败（可能为网络原因）
 * 注：
 *    1.根据服务端结果回调
 */
- (void)dyd_logoutResult:(BOOL)result;

/**
 * 切换账号出口
 * 点击了切换账号，退出了登录状态
 */
- (void)dyd_changeAccountLogoutSuccess;

@end

