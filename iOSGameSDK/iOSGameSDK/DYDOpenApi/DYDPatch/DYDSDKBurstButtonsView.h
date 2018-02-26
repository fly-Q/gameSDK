//
//  DYDSDKBurstButtonsView.h
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/4.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DYDSDKBurstButtonsViewDelegate <NSObject>

/** 分段按钮点击在index下标位置 */
- (void)burstButton_clickAtIndex:(NSInteger)index;

@end

@interface DYDSDKBurstButtonsView : UIView

+ (DYDSDKBurstButtonsView *)creatSDKBurstButtonsViewWithFrame:(CGRect)frame buttons:(NSArray *)buttons delegate:(id<DYDSDKBurstButtonsViewDelegate>)delegate;

- (void)relateScrollView:(UIScrollView *)scrollView;

@end
