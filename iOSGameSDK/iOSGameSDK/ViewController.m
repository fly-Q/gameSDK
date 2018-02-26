//
//  ViewController.m
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "ViewController.h"
#import "DYDLoginHeader.h"

@interface ViewController ()<DYDSDKCallBackDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tokenLab;
@property (weak, nonatomic) IBOutlet UIButton *but1;
@property (weak, nonatomic) IBOutlet UIButton *but2;
@property (weak, nonatomic) IBOutlet UIButton *but3;
@property (weak, nonatomic) IBOutlet UIButton *but4;
@property (weak, nonatomic) IBOutlet UIButton *but5;
@property (weak, nonatomic) IBOutlet UIButton *but6;
@property (weak, nonatomic) IBOutlet UIButton *but7;
@property (weak, nonatomic) IBOutlet UIButton *but8;
@property (weak, nonatomic) IBOutlet UIButton *but9;

@end

@implementation ViewController

- (void)setupButUI
{
    [self.but1 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but2 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but3 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but4 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but5 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but6 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but7 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but8 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
    [self.but9 setBackgroundImage:[[UIImage imageNamed:@"DYDOpenApi.bundle/dydsdk_button_back_white"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:42 / 255.0 green:41 / 255.0 blue:43 / 255.0 alpha:1.0];
    
//    [DYDLoginHeader registerDYDWithAppId:@"1234"];
    [DYDLoginHeader dyd_setCallBackDelegate:self];
    
    [self setupButUI];
    
    [DYDLoginHeader dyd_checkLoginUserWithLoginSuccess:^(DYDSDKUserEntity *loginUserE) {
        self.tokenLab.text = [NSString stringWithFormat:@"自动登录：%@", loginUserE.nickName];
        NSString *uidStr = @(loginUserE.userId).stringValue;
        NSLog(@"%@", uidStr);
    } loginFailure:^(DYDSDKCheckUserResult checkResult) {
        switch (checkResult) {
            case DYDSDKCheckUserResultNoUser:
            {
                self.tokenLab.text = @"没有检测到用户";
            }
                break;
            case DYDSDKCheckUserResultInvalidToken:
            {
                self.tokenLab.text = @"用户token失效";
            }
                break;
            case DYDSDKCheckUserResultNetError:
            {
                self.tokenLab.text = @"网络错误，自动登录失败";
            }
                break;
                
            default:
                break;
        }
    }];
}

//登录
- (IBAction)loginButAction:(id)sender {
    if ([DYDLoginHeader dyd_getCurrentUser]) {
        //已经登录的有账号了
        self.tokenLab.text = @"你已经登录了";
        return;
    }
    [DYDLoginHeader dyd_login];
}

//检查登录
- (IBAction)checkLoginAction:(id)sender {
   DYDSDKUserEntity *currentUserE = [DYDLoginHeader dyd_getCurrentUser];
    if (currentUserE) {
        self.tokenLab.text = [NSString stringWithFormat:@"当前用户：%@", currentUserE.nickName];
    }else{
        self.tokenLab.text = @"当前未登录";
    }
}

- (IBAction)verifyBut:(id)sender {
    [DYDLoginHeader dyd_verifyTokenSuccess:^(BOOL result, DYDSDKUserEntity *userE) {
        if (result) {
            self.tokenLab.text = @"登录有效！";
        }else{
            self.tokenLab.text = @"登录失效!";
        }
    } failure:^{
        self.tokenLab.text = @"验证token失败!";
    }];
}

- (IBAction)uploadRoleButAction:(id)sender {
    if ([DYDLoginHeader dyd_getCurrentUser] == nil) {
        self.tokenLab.text = @"未登录，上传角色失败";
        return;
    }
    
}

- (IBAction)logout:(id)sender {
    if ([DYDLoginHeader dyd_getCurrentUser] == nil) {
        self.tokenLab.text = @"你尚未登录";
        return;
    }
    [DYDLoginHeader dyd_logout];
}

- (IBAction)uploadBellwarAction:(id)sender {
    
    if ([DYDLoginHeader dyd_getCurrentUser] == nil) {
        self.tokenLab.text = @"未登录，上传对战失败";
        return;
    }
    [DYDLoginHeader dyd_uploadBattleDataWithRoleId:@"1" stage:@"2" zoneId:@"3" zoneName:nil battleNo:nil starNumber:nil isSuccess:nil mode:nil exp:nil gains:nil success:^{
        self.tokenLab.text = @"上传对战数据成功";
    } failure:^{
        
    }];
}

- (IBAction)getTokenButAction:(id)sender {
    NSString *currentToken = [DYDLoginHeader dyd_getToken];
    if (currentToken == nil || currentToken.length == 0) {
        //未获取到有效的token
        self.tokenLab.text = @"未获取到有效的Token";
    }else{
        self.tokenLab.text = currentToken;
    }
}

//支付
- (IBAction)payAction:(id)sender {
    
}
//上传角色信息
- (IBAction)gotoSubareaAction:(id)sender {
    if ([DYDLoginHeader dyd_getCurrentUser] == nil) {
        self.tokenLab.text = @"未登录，上传角色信息失败";
        return;
    }
    [DYDLoginHeader dyd_uploadRoleDataWithRoleId:@"1" roleName:@"2" roleLevel:@"3" roleZoneId:@"4" roleZoneName:@"5" roleBalance:@"6" roleVipLevel:@"7" rolePartyName:@"8" roleScene:@"9" roleExp:@"10" success:^{
        self.tokenLab.text = @"上传角色数据成功";
    } failure:^{
        
    }];
}
//悬浮球
- (IBAction)suspensionBut:(id)sender {
    if (nil == [DYDLoginHeader dyd_getCurrentUser]) {
        self.tokenLab.text = @"您还没有登录！";
        return;
    }
    [DYDLoginHeader dyd_showSuspensionFunctionMenu];
}

#pragma mark - DYDSDKCallBackDelegate
//登录成功
- (void)dyd_loginFinishWithResult:(DYDSDKLoginResult)result userE:(DYDSDKUserEntity *)userE
{
    switch (result) {
        case DYDSDKLoginResultSuccess:
        {
            //登录成功
            self.tokenLab.text = [NSString stringWithFormat:@"昵称：%@", userE.nickName];
        }
            break;
        case DYDSDKLoginResultCancel:
        {
            //用户取消登录，此状态下userE为nil
            self.tokenLab.text = @"用户取消登录";
        }
            break;
        case DYDSDKLoginResultFailure:
        {
            //登录失败，目前在内部处理，不回调改结果
            self.tokenLab.text = @"登录失败";
        }
            break;
            
        default:
            break;
    }
    //登录成功回调
}

//退出登录
- (void)dyd_logoutResult:(BOOL)result
{
    //退出登录回调
    self.tokenLab.text = @"退出登录！";
    [DYDLoginHeader dyd_login];
}

/**
 * 切换账号出口
 * 点击了切换账号，退出了登录状态
 */
- (void)dyd_changeAccountLogoutSuccess
{
    self.tokenLab.text = @"点击了切换账号";
}

@end
