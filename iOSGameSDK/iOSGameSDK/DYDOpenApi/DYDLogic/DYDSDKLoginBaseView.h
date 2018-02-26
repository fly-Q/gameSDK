//
//  DYDSDKLoginBaseView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYDSDKCallBackDelegate.h"
@class DYDSDKUserEntity;

typedef NS_ENUM(NSUInteger, DYDSDKShowViewType) {
    DYDSDKShowViewTypeLogin,         //登陆页面
    DYDSDKShowViewTypeAccountUpdate, //升级账号
    DYDSDKShowViewTypeWelcomeBack,   //欢迎回来
    DYDSDKShowViewTypeBindAccount,   //绑定账号
    DYDSDKShowViewTypeChangAccount,  //切换账号
    DYDSDKShowViewTypeModifyPassW,   //修改密码
    DYDSDKShowViewTypeLookFriends,   //查看弹友
};

@interface DYDSDKLoginBaseView : UIView

+ (DYDSDKLoginBaseView *)creatSDKLoginBaseViewWithFrame:(CGRect)frame;

- (void)showWithType:(DYDSDKShowViewType)type;

+ (BOOL)judgeIsMobiePhoneNumberWithPhoneString:(NSString *)string;

@end
