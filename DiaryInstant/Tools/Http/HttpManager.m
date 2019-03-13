//
//  HttpManager.m
//  Buyers
//
//  Created by 陈小明 on 2016/12/14.
//  Copyright © 2016年 wanshenglong. All rights reserved.
//

#import "HttpManager.h"
#import "UIImage+Resize.h"


@interface HttpManager (){
    
    NSOperationQueue *_downloadQueue;
}

@end

@implementation HttpManager

- (void)dealloc{
    
    [[NetworkDetector detector] removeObserver:self forKeyPath:@"status"];
}

+ (instancetype)sharedInstance{

    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] initWithServer:kBuyersHttpsServer];
    });
    
    return instance;
    
}

- (id)initWithServer:(NSString *)server{
    
    if (self = [super init]){
        
        // http
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:server]];
        self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

        /*
        self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        //.设置证书模式
        NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"xman_cert_file" ofType:@"cer"];
        NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
        self.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
        // 客户端是否信任非法证书
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        [self.manager.securityPolicy setValidatesDomainName:NO];
       */
        
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        // 修改是否为Josn模式 默认都加
        if(appdelegate.isJsonRequest == NO){

            self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        }
        
        self.manager.requestSerializer.timeoutInterval = 10.f;
    //    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];

       // "Content-Type" = "application/json;charset=UTF-8";
        // 网络模式监听
        [[NetworkDetector detector] addObserver:self
                                     forKeyPath:@"status"
                                        options:NSKeyValueObservingOptionNew
                                        context:nil];
    }
    
    return self;
}

- (NSURLSessionDataTask *)getWithCmd:(NSString *)cmd
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(NSURLSessionDataTask *, id))success dataWrong:(void (^)(NSInteger, NSString *))dataWrong failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{


    if (ValidStr(cmd)) {
    
        if ([NetworkDetector detector].status == AFNetworkReachabilityStatusNotReachable){
            
            if(failure){
                
                failure(nil, [NSError errorWithDomain:kNetworkError code:4041 userInfo:nil]);
            }
        }
        
//        if (![AppDelegate shareAppDelegate].isCurrentLoginStatus) {// 不是登录状态下,所有接口访问都需要上传cookie
//            
//            NSString *cookies = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCookies"];
//            
//            if (ValidStr(cookies)) {
//                
//                [self.manager.requestSerializer setValue:cookies forHTTPHeaderField:@"Cookie"];
//                [self.manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//            }
//        }
//
        
        NSURLSessionDataTask *operation = [_manager GET:cmd parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [CXMProgressView dismissLoading];

            if (!ValidDict(responseObject)) {
                
                [CXMProgressView showErrorText:Server_Return_Exception_Data];
                
                return ;
            }

            NSLog(@"url====%@",task.currentRequest.URL);
            NSDictionary *dic = (NSDictionary*)responseObject;
            NSDictionary *newDict = [NSDictionary changeType:dic];

            NSString *errCodeStr = [newDict objectForKey:@"errorCode"];
            NSString *errorMsg = [newDict objectForKey:@"errorMsg"];
            
            NSInteger  status = [errCodeStr integerValue];
            NSLog(@"errCodeStr==%@ errorCodeStr===%@",errCodeStr,errorMsg);
            
            if(status == 0){
                
                success(task,newDict);
                
            }
            else if (status == kHttpRequestStatusTokenLoseEfficacy){
            
                if (self.request_error_block){
                    
                    self.request_error_block((HttpRequestStatus)status);
                }
                
                return ;
            }else if(status ==KHttpRequestStatusPermFerBiden){
                
                if (self.request_error_block){
                    
                    self.request_error_block((HttpRequestStatus)status);
                }
                
                return ;
            }else{

                [CXMProgressView dismissLoading];
                if(ValidStr(errorMsg)){
                
                    [CXMProgressView showErrorText:errorMsg];
                    if(dataWrong){
                        dataWrong(status,errorMsg);
                    }else{
                        
                        [CXMProgressView showErrorText:errorMsg];
                    }
                }
            }
            
        } failure:failure];
        
        return operation;
    }
    else {
        
        return [self.manager GET:@"" parameters:nil progress:nil success:success failure:failure];
    }

}

- (NSURLSessionDataTask *)postWithCmd:(NSString *)cmd
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(NSURLSessionDataTask *, id))success dataWrong:(void (^)(NSInteger, NSString *))dataWrong failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{


    if (ValidStr(cmd)) {
        
        if ([NetworkDetector detector].status == AFNetworkReachabilityStatusNotReachable){
            
            if(failure){
                failure(nil, [NSError errorWithDomain:kNetworkError code:4041 userInfo:nil]);
            }
        }
        
//        if (![AppDelegate shareAppDelegate].isCurrentLoginStatus) {// 不是登录状态下,所有接口访问都需要上传cookie
//            
//            NSString *cookies = [[NSUserDefaults standardUserDefaults] objectForKey:@"userCookies"];
//            
//            if (ValidStr(cookies)) {
//             
//                [self.manager.requestSerializer setValue:cookies forHTTPHeaderField:@"Cookie"];
//                [self.manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//            }
//        }
        
        NSURLSessionDataTask *operation = [self.manager POST:cmd parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [CXMProgressView dismissLoading];

            
            NSLog(@"URL====%@",task.currentRequest.URL);
            if (!ValidDict(responseObject)) {
                
                [CXMProgressView showErrorText:Server_Return_Exception_Data];
                
                return ;
            }
            
            NSDictionary *dic = (NSDictionary*)responseObject;
            //json表示获取到的带有NULL对象的json数据
            
            NSLog(@"url====%@",task.currentRequest.URL);
            NSDictionary *newDict = [NSDictionary changeType:dic];
            NSLog(@"newDict===%@",newDict);
            NSString *errCodeStr = [newDict objectForKey:@"errorCode"];
            NSString *errorMsg = [newDict objectForKey:@"errorMsg"];
            
            NSInteger  status = [errCodeStr integerValue];
            NSLog(@"errCodeStr==%@ errorCodeStr===%@",errCodeStr,errorMsg);

            if(status ==0){
                    
                success(task,newDict);
            }
            else if (status == kHttpRequestStatusTokenLoseEfficacy){
                
                if (self.request_error_block){
                    
                    self.request_error_block((HttpRequestStatus)status);
                }
                
                return ;
            }else if(status ==KHttpRequestStatusPermFerBiden){
            
                if (self.request_error_block){
                    
                    self.request_error_block((HttpRequestStatus)status);
                }
                
                return ;

            }else{
    
                [CXMProgressView dismissLoading];
                if(ValidStr(errorMsg)){
                    
                    [CXMProgressView showErrorText:errorMsg];
                    dataWrong(status,errorMsg);
                }
                
            }
            
        } failure:failure];
        
        return operation;
    }
    else {
        
        return [self.manager POST:@"" parameters:nil progress:nil success:success failure:failure];
    }
}
- (NSURLSessionDataTask *)postUpDataImageWithCmd:(NSString *)cmd
                                      parameters:(NSDictionary *)parameters
                                       imageData:(NSArray*)imageArr
                                         success:(void (^)(NSURLSessionDataTask *, id))success dataWrong:(void (^)(NSInteger, NSString *))dataWrong failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    
    
    //  NSLog(@"url=====%@",self.manager.baseURL);
    NSURLSessionDataTask *operation = [self.manager POST:cmd parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageArr.count; i++) {
            
            UIImage *image = imageArr[i];
            
            // 按照比例处理图片
            UIImage *sizeImage = [UIImage handleImage:image withSize:CGSizeMake(720/2, 720/2)];
            
            NSData *imageData = UIImageJPEGRepresentation(sizeImage,0.5f);// 该改变照片的大小 100k->50K
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [CXMProgressView dismissLoading];
        
        
        NSLog(@"URL====%@",task.currentRequest.URL);
        if (!ValidDict(responseObject)) {
            
            [CXMProgressView showErrorText:Server_Return_Exception_Data];
            
            return ;
        }
        
        NSDictionary *dic = (NSDictionary*)responseObject;
        //json表示获取到的带有NULL对象的json数据
        
        NSLog(@"url====%@",task.currentRequest.URL);
        NSDictionary *newDict = [NSDictionary changeType:dic];
        NSLog(@"newDict===%@",newDict);
        NSString *errCodeStr = [newDict objectForKey:@"errorCode"];
        NSString *errorMsg = [newDict objectForKey:@"errorMsg"];
        
        NSInteger  status = [errCodeStr integerValue];
        NSLog(@"errCodeStr==%@ errorCodeStr===%@",errCodeStr,errorMsg);
        
        if(status ==0){
            
            success(task,newDict);
        }
        else if (status == kHttpRequestStatusTokenLoseEfficacy){
            
            if (self.request_error_block){
                
                self.request_error_block((HttpRequestStatus)status);
            }
            
            return ;
        }else if(status ==KHttpRequestStatusPermFerBiden){
            
            if (self.request_error_block){
                
                self.request_error_block((HttpRequestStatus)status);
            }
            
            return ;
            
        }else{
            
            [CXMProgressView dismissLoading];
            if(ValidStr(errorMsg)){
                
                [CXMProgressView showErrorText:errorMsg];
                dataWrong(status,errorMsg);
            }
            
        }
        
    } failure:failure];
    
    return operation;
    
}

- (void)download:(NSString *)url completionHandler:(void (^)(NSURL *location, NSURLResponse *response, NSError *error))completionHandler{
    
    if (!_downloadQueue)
        _downloadQueue = [[NSOperationQueue alloc] init];
    
    [_downloadQueue addOperationWithBlock:^{
        NSURLSessionConfiguration * configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url]
                                                    completionHandler:completionHandler];
        [task resume];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]){
        
        AFNetworkReachabilityStatus status = [NetworkDetector detector].status;
        switch (status){
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                [self.manager.operationQueue setSuspended:YES];
                [_downloadQueue setSuspended:YES];
                
            }
                break;
            default:
            {
                [self.manager.operationQueue setSuspended:NO];
                [_downloadQueue setSuspended:NO];
            }
                break;
        }
    }
}

@end
