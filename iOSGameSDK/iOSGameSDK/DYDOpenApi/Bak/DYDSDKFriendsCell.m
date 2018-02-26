//
//  DYDSDKFriendsCell.m
//  iOSGameSDK
//
//  Created by 邱明 on 17/1/4.
//  Copyright © 2017年 邱明. All rights reserved.
//

#import "DYDSDKFriendsCell.h"
#import "DYDSDKHexagonImageView.h"
#import "DYDSettingHeader.h"

@interface DYDSDKFriendsCell ()

//头像
@property (nonatomic, strong) DYDSDKHexagonImageView *avatarIV;
/** 昵称 */
@property (nonatomic, strong) UILabel *userNameLab;
/** friend:速度杀我 */
@property (nonatomic, strong) UILabel *label2;
/** genner */
@property (nonatomic, strong) UIImageView *sexIV;
/** 邀请按钮 */
@property (nonatomic, strong) UIButton *inviteBut;

@end

@implementation DYDSDKFriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.avatarIV = [[DYDSDKHexagonImageView alloc] initWithFrame:CGRectMake(16.5, 6.5, 35, 40)];
        [self addSubview:self.avatarIV];
        
        CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat screenH = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat cellW = screenH < screenW ? (screenH - 10) : (screenW - 10);
        
        //姓名
        self.userNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.userNameLab.textColor = [UIColor whiteColor];
        self.userNameLab.font = [UIFont systemFontOfSize:15];
        self.userNameLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.userNameLab];
        self.userNameLab.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLab
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:6.5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLab
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.avatarIV
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:7.5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLab
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:21]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.userNameLab
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:cellW - CGRectGetMaxX(self.avatarIV.frame) - 7.5 - 57 - 15 - 21 - 5]];
        
        //性别
        self.sexIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.sexIV];
        self.sexIV.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sexIV
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.userNameLab
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sexIV
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.userNameLab
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sexIV
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.userNameLab
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.sexIV
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.sexIV
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                          constant:0]];
        
        
        //速度杀我显示
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarIV.frame) + 7.5, CGRectGetMaxY(self.avatarIV.frame) - 16.5, cellW - CGRectGetMaxX(self.avatarIV.frame) - 7.5 - 57 - 15 - 5, 16.5)];
        self.label2.textColor = [UIColor whiteColor];
        self.label2.textAlignment = NSTextAlignmentLeft;
        self.label2.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.label2];
        
        //邀请按钮
        self.inviteBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.inviteBut.frame = CGRectMake(cellW - 57 - 15, 15.5, 57, 21.5);
        [self.inviteBut setBackgroundImage:DYDImage(@"dydsdk_button_redRound") forState:UIControlStateNormal];//正常使用红色框
        [self.inviteBut setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];//邀请之后使用无图片
        [self.inviteBut setTitle:@"邀请" forState:UIControlStateNormal];
        [self.inviteBut setTitle:@"已邀请" forState:UIControlStateDisabled];
        self.inviteBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.inviteBut];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 57, cellW, 1)];
        bottomLineView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:59 / 255.0 alpha:1.0];
        [self addSubview:bottomLineView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
