//
//  SystemMessageTableViewCell.h
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeMessageModel.h"

@interface SystemMessageTableViewCell : UITableViewCell

//@property(nonatomic,assign)NSInteger indexPathRow;

-(void)loadInterFaceWithModel:(HomeMessageModel*)model;

@end
