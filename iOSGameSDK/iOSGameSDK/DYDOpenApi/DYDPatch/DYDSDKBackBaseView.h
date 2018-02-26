//
//  DYDSDKBackBaseView.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYDSDKBackBaseViewDelegate <NSObject>

//baseView的关闭按钮点击
- (void)baseView_clickCloseBut;

@end

@interface DYDSDKBackBaseView : UIView

/** 返回按钮 */
@property (nonatomic, strong) UIButton * backBut;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton * closeBut;

/** 堆栈的下标(控制返回按钮的显示) */
@property (nonatomic, assign) NSInteger viewIndex;

/** 背景图标 */
@property (nonatomic, strong) UIImageView * backgroundIV;

/** logo */
@property (nonatomic, strong) UIImageView * logoBaseIV;

/** 父类的视图点击回调代理 */
@property (nonatomic, weak) id<DYDSDKBackBaseViewDelegate> baseViewDelegate;

@end
