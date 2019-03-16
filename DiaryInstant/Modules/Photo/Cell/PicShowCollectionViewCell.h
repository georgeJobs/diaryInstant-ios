//
//  PicShowCollectionViewCell.h
//  DiaryInstant
//
//  Created by George on 2019/3/14.
//  Copyright © 2019 George. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PicShowModel.h"

@protocol PicShowCollectionViewCellDelegate <NSObject>
/*
 * 点击选择图片按钮事件
 */
-(void)clickSelectedBtnWithInteger:(NSInteger)integer;

@end

@interface PicShowCollectionViewCell : UICollectionViewCell

@property(nonatomic,assign)NSInteger indexPathRow;

@property(nonatomic,strong)UIImage *showImage;

@property(nonatomic,assign)id<PicShowCollectionViewCellDelegate>delegate;

-(void)loadInterfaceWithModel:(PicShowModel*)picModel;

@end
