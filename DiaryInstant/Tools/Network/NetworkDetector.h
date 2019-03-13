//
//  NetworkDetector.h
//  letvRemoteControl
//
//  Created by sunlantao on 15/6/11.
//  Copyright (c) 2015年 sunlantao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworkReachabilityManager.h"

extern NSString * const kNotificationNetworkStatusChanged;

typedef NS_ENUM(NSInteger, NetworkType){
    kNetworkGPRS,
    kNetworkEDGE,
    kNetworkWCDMA,
    kNetworkCDMA1x,
    kNetworkHSDPA,
    kNetworkHSUPA,
    kNetworkHRPD,
    kNetworkLTE,
};

@protocol LRCNetworkDelegate<NSObject>

- (void)didNetworkChanged:(AFNetworkReachabilityStatus)state;

@end

@interface NetworkDetector : NSObject

@property(nonatomic, assign) AFNetworkReachabilityStatus status;
@property (nonatomic, assign) NetworkType type;

+ (instancetype)detector;

- (void)listenNetWorkStatus;

@end
