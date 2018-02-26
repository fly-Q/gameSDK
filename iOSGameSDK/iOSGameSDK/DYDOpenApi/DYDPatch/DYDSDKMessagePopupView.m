//
//  DYDSDKMessagePopupView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/17.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKMessagePopupView.h"

@interface DYDSDKMessagePopupView ()

/** 显示的提示语 */
@property (nonatomic, strong) UILabel *messageLab;
/** 消息内容 */
@property (nonatomic, copy) NSString * message;
/** 中心点（默认0, 0） */
@property (nonatomic, assign) CGPoint viewCenter;

@end

@implementation DYDSDKMessagePopupView

static NSMutableDictionary *messageDic = nil;
+ (NSMutableDictionary *)messageDic
{
    if (messageDic == nil) {
        messageDic = [NSMutableDictionary dictionary];
    }
    return messageDic;
}

+ (void)dydsdk_showMessage:(NSString *)message center:(CGPoint)center inView:(UIView *)view
{
    DYDSDKMessagePopupView *mesView = [self dydsdk_creatMessagePopupViewWithMessage:message center:center];
    [mesView showInView:view autoDismiss:YES];
}

+ (DYDSDKMessagePopupView *)dydsdk_creatMessagePopupViewWithMessage:(NSString *)message center:(CGPoint)center
{
    DYDSDKMessagePopupView *messageView = [[DYDSDKMessagePopupView alloc] initWithFrame:CGRectZero];
    messageView.message = message;
    messageView.viewCenter = center;
    if (message == nil || message.length == 0) {
        return nil;
    }
    if ([[self messageDic] objectForKey:message]) {
        //该信息正在显示，不再创建新的
        return nil;
    }
    [messageView constructUI];//搭建UI界面
    return messageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4.5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        self.messageLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.messageLab.font = [UIFont systemFontOfSize:15];
        self.messageLab.textColor = [UIColor whiteColor];
        self.messageLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLab];
        self.messageLab.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLab attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return self;
}

//搭建UI界面
- (void)constructUI
{
    CGFloat allHeight = [UIFont systemFontOfSize:15].lineHeight + 30;//30是上下的间距
    CGFloat leftGap = 15;
    NSString *message = self.message;
    CGFloat messageW = [message boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - leftGap *4, [UIFont systemFontOfSize:15].lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.width;
    CGFloat allWidth = messageW + leftGap *2;//总宽度是字宽加上左右间距
    self.frame = CGRectMake(0, 0, allWidth, allHeight);
    self.messageLab.text = self.message;
}

- (void)showInView:(UIView *)view autoDismiss:(BOOL)autoDismiss
{
    UIView *superView = view;
    if (superView == nil) {
        superView = [[UIApplication sharedApplication].delegate window];
    }
    [superView addSubview:self];
    if (self.viewCenter.x == 0 && self.viewCenter.y == 0) {
        //没有设置center
        self.center = CGPointMake(superView.frame.size.width *0.5, superView.frame.size.height *0.5);
    }else{
        self.center = self.viewCenter;
    }
    
    if (autoDismiss) {
        //开启自动消失
        [self performSelector:@selector(dismissAnimate) withObject:nil afterDelay:1.9];
    }
}

//带有动画的消失
- (void)dismissAnimate
{
    [self dismissWithAnimate:YES time:0.5];
}

//animate：是否带有动画，time：动画的时间
- (void)dismissWithAnimate:(BOOL)animate time:(CGFloat)time
{
    if (animate == NO || time < 0.01) {
        //没有动画
        //移除弹出记录
        [[[self class] messageDic] removeObjectForKey:self.message];
        [self removeFromSuperview];//移除视图
    }else{
        [UIView animateWithDuration:time animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            //移除弹出记录
            [[[self class] messageDic] removeObjectForKey:self.message];
            [self removeFromSuperview];//移除视图
        }];
    }
}

@end
