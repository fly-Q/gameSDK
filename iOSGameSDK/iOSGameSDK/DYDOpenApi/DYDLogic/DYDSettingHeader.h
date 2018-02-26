//
//  DYDSettingHeader.h
//  Demo_SDK
//
//  Created by 邱明 on 16/11/30.
//  Copyright © 2016年 邱明. All rights reserved.
//

#ifndef DYDSettingHeader_h
#define DYDSettingHeader_h

#define DYDScreenW ([UIScreen mainScreen].bounds.size.width)
#define DYDScreenH ([UIScreen mainScreen].bounds.size.height)
#define DYDSystemVersion ([[UIDevice currentDevice].systemVersion doubleValue])

#define kDYDColor [UIColor colorWithRed:(246)/255.0 green:(95)/255.0 blue:(109)/255.0 alpha:1]

#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define DYDSDKGamePassValureKey @"com.diyidan.gameSdk"
#define DYDAPPScheme @"diyidanOpenApiV1"
#define DYDSDKVersion @"1.0"
#define DYDSDKDYDPassValureKey @"cn.roc.diyidan"

#define DYDAppLoginSuccessNotificate @"diyidanAppLoginSuccess"

#define DYDImage(img) [UIImage imageNamed:[@"DYDOpenApi.bundle" stringByAppendingPathComponent:img]]

//#define DYDSDKAppKey @"SLNsjD9DcgKhZ3y8"

#endif /* DYDSettingHeader_h */
