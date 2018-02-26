//
//  DYDSDKBackBaseView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKBackBaseView.h"
#import "DYDSettingHeader.h"

@implementation DYDSDKBackBaseView

- (void)setViewIndex:(NSInteger)viewIndex
{
    _viewIndex = viewIndex;
    if (viewIndex == 0) {
        
        if (self.closeBut == nil || self.closeBut.superview == nil) {
            self.closeBut = [UIButton buttonWithType:UIButtonTypeCustom];
            self.closeBut.frame = CGRectMake(self.frame.size.width - 10 - 35, 10, 35, 35);
            [self.closeBut setImage:DYDImage(@"dydsdk_closeBut") forState:UIControlStateNormal];
            [self.closeBut addTarget:self action:@selector(closeButAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.closeBut];
        }
        
        self.backBut.hidden = YES;
        self.closeBut.hidden = NO;//第一个视图一般显示关闭按钮
    }else{
        self.backBut.hidden = NO;
        self.closeBut.hidden = YES;//其余不显示关闭按钮
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundIV.image = [DYDImage(@"dydsdk_background_icon") stretchableImageWithLeftCapWidth:40 topCapHeight:27];
        [self addSubview:self.backgroundIV];
        
        
        self.logoBaseIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.logoBaseIV.image = DYDImage(@"dydsdk_logo");
        [self addSubview:self.logoBaseIV];
        self.logoBaseIV.frame = CGRectMake((300 - 97) *0.5, 18, 97, 32);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundIV.frame = self.bounds;
}

- (void)closeButAction
{
    if (self.baseViewDelegate && [self.baseViewDelegate respondsToSelector:@selector(baseView_clickCloseBut)]) {
        [self.baseViewDelegate baseView_clickCloseBut];
    }
}

@end
