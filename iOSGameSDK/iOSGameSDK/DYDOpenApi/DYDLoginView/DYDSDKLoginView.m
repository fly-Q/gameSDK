//
//  DYDSDKLoginView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKLoginView.h"
#import "DYDSDKRightImageBut.h"
#import "DYDSDKPasswordPlainButton.h"
#import "DYDSDKCommonUICreater.h"
#import "DYDSDKGeneralAlertView.h"
#import "DYDSettingHeader.h"
#define kDYDColor [UIColor colorWithRed:(246)/255.0 green:(95)/255.0 blue:(109)/255.0 alpha:1]

@interface DYDSDKLoginView ()

/** 是否安装了第一弹 */
@property (nonatomic, assign) BOOL dyd_install;
/** 当前第一弹版本是否支持游戏SDK */
@property (nonatomic, assign) BOOL dyd_isNewDYD;

//---------------- 控件 ------------------//
///** 第一弹的logo */
//@property (nonatomic, strong) UIImageView * logoIV;
///** 标题，是登陆还是升级 */
//@property (nonatomic, strong) UILabel * titleLab;
/** 手机号提示lab */
//@property (nonatomic, strong) UILabel *phoneRemindLab;
/** 密码提示lab */
//@property (nonatomic, strong) UILabel *pwRemindLab;
/** 账号输入框 */
@property (nonatomic, strong) UITextField * phoneTF;
/** 密码输入框 */
@property (nonatomic, strong) UITextField * passwordTF;
/** 注册按钮 */
@property (nonatomic, strong) UIButton *registerBut;
/** 登录按钮 */
@property (nonatomic, strong) UIButton * loginBut;
/** 明文密文切换按钮 */
@property (nonatomic, strong) DYDSDKPasswordPlainButton * plainBut;

/** 第三方的提示语label */
@property (nonatomic, strong) UILabel * thirdLoginRemindLab;
/** visitorBackIV */
@property (nonatomic, strong) UIImageView * visitorBackIV;


//-------------------- 样式上的记录 ------------------//
/** 是登陆还是升级 */
@property (nonatomic, assign) DYDSDKLoginViewType viewType;
/** 是否带有游客按钮 */
@property (nonatomic, assign) BOOL hasNoUserBut;

@end

@implementation DYDSDKLoginView

+ (DYDSDKLoginView *)creatLoginViewWithNoUserBut:(BOOL)noUserBut type:(DYDSDKLoginViewType)type
{
    DYDSDKLoginView *loginView = [[DYDSDKLoginView alloc] initWithFrame:CGRectZero];
    loginView.hasNoUserBut = noUserBut;
    loginView.viewType = type;
    switch (type) {
        case DYDSDKLoginViewLogin:
        {
            //登陆
            
        }
            break;
        case DYDSDKLoginViewUpdate:
        {
            //升级
            loginView.hasNoUserBut = NO;
        }
            break;
            
        default:
            break;
    }
    [loginView constructUI];//搭建控件
    return loginView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dyd_install = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"diyidanApp://"]];
        self.dyd_isNewDYD = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"diyidanOpenApiV1://"]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

/** 搭建UI界面 */
- (void)constructUI
{
//    self.layer.cornerRadius = 8;
//    self.layer.masksToBounds = YES;
    
    
    switch (self.viewType) {
        case DYDSDKLoginViewLogin:
            if (self.hasNoUserBut) {
                self.frame = CGRectMake(0, 0, 300, 340);
            }else{
                if (self.dyd_install) {
                    //安装了第一弹
                    self.frame = CGRectMake(0, 0, 300, 300);
                }else{
                    self.frame = CGRectMake(0, 0, 300, 280);
                }
            }
            break;
        case DYDSDKLoginViewUpdate:
            self.frame = CGRectMake(0, 0, 300, 300);
            break;
            
        default:
            break;
    }
    
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
    self.titleLab.text = self.viewType == DYDSDKLoginViewLogin ? @"登录" : @"升级";
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.textColor = [UIColor colorWithRed:246 / 255.0 green:95 / 255.0 blue:109 / 255.0 alpha:1];
    [self addSubview:self.titleLab];
     */
    
    self.closeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBut.frame = CGRectMake(self.frame.size.width - 10 - 35, 10, 35, 35);
    [self.closeBut setImage:DYDImage(@"dydsdk_closeBut") forState:UIControlStateNormal];
    [self.closeBut addTarget:self action:@selector(closeButAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBut];
    
    
    CGFloat baseViewMinY = 18 + 32 + 10;
    //创建两个输入框底板
    UIView *phoneBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, baseViewMinY, 300 - 36, 40)];
    [self addSubview:phoneBV];
    UIView *pwBV = [DYDSDKCommonUICreater creatTextFiledBaseViewWithFrame:CGRectMake(18, baseViewMinY + 40 + 10, 300 - 36, 40)];
    [self addSubview:pwBV];
    
    //手机号提示语
//    NSString *phoneRemindStr = @"手机号";
//    CGRect widthR = [phoneRemindStr boundingRectWithSize:CGSizeMake(0, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
//    self.phoneRemindLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, widthR.size.width + 1, 40)];
//    self.phoneRemindLab.font = [UIFont systemFontOfSize:15];
//    self.phoneRemindLab.text = phoneRemindStr;
//    self.phoneRemindLab.textColor = [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1.0];
//    [phoneBV addSubview:self.phoneRemindLab];
    //手机号输入框
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(phoneBV.frame) - 30, 40)];
    self.phoneTF.textColor = [UIColor whiteColor];
    self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.phoneTF.font = [UIFont systemFontOfSize:15];
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [phoneBV addSubview:self.phoneTF];
    
    //密码提示语
//    self.pwRemindLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, widthR.size.width + 1, 40)];
//    NSMutableAttributedString *pwAttrStr = [[NSMutableAttributedString alloc] initWithString:@"密    码" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1.0]}];
//    self.pwRemindLab.attributedText = pwAttrStr;
//    [pwBV addSubview:self.pwRemindLab];
    //密码输入框
    self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(phoneBV.frame) - 15 - 40, 40)];
    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码（6-18位字符）" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.passwordTF.textColor = [UIColor whiteColor];
    self.passwordTF.font = [UIFont systemFontOfSize:15];
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    [pwBV addSubview:self.passwordTF];
    
    __weak typeof(self) weakSelf = self;
    DYDSDKPasswordPlainButton *pwPlainbut = [DYDSDKPasswordPlainButton dyd_creatPasswordPlainButWithFrame:CGRectMake(CGRectGetMaxX(self.passwordTF.frame), 0, 40, CGRectGetHeight(pwBV.frame)) callBack:^(BOOL isPlain) {
        //isPlain是明文(YES)
        weakSelf.passwordTF.secureTextEntry = !isPlain;
    }];
    [pwBV addSubview:pwPlainbut];
    
    CGFloat noUserButMinY = 0;
    if (self.dyd_install && self.viewType == DYDSDKLoginViewLogin) {//安装了第一弹，升级时不允许第三方授权，必须使用手机号
        //登录注册按钮
        self.registerBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(pwBV.frame) + 10, (300 - 46) * 0.3, 39) action:@selector(registerButAction) title:@"注册" target:self];
//        self.registerBut.layer.borderColor = kDYDColor.CGColor;
//        self.registerBut.layer.borderWidth = 1;
        UIImage *registerButImg = [DYDImage(@"dydsdk_button_back_white") stretchableImageWithLeftCapWidth:15 topCapHeight:30];
        [self.registerBut setBackgroundImage:registerButImg forState:UIControlStateNormal];
        [self.registerBut setTitleColor:kDYDColor forState:UIControlStateNormal];
        
//        [self.registerBut setBackgroundImage:[DYDSDKLoginView createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [self.registerBut setBackgroundImage:[DYDSDKLoginView createImageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]] forState:UIControlStateHighlighted];
//        [self.registerBut setTitleColor:kDYDColor forState:UIControlStateNormal];
        
        self.loginBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(CGRectGetMaxX(self.registerBut.frame) + 10, CGRectGetMinY(self.registerBut.frame), (300 - 46) * 0.7, 39) action:@selector(loginButAction) title:self.viewType == DYDSDKLoginViewLogin ? @"登录" : @"绑定" target:self];
        [self addSubview:self.registerBut];
        [self addSubview:self.loginBut];
        
        UIButton *dydLoginBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(self.registerBut.frame) + 10, 300 - 36, 39) action:@selector(loginWithDYDAppAction) title:@"第一弹授权登录" target:self];
        [self addSubview:dydLoginBut];
        noUserButMinY = CGRectGetMaxY(dydLoginBut.frame);
        
        /*
        //第三方登录
        //1.提示框
        self.thirdLoginRemindLab = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 80) / 2.0, CGRectGetMaxY(self.registerBut.frame) + 20, 80, [UIFont systemFontOfSize:14].lineHeight)];
        self.thirdLoginRemindLab.textColor = [UIColor colorWithRed:128 / 255.0 green:128 / 255.0 blue:128 / 255.0 alpha:1.0];
        self.thirdLoginRemindLab.text = @"第三方登录";
        self.thirdLoginRemindLab.font = [UIFont systemFontOfSize:14];
        self.thirdLoginRemindLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.thirdLoginRemindLab];
        //两根线
        CGFloat lineW = (self.frame.size.width - self.thirdLoginRemindLab.frame.size.width) / 2.0 * 0.7;
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.thirdLoginRemindLab.frame) - lineW, CGRectGetMidY(self.thirdLoginRemindLab.frame) - 0.25, lineW, 0.5)];
        leftLine.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:240 / 255.0 alpha:1.0];
        [self addSubview:leftLine];
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.thirdLoginRemindLab.frame), leftLine.frame.origin.y, lineW, 0.5)];
        rightLine.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:240 / 255.0 alpha:1.0];
        [self addSubview:rightLine];
        
        //第三方的图标
        NSMutableArray *thirdButAry = [NSMutableArray array];
        [thirdButAry addObject:[self creatThirdLoginButWithIcon:@"dydsdk_qqLogin_normal" selectIcon:@"dydsdk_qqLogin_highlight" action:@selector(qq_loginAction)]];
        if (self.wechat_install) {
            //安装了微信
            [thirdButAry addObject:[self creatThirdLoginButWithIcon:@"dydsdk_wechatLogin_normal" selectIcon:@"dydsdk_wechatLogin_highlight" action:@selector(wechat_loginAction)]];
        }
        [thirdButAry addObject:[self creatThirdLoginButWithIcon:@"dydsdk_sinaLogin_normal" selectIcon:@"dydsdk_sinaLogin_highlight" action:@selector(sina_loginAction)]];
        CGFloat leftX = (self.frame.size.width - (thirdButAry.count *2 - 1) *35) / 2.0;
        CGFloat minY = CGRectGetMaxY(self.thirdLoginRemindLab.frame) + 12;
        for (int i = 0; i < thirdButAry.count; i++) {
            UIButton *but = [thirdButAry objectAtIndex:i];
            but.frame = CGRectMake(leftX + i *70, minY, 35, 35);
            if (i == 0) {
                noUserButMinY = CGRectGetMaxY(but.frame);
            }
        }
         */
        
    }else{
        //未安装第一弹
        UIButton *loginBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(pwBV.frame) + 12, self.frame.size.width - 36, 39) action:@selector(loginButAction) title:self.viewType == DYDSDKLoginViewLogin ? @"登录" : @"绑定" target:self];
        UIButton *registerBut = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(loginBut.frame) + 12, self.frame.size.width - 36, 39) action:@selector(registerButAction) title:@"注册" target:self];
        [self addSubview:loginBut];
        [self addSubview:registerBut];
        
//        registerBut.layer.borderColor = kDYDColor.CGColor;
//        registerBut.layer.borderWidth = 1;
        UIImage *registerButImg = [DYDImage(@"dydsdk_button_back_white") stretchableImageWithLeftCapWidth:15 topCapHeight:30];
        [registerBut setBackgroundImage:registerButImg forState:UIControlStateNormal];
        [registerBut setTitleColor:kDYDColor forState:UIControlStateNormal];
        
        noUserButMinY = CGRectGetMaxY(registerBut.frame);
    }
    
    if (self.hasNoUserBut) {
        self.visitorBackIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300 - 34.5, 153.5, 34.5)];
        self.visitorBackIV.image = DYDImage(@"dydsdk_visitorBut_back");
        [self addSubview:_visitorBackIV];
        
//        UIButton *noUserBut = [UIButton buttonWithType:UIButtonTypeCustom];
//        noUserBut.frame = CGRectMake(0, 300 - 34.5, self.frame.size.width *0.5, 34.5);
//        [noUserBut setTitle:@"游客登录" forState:UIControlStateNormal];
//        noUserBut.titleLabel.font = [UIFont systemFontOfSize:15];
//        [noUserBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [noUserBut addTarget:self action:@selector(noUserButAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:noUserBut];
        
//        UIButton *getPasswordBut = [self creatNoUserLoginButWithFrame:CGRectMake(self.frame.size.width *0.5, CGRectGetMinY(noUserBut.frame), self.frame.size.width *0.5, CGRectGetHeight(noUserBut.frame)) title:@"找回密码" action:@selector(getPasswordAction)];
        UIButton *getPasswordBut = [self creatNoUserLoginButWithFrame:CGRectMake(self.frame.size.width *0.5, 300 - 34.5, self.frame.size.width *0.5, 34.5) title:@"找回密码" action:@selector(getPasswordAction)];
        [self addSubview:getPasswordBut];
        self.frame = CGRectMake(0, 0, 300, CGRectGetMaxY(getPasswordBut.frame));
        
    }else{
        self.frame = CGRectMake(0, 0, 300, noUserButMinY + 18);
    }
}

/** 创建游客登录找回密码按钮 */
- (UIButton *)creatNoUserLoginButWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action
{
    DYDSDKRightImageBut *but = [DYDSDKRightImageBut buttonWithType:UIButtonTypeCustom];
    but.butTitle = title;
    but.frame = frame;
    [but setTitle:title forState:UIControlStateNormal];
    [but setImage:DYDImage(@"dydsdk_rightArrow") forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:15];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return but;
}

- (UIButton *)creatThirdLoginButWithIcon:(NSString *)icon selectIcon:(NSString *)selectIcon action:(SEL)action
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but setImage:DYDImage(icon) forState:UIControlStateNormal];
    [but setImage:DYDImage(selectIcon) forState:UIControlStateHighlighted];
    but.frame = CGRectMake(0, 0, 35, 35);
    [but addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    but.layer.cornerRadius = 35 *0.5;
    but.layer.masksToBounds = YES;
    [self addSubview:but];
    return but;
}

#pragma mark - Action

/** 返回按钮的点击事件 */
- (void)backButAction:(UIButton *)sender
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickBackBut)]) {
        [self.clickDelegate loginView_clickBackBut];
    }
}

/** 点击游客登录 */
- (void)noUserButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickVisitorLoginBut)]) {
        [self.clickDelegate loginView_clickVisitorLoginBut];
    }
}

/** 点击了找回密码 */
- (void)getPasswordAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickGetBackPasswordBut)]) {
        [self.clickDelegate loginView_clickGetBackPasswordBut];
    }
}

/** 点击注册按钮 */
- (void)registerButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickRegisterViewWithLoginViewtype:)]) {
        [self.clickDelegate loginView_clickRegisterViewWithLoginViewtype:self.viewType];
    }
}

/** 点击登录按钮 */
- (void)loginButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_ClickLohinButWithPhone:password:type:)]) {
        [self.clickDelegate loginView_ClickLohinButWithPhone:self.phoneTF.text password:self.passwordTF.text type:self.viewType];
    }
}

/** 点击QQ登录 */
- (void)qq_loginAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickQQLoginBut)]) {
        [self.clickDelegate loginView_clickQQLoginBut];
    }
}

/** 点击微信登录 */
- (void)wechat_loginAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickWechatLoginBut)]) {
        [self.clickDelegate loginView_clickWechatLoginBut];
    }
}

/** 点击微博登录 */
- (void)sina_loginAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickSinaLoginBut)]) {
        [self.clickDelegate loginView_clickSinaLoginBut];
    }
}

/** 点击关闭按钮 */
- (void)closeButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickCloseBut)]) {
        [self.clickDelegate loginView_clickCloseBut];
    }
}

/** 点击检测登录（跳转第一弹客户端登录） */
- (void)loginWithDYDAppAction
{
    self.dyd_install = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"diyidanApp://"]];
    self.dyd_isNewDYD = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"diyidanOpenApiV1://"]];
    if (self.dyd_isNewDYD) {//是新版本的第一弹，直接打开第一弹授权
        if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(loginView_clickDYDAppLoginBut)]) {
            [self.clickDelegate loginView_clickDYDAppLoginBut];
        }
    }else{
        //弹出提示下载最新版第一弹
        DYDSDKGeneralAlertView *alert = [DYDSDKGeneralAlertView creatSDKGeneralAlertVieiwWithMessage:@"请下载最新版第一弹进行登录。" callBack:^(NSInteger index) {
            switch (index) {
                case 0:
                {
                    //点击了取消
                    
                }
                    break;
                case 1:
                {
                    //点击了确定，跳转appStore
                    NSString *appid = @"983337376";
                    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
                    NSURL *url = [NSURL URLWithString:str];
                    [[UIApplication sharedApplication] openURL:url];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [alert alertView_setupBut1:@"取消" but2:@"去下载"];
        [alert show];
    }
    
}

@end
