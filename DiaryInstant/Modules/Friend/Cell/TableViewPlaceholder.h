//
//  TableViewPlaceholder.h
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewPlaceholder : UIView

@property (nonatomic, copy) void(^reloadClickBlock)(void);

@property(nonatomic,copy) NSString *titleStr;
@end

