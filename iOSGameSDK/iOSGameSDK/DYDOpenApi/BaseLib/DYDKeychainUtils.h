//
//  DYDKeychainUtils.h
//
//  Created by 邱明 on 16/12/22.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYDKeychainUtils : NSObject

+ (NSString *) getPasswordForUsername: (NSString *) username
                       andServiceName: (NSString *) serviceName
                                error: (NSError **) error;

+ (BOOL) storeUsername: (NSString *) username
           andPassword: (NSString *) password
        forServiceName: (NSString *) serviceName
        updateExisting: (BOOL) updateExisting
                 error: (NSError **) error;

+ (BOOL) deleteItemForUsername: (NSString *) username
                andServiceName: (NSString *) serviceName
                         error: (NSError **) error;

+ (BOOL) purgeItemsForServiceName:(NSString *) serviceName
                            error: (NSError **) error;

@end
