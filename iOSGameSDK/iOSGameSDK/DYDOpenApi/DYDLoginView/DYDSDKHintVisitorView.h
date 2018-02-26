//
//  DYDSDKHintVisitorView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKBackBaseView.h"

@protocol DYDSDKHintVisitorViewDelegate <NSObject>

//点击切换账号
- (void)hintVositorView_clickChangeAccountBut;
//点击进入按钮
- (void)hintVositorView_clickComeinBut;
//点击马上升级
- (void)hintVositorView_clickAcountUpdateBut;
//点击关闭按钮
- (void)hintVositorView_clickCloseBut;

@end

@interface DYDSDKHintVisitorView : DYDSDKBackBaseView

+ (DYDSDKHintVisitorView *)creatHintVisitorViewWithVisitorName:(NSString *)visitorName;

/** 点击回调代理 */
@property (nonatomic, weak) id<DYDSDKHintVisitorViewDelegate> clickDelegate;

@end
