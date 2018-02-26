//
//  DYDSDKGeneralAlertView.h
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/5.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYDSDKGeneralAlertView : UIView

+ (DYDSDKGeneralAlertView *)creatSDKGeneralAlertVieiwWithMessage:(NSString *)message callBack:(void(^)(NSInteger index))callBack;
//显示视图
- (void)show;

- (void)alertView_setupBut1:(NSString *)but1 but2:(NSString *)but2;

@end
