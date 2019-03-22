//
//  NoteViewController.h
//  DiaryInstant
//
//  Created by George on 2019/3/12.
//  Copyright © 2019 George. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NoteSelecedPicBlock)(NSString *resourceId);
@interface NoteViewController : UIViewController
@property(nonatomic,assign) BOOL isMainCall;
@property(nonatomic,copy)NoteSelecedPicBlock noteBlock;
@end

NS_ASSUME_NONNULL_END
