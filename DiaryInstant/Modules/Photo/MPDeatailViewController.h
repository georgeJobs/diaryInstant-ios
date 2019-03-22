//
//  MPDeatailViewController.h
//  DiaryInstant
//
//  Created by George on 2019/3/14.
//  Copyright © 2019 George. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPDeatailViewController : UIViewController

@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *timeStamp;
@property(nonatomic,strong) NSString *timeleft;
@property(nonatomic,strong) NSString *topic;
@property(nonatomic,assign) BOOL isPhoto;

@end

NS_ASSUME_NONNULL_END
