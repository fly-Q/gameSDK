//
//  DYDSDKRegisterSendCodeView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/1.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYDSDKBackBaseView.h"

@protocol DYDSDKRegisterSendCodeViewDelegate <NSObject>

//点击返回按钮
- (void)sendCode_clickBackBut;
//点击获取验证码
- (void)sendCode_clickSendCodeButWithPhone:(NSString *)phone;

@end

@interface DYDSDKRegisterSendCodeView : DYDSDKBackBaseView

+ (DYDSDKRegisterSendCodeView *)creatRegisterSendCodeView;

/** 点击回调 */
@property (nonatomic, weak) id<DYDSDKRegisterSendCodeViewDelegate> sendCodeDelegate;

@end
