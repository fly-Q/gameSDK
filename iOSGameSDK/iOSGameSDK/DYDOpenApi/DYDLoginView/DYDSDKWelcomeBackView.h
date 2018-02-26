//
//  DYDSDKWelcomeBackView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

//切换账号按钮
typedef void(^DYDSDKWelcomeBackChangeUserBlock)();

@interface DYDSDKWelcomeBackView : UIView

/** 顶部的约束 */
@property (nonatomic, strong) NSLayoutConstraint *topLayoutConstraint;

+ (DYDSDKWelcomeBackView *)creatWelcomeBackViewWithVisitorName:(NSString *)visitorName avatar:(NSString *)avatar callBack:(DYDSDKWelcomeBackChangeUserBlock)callBack;

- (void)insertToWindow;

@end
