//
//  DYDSDKRegisterView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/1.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKBackBaseView.h"


@protocol DYDSDKRegisterViewDelegate <NSObject>

//点击返回按钮
- (void)registerView_clickBackBut;
//点击注册按钮
- (void)registerView_clickRegisterButWithSeccode:(NSString *)seccode nickName:(NSString *)nickName password:(NSString *)password phone:(NSString *)phone;

@end

@interface DYDSDKRegisterView : DYDSDKBackBaseView

+ (DYDSDKRegisterView *)creatSDKRegsterView;

/** 填上去的电话号码 */
@property (nonatomic, copy) NSString * phoneNumStr;

//点击回调代理
@property (nonatomic, weak) id<DYDSDKRegisterViewDelegate> registerDelegate;

@end
