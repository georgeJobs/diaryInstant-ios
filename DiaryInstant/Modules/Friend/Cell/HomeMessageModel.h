//
//  HomeMessageModel.h
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeMessageModel : NSObject

@property(nonatomic,copy) NSString * arriveTime;
@property(nonatomic,copy) NSString * cell ;
@property(nonatomic,copy) NSString * clickTime;
@property(nonatomic,copy) NSString * content;
@property(nonatomic,copy) NSString * headImgUrl;
@property(nonatomic,copy) NSString * ID;
@property(nonatomic,copy) NSString * msgFrom;
@property(nonatomic,copy) NSString * msgType ;
@property(nonatomic,copy) NSString * pushTime;
//1-未读，2：已读
@property(nonatomic,copy) NSString * readStatus;
@property(nonatomic,copy) NSString * status;
@property(nonatomic,copy) NSString * uid;
@property(nonatomic,copy) NSString * usrType;
@property(nonatomic,copy) NSString * transferId;

@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * email;
@property(nonatomic,copy) NSString * profileUrl;

@end
