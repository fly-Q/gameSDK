//
//  DYDSDKLoginBaseView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKLoginBaseView.h"
#import "DYDSDKLoginView.h"
#import "DYDSDKRegisterSendCodeView.h"
#import "DYDSDKRegisterView.h"
#import "DYDSDKSettingPasswordView.h"
#import "DYDSDKHintVisitorView.h"
#import "DYDSDKBackBaseView.h"
#import "DYDSDKNetworkTool.h"
#import "DYDSDKUserEntity.h"
#import "DYDSDKMessagePopupView.h"
#import "DYDDataManager.h"
#import "DYDSDKBindVisitorView.h"
#import "DYDDBManager.h"
#import "DYDLoginHeader.h"
#import "DYDSettingHeader.h"
#import "DYDSDKLookFriendsView.h"
#import "DYDSDKDataRequstTool.h"

@interface DYDSDKLoginBaseView ()<DYDSDKLoginViewDelegate, DYDSDKRegisterSendCodeViewDelegate, DYDSDKRegisterViewDelegate, DYDSDKSettingPasswordViewDelegate, DYDSDKHintVisitorViewDelegate, DYDSDKBindVisitorViewDelegate, DYDSDKBackBaseViewDelegate>

/** 视图堆栈 */
@property (nonatomic, strong) NSMutableArray * viewAryM;
/** 当前显示的视图 */
//@property (nonatomic, strong) DYDSDKBackBaseView * currntView;

/** 标记样式（登录、升级） */
@property (nonatomic, assign) DYDSDKShowViewType showViewType;

@end

@implementation DYDSDKLoginBaseView

+ (DYDSDKLoginBaseView *)creatSDKLoginBaseViewWithFrame:(CGRect)frame
{
    DYDSDKLoginBaseView *baseView = [[DYDSDKLoginBaseView alloc] initWithFrame:frame];
    return baseView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baseViewTapAction)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdk_diyidanAppLoginSuccessEvent:) name:DYDAppLoginSuccessNotificate object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@, dealloc", self.class);
}

//第一弹客户端授权登录成功通知
- (void)sdk_diyidanAppLoginSuccessEvent:(NSNotification *)noti
{
    DYDSDKUserEntity *userE = noti.object;
    if (userE == nil) {
        return;
    }
    //用户信息存在
    [DYDDataManager shareDYDDataManager].loginUser = userE;
    //保存到本地
    [DYDDBManager insertUsersTable:userE];
    
    
    //如果有监听代理，回调
    
    //出口-登录成功
    if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
        if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
            [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:DYDSDKLoginResultSuccess userE:userE];
        }else{
            NSLog(@"未实现登录代理回调方法");
        }
    }
    
    //显示悬浮球
    //                    [DYDLoginHeader dyd_showSuspensionBut];
    
    //登陆成功
    [self removeFromSuperview];
}

- (void)baseViewTapAction
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window endEditing:YES];
}

- (void)showWithType:(DYDSDKShowViewType)type
{
    //显示之前把以前的移除
    if ([DYDDataManager shareDYDDataManager].lastBaseView) {
        if ([DYDDataManager shareDYDDataManager].lastBaseView.superview) {
            //存在父视图
            [[DYDDataManager shareDYDDataManager].lastBaseView removeFromSuperview];
        }
        [DYDDataManager shareDYDDataManager].lastBaseView = nil;
    }
    self.showViewType = type;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [DYDDataManager shareDYDDataManager].lastBaseView = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    switch (type) {
        case DYDSDKShowViewTypeLogin:
        {
            //登录页面
            DYDSDKLoginView *loginView = [DYDSDKLoginView creatLoginViewWithNoUserBut:YES type:DYDSDKLoginViewLogin];
            loginView.clickDelegate = self;
            
            [self pushView:loginView];
        }
            break;
        case DYDSDKShowViewTypeAccountUpdate:
        {
            //账号升级
            DYDSDKHintVisitorView *hintVisitorView = [DYDSDKHintVisitorView creatHintVisitorViewWithVisitorName:[DYDDataManager shareDYDDataManager].loginUser.nickName];
            hintVisitorView.clickDelegate = self;
            [self pushView:hintVisitorView];
            
            
//            DYDSDKLoginView *loginView = [DYDSDKLoginView creatLoginViewWithNoUserBut:YES type:DYDSDKLoginViewUpdate];
//            loginView.clickDelegate = self;
//            
//            [self pushView:loginView];
        }
            break;
        case DYDSDKShowViewTypeBindAccount:
        {
            //账号升级
            //升级账号的页面
            DYDSDKLoginView *updateView = [DYDSDKLoginView creatLoginViewWithNoUserBut:NO type:DYDSDKLoginViewUpdate];
            updateView.clickDelegate = self;
            [self pushView:updateView];
        }
            break;
        case DYDSDKShowViewTypeChangAccount:
        {
            //切换账号
            //切换到登录界面
            DYDSDKLoginView *loginView = [DYDSDKLoginView creatLoginViewWithNoUserBut:NO type:DYDSDKLoginViewLogin];
            loginView.clickDelegate = self;
            [self pushView:loginView];
        }
            break;
        case DYDSDKShowViewTypeModifyPassW:
        {
            //修改密码
            DYDSDKSettingPasswordView *getPW = [DYDSDKSettingPasswordView creatSettingPasswordView];
            getPW.settingPWDelegate = self;
            [self pushView:getPW];
        }
            break;
        case DYDSDKShowViewTypeLookFriends:
        {
            //查看弹友
            DYDSDKLookFriendsView *lookFriends = [DYDSDKLookFriendsView creatSDKLookFriendsView];
            [self pushView:lookFriends];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.viewAryM) {//其实应该找到最后一个，但是这样逻辑更简单
        view.center = self.center;
    }
}


- (void)pushView:(DYDSDKBackBaseView *)view
{
    if (self.viewAryM.count > 0) {//首先把上一个视图从视图上移除
        UIView *view = [self.viewAryM lastObject];
        [view removeFromSuperview];
    }
    view.transform = CGAffineTransformMakeScale([DYDDataManager shareDYDDataManager].viewScale, [DYDDataManager shareDYDDataManager].viewScale);
    [self addSubview:view];
    NSInteger viewIndex = self.viewAryM.count;
    view.viewIndex = viewIndex;
    if ([view isKindOfClass:[DYDSDKBackBaseView class]]) {
        view.baseViewDelegate = self;
    }
    
    [self.viewAryM addObject:view];
}

- (void)popView
{
    UIView *lastView = [self.viewAryM lastObject];//上一个视图
    [lastView removeFromSuperview];
    [self.viewAryM removeLastObject];//移除最后一个视图
    DYDSDKBackBaseView *view = [self.viewAryM lastObject];
    [self addSubview:view];
    view.viewIndex = self.viewAryM.count - 1;//已在数组中
    
    if (self.viewAryM.count == 0) {
        //最后一个也没有了
        [self removeFromSuperview];
    }
}

- (void)popViewCount:(NSInteger)viewCount
{
    for (int i = 0; i < viewCount; i++) {
        [self popView];
    }
}

#pragma mark - 逻辑区 <所有页面的逻辑在此处理，集中复用>

#pragma mark - Delegate
#pragma mark -
#pragma mark DYDSDKLoginViewDelegate
/** 点击返回按钮 */
- (void)loginView_clickBackBut
{
    [self popView];
}

/** 点击注册按钮 */
- (void)loginView_clickRegisterViewWithLoginViewtype:(DYDSDKLoginViewType)type
{
    switch (type) {
        case DYDSDKLoginViewLogin:
        {
            //登录
            DYDSDKRegisterSendCodeView *view = [DYDSDKRegisterSendCodeView creatRegisterSendCodeView];
            view.sendCodeDelegate = self;
            [self pushView:view];
        }
            break;
        case DYDSDKLoginViewUpdate:
        {
            //升级账号
            DYDSDKBindVisitorView *updateVisitorView = [DYDSDKBindVisitorView creatBindVisitorViewWithDelegate:self];
            [self pushView:updateVisitorView];
        }
            break;
            
        default:
            break;
    }
}

/** 点击登录按钮 */
- (void)loginView_ClickLohinButWithPhone:(NSString *)phone password:(NSString *)password type:(DYDSDKLoginViewType)type
{
    if (![DYDSDKLoginBaseView judgeIsMobiePhoneNumberWithPhoneString:phone]) {
        //非正确的手机号
        NSLog(@"手机号不符合规范");
        [DYDSDKMessagePopupView dydsdk_showMessage:@"手机号不正确" center:CGPointZero inView:nil];
        return;
    }
    if (password.length == 0) {
        NSLog(@"密码输入不正确");
        [DYDSDKMessagePopupView dydsdk_showMessage:@"密码输入不正确" center:CGPointZero inView:nil];
        return ;
    }
    
    //登录和升级要区分
    switch (type) {
        case DYDSDKLoginViewLogin:
        {
            //登录
            [DYDSDKDataRequstTool sdk_loginWithPhone:phone password:password loginSuccess:^(DYDSDKUserEntity *user) {
                if (user) {
                    //用户信息存在
                    [DYDDataManager shareDYDDataManager].loginUser = user;
                    //保存到本地
                    [DYDDBManager insertUsersTable:user];
                    
                    
                    //如果有监听代理，回调
                    
                    //出口-登录成功
                    if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
                        if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
                            [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:DYDSDKLoginResultSuccess userE:user];
                        }else{
                            NSLog(@"未实现登录代理回调方法");
                        }
                    }
                    
                    //登陆成功
                    [self removeFromSuperview];
                }else{
                    //发生未知错误
//                    if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
//                        if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
//                            [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:NO userE:nil];
//                        }else{
//                            NSLog(@"未实现登录代理回调方法");
//                        }
//                    }
                }
            } failure:^{
//                if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
//                    if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
//                        [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:NO userE:nil];
//                    }else{
//                        NSLog(@"未实现登录代理回调方法");
//                    }
//                }
            }];
            
        }
            break;
        case DYDSDKLoginViewUpdate:
        {
            //升级账号
            [DYDSDKDataRequstTool sdk_updateAccountWithAccount:phone password:password type:@"bind_exist_user" success:^(DYDSDKUserEntity *user) {
                if (user) {
                    //有用户信息
                    [DYDDataManager shareDYDDataManager].loginUser = user;
                    //保存到本地
                    [DYDDBManager insertUsersTable:user];
                    //出口-登录成功
                    if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
                        if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
                            [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:DYDSDKLoginResultSuccess userE:user];
                        }else{
                            NSLog(@"未实现登录代理回调方法");
                        }
                    }
                    
                    [self removeFromSuperview];
                }else{
                    //无用户信息，未知错误
                }
            } failure:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}

/** 点击QQ登录 */
- (void)loginView_clickQQLoginBut
{
    
}

/** 点击微信登录 */
- (void)loginView_clickWechatLoginBut
{
    
}

/** 点击新浪微博登录 */
- (void)loginView_clickSinaLoginBut
{
    
}

/** 点击游客登录 */
- (void)loginView_clickVisitorLoginBut
{
    NSString *deviceId = [DYDDataManager shareDYDDataManager].deviceId;
    [DYDSDKDataRequstTool sdk_registerVisitorWithDeviceId:deviceId success:^(DYDSDKUserEntity *user) {
        if (user) {
            [DYDDataManager shareDYDDataManager].loginUser = user;
            //游客登录保存数据库
            [DYDDBManager insertUsersTable:user];
            
            //出口-登录成功
            if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
                if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
                    [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:DYDSDKLoginResultSuccess userE:user];
                }else{
                    NSLog(@"未实现登录代理回调方法");
                }
            }
            [self removeFromSuperview];//移除视图
        }else{
            //没有登录用户
            [DYDSDKMessagePopupView dydsdk_showMessage:@"登录发生未知错误" center:CGPointZero inView:nil];
        }
    } failure:^{
        
    }];
}

/** 点击找回密码 */
- (void)loginView_clickGetBackPasswordBut
{
    DYDSDKSettingPasswordView *getPW = [DYDSDKSettingPasswordView creatSettingPasswordView];
    getPW.settingPWDelegate = self;
    [self pushView:getPW];
}

/** 点击关闭按钮 */
- (void)loginView_clickCloseBut
{
    [self removeFromSuperview];
    //点击关闭按钮
    //未登录回调
    if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
        if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
            [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:DYDSDKLoginResultCancel userE:nil];
        }
    }
}

//点击进行第一弹授权登录
- (void)loginView_clickDYDAppLoginBut
{
    //获取schemes
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    NSArray *urlTypeAry = [infoDic objectForKey:@"CFBundleURLTypes"];
    NSString *gameScheme = nil;
    if (urlTypeAry && urlTypeAry.count > 0) {
        //有scheme
        for (NSDictionary *schemeDic in urlTypeAry) {
            NSArray *schemeAry = [schemeDic objectForKey:@"CFBundleURLSchemes"];
            if (schemeAry && schemeAry.count > 0) {
                for (NSString *scheme in schemeAry) {
                    if ([scheme isEqualToString:[NSString stringWithFormat:@"dyd%@", [DYDDataManager shareDYDDataManager].gs_appId]]) {
                        //是第一弹的
                        gameScheme = scheme;
                        break;
                    }else{
                        if (gameScheme == nil) {
                            gameScheme = scheme;//没有dyd的使用第一个scheme
                        }
                    }
                }
            }
            if ([gameScheme isEqualToString:[NSString stringWithFormat:@"dyd%@", [DYDDataManager shareDYDDataManager].gs_appId]]) {
                break;
            }
        }
        if (gameScheme) {
            //scheme存在
            NSLog(@"获得scheme:%@", gameScheme);
            
            //用剪贴板传值
            NSDictionary *passValueDic = @{
                                           @"fromAppType" : @"game",           //来自游戏应用
                                           @"requestType" : @"login",          //登录请求
                                           //                                   @"loginPlatform" : platForm,        //登录平台
                                           @"AppID" : [DYDDataManager shareDYDDataManager].gs_appId,    //AppID
                                           @"Authorization" : [DYDSDKNetworkTool dyd_getAuthorization] ,
                                           @"scheme" : gameScheme,       //应用Scheme
                                           @"sdkVersion" : DYDSDKVersion       //sdk版本号
                                           };
            NSError *passValureError;
            NSData *passValueData = [NSJSONSerialization dataWithJSONObject:passValueDic options:NSJSONWritingPrettyPrinted error:&passValureError];
            if (passValureError) {
                NSLog(@"字典转data失败 errorCode = %ld", (long)[passValureError code]);
            } else {
                NSString *passValureStr = [[NSString alloc] initWithData:passValueData encoding:NSUTF8StringEncoding];
                NSLog(@"passValureStr = %@", passValureStr);
                [[UIPasteboard generalPasteboard] setValue:[NSKeyedArchiver archivedDataWithRootObject:passValureStr] forPasteboardType:DYDSDKGamePassValureKey];
            }
            
            //跳转
            NSString *urlStr = [NSString stringWithFormat:@"%@://thirdLogin/%@?generalpastboard=1&sdkv=%@", DYDAPPScheme, gameScheme, DYDSDKVersion];   //diyidanApp是第一弹的scheme
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
            
        }else{
            //无scheme
            NSLog(@"没有设置URL Type中的scheme，例如\"dyd1234\"");
        }
    }else{
        //无scheme
        NSLog(@"没有设置URL Type中的scheme，例如\"dyd1234\"");
    }
}

#pragma mark DYDSDKRegisterSendCodeViewDelegate
//注册获取验证码
//点击返回按钮
- (void)sendCode_clickBackBut
{
    [self popView];
}

//点击获取验证码
- (void)sendCode_clickSendCodeButWithPhone:(NSString *)phone
{
    if ([[self class] judgeIsMobiePhoneNumberWithPhoneString:phone] == NO) {
        //不是标准的手机号码
        [DYDSDKMessagePopupView dydsdk_showMessage:@"请输入正确的手机号" center:CGPointZero inView:nil];
        return;
    }
    
    [DYDSDKDataRequstTool sdk_getPhoneCodeWithType:@"register" phone:phone success:^{
        //发送成功
        //进入到注册页面
        [DYDDataManager shareDYDDataManager].getCodeTime = 60;
        DYDSDKRegisterView *registerView = [DYDSDKRegisterView creatSDKRegsterView];
        registerView.registerDelegate = self;
        registerView.phoneNumStr = phone;
        [self pushView:registerView];
    } failure:^{
        //发送失败
    }];
    
}

#pragma mark DYDSDKRegisterViewDelegate
//注册页面
//点击返回按钮
- (void)registerView_clickBackBut
{
    //注册页面点击时需要区分是登录还是升级账号
    switch (self.showViewType) {
        case DYDSDKShowViewTypeLogin:
        {
            //登录
            [self popViewCount:2];
        }
            break;
        case DYDSDKShowViewTypeAccountUpdate:
        {
            //升级账号
            [self popViewCount:2];//注册页面的获取验证码分离了，所以是两级
        }
            break;
            
        default:
            break;
    }
}

//点击注册按钮
- (void)registerView_clickRegisterButWithSeccode:(NSString *)seccode nickName:(NSString *)nickName password:(NSString *)password phone:(NSString *)phone
{
    if (seccode.length != 6) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"请输入正确的验证码" center:CGPointZero inView:nil];
        return;
    }
    if (nickName.length == 0) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"请输入昵称" center:CGPointZero inView:nil];
        return;
    }
    if (password.length < 6 || password.length > 18) {
        [DYDSDKMessagePopupView dydsdk_showMessage:@"密码长度建议在6到18位之间噢(^_^)" center:CGPointZero inView:nil];
        return;
    }
    //点击注册要区分登录和升级，因为返回的
    switch (self.showViewType) {
        case DYDSDKShowViewTypeLogin:
        {
            //登录
            //提交成功后应该回到登录界面
//            [self popViewCount:2];
            [DYDSDKDataRequstTool sdk_registerWithPhone:phone smsCode:seccode password:password nickName:nickName success:^(DYDSDKUserEntity *user) {
                [DYDSDKMessagePopupView dydsdk_showMessage:@"注册成功 ヾ(￣▽￣)" center:CGPointZero inView:nil];
//                [self popViewCount:2];
                //注册完成，user存储，回调登录成功
                if (user) {
                    [DYDDataManager shareDYDDataManager].loginUser = user;
                    
                    //存储数据库
                    [DYDDBManager insertUsersTable:user];
                    
                    //出口-登录成功
                    if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
                        if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
                            [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:DYDSDKLoginResultSuccess userE:user];
                        }else{
                            NSLog(@"未实现登录代理回调方法");
                        }
                    }
                    [self removeFromSuperview];
                }else{
                    //注册出错，没有获取用户信息
                    
                }
            } failure:^{
                
            }];
        }
            break;
        case DYDSDKShowViewTypeAccountUpdate:
        {
            //升级账号
            //提交成功后应该回到登录界面
            //如果是升级账号，不走此界面
        }
            break;
            
        default:
            break;
    }
    
    //点击注册，提交填写的内容
    
}

#pragma mark DYDSDKSettingPasswordViewDelegate
//修改密码，找回密码
//点击返回按钮
- (void)settingPassword_clickBackBut
{
    [self popView];
}

//点击确定修改按钮
- (void)settingPassword_clickRegisterButWithPhoneNum:(NSString *)phoneNum seccode:(NSString *)seccode password:(NSString *)password
{
    //提交修改密码
    [DYDSDKDataRequstTool sdk_modifyPasswordWithPhone:phoneNum password:password smsCode:seccode loginSuccess:^(DYDSDKUserEntity *user) {
        //修改密码成功
        [self popView];
    } failure:^{
        
    }];
}



#pragma mark DYDSDKHintVisitorViewDelegate
//提示升级账号的视图
//点击切换账号
- (void)hintVositorView_clickChangeAccountBut
{
    //切换到登录界面
    DYDSDKLoginView *loginView = [DYDSDKLoginView creatLoginViewWithNoUserBut:NO type:DYDSDKLoginViewLogin];
    loginView.clickDelegate = self;
    [self pushView:loginView];
}

//点击进入按钮
- (void)hintVositorView_clickComeinBut
{
    //点击进入游戏
    //当前游客界面，无需操作
    [self removeFromSuperview];
}

//点击马上升级
- (void)hintVositorView_clickAcountUpdateBut
{
    //升级账号的页面
    DYDSDKLoginView *updateView = [DYDSDKLoginView creatLoginViewWithNoUserBut:NO type:DYDSDKLoginViewUpdate];
    updateView.clickDelegate = self;
    [self pushView:updateView];
    
    //注册页面
//    DYDSDKRegisterView *registerView = [DYDSDKRegisterView creatSDKRegsterView];
//    registerView.registerDelegate = self;
//    [self pushView:registerView];
    
}

//点击关闭按钮
- (void)hintVositorView_clickCloseBut
{
    //取消升级，什么也不做
    [self removeFromSuperview];
}

#pragma mark DYDSDKBindVisitorViewDelegate
//升级账号页面
//升级账号页面点击确定按钮
- (void)bindVisitorView_clickDonebutWithPhone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password
{
    [DYDSDKDataRequstTool sdk_updateNewAccountWithPhone:phone smsCode:smsCode password:password success:^(DYDSDKUserEntity *user) {
        if (user) {
            //用户信息存在
            [DYDDataManager shareDYDDataManager].loginUser = user;
            //存一下数据库
            [DYDDBManager insertUsersTable:user];
            
            //出口-登录成功
            if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
                if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_loginFinishWithResult:userE:)]) {
                    [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_loginFinishWithResult:DYDSDKLoginResultSuccess userE:user];
                }else{
                    NSLog(@"未实现登录代理回调方法");
                }
            }
            //登录成功移除视图
            [self removeFromSuperview];
        }else{
            //不存在用户信息
            
        }
    } failure:^{
        //反正是失败
        
    }];
}

//点击返回按钮
- (void)bindVisitorView_clickBackBut
{
    [self popView];
}

#pragma mark DYDSDKBackBaseViewDelegate
//baseView的关闭按钮点击
- (void)baseView_clickCloseBut
{
    [self removeFromSuperview];
}

#pragma mark - 公共逻辑
//判断是否是标准的手机号码
+ (BOOL)judgeIsMobiePhoneNumberWithPhoneString:(NSString *)string
{
    if (string.length == 0 || string.length > 11) {
        return NO;
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^1[34578][0-9]\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 懒加载

- (NSMutableArray *)viewAryM
{
    if (!_viewAryM) {
        self.viewAryM = [NSMutableArray array];
    }
    return _viewAryM;
}

@end
