//
//  ArticleHttpManager.m
//  Smart Healthcare
//
//  Created by yiche_chenXming on 2018/3/15.
//  Copyright © 2018年 陈小明. All rights reserved.
//

#import "ArticleHttpManager.h"

@implementation ArticleHttpManager

+ (instancetype)sharedInstance{
    
    static dispatch_once_t token;
    static id instance = nil;
    dispatch_once(&token, ^{
        
        instance = [[self alloc] initWithServer:KArticleHttpsServer];
    });
    
    return instance;
}


@end
