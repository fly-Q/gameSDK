//
//  DYDSDKSettingPasswordView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKSettingPasswordView.h"
#import "DYDSDKPasswordPlainButton.h"
#import "DYDSettingHeader.h"
#import "DYDSDKGetCodeBut.h"
#import "DYDSDKLoginBaseView.h"
#import "DYDSDKMessagePopupView.h"
#import "DYDSDKCommonUICreater.h"
#import "DYDSDKDataRequstTool.h"

@interface DYDSDKSettingPasswordView ()<UITextFieldDelegate>

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

@end

@implementation DYDSDKSettingPasswordView

+ (DYDSDKSettingPasswordView *)creatSettingPasswordView
{
    DYDSDKSettingPasswordView *pwView = [[DYDSDKSettingPasswordView alloc] initWithFrame:CGRectZero];
    
    [pwView constructUI];
    
    return pwView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 9;
//        self.layer.masksToBounds = YES;
        self.frame = CGRectMake(0, 0, 300, 285);
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
    self.logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(75, 18, 88, 21)];
    self.logoIV.image = [UIImage imageNamed:@"dydsdk_logo"];
    self.logoIV.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.logoIV];
    
    //标题的显示
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoIV.frame) + 10, 18, 100, 21)];
    self.titleLab.text = @"修改密码";
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textColor = [UIColor colorWithRed:246 / 255.0 green:95 / 255.0 blue:109 / 255.0 alpha:1];
    [self addSubview:self.titleLab];
    */
    
    //创建仨输入框的底板
    //验证码的输入框底板
    CGFloat baseViewMinY = 18 + 32 + 10;
    UIView *codeBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, baseViewMinY, self.frame.size.width - 36, 39)];
    [self addSubview:codeBV];
    //昵称的底板
    UIView *nickNameBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, CGRectGetMaxY(codeBV.frame) + 12, self.frame.size.width - 36, 39)];
    [self addSubview:nickNameBV];
    //密码的底板
    UIView *passwordBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, CGRectGetMaxY(nickNameBV.frame) + 12, self.frame.size.width - 36, 39)];
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
        [DYDSDKDataRequstTool sdk_getPhoneCodeWithType:@"resetpass" phone:self.codeTF.text success:^{
            
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
    
    UIButton *registerBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(passwordBV.frame) + 16, self.frame.size.width - 36, 40) action:@selector(registerButAction) title:@"确定" target:self];
    [self addSubview:registerBut];
}


- (void)backButAction:(UIButton *)sender
{
    if (self.settingPWDelegate && [self.settingPWDelegate respondsToSelector:@selector(settingPassword_clickBackBut)]) {
        [self.settingPWDelegate settingPassword_clickBackBut];
    }
}

//点击确定修改按钮
- (void)registerButAction
{
    if (![DYDSDKLoginBaseView judgeIsMobiePhoneNumberWithPhoneString:self.codeTF.text]) {
        //非手机号码
        [DYDSDKMessagePopupView dydsdk_showMessage:@"手机号码不合法!" center:CGPointZero inView:nil];
        return;
    }
    if (self.nickNameTF.text.length != 6) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"请输入正确的验证码!" center:CGPointZero inView:nil];
        return;
    }
    if (self.passwordTF.text.length < 6) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"密码不能小于6位!" center:CGPointZero inView:nil];
        return;
    }
    
    if (self.settingPWDelegate && [self.settingPWDelegate respondsToSelector:@selector(settingPassword_clickRegisterButWithPhoneNum:seccode:password:)]) {
        [self.settingPWDelegate settingPassword_clickRegisterButWithPhoneNum:self.codeTF.text seccode:self.nickNameTF.text password:self.passwordTF.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

@end
