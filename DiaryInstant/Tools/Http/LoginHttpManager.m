//
//  LoginHttpManager.m
//  Buyers
//
//  Created by liubo on 17/1/9.
//  Copyright © 2017年 wanshenglong. All rights reserved.
//

#import "LoginHttpManager.h"

@implementation LoginHttpManager

+ (instancetype)sharedInstance{
    
    static dispatch_once_t token;
    static id instance = nil;
    dispatch_once(&token, ^{
        
        instance = [[self alloc] initWithServer:kLoginHttpsServer];
    });
    
    return instance;
}

@end
