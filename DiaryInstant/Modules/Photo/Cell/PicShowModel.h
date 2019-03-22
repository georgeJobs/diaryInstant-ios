//
//  PicShowModel.h
//  DiaryInstant
//
//  Created by George on 2019/3/14.
//  Copyright © 2019 George. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicShowModel : NSObject

/*
 *大图
 */
@property(nonatomic,copy)NSString *content;
/*
 *时间
 */
@property(nonatomic,copy)NSString *createTime;
/*
 * code
 */
@property(nonatomic,copy)NSString *size;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *resourceId;


@end

NS_ASSUME_NONNULL_END
