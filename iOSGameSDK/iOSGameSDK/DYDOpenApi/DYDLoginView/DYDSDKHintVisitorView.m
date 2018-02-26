//
//  DYDSDKHintVisitorView.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/2.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKHintVisitorView.h"
#import "DYDSDKRightImageBut.h"
#import "DYDSDKCommonUICreater.h"
#import "DYDSettingHeader.h"

#define kDYDColor [UIColor colorWithRed:(246)/255.0 green:(95)/255.0 blue:(109)/255.0 alpha:1]

@interface DYDSDKHintVisitorView ()

/** 游客昵称 */
@property (nonatomic, strong) UILabel *nickNameLab;
/** 昵称 */
@property (nonatomic, copy) NSString * visitorName;

@end

@implementation DYDSDKHintVisitorView

+ (DYDSDKHintVisitorView *)creatHintVisitorViewWithVisitorName:(NSString *)visitorName
{
    DYDSDKHintVisitorView *visitorView = [[DYDSDKHintVisitorView alloc] initWithFrame:CGRectZero];
    visitorView.visitorName = visitorName;
    [visitorView constructUI];//搭建UI界面
    
    return visitorView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.cornerRadius = 9;
//        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, 300, 245);
    }
    return self;
}

/** 搭建UI界面 */
- (void)constructUI
{
    self.logoBaseIV.hidden = YES;
    //游客昵称
    NSMutableAttributedString *visitorNameAtrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"游客：%@", self.visitorName] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    [visitorNameAtrStr addAttribute:NSForegroundColorAttributeName value:kDYDColor range:NSMakeRange(0, visitorNameAtrStr.length)];
    [visitorNameAtrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0] range:NSMakeRange(0, 3)];
    NSMutableParagraphStyle *postListStyle = [[NSMutableParagraphStyle alloc] init];
    postListStyle.alignment = NSTextAlignmentCenter;
    [visitorNameAtrStr addAttribute:NSParagraphStyleAttributeName value:postListStyle range:NSMakeRange(0, visitorNameAtrStr.length)];
    self.nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, [UIFont systemFontOfSize:16].lineHeight)];
    [self addSubview:self.nickNameLab];
    self.nickNameLab.attributedText = visitorNameAtrStr;
    
    //提示语
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nickNameLab.frame) + 16, self.frame.size.width, [UIFont systemFontOfSize:15].lineHeight *2)];
    remindLab.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0];
    remindLab.font = [UIFont systemFontOfSize:15];
    remindLab.text = @"请尽快绑定第一弹账号\n避免游戏数据信息丢失";
    remindLab.numberOfLines = 0;
    remindLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:remindLab];
    
    //马上升级按钮
    UIButton *but = [DYDSDKCommonUICreater creatRegisterAndLoginButWithFrame:CGRectMake(18, CGRectGetMaxY(remindLab.frame) + 30, self.frame.size.width - 36, 45) action:@selector(updateButAction) title:@"马上绑定" target:self];
    [self addSubview:but];
    
    //切换按钮
    UIButton *changeBut = [self creatRightImageButWithFrame:CGRectMake(30, 10 + CGRectGetMaxY(but.frame), (self.frame.size.width - 60) *0.5, 36) title:@"切换" action:@selector(changeButAction)];
    [self addSubview:changeBut];
    
    //进入按钮
    UIButton *comeInBut = [self creatRightImageButWithFrame:CGRectMake(self.frame.size.width * 0.5, CGRectGetMinY(changeBut.frame), CGRectGetWidth(changeBut.frame), 36) title:@"进入" action:@selector(comeInButAction)];
    [self addSubview:comeInBut];
    
    self.closeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBut.frame = CGRectMake(self.frame.size.width - 10 - 35, 10, 35, 35);
    [self.closeBut setImage:DYDImage(@"dydsdk_closeBut") forState:UIControlStateNormal];
    [self.closeBut addTarget:self action:@selector(closeButAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBut];
}

- (UIButton *)creatRightImageButWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action
{
    DYDSDKRightImageBut *but = [DYDSDKRightImageBut buttonWithType:UIButtonTypeCustom];
    but.butTitle = title;
    but.frame = frame;
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:15];
    [but setImage:DYDImage(@"dydsdk_rightArrow") forState:UIControlStateNormal];
    [but addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return but;
}

- (void)updateButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(hintVositorView_clickAcountUpdateBut)]) {
        [self.clickDelegate hintVositorView_clickAcountUpdateBut];
    }
}

- (void)changeButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(hintVositorView_clickChangeAccountBut)]) {
        [self.clickDelegate hintVositorView_clickChangeAccountBut];
    }
}

- (void)comeInButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(hintVositorView_clickComeinBut)]) {
        [self.clickDelegate hintVositorView_clickComeinBut];
    }
}

- (void)closeButAction
{
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(hintVositorView_clickCloseBut)]) {
        [self.clickDelegate hintVositorView_clickCloseBut];
    }
}

@end
