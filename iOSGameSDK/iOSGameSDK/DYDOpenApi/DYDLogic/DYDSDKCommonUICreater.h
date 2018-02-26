//
//  DYDSDKCommonUICreater.h
//  iOSGameSDK
//
//  Created by 邱明 on 16/12/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYDSDKCommonUICreater : NSObject

+ (UITextField *)creatTextFiledWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate;

+ (UIView *)creatTextFiledBaseViewWithFrame:(CGRect)frame;

/** 颜色转成image图片 */
+ (UIImage *)createImageWithColor:(UIColor*)color;

/** 注册按钮 */
+ (UIButton *)creatRegisterAndLoginButWithFrame:(CGRect)frame action:(SEL)action title:(NSString *)title target:(id)target;

@end
