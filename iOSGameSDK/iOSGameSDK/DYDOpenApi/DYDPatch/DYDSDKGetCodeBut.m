//
//  DYDSDKGetCodeBut.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/20.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKGetCodeBut.h"
#import "DYDDataManager.h"
#import "DYDSDKCommonUICreater.h"

@interface DYDSDKGetCodeBut ()

//点击回调
@property (nonatomic, copy) DYDSDKGetCodeButBlock callBack;
/** 可点击的尺寸位置 */
@property (nonatomic, assign) CGRect orignFrame;

@end

@implementation DYDSDKGetCodeBut

+ (DYDSDKGetCodeBut *)dyd_creatGetCodeButWithFrame:(CGRect)frame callBack:(DYDSDKGetCodeButBlock)callBack
{
    DYDSDKGetCodeBut *getCodeBut = [DYDSDKGetCodeBut buttonWithType:UIButtonTypeCustom];
    getCodeBut.callBack = callBack;
    getCodeBut.orignFrame = frame;
    getCodeBut.frame = frame;
    
    //开始监听重新获取验证码的时间
    if ([DYDDataManager shareDYDDataManager].getCodeTime == 0) {
        //等于0，可以马上获取验证码
        getCodeBut.enabled = YES;
        getCodeBut.layer.borderWidth = 1;
        getCodeBut.layer.borderColor = [UIColor whiteColor].CGColor;
        getCodeBut.frame = getCodeBut.orignFrame;
    }else{
        //不等于0，不能马上开始请求验证码
        getCodeBut.frame = CGRectMake(CGRectGetMaxX(getCodeBut.orignFrame) - CGRectGetHeight(getCodeBut.orignFrame), CGRectGetMinY(getCodeBut.orignFrame), CGRectGetHeight(getCodeBut.orignFrame), CGRectGetHeight(getCodeBut.orignFrame));
        getCodeBut.enabled = NO;
        getCodeBut.layer.cornerRadius = CGRectGetHeight(getCodeBut.orignFrame) * 0.5;
        getCodeBut.layer.masksToBounds = YES;
        getCodeBut.layer.borderWidth = 0;
        getCodeBut.layer.borderColor = [UIColor whiteColor].CGColor;
        getCodeBut.layer.borderColor = [UIColor colorWithRed:125 / 255.0 green:125 / 255.0 blue:125 / 255.0 alpha:1.0].CGColor;
        //更新时间
        [getCodeBut setTitle:[NSString stringWithFormat:@"%zd", [DYDDataManager shareDYDDataManager].getCodeTime] forState:UIControlStateDisabled];
        //开始监听剩余时间变化
        [getCodeBut performSelector:@selector(listenGetCodeTime) withObject:nil afterDelay:1];
    }
    
    return getCodeBut;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    DYDSDKGetCodeBut *getCodeBut = [super buttonWithType:buttonType];
    if (getCodeBut) {
//        getCodeBut.layer.cornerRadius = 4.5;
//        getCodeBut.layer.masksToBounds = YES;
        getCodeBut.layer.borderColor = [UIColor colorWithRed:246 / 255.0 green:95 / 255.0 blue:109 / 255.0 alpha:1.0].CGColor;
        [getCodeBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getCodeBut setTitle:@"获取" forState:UIControlStateNormal];
//        [getCodeBut setTitleColor:[UIColor colorWithRed:125 / 255.0 green:125 / 255.0 blue:125 / 255.0 alpha:1.0] forState:UIControlStateDisabled];
        getCodeBut.titleLabel.font = [UIFont systemFontOfSize:13.5];
        
        [getCodeBut addTarget:getCodeBut action:@selector(getCodeButAction) forControlEvents:UIControlEventTouchUpInside];
        
        [getCodeBut setBackgroundImage:[DYDSDKCommonUICreater createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [getCodeBut setBackgroundImage:[DYDSDKCommonUICreater createImageWithColor:[UIColor colorWithRed:1.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0]] forState:UIControlStateDisabled];
    }
    return getCodeBut;
}

//监听获取验证码的剩余时间
- (void)listenGetCodeTime
{
    NSInteger time = [DYDDataManager shareDYDDataManager].getCodeTime;
    if (time == 0) {
        //时间到了可以重新发送了
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        //变回按钮的状态
        [self setTitle:@"00" forState:UIControlStateDisabled];
        self.frame = self.orignFrame;
        self.layer.cornerRadius = 0;
        self.layer.borderWidth = 1;
        //可点击
        self.enabled = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        self.enabled = NO;
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        [self setTitle:[NSString stringWithFormat:@"%.2zd", time] forState:UIControlStateDisabled];
        [self performSelector:@selector(listenGetCodeTime) withObject:nil afterDelay:1];
    }
}

//点击获取验证码
- (void)getCodeButAction
{
    if (self.callBack) {
        BOOL clickRes = self.callBack();
        //不管结果，直接
        
        if (clickRes) {
            //点击回调YES
            //赋值60，开始计时
            [DYDDataManager shareDYDDataManager].getCodeTime = 60;//60开始计时
            self.enabled = NO;
            [self setTitle:@"60" forState:UIControlStateDisabled];
            self.frame = CGRectMake(CGRectGetMaxX(self.orignFrame) - CGRectGetHeight(self.orignFrame), CGRectGetMinY(self.orignFrame), CGRectGetHeight(self.orignFrame), CGRectGetHeight(self.orignFrame));
            self.layer.cornerRadius = CGRectGetHeight(self.orignFrame) *0.5;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 0;
            self.layer.borderColor = [UIColor colorWithRed:125 / 255.0 green:125 / 255.0 blue:125 / 255.0 alpha:1.0].CGColor;
            [self performSelector:@selector(listenGetCodeTime) withObject:nil afterDelay:1];
        }else{
            //点击回调NO
            //未开始请求验证码
        }
    }
}



@end
