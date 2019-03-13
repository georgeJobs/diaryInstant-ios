//
//  NetworkDetector.m
//  letvRemoteControl
//
//  Created by sunlantao on 15/6/11.
//  Copyright (c) 2015年 sunlantao. All rights reserved.
//

#import "NetworkDetector.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>  //为判断网络制式的主要文件
#import <CoreTelephony/CTCarrier.h> //添加获取客户端运营商 支持


NSString * const kNotificationNetworkStatusChanged = @"kNotificationNetworkStatusChanged";

@interface NetworkDetector()

@property (nonatomic, strong) CTTelephonyNetworkInfo *networkStatus;
@end

@implementation NetworkDetector

+ (instancetype)detector{
    static id instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (id)init{

    if (self = [super init]){
        _networkStatus = [[CTTelephonyNetworkInfo alloc]init];  //创建一个CTTelephonyNetworkInfo对象
        
        self.status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    }

    return self;
}

#pragma mark --
#pragma mark - 判断网络状态

- (void)listenNetWorkStatus {

    @weakify(self)
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [weak_self networkChanged:status];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}
- (void)setStatus:(AFNetworkReachabilityStatus)status{
    [self willChangeValueForKey:@"status"];
    _status = status;
    [self didChangeValueForKey:@"status"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkStatusChanged
                                                        object:self];
}

/*维护网络状态标志位*/
- (void)networkChanged:(AFNetworkReachabilityStatus)status {
    self.status = status;

    if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]){
        self.type = kNetworkGPRS;
    }else if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]){
        self.type = kNetworkEDGE;
    }else if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]){
        self.type = kNetworkWCDMA;
    }else if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]){
        self.type = kNetworkHSDPA;
    }else if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]){
        self.type = kNetworkHSUPA;
    }else if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        self.type = kNetworkCDMA1x;
    }else if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]){
        self.type = kNetworkHRPD;
    }else if ([_networkStatus.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]){
        self.type = kNetworkLTE;
    }

}

@end
