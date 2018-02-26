//
//  DYDSDKLookFriendsView.m
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/4.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKLookFriendsView.h"
#import "DYDSDKBurstButtonsView.h"
#import "DYDSDKFriendsCell.h"
#import "DYDSDKDataRequstTool.h"
#import "DYDSettingHeader.h"

#define cellId NSStringFromClass([DYDSDKFriendsCell class])

@interface DYDSDKLookFriendsView ()<DYDSDKBurstButtonsViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

/** 标题显示 */
@property (nonatomic, strong) UILabel *titleLab;
/** 分段控制按钮 */
@property (nonatomic, strong) DYDSDKBurstButtonsView *controlBut;
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *friendSV;
/** tableView数组 */
@property (nonatomic, strong) NSMutableArray *tableViewAryM;

@end

@implementation DYDSDKLookFriendsView

+ (DYDSDKLookFriendsView *)creatSDKLookFriendsView
{
    CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenH = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat width = 0;
    width = screenH < screenW ? (screenH - 10) : (screenW - 10);
    
    DYDSDKLookFriendsView *lookFriendsView = [[DYDSDKLookFriendsView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    
    return lookFriendsView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundIV.image = DYDImage(@"dydsdk_lookFriends_back");
        self.logoBaseIV.hidden = YES;
        
        CGFloat titleRightGap = 50;
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleRightGap, 11.5, CGRectGetWidth(frame) - titleRightGap *2, 21)];
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = @"查看弹友";
        [self addSubview:self.titleLab];
        
        //控制按钮
        self.controlBut = [DYDSDKBurstButtonsView creatSDKBurstButtonsViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame) + 20, frame.size.width, 28) buttons:@[@"相互关注", @"我的粉丝"] delegate:self];
        [self addSubview:self.controlBut];
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.controlBut.frame), frame.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0];
        [self addSubview:lineView];
        
        //scrollView
        self.friendSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), frame.size.width, frame.size.height - CGRectGetMaxY(lineView.frame))];
        self.friendSV.delegate = self;
        self.friendSV.backgroundColor = [UIColor clearColor];
        self.friendSV.pagingEnabled = YES;
        self.friendSV.contentSize = CGSizeMake(frame.size.width *2, self.friendSV.frame.size.height);
        [self addSubview:self.friendSV];
        
        //创建两个tableView
        UITableView *xhgzTable = [self creatTableViewWithFrame:CGRectMake(0, 0, self.friendSV.frame.size.width, CGRectGetHeight(self.friendSV.frame))];
        [self.friendSV addSubview:xhgzTable];
        [self.tableViewAryM addObject:xhgzTable];
        UITableView *wdfsTable = [self creatTableViewWithFrame:CGRectMake(CGRectGetWidth(self.friendSV.frame), 0, CGRectGetWidth(self.friendSV.frame), CGRectGetHeight(self.friendSV.frame))];
        [self.friendSV addSubview:wdfsTable];
        [self.tableViewAryM addObject:wdfsTable];
        
        //请求数据
        
        [self getFriendsDataWithType:@"friends" perPage:50 page:1];
    }
    return self;
}

//type = @"friends"相互关注   type = @"fans"我的粉丝
- (void)getFriendsDataWithType:(NSString *)type perPage:(NSInteger)perPage page:(NSInteger)page
{
    [DYDSDKDataRequstTool sdk_get_friendsDataWithType:type perPage:perPage page:page];
}

- (UITableView *)creatTableViewWithFrame:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[DYDSDKFriendsCell class] forCellReuseIdentifier:cellId];
    tableView.rowHeight = 58;
    return tableView;
}

#pragma mark - DYDSDKBurstButtonsViewDelegate

/** 分段按钮点击在index下标位置 */
- (void)burstButton_clickAtIndex:(NSInteger)index
{
    [self.friendSV scrollRectToVisible:CGRectMake(self.friendSV.frame.size.width *index, 0, self.friendSV.frame.size.width, self.friendSV.frame.size.height) animated:YES];
}

#pragma mark - UIScrollViewDelegate
/** 视图滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.friendSV) {
        [self.controlBut relateScrollView:scrollView];//联动
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DYDSDKFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    return cell;
}

#pragma mark - 懒加载
- (NSMutableArray *)tableViewAryM
{
    if (!_tableViewAryM) {
        self.tableViewAryM = [NSMutableArray array];
    }
    return _tableViewAryM;
}

@end
