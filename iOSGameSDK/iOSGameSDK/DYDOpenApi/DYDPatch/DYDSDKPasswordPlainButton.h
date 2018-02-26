//
//  DYDSDKPasswordPlainButton.h
//  Demo_SDK
//
//  Created by 邱明 on 16/12/19.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DYDSDKPasswordPlainBlock)(BOOL isPlain);

@interface DYDSDKPasswordPlainButton : UIButton

+ (DYDSDKPasswordPlainButton *)dyd_creatPasswordPlainButWithFrame:(CGRect)frame callBack:(DYDSDKPasswordPlainBlock)callBack;

@end
