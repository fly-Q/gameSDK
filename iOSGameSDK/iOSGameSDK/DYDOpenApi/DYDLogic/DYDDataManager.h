//
//  DYDDataManager.h
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYDSDKUserEntity.h"
#import "DYDSDKCallBackDelegate.h"
@class DYDSDKSuspensionButton;

@interface DYDDataManager : NSObject

/** 实例 */
+ (DYDDataManager *)shareDYDDataManager;
/** 保存appId */
@property (nonatomic, copy) NSString * gs_appId;
/** 保存appKey */
@property (nonatomic, copy) NSString * gs_appKey;
/** app在第一弹上对应的scheme */
@property (nonatomic, copy) NSString * gs_scheme;

/** 重新获取验证码的时间 */
@property (nonatomic, assign) NSInteger getCodeTime;
/** 保存deviceId */
@property (nonatomic, copy) NSString * deviceId;

/** 保存登录的用户 */
@property (nonatomic, strong) DYDSDKUserEntity * loginUser;

/** 回调代理 */
@property (nonatomic, weak) id<DYDSDKCallBackDelegate> dyd_delegate;

/** scale */
@property (nonatomic, assign) CGFloat viewScale;

/** 上一次显示的View，如果上次弹出的View存在，把它移除 */
@property (nonatomic, weak) UIView * lastBaseView;

@end
