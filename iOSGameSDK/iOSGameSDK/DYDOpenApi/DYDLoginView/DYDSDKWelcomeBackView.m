//
//  DYDSDKWelcomeBackView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKWelcomeBackView.h"
#import "DYDSDKNetworkTool.h"
#import "DYDSDKHexagonImageView.h"
#import "DYDDataManager.h"
#import "DYDSettingHeader.h"

@interface DYDSDKWelcomeBackView ()

/** 用户头像 */
@property (nonatomic, strong) DYDSDKHexagonImageView *userIconIV;
/** 切换账号的按钮 */
@property (nonatomic, strong) UIButton * changeUserBut;
/** 欢迎回来 */
@property (nonatomic, strong) UILabel * welcomesLab;
/** 用户昵称 */
@property (nonatomic, strong) NSString * userName;
/** 头像网址 */
@property (nonatomic, copy) NSString * avatar;
/** 回调的block */
@property (nonatomic, copy) DYDSDKWelcomeBackChangeUserBlock callBack;

@end

@implementation DYDSDKWelcomeBackView

+ (DYDSDKWelcomeBackView *)creatWelcomeBackViewWithVisitorName:(NSString *)visitorName avatar:(NSString *)avatar callBack:(DYDSDKWelcomeBackChangeUserBlock)callBack
{
    DYDSDKWelcomeBackView *view = [[DYDSDKWelcomeBackView alloc] initWithFrame:CGRectZero];
    view.userName = visitorName;
    view.avatar = avatar;
    view.callBack = callBack;
    [view constructUI];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:78 / 255.0 green:76 / 255.0 blue:79 / 255.0 alpha:1.0];
    }
    return self;
}

/** 搭建UI界面 */
- (void)constructUI
{
    self.userIconIV = [[DYDSDKHexagonImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.userIconIV addRedFrameWithWidth:4];
    [self addSubview:self.userIconIV];
    self.userIconIV.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userIconIV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:3.5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userIconIV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:25]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userIconIV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-3.5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userIconIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.userIconIV attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
//    self.userIconIV.layer.cornerRadius = 20;
//    self.userIconIV.layer.masksToBounds = YES;
    self.userIconIV.backgroundColor = [UIColor redColor];
    
    self.changeUserBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeUserBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.changeUserBut setImage:DYDImage(@"dydsdk_changeUser") forState:UIControlStateNormal];
    [self.changeUserBut setTitle:@"切换账号" forState:UIControlStateNormal];
    self.changeUserBut.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.changeUserBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changeUserBut addTarget:self action:@selector(changeUSerButAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.changeUserBut];
    self.changeUserBut.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.changeUserBut attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:3.5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.changeUserBut attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-16]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.changeUserBut attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:3.5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.changeUserBut attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.changeUserBut attribute:NSLayoutAttributeHeight multiplier:11.0 / 4.0 constant:0]];
    
    self.welcomesLab = [[UILabel alloc] init];
    self.welcomesLab.font = [UIFont systemFontOfSize:14];
    self.welcomesLab.textColor = [UIColor whiteColor];
    [self addSubview:self.welcomesLab];
    self.welcomesLab.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.welcomesLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.welcomesLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.userIconIV attribute:NSLayoutAttributeRight multiplier:1 constant:14]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.welcomesLab attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.welcomesLab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.changeUserBut attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
    self.welcomesLab.text = [NSString stringWithFormat:@"欢迎回来，%@", self.userName];
    
    [DYDSDKNetworkTool dyd_downloadImageWithUrl:self.avatar useCache:YES success:^(UIImage *img) {
        self.userIconIV.image = img;
    } failure:^{
        self.userIconIV.image = DYDImage(@"dydsdk_sinaLogin_highlight");
    }];
}

- (void)insertToWindow
{
    //显示之前先把以前的移除
    if ([DYDDataManager shareDYDDataManager].lastBaseView) {
        if ([DYDDataManager shareDYDDataManager].lastBaseView.superview) {
            //存在父视图
            [[DYDDataManager shareDYDDataManager].lastBaseView removeFromSuperview];
        }
        [DYDDataManager shareDYDDataManager].lastBaseView = nil;
    }
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [DYDDataManager shareDYDDataManager].lastBaseView = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.topLayoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeTop multiplier:1 constant:-47];
    [window addConstraint:_topLayoutConstraint];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [window addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:47]];
    [window layoutIfNeeded];
    self.topLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismissFromWindow) withObject:nil afterDelay:5];
    }];
}

- (void)dismissFromWindow
{
    self.topLayoutConstraint.constant = -47;
    [UIView animateWithDuration:0.5 animations:^{
        [[[UIApplication sharedApplication].delegate window] layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

//点击切换账号按钮
- (void)changeUSerButAction
{
    if (self.callBack) {
        self.callBack();
    }
}

@end
