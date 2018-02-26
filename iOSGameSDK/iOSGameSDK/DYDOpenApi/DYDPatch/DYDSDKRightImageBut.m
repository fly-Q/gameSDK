//
//  DYDSDKRightImageBut.m
//  Demo_SDK
//
//  Created by 邱明 on 16/12/1.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKRightImageBut.h"

@implementation DYDSDKRightImageBut

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    NSString *title = self.butTitle;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(0, [UIFont systemFontOfSize:15].lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    CGFloat allW = rect.size.width + 1 + 15;
    
    return CGRectMake((contentRect.size.width - allW) / 2.0, 0, rect.size.width + 1, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    NSString *title = self.butTitle;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(0, [UIFont systemFontOfSize:15].lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    CGFloat allW = rect.size.width + 1 + 18;
    
    return CGRectMake((contentRect.size.width - allW) / 2.0 + rect.size.width + 1 + 5, (contentRect.size.height - 13) / 2.0, 13, 13);
}

@end
