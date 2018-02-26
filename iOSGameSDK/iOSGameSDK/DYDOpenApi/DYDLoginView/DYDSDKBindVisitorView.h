//
//  DYDSDKBindVisitorView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/22.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKBackBaseView.h"

@protocol DYDSDKBindVisitorViewDelegate <NSObject>

//升级账号页面点击确定按钮
- (void)bindVisitorView_clickDonebutWithPhone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password;
//点击返回按钮
- (void)bindVisitorView_clickBackBut;

@end

@interface DYDSDKBindVisitorView : DYDSDKBackBaseView

+ (DYDSDKBindVisitorView *)creatBindVisitorViewWithDelegate:(id<DYDSDKBindVisitorViewDelegate>)delegate;

/** 回调代理 */
@property (nonatomic, weak) id<DYDSDKBindVisitorViewDelegate> clickDelegate;

@end
