//
//  DYDDataManager.m
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDDataManager.h"
#import "DYDMachineKeyStore.h"
#import "DYDSDKSuspensionButton.h"
#import "DYDSDKFunctionMenuView.h"

@implementation DYDDataManager

+ (DYDDataManager *)shareDYDDataManager
{
    static DYDDataManager *sdk_dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk_dataManager = [DYDDataManager new];
    });
    return sdk_dataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat screenH = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat minW = screenW < screenH ? screenW : screenH;
        if (minW > 400) {
            self.viewScale = 1.15;
        }else if (minW > 370){
            self.viewScale = 1.0;
        }else{
            self.viewScale = 0.88;
        }
    }
    return self;
}

- (void)setGetCodeTime:(NSInteger)getCodeTime
{
    if (getCodeTime == 60) {
        //如果等于60，开始计时
        _getCodeTime = getCodeTime;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(beginGetCodeTimer) withObject:nil afterDelay:1];
    }
}

//开始获取验证码计时
- (void)beginGetCodeTimer
{
    _getCodeTime--;
    if (_getCodeTime == 0) {
        //到底了
        
    }else{
        [self performSelector:@selector(beginGetCodeTimer) withObject:nil afterDelay:1];
    }
}

#pragma mark - 懒加载

- (NSString *)deviceId
{
    if (!_deviceId) {
        _deviceId = [[DYDMachineKeyStore sharedInstance] getMachineKey];
    }
    if (!_deviceId) {
        return @"";
    }
    return _deviceId;
}


@end
