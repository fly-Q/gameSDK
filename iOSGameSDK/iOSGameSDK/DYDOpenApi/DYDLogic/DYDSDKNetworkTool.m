//
//  DYDSDKNetworkTool.m
//  Demo_urlsession
//
//  Created by 邱明 on 16/12/20.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import "DYDSDKNetworkTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "DYDDataManager.h"
#import "DYDSettingHeader.h"

static NSString *kDYDUserDefaultsCookie = @"DYDCookie";
static NSString *kDYDNetVersionName = @"20161212";

@implementation DYDSDKNetworkTool

//保存cookie
+ (void)dyd_saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: kDYDUserDefaultsCookie];
    [defaults synchronize];
}

//加载cookie
+ (void)dyd_loadCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: kDYDUserDefaultsCookie]];
    
    //    NSArray *cookies = [FQDBManager loaclCookies];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    cookieStorage.cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}

//移除cookies
+ (void)dyd_removeCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    NSLog(@"移除cookie");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kDYDUserDefaultsCookie];
}

+ (NSURLSessionDataTask *)dydsdk_get_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure
{
    if (url == nil) {
        NSLog(@"url不能为空");
        return nil;
    }
    NSString *resUrl = nil;
    if (![url hasPrefix:@"http"]) {
        resUrl = [kDYDBaseUrl stringByAppendingString:url];
    }else{
        resUrl = url;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setValue:@"ios" forKey:@"appChannel"];
    [dic setValue:kDYDNetVersionName forKey:@"versionName"];
    resUrl = [self dyd_handleParameter:dic toUrl:resUrl];
    
    NSDictionary *headers = @{@"deviceId" : [DYDDataManager shareDYDDataManager].deviceId, @"AppId" : [DYDDataManager shareDYDDataManager].gs_appId, @"Authorization" : [self dyd_getAuthorization], @"Content-Type" : @"text/html"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];//get方法
    if (request == nil) {
        NSLog(@"request无效");
        return nil;
    }
    [request setAllHTTPHeaderFields:headers];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"text/javascript" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }else{
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
                NSDictionary *allHeaderFields = [r allHeaderFields];
                if ([allHeaderFields objectForKey:@"Set-Cookie"] || [allHeaderFields objectForKey:@"set-cookie"]) {
                    [self dyd_saveCookies];
                }
            }
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode != 200) {//结果不是成功状态，而且服务器并没有回应
                NSHTTPURLResponse *httpRsp = (NSHTTPURLResponse *)response;
                NSInteger statusCode = httpRsp.statusCode;
                //状态不是200，返回失败code
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"No domain" code:statusCode userInfo:nil]);
                    }
                });
                
            }else{
                NSError *jsonError = nil;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if (jsonError) {
                    NSLog(@"解析错误");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil, 0, nil);
                        }
                    });
                    
                }else{
                    NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                    NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
                    NSMutableDictionary *otherData = [NSMutableDictionary dictionary];
                    [otherData setObject:[jsonDic objectForKey:@"message"] forKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(dataDic, code, otherData);
                        }
                    });
                }
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionDataTask *)dydsdk_post_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure
{
    if (url == nil) {
        NSLog(@"url不能为空");
        return nil;
    }
    NSString *resUrl = [kDYDBaseUrl stringByAppendingString:url];
    NSDictionary *headers = @{@"deviceId" : [DYDDataManager shareDYDDataManager].deviceId, @"AppId" : [DYDDataManager shareDYDDataManager].gs_appId, @"Authorization" : [self dyd_getAuthorization], @"Content-Type" : @"application/x-www-form-urlencoded"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];//post方法
    if (request == nil) {
        NSLog(@"request无效");
        return nil;
    }
    [request setAllHTTPHeaderFields:headers];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setValue:@"ios" forKey:@"appChannel"];
    [dic setValue:kDYDNetVersionName forKey:@"versionName"];
    if (dic) {
        [request setHTTPBody:[self turnParamDataWithDic:dic]];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }else{
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
                NSDictionary *allHeaderFields = [r allHeaderFields];
                if ([allHeaderFields objectForKey:@"Set-Cookie"] || [allHeaderFields objectForKey:@"set-cookie"]) {
                    [self dyd_saveCookies];
                }
            }
            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode != 200) {//结果不是成功状态，而且服务器并没有回应
                NSHTTPURLResponse *httpRsp = (NSHTTPURLResponse *)response;
                NSInteger statusCode = httpRsp.statusCode;
                //状态不是200，返回失败code
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"No domain" code:statusCode userInfo:nil]);
                    }
                });
                
            }else{
                NSError *jsonError = nil;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if (jsonError) {
                    NSLog(@"解析错误");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil, 0, nil);
                        }
                    });
                    
                }else{
                    NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                    NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
                    NSMutableDictionary *otherData = [NSMutableDictionary dictionary];
                    [otherData setObject:[jsonDic objectForKey:@"message"] forKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(dataDic, code, otherData);
                        }
                    });
                }
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionDataTask *)dydsdk_delete_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure
{
    if (url == nil) {
        NSLog(@"url不能为空");
        return nil;
    }
    
    NSString *resUrl = [kDYDBaseUrl stringByAppendingString:url];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setValue:@"ios" forKey:@"appChannel"];
    [dic setValue:kDYDNetVersionName forKey:@"versionName"];
    resUrl = [self dyd_handleParameter:dic toUrl:resUrl];
    
    NSDictionary *headers = @{@"deviceId" : [DYDDataManager shareDYDDataManager].deviceId, @"AppId" : [DYDDataManager shareDYDDataManager].gs_appId, @"Authorization" : [self dyd_getAuthorization], @"Content-Type" : @"application/x-www-form-urlencoded"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"DELETE"];//delete方法
    if (request == nil) {
        NSLog(@"request无效");
        return nil;
    }
    [request setAllHTTPHeaderFields:headers];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }else{
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
                NSDictionary *allHeaderFields = [r allHeaderFields];
                if ([allHeaderFields objectForKey:@"Set-Cookie"] || [allHeaderFields objectForKey:@"set-cookie"]) {
                    [self dyd_saveCookies];
                }
            }
            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode != 200) {//结果不是成功状态，而且服务器并没有回应
                NSHTTPURLResponse *httpRsp = (NSHTTPURLResponse *)response;
                NSInteger statusCode = httpRsp.statusCode;
                //状态不是200，返回失败code
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"No domain" code:statusCode userInfo:nil]);
                    }
                });
                
            }else{
                NSError *jsonError = nil;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if (jsonError) {
                    NSLog(@"解析错误");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil, 0, nil);
                        }
                    });
                    
                }else{
                    NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                    NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
                    NSMutableDictionary *otherData = [NSMutableDictionary dictionary];
                    [otherData setObject:[jsonDic objectForKey:@"message"] forKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(dataDic, code, otherData);
                        }
                    });
                }
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionDataTask *)dydsdk_put_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(DYDSDKNetworkSuccessBlock)success failure:(DYDSDKNetworkFailureBlock)failure
{
    if (url == nil) {
        NSLog(@"url不能为空");
        return nil;
    }
    NSString *resUrl = [kDYDBaseUrl stringByAppendingString:url];
    NSDictionary *headers = @{@"deviceId" : [DYDDataManager shareDYDDataManager].deviceId, @"AppId" : [DYDDataManager shareDYDDataManager].gs_appId, @"Authorization" : [self dyd_getAuthorization], @"Content-Type" : @"application/x-www-form-urlencoded"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"PUT"];//put方法
    if (request == nil) {
        NSLog(@"request无效");
        return nil;
    }
    [request setAllHTTPHeaderFields:headers];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [dic setValue:@"ios" forKey:@"appChannel"];
    [dic setValue:kDYDNetVersionName forKey:@"versionName"];
    if (dic) {
        [request setHTTPBody:[self turnParamDataWithDic:dic]];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(error);
                }
            });
        }else{
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
                NSDictionary *allHeaderFields = [r allHeaderFields];
                if ([allHeaderFields objectForKey:@"Set-Cookie"] || [allHeaderFields objectForKey:@"set-cookie"]) {
                    [self dyd_saveCookies];
                }
            }
            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode != 200) {//结果不是成功状态，而且服务器并没有回应
                NSHTTPURLResponse *httpRsp = (NSHTTPURLResponse *)response;
                NSInteger statusCode = httpRsp.statusCode;
                //状态不是200，返回失败code
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"No domain" code:statusCode userInfo:nil]);
                    }
                });
                
            }else{
                NSError *jsonError = nil;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if (jsonError) {
                    NSLog(@"解析错误");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil, 0, nil);
                        }
                    });
                    
                }else{
                    NSDictionary *dataDic = [jsonDic objectForKey:@"data"];
                    NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
                    NSMutableDictionary *otherData = [NSMutableDictionary dictionary];
                    [otherData setObject:[jsonDic objectForKey:@"message"] forKey:@"message"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(dataDic, code, otherData);
                        }
                    });
                }
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (void)dyd_downloadImageWithUrl:(NSString *)imgUrl useCache:(BOOL)useCache success:(void(^)(UIImage *img))success failure:(void(^)())failure
{
    NSString *resImgUrl = nil;
    if ([imgUrl hasPrefix:@"http"]) {
        //带有头
        resImgUrl = imgUrl;
    }else{
        resImgUrl = [kDYDImageUrl stringByAppendingPathComponent:imgUrl];
    }
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imgPath = [cachePath stringByAppendingPathComponent:[imgUrl lastPathComponent]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (useCache && [fileManager fileExistsAtPath:imgPath]) {
        //使用缓存并且有缓存
        UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
        if (success) {
            success(image);
        }
    }else{
        //没有，或者不使用缓存，下载图片
       [self dydsdk_image_connectWebWithUrl:imgUrl parameter:nil success:^(NSData *data) {
           UIImage *image = [UIImage imageWithData:data];
           if (image) {
               [data writeToFile:imgPath atomically:YES];
           }
           if (success) {
               success(image);
           }
       } failure:^{
           if (failure) {
               failure();
           }
       }];
    }
}

+ (NSURLSessionDataTask *)dydsdk_image_connectWebWithUrl:(NSString *)url parameter:(NSDictionary *)parameter success:(void(^)(NSData *data))success failure:(void(^)())failure
{
    if (url == nil) {
        NSLog(@"url不能为空");
        return nil;
    }
    NSString *resUrl = url;
    NSDictionary *headers = @{@"deviceId" : [DYDDataManager shareDYDDataManager].deviceId, @"AppId" : [DYDDataManager shareDYDDataManager].gs_appId, @"Authorization" : [self dyd_getAuthorization], @"Content-Type" : @"text/html"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];//get方法
    if (request == nil) {
        NSLog(@"request无效");
        return nil;
    }
    [request setAllHTTPHeaderFields:headers];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/javascript" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    //    [request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    //    [request addValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    if (parameter) {
        [request setHTTPBody:[self turnParamDataWithDic:parameter]];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure();
                }
            });
        }else{
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(data);
                });
            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSData *)turnParamDataWithDic:(NSDictionary *)dic
{
    NSMutableString *parStr = [NSMutableString new];
    for (NSString *keyPath in dic) {
        NSString *keyStr = [dic objectForKey:keyPath];
        [parStr appendString:[NSString stringWithFormat:@"%@=%@&", keyPath, keyStr]];
    }
    if (parStr.length > 0) {
        [parStr deleteCharactersInRange:NSMakeRange(parStr.length - 1, 1)];
    }
    NSData *data = [[parStr copy] dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    if (plaintext == nil) {
        return @"";
    }
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

+ (NSString *)dyd_getAuthorization
{
    return [self hmac:[DYDDataManager shareDYDDataManager].gs_appId withKey:[DYDDataManager shareDYDDataManager].gs_appKey];
}

+ (NSString *)dyd_handleParameter:(NSDictionary *)param toUrl:(NSString *)url
{
    NSMutableString *paramStr = [[NSMutableString alloc] initWithString:url];
    if (param.allKeys.count > 0) {
        [paramStr appendString:@"?"];
        for (NSString *key in param) {
            NSString *value = [param objectForKey:key];
            [paramStr appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
        [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
    }
    return paramStr;
}

@end
