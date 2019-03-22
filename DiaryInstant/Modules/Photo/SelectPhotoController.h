//
//  SelectPhotoController.h
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicShowModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ShowSelecedPicBlock)(NSString *resourceId);
@interface SelectPhotoController : UIViewController

@property(nonatomic,copy)ShowSelecedPicBlock showPicBlock;
@end

NS_ASSUME_NONNULL_END
