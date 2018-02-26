//
//  DYDSDKLoginView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKBackBaseView.h"

typedef NS_ENUM(NSUInteger, DYDSDKLoginViewType) {
    DYDSDKLoginViewLogin, //登录
    DYDSDKLoginViewUpdate, //升级
};

@protocol DYDSDKLoginViewDelegate <NSObject>

/** 点击返回按钮 */
- (void)loginView_clickBackBut;
/** 点击注册按钮 */
- (void)loginView_clickRegisterViewWithLoginViewtype:(DYDSDKLoginViewType)type;
/** 点击登录按钮 */
- (void)loginView_ClickLohinButWithPhone:(NSString *)phone password:(NSString *)password type:(DYDSDKLoginViewType)type;
/** 点击QQ登录 */
- (void)loginView_clickQQLoginBut;
/** 点击微信登录 */
- (void)loginView_clickWechatLoginBut;
/** 点击新浪微博登录 */
- (void)loginView_clickSinaLoginBut;
/** 点击游客登录 */
- (void)loginView_clickVisitorLoginBut;
/** 点击找回密码 */
- (void)loginView_clickGetBackPasswordBut;
/** 点击关闭按钮 */
- (void)loginView_clickCloseBut;
/** 点击客户端登录 */
- (void)loginView_clickDYDAppLoginBut;

@end

@interface DYDSDKLoginView : DYDSDKBackBaseView

+ (DYDSDKLoginView *)creatLoginViewWithNoUserBut:(BOOL)noUserBut type:(DYDSDKLoginViewType)type;
/** 点击回调代理 */
@property (nonatomic, weak) id<DYDSDKLoginViewDelegate> clickDelegate;

@end
