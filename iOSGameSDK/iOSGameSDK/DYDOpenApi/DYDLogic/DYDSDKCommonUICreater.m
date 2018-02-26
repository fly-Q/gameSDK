//
//  DYDSDKCommonUICreater.m
//  iOSGameSDK
//
//  Created by 邱明 on 16/12/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKCommonUICreater.h"
#import "DYDSettingHeader.h"

@implementation DYDSDKCommonUICreater

+ (UITextField *)creatTextFiledWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate
{
    UITextField *textFiled = [[UITextField alloc] initWithFrame:frame];
    textFiled.font = [UIFont systemFontOfSize:15];
    textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    textFiled.delegate = delegate;
    textFiled.textColor = [UIColor whiteColor];
    return textFiled;
}

+ (UIView *)creatTextFiledBaseViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.0];
    //    view.layer.cornerRadius = 5;
    //    view.layer.masksToBounds = YES;
    UIImageView *baseViewIV = [[UIImageView alloc] initWithFrame:view.bounds];
    baseViewIV.image = DYDImage(@"dydsdk_textfiled_back");
    baseViewIV.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:baseViewIV];
    return view;
}

/** 颜色转成image图片 */
+ (UIImage *)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/** 注册按钮 */
+ (UIButton *)creatRegisterAndLoginButWithFrame:(CGRect)frame action:(SEL)action title:(NSString *)title target:(id)target
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = frame;
    [but addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:title forState:UIControlStateNormal];
    UIImage *butBack = [DYDImage(@"dydsdk_button_back_red") stretchableImageWithLeftCapWidth:20 topCapHeight:25];
    [but setBackgroundImage:butBack forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:17];
    //    but.layer.cornerRadius = 4;
    //    but.layer.masksToBounds = YES;
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return but;
}

@end
