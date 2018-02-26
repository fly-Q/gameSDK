//
//  DYDSDKBindVisitorView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/22.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKBindVisitorView.h"
#import "DYDSDKGetCodeBut.h"
#import "DYDSDKLoginBaseView.h"
#import "DYDSDKMessagePopupView.h"
#import "DYDSDKPasswordPlainButton.h"
#import "DYDSettingHeader.h"
#import "DYDSDKCommonUICreater.h"
#import "DYDSDKDataRequstTool.h"

@interface DYDSDKBindVisitorView ()<UITextFieldDelegate>

///** logo */
//@property (nonatomic, strong) UIImageView * logoIV;
///** 显示的标题 */
//@property (nonatomic, strong) UILabel * titleLab;
/** 验证码输入框 */
@property (nonatomic, strong) UITextField * codeTF;
/** 昵称输入框 */
@property (nonatomic, strong) UITextField * nickNameTF;
/** 密码输入框 */
@property (nonatomic, strong) UITextField * passwordTF;
/** <#注释#> */
@property (nonatomic, strong) UIButton * registerProtocolSelectBut;

@end

@implementation DYDSDKBindVisitorView

+ (DYDSDKBindVisitorView *)creatBindVisitorViewWithDelegate:(id<DYDSDKBindVisitorViewDelegate>)delegate
{
    DYDSDKBindVisitorView *updateView = [[DYDSDKBindVisitorView alloc] initWithFrame:CGRectZero];
    updateView.clickDelegate = delegate;
    [updateView constructUI];
    return updateView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 9;
//        self.layer.masksToBounds = YES;
        self.frame = CGRectMake(0, 0, 300, 301);
    }
    return self;
}

/** 搭建UI界面 */
- (void)constructUI
{
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
    self.titleLab.text = @"升级";
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textColor = [UIColor colorWithRed:246 / 255.0 green:95 / 255.0 blue:109 / 255.0 alpha:1];
    [self addSubview:self.titleLab];
     */
    
    CGFloat baseViewMinY = 18 + 32 + 10;
    //创建仨输入框的底板
    //验证码的输入框底板
    UIView *codeBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, baseViewMinY, self.frame.size.width - 36, 39)];
    [self addSubview:codeBV];
    //昵称的底板
    UIView *nickNameBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, CGRectGetMaxY(codeBV.frame) + 7, self.frame.size.width - 36, 39)];
    [self addSubview:nickNameBV];
    //密码的底板
    UIView *passwordBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, CGRectGetMaxY(nickNameBV.frame) + 7, self.frame.size.width - 36, 39)];
    [self addSubview:passwordBV];
    
    //验证码输入框
    self.codeTF = [DYDSDKCommonUICreater creatTextFiledWithFrame:CGRectMake(15, 0, codeBV.frame.size.width - 15 - 80, codeBV.frame.size.height) placeholder:@"手机号" delegate:self];
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [codeBV addSubview:self.codeTF];
    //昵称
    self.nickNameTF = [DYDSDKCommonUICreater creatTextFiledWithFrame:CGRectMake(15, 0, codeBV.frame.size.width - 15 - 80, codeBV.frame.size.height) placeholder:@"验证码" delegate:self];
    self.nickNameTF.keyboardType = UIKeyboardTypeNumberPad;
    [nickNameBV addSubview:self.nickNameTF];
    DYDSDKGetCodeBut *getCodeBut = [DYDSDKGetCodeBut dyd_creatGetCodeButWithFrame:CGRectMake(10 + CGRectGetMaxX(self.nickNameTF.frame), 6, 60, CGRectGetHeight(nickNameBV.frame) - 12) callBack:^BOOL{
        
        //点击获取验证码
        if (![DYDSDKLoginBaseView judgeIsMobiePhoneNumberWithPhoneString:self.codeTF.text]) {
            //非手机号码
            [DYDSDKMessagePopupView dydsdk_showMessage:@"手机号码不合法!" center:CGPointZero inView:nil];
            return NO;
        }
        //发送验证码
        [DYDSDKDataRequstTool sdk_getPhoneCodeWithType:@"registerBindPhone" phone:self.codeTF.text success:^{
            
        } failure:^{
            
        }];
        return YES;
    }];
    [nickNameBV addSubview:getCodeBut];
    
    //密码
    self.passwordTF = [DYDSDKCommonUICreater creatTextFiledWithFrame:CGRectMake(15, 0, codeBV.frame.size.width - 40 - 15, codeBV.frame.size.height) placeholder:@"密码（6-18位字符）" delegate:self];
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    [passwordBV addSubview:self.passwordTF];
    
    __weak typeof(self) weakSelf = self;
    DYDSDKPasswordPlainButton *plainBut = [DYDSDKPasswordPlainButton dyd_creatPasswordPlainButWithFrame:CGRectMake(CGRectGetMaxX(self.passwordTF.frame), 0, 40, CGRectGetHeight(passwordBV.frame)) callBack:^(BOOL isPlain) {
        weakSelf.passwordTF.secureTextEntry = !isPlain;
    }];
    [passwordBV addSubview:plainBut];
    
    //会员协议和按钮
    self.registerProtocolSelectBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerProtocolSelectBut.frame = CGRectMake(25, CGRectGetMaxY(passwordBV.frame) + 15, 20, 20);
    [self.registerProtocolSelectBut setImage:DYDImage(@"dydsdk_registerProtocol_noemal") forState:UIControlStateNormal];
    [self.registerProtocolSelectBut setImage:DYDImage(@"dydsdk_registerProtocol_select") forState:UIControlStateSelected];
    [self.registerProtocolSelectBut addTarget:self action:@selector(selectRegisterProtocolAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.registerProtocolSelectBut];
    
    //提示阅读同意会员协议
    CGFloat agreeLabH = [UIFont systemFontOfSize:13].lineHeight;
    UILabel *agreeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.registerProtocolSelectBut.frame), CGRectGetMinY(self.registerProtocolSelectBut.frame) + (20 - agreeLabH) *0.5, 80, agreeLabH)];
    agreeLab.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1.0];
    agreeLab.text = @"已阅读并同意";
    agreeLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:agreeLab];
    
    //开始阅读会员协议的按钮
    UIButton *readRegisterProtocolBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [readRegisterProtocolBut setTitle:@"《会员注册协议》" forState:UIControlStateNormal];
    [readRegisterProtocolBut addTarget:self action:@selector(readProtocolAction) forControlEvents:UIControlEventTouchUpInside];
    [readRegisterProtocolBut setTitleColor:kDYDColor forState:UIControlStateNormal];
    readRegisterProtocolBut.frame = CGRectMake(CGRectGetMaxX(agreeLab.frame) + 5, CGRectGetMinY(agreeLab.frame), 120, CGRectGetHeight(agreeLab.frame));
    readRegisterProtocolBut.titleLabel.font = [UIFont systemFontOfSize:13];
    readRegisterProtocolBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:readRegisterProtocolBut];
    
    UIButton *registerBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(self.registerProtocolSelectBut.frame) + 10, self.frame.size.width - 36, 40) action:@selector(registerButAction) title:@"确定" target:self];
    [self addSubview:registerBut];
}

- (void)readProtocolAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://app.diyidan.net/register.html"]];
}


- (void)backButAction:(UIButton *)sender
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(bindVisitorView_clickBackBut)]) {
        [self.clickDelegate bindVisitorView_clickBackBut];
    }
}

//点击确定修改按钮
- (void)registerButAction
{
    if (self.registerProtocolSelectBut.isSelected == NO) {
        //没有勾选会员注册协议
        [DYDSDKMessagePopupView dydsdk_showMessage:@"请阅读并同意《会员注册协议》" center:CGPointZero inView:nil];
        return;
    }
    
    if (![DYDSDKLoginBaseView judgeIsMobiePhoneNumberWithPhoneString:self.codeTF.text]) {
        //非手机号码
        [DYDSDKMessagePopupView dydsdk_showMessage:@"手机号码不合法!" center:CGPointZero inView:nil];
        return;
    }
    if (self.nickNameTF.text.length != 6) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"请输入正确的验证码!" center:CGPointZero inView:nil];
        return;
    }
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 18) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"密码长度建议在6到18位之间噢(^_^)" center:CGPointZero inView:nil];
        return;
    }
    
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(bindVisitorView_clickDonebutWithPhone:smsCode:password:)]) {
        [self.clickDelegate bindVisitorView_clickDonebutWithPhone:self.codeTF.text smsCode:self.nickNameTF.text password:self.passwordTF.text];
    }
    
}

//点击阅读会员注册协议
- (void)selectRegisterProtocolAction
{
    self.registerProtocolSelectBut.selected = !self.registerProtocolSelectBut.isSelected;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}


@end
