//
//  DYDSDKMessagePopupView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/17.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYDSDKMessagePopupView : UIView

//创建并显示视图在指定视图上，默认window上
+ (void)dydsdk_showMessage:(NSString *)message center:(CGPoint)center inView:(UIView *)view;

//创建一个视图
+ (DYDSDKMessagePopupView *)dydsdk_creatMessagePopupViewWithMessage:(NSString *)message center:(CGPoint)center;

//显示在视图中，默认加载到window上
- (void)showInView:(UIView *)view autoDismiss:(BOOL)autoDismiss;

//animate：是否带有动画，time：动画的时间
- (void)dismissWithAnimate:(BOOL)animate time:(CGFloat)time;

@end
