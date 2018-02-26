//
//  DYDSDKRegisterSendCodeView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/1.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKRegisterSendCodeView.h"
#import "DYDSDKMessagePopupView.h"
#import "DYDSDKCommonUICreater.h"
#import "DYDSettingHeader.h"

@interface DYDSDKRegisterSendCodeView ()

///** logo */
//@property (nonatomic, strong) UIImageView * logoIV;
///** 标题的label */
//@property (nonatomic, strong) UILabel * titleLab;
/** 电话输入框 */
@property (nonatomic, strong) UITextField *phoneTF;

@end

@implementation DYDSDKRegisterSendCodeView

+ (DYDSDKRegisterSendCodeView *)creatRegisterSendCodeView
{
    DYDSDKRegisterSendCodeView *sendCodeView = [[DYDSDKRegisterSendCodeView alloc] initWithFrame:CGRectZero];
    
    [sendCodeView constructUI];//搭建UI界面
    return sendCodeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 300, 185);
    }
    return self;
}

/** 搭建UI界面 */
- (void)constructUI
{
//    self.backgroundColor = [UIColor whiteColor];
//    self.layer.cornerRadius = 9;
//    self.layer.masksToBounds = YES;
    
    //返回按钮
    self.backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBut.frame = CGRectMake(18, 18, 26, 26);
    [self.backBut setImage:DYDImage(@"dydsdk_icon_back") forState:UIControlStateNormal];
    [self.backBut addTarget:self action:@selector(backButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backBut];
    
    /*
    //logo
    self.logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(85, 18, 88, 21)];
    self.logoIV.image = [UIImage imageNamed:@"dydsdk_logo"];
    self.logoIV.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.logoIV];
    
    //标题的显示
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoIV.frame) + 10, 18, 100, 21)];
    self.titleLab.text = @"注册";
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textColor = [UIColor colorWithRed:246 / 255.0 green:95 / 255.0 blue:109 / 255.0 alpha:1];
    [self addSubview:self.titleLab];
     */
    
    CGFloat baseViewMinY = 18 + 32 + 10;
    //输入框底板
    UIView *phoneBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, baseViewMinY, 300 - 36, 39)];
    [self addSubview:phoneBV];
    
    //电话输入框
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(18, 0, phoneBV.frame.size.width - 36, phoneBV.frame.size.height)];
    self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTF.font = [UIFont systemFontOfSize:15];
    self.phoneTF.textColor = [UIColor whiteColor];
    [phoneBV addSubview:self.phoneTF];
    
    //注册按钮
    UIButton *registerBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(phoneBV.frame) + 10, 300 - 36, 40) action:@selector(registerButAction:) title:@"获取验证码" target:self];
    [self addSubview:registerBut];
}

//点击返回按钮
- (void)backButAction:(UIButton *)sender
{
    if (self.sendCodeDelegate && [self.sendCodeDelegate respondsToSelector:@selector(sendCode_clickBackBut)]) {
        [self.sendCodeDelegate sendCode_clickBackBut];
    }
}

//点击注册按钮
- (void)registerButAction:(UIButton *)sender
{
    if (self.sendCodeDelegate && [self.sendCodeDelegate respondsToSelector:@selector(sendCode_clickSendCodeButWithPhone:)]) {
        [self.sendCodeDelegate sendCode_clickSendCodeButWithPhone:_phoneTF.text];
    }
}

@end
