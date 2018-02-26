//
//  DYDSDKSuspensionMenuView.h
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/3.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYDSDKSuspensionMenuViewDelegate <NSObject>

//点击关闭按钮
- (void)suspensionMenuView_clickCloseBut;
//点击修改密码
- (void)suspensionMenuView_clickSettingPWBut;
//点击查看弹友
- (void)suspensionMenuView_clickLookFriendsBut;
//点击切换账号
- (void)suspensionMenuView_clickChangAccountBut;
//点击退出游戏
- (void)suspensionMenuView_clickQuitGameBut;
//点击绑定按钮
- (void)suspensionMenuView_clickBindAccountBut;

@end

@interface DYDSDKSuspensionMenuView : UIView

//创建
+ (DYDSDKSuspensionMenuView *)sdk_creatSuspensionViewWithDelegate:(id<DYDSDKSuspensionMenuViewDelegate>)delegate;

@end
