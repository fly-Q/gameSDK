//
//  DYDSDKPasswordPlainButton.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/19.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKPasswordPlainButton.h"
#import "DYDSettingHeader.h"

@interface DYDSDKPasswordPlainButton ()

@property (nonatomic, copy) DYDSDKPasswordPlainBlock callBack;

@end

@implementation DYDSDKPasswordPlainButton

+ (DYDSDKPasswordPlainButton *)dyd_creatPasswordPlainButWithFrame:(CGRect)frame callBack:(DYDSDKPasswordPlainBlock)callBack
{
    DYDSDKPasswordPlainButton *button = [DYDSDKPasswordPlainButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.callBack = callBack;
    return button;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    DYDSDKPasswordPlainButton *but = [super buttonWithType:buttonType];
    if (but) {
        [but setImage:DYDImage(@"dydsdk_password_plain") forState:UIControlStateNormal];//默认密文
        [but setImage:DYDImage(@"dydsdk_password_cipher") forState:UIControlStateSelected];//明文显示
        [but addTarget:but action:@selector(passwordPlainChangeAction) forControlEvents:UIControlEventTouchUpInside];
        but.clipsToBounds = YES;
    }
    return but;
}

- (void)passwordPlainChangeAction
{
    if (self.callBack) {
        self.selected = !self.isSelected;
        BOOL isPlain = self.selected;//选中状态下是明文显示
        self.callBack(isPlain);//回调
    }
}

@end
