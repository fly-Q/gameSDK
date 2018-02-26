//
//  DYDSDKSuspensionMenuView.m
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/3.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKSuspensionMenuView.h"
#import "DYDSDKHexagonImageView.h"
#import "DYDDataManager.h"
#import "DYDSDKNetworkTool.h"
#import "DYDSDKMessagePopupView.h"
#import "DYDSettingHeader.h"

@interface DYDSDKSuspensionMenuView ()

//背景图片
@property (nonatomic, strong) UIImageView *backIV;
/** 用户的头像 */
@property (nonatomic, strong) UIImageView *avatarIV;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBut;
/** 用户名显示 */
@property (nonatomic, strong) UILabel *userNameLab;
/** 用户账号的显示 */
@property (nonatomic, strong) UILabel *userAccountLab;
/** 换绑按钮 */
@property (nonatomic, strong) UIButton *changePhoneBut;
/** 用户头像显示 */
@property (nonatomic, strong) DYDSDKHexagonImageView *userAvatarIV;
/** 回调代理 */
@property (nonatomic, weak) id<DYDSDKSuspensionMenuViewDelegate> clickDelegate;

/** 按钮的数组 */
@property (nonatomic, strong) NSMutableArray *functionButAryM;
/** 联系客服按钮 */
@property (nonatomic, strong) UIButton * contactUsBut;

@end

@implementation DYDSDKSuspensionMenuView

+ (DYDSDKSuspensionMenuView *)sdk_creatSuspensionViewWithDelegate:(id<DYDSDKSuspensionMenuViewDelegate>)delegate
{
    DYDSDKSuspensionMenuView *view = [[DYDSDKSuspensionMenuView alloc] initWithFrame:CGRectZero];
    view.clickDelegate = delegate;
    [view constructUI];//创建UI视图
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backIV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backIV.image = DYDImage(@"dydsdk_function_background");
        [self addSubview:self.backIV];
        
        //拦截父视图的手势
        UITapGestureRecognizer *tacklTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tacklTapAction)];
        [self addGestureRecognizer:tacklTap];
    }
    return self;
}

//拦截父视图手势
- (void)tacklTapAction
{
    //什么也不做，只是拦截一下
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backIV.frame = self.bounds;
    CGFloat nameTop = 50.0 / 384.0 *self.frame.size.height + 30 + 5;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    self.userNameLab.frame = CGRectMake(27.5, nameTop, screenW - 27.5 *2, 21);
    self.userAccountLab.frame = CGRectMake(CGRectGetMinX(self.userAccountLab.frame), CGRectGetMaxY(self.userNameLab.frame) + 2, CGRectGetWidth(self.userAccountLab.frame), CGRectGetHeight(self.userAccountLab.frame));
    self.userAvatarIV.frame = CGRectMake(23.5, 52.5 / 384.0 *self.frame.size.height - 27.5, 55, 55);
    
    //关闭按钮的自动布局
    CGFloat closeButW = 18 + 12.5 *2;
    CGFloat closeButH = 18 + 14.5 *2;
    self.closeBut.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - closeButW, 0, closeButW, closeButH);
    
    self.changePhoneBut.frame = CGRectMake(CGRectGetMaxX(self.userAccountLab.frame), CGRectGetMinY(self.userAccountLab.frame), CGRectGetHeight(self.userAccountLab.frame), 35);
    
    [self layoutFunctionButs];//布局几个功能按钮
}

- (void)constructUI
{
    CGFloat nameTop = 50.0 / 384.0 *self.frame.size.height + 30 + 5;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    //用户名
    self.userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(27.5, nameTop, screenW - 27.5 *2, 21)];
    self.userNameLab.font = [UIFont systemFontOfSize:15];
    self.userNameLab.textColor = [UIColor whiteColor];
    [self addSubview:self.userNameLab];
    self.userNameLab.text = [DYDDataManager shareDYDDataManager].loginUser.nickName;
    
    //用户账号
    self.userAccountLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.userNameLab.frame), CGRectGetMaxY(self.userNameLab.frame) + 2, CGRectGetWidth(self.userNameLab.frame), CGRectGetHeight(self.userNameLab.frame))];
    self.userAccountLab.font = [UIFont systemFontOfSize:15];
    self.userAccountLab.textColor = [UIColor whiteColor];
    [self addSubview:self.userAccountLab];
    DYDSDKUserEntity *userE = [DYDDataManager shareDYDDataManager].loginUser;
    self.userAccountLab.text = nil;
    if (userE.userType != DYDSDKUserTypeAnonymous) {
        if (userE.account) {
            //账号存在
            NSString *accountStr = [NSString stringWithFormat:@"登录号：%@", userE.account];
            self.userAccountLab.text = accountStr;
            CGRect accountRect = [accountStr boundingRectWithSize:CGSizeMake(0, CGRectGetHeight(self.userAccountLab.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
            self.userAccountLab.frame = CGRectMake(CGRectGetMinX(self.userAccountLab.frame), CGRectGetMinY(self.userAccountLab.frame), accountRect.size.width + 5, 35);
            //提供换绑按钮
            self.changePhoneBut = [UIButton buttonWithType:UIButtonTypeCustom];
            self.changePhoneBut.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.changePhoneBut setTitle:@"换绑" forState:UIControlStateNormal];
            [self.changePhoneBut setTitleColor:[UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.changePhoneBut addTarget:self action:@selector(changePhoneButAction) forControlEvents:UIControlEventTouchUpInside];
            self.changePhoneBut.frame = CGRectMake(CGRectGetMaxX(self.userAccountLab.frame), CGRectGetMinY(self.userAccountLab.frame), CGRectGetHeight(self.userAccountLab.frame), CGRectGetHeight(self.userAccountLab.frame));
            [self addSubview:self.changePhoneBut];
        }
    }
    
    self.userAvatarIV = [[DYDSDKHexagonImageView alloc] initWithFrame:CGRectMake(23.5, 52.5 / 384.0 *self.frame.size.height - 27.5, 55, 55)];
    [self.userAvatarIV addRedFrame];//添加红色的框
    self.userAvatarIV.backgroundColor = [UIColor colorWithRed:42 / 255.0 green:41 / 255.0 blue:43 / 255.0 alpha:1.0];
    
    [self addSubview:self.userAvatarIV];
    
    self.closeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat closeButW = 18 + 12.5 *2;
    CGFloat closeButH = 18 + 14.5 *2;
    self.closeBut.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - closeButW, 0, closeButW, closeButH);
    [self.closeBut setImage:DYDImage(@"dydsdk_closeBut") forState:UIControlStateNormal];
    [self.closeBut addTarget:self action:@selector(closeButAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBut];
    
    [DYDSDKNetworkTool dyd_downloadImageWithUrl:userE.avatar useCache:YES success:^(UIImage *img) {
        self.userAvatarIV.image = img;
    } failure:^{
        self.userAvatarIV.image = nil;
    }];
    
    //创建功能按钮
    if (userE.userType == DYDSDKUserTypeAnonymous) {
        //1.如果是游客用户   绑定手机、切换账号、退出游戏
        UIButton *bindBut = [self creatFunctionButtonWithTitle:@"绑定账号"
                                                           img:@"dydsdk_function_bind"
                                                        target:self
                                                        action:@selector(bindButAction)];//绑定账号
        [self addSubview:bindBut];
        [self.functionButAryM addObject:bindBut];
        UIButton *changAccountBut = [self creatFunctionButtonWithTitle:@"切换账号"
                                                                   img:@"dydsdk_function_changAccount"
                                                                target:self
                                                                action:@selector(changAccountButAction)];
        [self addSubview:changAccountBut];
        [self.functionButAryM addObject:changAccountBut];
//        UIButton *gameOverBut = [self creatFunctionButtonWithTitle:@"退出游戏"
//                                                               img:@"dydsdk_function_gameOver"
//                                                            target:self
//                                                            action:@selector(gameOverButAction)];
//        [self addSubview:gameOverBut];
//        [self.functionButAryM addObject:gameOverBut];
        
    }else{
        //2.如果是手机号用户 修改密码、查看弹友、切换账号、退出游戏
        UIButton *settingPW = [self creatFunctionButtonWithTitle:@"修改密码"
                                                             img:@"dydsdk_function_settingPW"
                                                          target:self
                                                          action:@selector(settingPWButAction)];
        [self addSubview:settingPW];
        [self.functionButAryM addObject:settingPW];
//        UIButton *lookFriends = [self creatFunctionButtonWithTitle:@"查看弹友"
//                                                               img:@"dydsdk_function_lookFriends"
//                                                            target:self
//                                                            action:@selector(lookFriendsButAction)];
//        [self addSubview:lookFriends];
//        [self.functionButAryM addObject:lookFriends];
        UIButton *changAccountBut = [self creatFunctionButtonWithTitle:@"切换账号"
                                                                   img:@"dydsdk_function_changAccount"
                                                                target:self
                                                                action:@selector(changAccountButAction)];
        [self addSubview:changAccountBut];
        [self.functionButAryM addObject:changAccountBut];
//        UIButton *gameOverBut = [self creatFunctionButtonWithTitle:@"退出游戏"
//                                                               img:@"dydsdk_function_gameOver"
//                                                            target:self
//                                                            action:@selector(gameOverButAction)];
//        [self addSubview:gameOverBut];
//        [self.functionButAryM addObject:gameOverBut];
    }
    
    [self layoutFunctionButs];//布局几个功能按钮
    
    
    self.contactUsBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contactUsBut setTitle:@"联系客服" forState:UIControlStateNormal];
    [self.contactUsBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat color = 0.5;
    [self.contactUsBut setTitleColor:[UIColor colorWithRed:color green:color blue:color alpha:1.0] forState:UIControlStateHighlighted];
    self.contactUsBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contactUsBut addTarget:self action:@selector(contactUsButAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contactUsBut];
}

//布局功能菜单按钮的位置
- (void)layoutFunctionButs
{
    CGFloat bottomGap = 0;
    if (self.frame.size.width > self.frame.size.height) {
        //宽度大于高度
        bottomGap = 60;
    }else{
        //高度大于宽度
        bottomGap = 90;
    }
    self.contactUsBut.frame = CGRectMake(self.frame.size.width - 50 - 60, self.frame.size.height - (bottomGap *0.7 + 8), 60, 16);
    
    CGFloat leftGap = ([UIScreen mainScreen].bounds.size.width - self.functionButAryM.count *80) / 2.0;
    for (int i = 0; i < self.functionButAryM.count; i++) {
        UIButton *but = [self.functionButAryM objectAtIndex:i];
        but.frame = CGRectMake(leftGap + i *80, self.frame.size.height - bottomGap - 62, CGRectGetWidth(but.frame), CGRectGetHeight(but.frame));
    }
}

- (UIButton *)creatFunctionButtonWithTitle:(NSString *)title img:(NSString *)img target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 62);
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [button setImage:DYDImage(img) forState:UIControlStateNormal];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 62 - [UIFont systemFontOfSize:12].lineHeight, button.frame.size.width, [UIFont systemFontOfSize:12].lineHeight)];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [button addSubview:titleLab];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//点击关闭按钮
- (void)closeButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(suspensionMenuView_clickCloseBut)]) {
        [self.clickDelegate suspensionMenuView_clickCloseBut];
    }
}

//联系客服
- (void)contactUsButAction
{
    //点击联系客服，跳转safari
    NSURL *contactUrl = [NSURL URLWithString:@"http://post.diyidan.net/kefu/fringe.html"];
    [[UIApplication sharedApplication] openURL:contactUrl];
}

#pragma mark - 游客模式下点击事件
//绑定账号
- (void)bindButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(suspensionMenuView_clickBindAccountBut)]) {
        [self.clickDelegate suspensionMenuView_clickBindAccountBut];
    }
}

//切换账号
- (void)changAccountButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(suspensionMenuView_clickChangAccountBut)]) {
        [self.clickDelegate suspensionMenuView_clickChangAccountBut];
    }
}

//退出游戏
- (void)gameOverButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(suspensionMenuView_clickQuitGameBut)]) {
        [self.clickDelegate suspensionMenuView_clickQuitGameBut];
    }
}

#pragma mark - 手机号用户按钮点击事件
//修改密码
- (void)settingPWButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(suspensionMenuView_clickSettingPWBut)]) {
        [self.clickDelegate suspensionMenuView_clickSettingPWBut];
    }
}

//查看弹友
- (void)lookFriendsButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(suspensionMenuView_clickLookFriendsBut)]) {
        [self.clickDelegate suspensionMenuView_clickLookFriendsBut];
    }
}

//点击换绑按钮
- (void)changePhoneButAction
{
    [DYDSDKMessagePopupView dydsdk_showMessage:@"请到最新版第一弹更换绑定手机" center:CGPointZero inView:nil];
}

- (NSMutableArray *)functionButAryM
{
    if (!_functionButAryM) {
        self.functionButAryM = [NSMutableArray array];
    }
    return _functionButAryM;
}

@end
