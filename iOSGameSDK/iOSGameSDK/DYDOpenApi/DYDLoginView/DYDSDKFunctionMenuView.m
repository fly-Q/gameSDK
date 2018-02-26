//
//  DYDSDKFunctionMenuView.m
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/3.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKFunctionMenuView.h"
#import "DYDSDKSuspensionMenuView.h"
#import "DYDSDKLoginBaseView.h"
#import "DYDLoginHeader.h"
#import "DYDDataManager.h"
#import "DYDDBManager.h"
#import "DYDSDKGeneralAlertView.h"
#import "DYDSDKDataRequstTool.h"

@interface DYDSDKFunctionMenuView ()<DYDSDKSuspensionMenuViewDelegate, UIAlertViewDelegate>

//功能菜单左边的约束
@property (nonatomic, strong) NSLayoutConstraint *menuLeftLC;
/** 功能菜单右边的约束 */
@property (nonatomic, strong) NSLayoutConstraint *menuRightLC;
/** 功能菜单的高度约束 */
@property (nonatomic, strong) NSLayoutConstraint *menuHeightLC;
/** 功能菜单的视图 */
@property (nonatomic, strong) DYDSDKSuspensionMenuView *functionView;

@end

@implementation DYDSDKFunctionMenuView

+ (DYDSDKFunctionMenuView *)sdk_creatFunctionMenuView
{
    DYDSDKFunctionMenuView *view = [[DYDSDKFunctionMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRemoveViewAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//添加移除手势
- (void)clickRemoveViewAction
{
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view
{
    //父视图
    UIView * superView = view;
    if (superView == nil) {
        superView = [[UIApplication sharedApplication].delegate window];
    }
    
    //显示之前把其他的视图移除
    if ([DYDDataManager shareDYDDataManager].lastBaseView) {
        if ([DYDDataManager shareDYDDataManager].lastBaseView.superview) {
            [[DYDDataManager shareDYDDataManager].lastBaseView removeFromSuperview];
        }
        [DYDDataManager shareDYDDataManager].lastBaseView = nil;
    }
    //以约束的形式添加到父视图
    [superView addSubview:self];
    [DYDDataManager shareDYDDataManager].lastBaseView = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    //以约束的形式添加功能菜单，保留左右的约束，便于扩展动画
    DYDSDKSuspensionMenuView *functionView = [DYDSDKSuspensionMenuView sdk_creatSuspensionViewWithDelegate:self];
    functionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:functionView];
    self.menuLeftLC = [NSLayoutConstraint constraintWithItem:functionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    self.menuRightLC = [NSLayoutConstraint constraintWithItem:functionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    [self addConstraint:self.menuLeftLC];
    [self addConstraint:self.menuRightLC];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:functionView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    CGFloat preHeight = [UIScreen mainScreen].bounds.size.width *(778.0 / 720.0);
    if (preHeight > [UIScreen mainScreen].bounds.size.height *0.85) {
        preHeight = [UIScreen mainScreen].bounds.size.height *0.85;
    }
    NSLayoutConstraint *heightLC = [NSLayoutConstraint constraintWithItem:functionView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:preHeight];
    self.menuHeightLC = heightLC;
    [self addConstraint:self.menuHeightLC];
    self.functionView = functionView;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat preHeight = [UIScreen mainScreen].bounds.size.width *(778.0 / 720.0);
    if (preHeight > [UIScreen mainScreen].bounds.size.height *0.85) {
        preHeight = [UIScreen mainScreen].bounds.size.height *0.85;
    }
    self.menuHeightLC.constant = preHeight;
}

#pragma mark - DYDSDKSuspensionMenuViewDelegate

//点击关闭按钮
- (void)suspensionMenuView_clickCloseBut
{
    [self removeFromSuperview];
}

//点击修改密码
- (void)suspensionMenuView_clickSettingPWBut
{
    [self removeFromSuperview];
    DYDSDKLoginBaseView *pushView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
    [pushView showWithType:DYDSDKShowViewTypeModifyPassW];
}

//点击查看弹友
- (void)suspensionMenuView_clickLookFriendsBut
{
    [self removeFromSuperview];
    DYDSDKLoginBaseView *pushView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
    [pushView showWithType:DYDSDKShowViewTypeLookFriends];
}

//点击切换账号
- (void)suspensionMenuView_clickChangAccountBut
{
    DYDSDKGeneralAlertView *alert = [DYDSDKGeneralAlertView creatSDKGeneralAlertVieiwWithMessage:@"确定要切换账号吗?" callBack:^(NSInteger index) {
        if (index == 1) {
            //确定切换账号
            //清空内存的数据
            [DYDDataManager shareDYDDataManager].loginUser = nil;
            //清除数据库中的登录用户
            [DYDDBManager insertUsersTable:nil];
            
            [DYDSDKDataRequstTool sdk_logoutAccountSuccess:^(NSInteger code) {
                if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
                    if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_changeAccountLogoutSuccess)]) {
                        [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_changeAccountLogoutSuccess];
                    }else{
                        NSLog(@"未实现代理方法'dyd_logoutResult:'");
                    }
                }else{
                    NSLog(@"未设置回调代理");
                }
            } failure:^{
                if ([DYDDataManager shareDYDDataManager].dyd_delegate) {
                    if ([[DYDDataManager shareDYDDataManager].dyd_delegate respondsToSelector:@selector(dyd_changeAccountLogoutSuccess)]) {
                        [[DYDDataManager shareDYDDataManager].dyd_delegate dyd_changeAccountLogoutSuccess];
                    }else{
                        NSLog(@"未实现代理方法'dyd_logoutResult:'");
                    }
                }else{
                    NSLog(@"未设置回调代理");
                }
            }];
            [self removeFromSuperview];
        }else{
            //点击了其他取消按钮
        }
    }];
    [alert show];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要切换账号吗？"
//                                                    message:nil
//                                                   delegate:self
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"确定", nil];
//    alert.tag = 10086;
//    [alert show];
    
//    DYDSDKLoginBaseView *pushView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
//    [pushView showWithType:DYDSDKShowViewTypeChangAccount];
}

//点击退出游戏
- (void)suspensionMenuView_clickQuitGameBut
{
    [self removeFromSuperview];
    [DYDLoginHeader dyd_logout];//退出当前账号
}

//点击绑定按钮
- (void)suspensionMenuView_clickBindAccountBut
{
    [self removeFromSuperview];
    DYDSDKLoginBaseView *pushView = [DYDSDKLoginBaseView creatSDKLoginBaseViewWithFrame:CGRectZero];
    [pushView showWithType:DYDSDKShowViewTypeBindAccount];
}


@end
