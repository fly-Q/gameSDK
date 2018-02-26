//
//  DYDSDKGetCodeBut.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/20.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^DYDSDKGetCodeButBlock)();

@interface DYDSDKGetCodeBut : UIButton

//初始化，frame:尺寸。callBack:点击的回调
+ (DYDSDKGetCodeBut *)dyd_creatGetCodeButWithFrame:(CGRect)frame callBack:(DYDSDKGetCodeButBlock)callBack;

@end
