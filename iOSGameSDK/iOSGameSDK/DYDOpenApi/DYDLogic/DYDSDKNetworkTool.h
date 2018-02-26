//
//  DYDSDKNetworkTool.h
//  Demo_urlsession
//
//  Created by 邱明 on 16/12/20.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <UIKit/UIKit.h>

//测试接口
//static const NSString *kDYDBaseUrl = @"http://gametest.diyidan.net/g0.3/";
//static const NSString *kDYDImageUrl = @"http://image.diyidan.net";

//正式接口
static const NSString *kDYDBaseUrl = @"https://gameapi.diyidan.net/g0.3/";
static const NSString *kDYDImageUrl = @"http://image.diyidan.net";

//网络请求成功回调，object:请求来的数据,code:200为成功
typedef void(^DYDSDKNetworkSuccessBlock)(id object, NSInteger code, NSDictionary *otherData);
//网络请求失败回调
typedef void(^DYDSDKNetworkFailureBlock)(NSError *error);

@interface DYDSDKNetworkTool : NSObject

+ (NSURLSessionDataTask *)dydsdk_get_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure;


+ (NSURLSessionDataTask *)dydsdk_post_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure;

+ (NSURLSessionDataTask *)dydsdk_delete_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure;

+ (NSURLSessionDataTask *)dydsdk_put_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure;


//保存cookie
+ (void)dyd_saveCookies;

//加载cookie
+ (void)dyd_loadCookies;

//移除cookies
+ (void)dyd_removeCookies;

//下载图片，沙盒有缓存就取沙盒里的  useCache是否使用缓存
+ (void)dyd_downloadImageWithUrl:(NSString *)imgUrl useCache:(BOOL)useCache success:(void(^)(UIImage *img))success failure:(void(^)())failure;

+ (NSString *)dyd_getAuthorization;

@end
