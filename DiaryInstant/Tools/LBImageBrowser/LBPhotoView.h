//
//  LBPhotoView.h
//  Suppliers
//
//  Created by liubo on 16/11/12.
//  Copyright © 2016年 wanshenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBPhotoViewDelegate <NSObject>

//点击图片时，隐藏图片浏览器
-(void)tapHiddenPhotoView;

@end

@interface LBPhotoView : UIView

/*
 * 是否展示保存按钮
 */
@property (nonatomic, assign) BOOL isShowSaveBtn;

/**
 *  添加的图片
 */
@property(nonatomic, strong) UIImageView *imageView;
//2.
/**
 *  代理
 */
@property(nonatomic, assign) id<LBPhotoViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)photoUrl;

-(id)initWithFrame:(CGRect)frame withPhotoImage:(UIImage *)image;


@end
