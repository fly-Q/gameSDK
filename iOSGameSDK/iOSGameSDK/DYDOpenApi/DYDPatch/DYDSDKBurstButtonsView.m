//
//  DYDSDKBurstButtonsView.m
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/4.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKBurstButtonsView.h"

@interface DYDSDKBurstButtonsView ()

/** 按钮（控件）数组 */
@property (nonatomic, strong) NSMutableArray *butAryM;
/** 按钮标题数组 */
@property (nonatomic, copy) NSArray *butTitlesAryI;
/** 下方滑动的线 */
@property (nonatomic, strong) UIView * slideLineView;
/** 下划线的初始X值 */
@property (nonatomic, assign) CGFloat lineOrignX;
/** 回调代理 */
@property (nonatomic, weak) id<DYDSDKBurstButtonsViewDelegate> delegate;

@end

@implementation DYDSDKBurstButtonsView

+ (DYDSDKBurstButtonsView *)creatSDKBurstButtonsViewWithFrame:(CGRect)frame buttons:(NSArray *)buttons delegate:(id<DYDSDKBurstButtonsViewDelegate>)delegate
{
    DYDSDKBurstButtonsView *burstView = [[DYDSDKBurstButtonsView alloc] initWithFrame:frame];
    burstView.butTitlesAryI = buttons;//存储标题
    burstView.delegate = delegate;
    [burstView constructUI];//搭建UI界面
    return burstView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//搭建UI界面
- (void)constructUI
{
    //俩按钮中间的间距
    CGFloat midGap = 56;
    CGFloat butW = 64;
    CGFloat leftGap = (self.frame.size.width - butW *self.butTitlesAryI.count - midGap *(self.butTitlesAryI.count - 1)) / 2;//左边的间距
    
    for (int i = 0; i < self.butTitlesAryI.count; i++) {
        NSString *butTitle = [self.butTitlesAryI objectAtIndex:i];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitle:butTitle forState:UIControlStateNormal];
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0] forState:UIControlStateSelected];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        but.frame = CGRectMake(leftGap + i *(midGap + butW), 0, butW, 21);
        but.tag = i;
        [but addTarget:self action:@selector(controlButClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:but];
        [self.butAryM addObject:but];
    }
    
    self.lineOrignX = leftGap;
    self.slideLineView = [[UIView alloc] initWithFrame:CGRectMake(self.lineOrignX, 21 + 4.5, butW, 2.5)];
    self.slideLineView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0];
    [self addSubview:self.slideLineView];
    [self changSelectAtIndex:0];
}

- (void)relateScrollView:(UIScrollView *)scrollView
{
    CGFloat changX = scrollView.contentOffset.x;//变化X达到一个宽度，slideView移动64 + 56 = 120
    self.slideLineView.frame = CGRectMake(changX *120 / self.frame.size.width + self.lineOrignX, self.slideLineView.frame.origin.y, self.slideLineView.frame.size.width, self.slideLineView.frame.size.height);
    
    NSInteger index = (NSInteger)(changX / self.frame.size.width + 0.5);
    [self changSelectAtIndex:index];
}

//切换到下标
- (void)changSelectAtIndex:(NSInteger)index
{
    for (int i = 0; i < self.butAryM.count; i++) {
        UIButton *but = [self.butAryM objectAtIndex:i];
        if (i == index) {
            but.selected = YES;
        }else{
            but.selected = NO;
        }
    }
}

//点击控制按钮
- (void)controlButClickAction:(UIButton *)sender
{
    NSInteger index = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(burstButton_clickAtIndex:)]) {
        [self.delegate burstButton_clickAtIndex:index];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)butAryM
{
    if (!_butAryM) {
        self.butAryM = [NSMutableArray array];
    }
    return _butAryM;
}

@end
