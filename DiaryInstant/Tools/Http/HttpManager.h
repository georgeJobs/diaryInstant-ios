//
//  HttpManager.h
//  Buyers
//
//  Created by 陈小明 on 2016/12/14.
//  Copyright © 2016年 wanshenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>
#import "NetworkDetector.h"

// 开发模式切换
//#define kBuyersDevelopment 0
// 预发布模式
//#define kBuyersPreDistribution 1
// 正式模式
#define kBuyerseDistribution 2

#if defined(kBuyersDevelopment)

#define kBuyersHttpsServer      @"http://39.106.109.237/med-biz/api/"
#define kLoginHttpsServer       @"http://39.106.109.237:8100/common-platform/"
#define KArticleHttpsServer     @"http://39.106.109.237/feedback/"

#elif defined(kBuyersPreDistribution)
#define kBuyersHttpsServer      @"http://39.106.109.237/med-biz/api/"
#define kLoginHttpsServer       @"http://39.106.109.237:8100/common-platform/"
#define KArticleHttpsServer     @"http://39.106.109.237/feedback/"


#else
#define kBuyersHttpsServer      @"http://di.leizhenxd.com/"
#define kLoginHttpsServer       @"http://39.106.109.237:8100/common-platform/"
//文章信息流 接口
#define KArticleHttpsServer     @"http://39.106.109.237/feedback/"

#endif

#define kNetworkError [NetworkDetector detector].status != AFNetworkReachabilityStatusNotReachable? @"请求失败": @"当前网络不可用,请检查网络设置"

typedef NS_ENUM(NSUInteger, HttpRequestResult){
   
    kHttpRequestResultNormal,
    kHttpRequestResultError,
    kHttpRequestResultNoMoreData,
    kHttpRequestResultNoValidData
};

typedef NS_ENUM(NSUInteger, HttpRequestStatus){
    
    kHttpRequestStatusNoSession = 1000,
    kHttpRequestStatusException = -1,// 系统异常
    kHttpRequestStatusSuccess = 0,// 成功
    kHttpRequestStatusFail = 1,// 失败

    kHttpRequestStatusArgumentInvalid = 2,// 参数错误,不符合接口要求
    kHttpRequestStatusDataUnAvailable = 3,// 数据不存在,无法获取
    kHttpRequestStatusDataHaveAvailable = 4,// 数据已存在,不能写入
    kHttpRequestStatusSIDInvalid = 6,// sid无效,参数签名有误
    kHttpRequestStatusAuthInvalid  = 7,// 登录状态失效,被另外手机登录过,需要重新登录
    kHttpRequestStatusTokenLoseEfficacy = 80000,//token失效
    KHttpRequestStatusPermFerBiden = 403 // 没有访问权限
    
};

typedef void (^request_error_block)(HttpRequestStatus error);

@interface HttpManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, copy) request_error_block request_error_block;

+ (instancetype)sharedInstance;

- (id)initWithServer:(NSString *)server;

/*
 * 通用post接口, 调用界面不用将cmd封装到parameter,此方法自动封装到一起
 * parameters:
 *      cmd: 操作命令,例如 注册, 登录, 获取列表
 *      parameters:post参数列表
 *      success:成功回调
 *      dataWrong: 服务区返回错误
 *      failure:失败回调
 * */
- (NSURLSessionDataTask *)postWithCmd:(NSString *)cmd
                           parameters:(NSDictionary *)parameters
                              success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                              dataWrong:(void (^)(NSInteger code,NSString *msg))dataWrong
                              failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

- (NSURLSessionDataTask *)getWithCmd:(NSString *)cmd
                          parameters:(NSDictionary *)parameters
                             success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                           dataWrong:(void(^)(NSInteger code,NSString *msg))dataWrong
                             failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

/*
 * 图片上传通用post接口, 调用界面不用将cmd封装到parameter,此方法自动封装到一起
 * parameters:
 *      cmd: 操作命令,例如 注册, 登录, 获取列表
 *      parameters:post参数列表
 *      imageArr :要上传的图片数组
 *      success:成功回调
 *      dataWrong: 服务区返回错误
 *      failure:失败回调
 * */
- (NSURLSessionDataTask *)postUpDataImageWithCmd:(NSString *)cmd
                                      parameters:(NSDictionary *)parameters
                                       imageData:(NSArray*)imageArr
                                         success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success dataWrong:(void (^)(NSInteger code, NSString *msg))dataWrong failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;


- (void)download:(NSString *)url completionHandler:(void ( ^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler;

@end
