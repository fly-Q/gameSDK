//
//  DYDSDKHexagonImageView.m
//
//  Created by 邱明 on 17/1/3.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKHexagonImageView.h"

@interface DYDSDKHexagonImageView ()


@end

@implementation DYDSDKHexagonImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect hexagnoRect = self.bounds;
        //绘制一个六边形的layer作为边界
        CALayer *hexagonLayer = [CALayer layer];
        hexagonLayer.frame = hexagnoRect;
        CAShapeLayer * shapLayer = [CAShapeLayer layer];
        shapLayer.path = [self getCGPath:hexagnoRect.size.width];
        self.layer.mask = shapLayer;

        self.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void)addRedFrame
{
    CGRect hexagnoRect = self.bounds;
    //上面贴一个小圈
    CAShapeLayer *borderShap = [CAShapeLayer layer];
    borderShap.lineWidth = 7.5;
    borderShap.path = [self getCGPath:hexagnoRect.size.width];
    borderShap.strokeColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0].CGColor;
    borderShap.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:borderShap];
}

- (void)addRedFrameWithWidth:(CGFloat)width
{
    CGRect hexagnoRect = self.bounds;
    //上面贴一个小圈
    CAShapeLayer *borderShap = [CAShapeLayer layer];
    borderShap.lineWidth = width;
    borderShap.path = [self getCGPath:hexagnoRect.size.width];
    borderShap.strokeColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0].CGColor;
    borderShap.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:borderShap];
}

- (CGPathRef)getCGPath:(CGFloat)viewWidth
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [[UIColor whiteColor] setStroke];
    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    [path closePath];
    return path.CGPath;
}

@end
