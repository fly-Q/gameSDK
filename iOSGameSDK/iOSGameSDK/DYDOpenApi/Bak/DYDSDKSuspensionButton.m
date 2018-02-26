//
//  DYDSDKSuspensionButton.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/28.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKSuspensionButton.h"
#import "DYDSettingHeader.h"

@interface DYDSDKSuspensionButton ()
/** 上一次点击的位置 */
@property (nonatomic, assign) CGPoint lastPoint;
/** 按下的位置 */
@property (nonatomic, assign) CGPoint firstPoint;
/** 上一次的center */
@property (nonatomic, assign) CGPoint lastCenter;

@end

@implementation DYDSDKSuspensionButton

+ (DYDSDKSuspensionButton *)sdk_creatSuspensionButtonWithAction:(SEL)action target:(id)target
{
    DYDSDKSuspensionButton *but = [DYDSDKSuspensionButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [but setBackgroundImage:DYDImage(@"dydsdk_suspensionBut_back") forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:but selector:@selector(sdk_deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    return but;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    DYDSDKSuspensionButton *but = [super buttonWithType:buttonType];
    if (but) {
        //为防止与点击事件冲突, 不用touch方法, 用平移手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:but action:@selector(panGestureRecognizerAction:)];
        [but addGestureRecognizer:pan];
        but.frame = CGRectMake(-25, 100, 50, 50);
        but.alpha = 0.6;
        [but addTarget:but action:@selector(showSuspensionButEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return but;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.lastPoint = [sender translationInView:self.superview];
            self.lastCenter = self.center;
            self.alpha = 1;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [sender translationInView:self.superview];
            float centerX = _lastCenter.x + point.x - _lastPoint.x;
            float centerY = _lastCenter.y + point.y - _lastPoint.y;
            
            float minCenterX = self.frame.size.width * 0.5;
            float minCenterY = self.frame.size.height * 0.5;
            float maxCenterX = self.superview.frame.size.width - self.frame.size.width * 0.5;
            float maxCenterY = self.superview.frame.size.height - self.frame.size.height * 0.5;
            
            if (centerX < minCenterX) {
                centerX = minCenterX;
            } else if (centerX > maxCenterX) {
                centerX = maxCenterX;
            }
            if (centerY < minCenterY) {
                centerY = minCenterY;
            } else if (centerY > maxCenterY) {
                centerY = maxCenterY;
            }
            self.center = CGPointMake(centerX , centerY);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:  //划着划着突然中止
        {
            float x = self.frame.origin.x;
            if (self.frame.origin.x + self.frame.size.width * 0.5 < self.superview.frame.size.width * 0.5) {
                x = 0;
            } else {
                x = self.superview.frame.size.width - self.frame.size.width;
            }
            [UIView animateWithDuration:0.12 animations:^{
                self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                [self performSelector:@selector(standardSuspensionButFrame) withObject:nil afterDelay:1];
            }];
            
        }
            break;
        default:
            break;
    }
    
}

- (void)standardSuspensionButFrame
{
    if (self.frame.origin.x < CGRectGetWidth([UIScreen mainScreen].bounds) *0.5) {
        //在左边
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(-25, self.frame.origin.y, 50, 50);
        } completion:^(BOOL finished) {
            self.alpha = 0.6;
        }];
    }else{
        //在右边
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 25, self.frame.origin.y, 50, 50);
        } completion:^(BOOL finished) {
            self.alpha = 0.6;
        }];
    }
}

- (void)showSuspensionButEvent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.alpha = 1;
    if (self.frame.origin.x < 0) {
        //在左边躲着
        self.frame = CGRectMake(0, self.frame.origin.y, 50, 50);
    }else if(self.frame.origin.x + 25 + 1 > CGRectGetWidth([UIScreen mainScreen].bounds)){
        //在右边躲着
        self.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 50, self.frame.origin.y, 50, 50);
    }
    [self performSelector:@selector(standardSuspensionButFrame) withObject:nil afterDelay:1];
}

- (void)sdk_deviceOrientationDidChangeNotification:(NSNotification*)noti
{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
//        NSLog(@"竖屏");
        if (self.frame.origin.x + 25 + 2 > CGRectGetWidth([UIScreen mainScreen].bounds)) {//位置超出屏宽
            CGFloat x = CGRectGetWidth([UIScreen mainScreen].bounds) - 25;
            self.frame = CGRectMake(x, self.frame.origin.y, 50, 50);
        }
        
        if (self.frame.origin.x + 50 < CGRectGetWidth([UIScreen mainScreen].bounds) && self.frame.origin.x > 2) {
            //小于屏宽一定距离的情况
            CGFloat x = CGRectGetWidth([UIScreen mainScreen].bounds) - 25;
            self.frame = CGRectMake(x, self.frame.origin.y, 50, 50);
        }
        
    } else {
        //横屏
//        NSLog(@"横屏");
        if (self.frame.origin.y + self.frame.size.height > CGRectGetHeight([UIScreen mainScreen].bounds)) {
            CGFloat y = CGRectGetHeight([UIScreen mainScreen].bounds) - self.frame.size.height;
            self.frame = CGRectMake(self.frame.origin.x, y, 50, 50);
        }
        if (self.frame.origin.x + 50 > CGRectGetWidth([UIScreen mainScreen].bounds)) {//位置超出屏宽
            CGFloat x = CGRectGetWidth([UIScreen mainScreen].bounds) - 25;
            self.frame = CGRectMake(x, self.frame.origin.y, 50, 50);
        }
        if (self.frame.origin.x + 50 < CGRectGetWidth([UIScreen mainScreen].bounds) && self.frame.origin.x > 2) {
            //小于屏宽一定距离的情况
            CGFloat x = CGRectGetWidth([UIScreen mainScreen].bounds) - 25;
            self.frame = CGRectMake(x, self.frame.origin.y, 50, 50);
        }
    }
}


@end
