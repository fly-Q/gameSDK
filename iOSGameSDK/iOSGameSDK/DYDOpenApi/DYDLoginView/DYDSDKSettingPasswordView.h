//
//  DYDSDKSettingPasswordView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKBackBaseView.h"

@protocol DYDSDKSettingPasswordViewDelegate <NSObject>

//点击返回按钮
- (void)settingPassword_clickBackBut;
//点击确定修改
- (void)settingPassword_clickRegisterButWithPhoneNum:(NSString *)phoneNum seccode:(NSString *)seccode password:(NSString *)password;

@end

@interface DYDSDKSettingPasswordView : DYDSDKBackBaseView

+ (DYDSDKSettingPasswordView *)creatSettingPasswordView;

/** 回调代理 */
@property (nonatomic, weak) id<DYDSDKSettingPasswordViewDelegate> settingPWDelegate;

@end
