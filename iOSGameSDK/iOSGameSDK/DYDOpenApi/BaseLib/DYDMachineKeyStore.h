//
//  DYDMachineKeyStore.h
//
//  Created by 邱明 on 16/12/22.
//  Copyright © 2016年 邱明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYDMachineKeyStore : NSObject

+ (DYDMachineKeyStore *)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;

- (BOOL)isMachineKeyExsit;
- (NSString*)getMachineKey;
- (BOOL)setMachineKey:(NSString*)strKey;
- (NSString*) createAndStoreMachinKey;
- (BOOL) deleteMachineKey;

@end
