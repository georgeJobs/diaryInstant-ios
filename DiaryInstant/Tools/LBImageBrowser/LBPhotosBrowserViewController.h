//
//  LBPhotosBrowserViewController.h
//  Suppliers
//
//  Created by liubo on 16/11/12.
//  Copyright © 2016年 wanshenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickDeleBtn_Block)(void);

//  功能描述：用于显示并浏览图片，添加了加载进度条功能
@interface LBPhotosBrowserViewController : UIViewController
//点击删除按钮操作
@property(copy,nonatomic)ClickDeleBtn_Block cliclDeleBtn;

/**
 *  接收图片数组，数组类型可以是url数组，image数组
 */
@property (nonatomic, strong) NSMutableArray *imgArr;
/**
 *  显示scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  显示下标
 */
@property (nonatomic, strong) UILabel *sliderLabel;
/**
 *  接收当前图片的序号,默认的是0
 */
@property (nonatomic, assign) NSInteger currentIndex;

/*
 * 传入的是URL的img数组，还是UIImage的img数组
 */
@property (nonatomic, assign) BOOL isURLImage;

/*
 * 是否按页滚动
 */
@property (nonatomic, assign) BOOL isPageScrolling;
/*
 * 是否展示保存按钮
 */
@property (nonatomic, assign) BOOL isShowSaveBtn;

/*
 * 是否展示删除
 */
@property (nonatomic, assign) BOOL isShowDeleBtn;
@end
