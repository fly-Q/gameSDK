//
//  DYDSDKGeneralAlertView.m
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/5.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKGeneralAlertView.h"
#import "DYDSettingHeader.h"

@interface DYDSDKGeneralAlertView ()

/** 背景图片 */
@property (nonatomic, strong) UIImageView *backgroundIV;
/** 关闭按钮，点击等同于点击取消按钮 */
@property (nonatomic, strong) UIButton * closeBut;
/** 显示的信息的Label */
@property (nonatomic, strong) UILabel *messageLab;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBut;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *doneBut;
/** logo显示 */
@property (nonatomic, strong) UIImageView *logoBaseIV;

/** 回调 */
@property (nonatomic, copy) void(^alertCallBack)(NSInteger index);
/** 基板 */
@property (nonatomic, weak) UIView * baseView;
/** 显示的信息 */
@property (nonatomic, copy) NSString *message;

@end

@implementation DYDSDKGeneralAlertView

+ (DYDSDKGeneralAlertView *)creatSDKGeneralAlertVieiwWithMessage:(NSString *)message callBack:(void(^)(NSInteger index))callBack
{
    DYDSDKGeneralAlertView *alert = [[DYDSDKGeneralAlertView alloc] initWithFrame:CGRectZero];
    alert.alertCallBack = callBack;
    alert.message = message;
    alert.messageLab.text = message;
    return alert;
}

- (void)alertView_setupBut1:(NSString *)but1 but2:(NSString *)but2
{
    [self.cancelBut setTitle:but1 forState:UIControlStateNormal];
    [self.doneBut setTitle:but2 forState:UIControlStateNormal];
}

//视图消失
- (void)dismiss
{
    [self.baseView removeFromSuperview];
    [self removeFromSuperview];
}

//显示视图
- (void)show
{
    //获取根窗口
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *baseView = [[UIView alloc] initWithFrame:window.bounds];
    baseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [window addSubview:baseView];
    baseView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [window addConstraint:[NSLayoutConstraint constraintWithItem:baseView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:window
                                                       attribute:NSLayoutAttributeTop
                                                      multiplier:1
                                                        constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:baseView
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:window
                                                       attribute:NSLayoutAttributeLeft
                                                      multiplier:1
                                                        constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:baseView
                                                       attribute:NSLayoutAttributeBottom
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:window
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1
                                                        constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:baseView
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:window
                                                       attribute:NSLayoutAttributeRight
                                                      multiplier:1
                                                        constant:0]];
    
    self.baseView = baseView;//弱指针
    //将alert添加在baseView上
    [baseView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [baseView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:baseView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    [baseView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:baseView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
    [baseView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:296]];
    [baseView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:185]];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 296, 185);
        self.backgroundIV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundIV.image = DYDImage(@"dydsdk_alert_back");
        [self addSubview:self.backgroundIV];
        
        self.logoBaseIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.logoBaseIV.image = DYDImage(@"dydsdk_logo");
        [self addSubview:self.logoBaseIV];
        self.logoBaseIV.frame = CGRectMake((296 - 97) *0.5, 18, 97, 32);
        
        self.closeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBut.frame = CGRectMake(self.frame.size.width - 10 - 35, 10, 35, 35);
        [self.closeBut setImage:DYDImage(@"dydsdk_closeBut") forState:UIControlStateNormal];
        [self.closeBut addTarget:self action:@selector(closeButAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBut];
        
        //显示内容
        CGFloat mesX = 15;
        CGFloat mesY = 55;
        CGFloat mesBottom = 50;
        CGFloat mesW = CGRectGetWidth(self.frame) - mesX *2;
        CGFloat mesH = CGRectGetHeight(self.frame) - mesY - mesBottom;
        
        self.messageLab = [[UILabel alloc] initWithFrame:CGRectMake(mesX, mesY, mesW, mesH)];
        self.messageLab.textColor = [UIColor whiteColor];
        self.messageLab.font = [UIFont systemFontOfSize:14];
        self.messageLab.textAlignment = NSTextAlignmentCenter;
        self.messageLab.numberOfLines = 0;
        [self addSubview:self.messageLab];
        
        
        //两个按钮
        //取消按钮
        self.cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBut.frame = CGRectMake(0, CGRectGetHeight(self.frame) *151.5 / 185, CGRectGetWidth(self.frame) *0.5, 31.5);
        [self.cancelBut setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.cancelBut addTarget:self action:@selector(cancelButAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBut];
        
        //确定按钮
        self.doneBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneBut.frame = CGRectMake(CGRectGetMaxX(self.cancelBut.frame), CGRectGetHeight(self.frame) *151.5 / 185, CGRectGetWidth(self.frame) *0.5, 31.5);
        [self.doneBut setTitle:@"确定" forState:UIControlStateNormal];
        [self.doneBut setTitleColor:[UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        self.doneBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.doneBut addTarget:self action:@selector(doneButAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneBut];
    }
    return self;
}


#pragma mark - Action
//点击了取消按钮
- (void)cancelButAction
{
    //当视图移除，回调点击事件
    [self dismiss];
    if (self.alertCallBack) {
        self.alertCallBack(0);
    }
}

//点击了确定按钮
- (void)doneButAction
{
    //移除视图，回调点击事件
    [self dismiss];
    if (self.alertCallBack) {
        self.alertCallBack(1);
    }
}

//点击了关闭按钮
- (void)closeButAction
{
    //等同于点击取消按钮
    [self dismiss];
    if (self.alertCallBack) {
        self.alertCallBack(0);
    }
}
- (void)dealloc
{
    NSLog(@"%@, dealloc", self.class);
}

@end
