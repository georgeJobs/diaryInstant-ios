//
//  FriendViewController.h
//  DiaryInstant
//
//  Created by George on 2019/3/12.
//  Copyright © 2019 George. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^FriendSelecedBlock)(NSString * friendId);
@interface FriendViewController : UIViewController
@property(nonatomic,assign) BOOL isMainCall;
@property(nonatomic,copy)FriendSelecedBlock friendBlock;

@end

NS_ASSUME_NONNULL_END
