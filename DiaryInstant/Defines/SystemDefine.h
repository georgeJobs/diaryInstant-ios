//
//  SystemDefine.h
//  DiaryInstant
//
//  Created by George on 2019/3/7.
//  Copyright © 2019 George. All rights reserved.
//

#ifndef SystemDefine_h
#define SystemDefine_h

#pragma mark - 屏幕相关宏
#define     SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define     SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
#define     KScreenWidth    SCREEN_WIDTH
#define     KScreenHeight   SCREEN_HEIGHT
#define     IPhoneX_Height  812.0f

#define System_Version   [[UIDevice currentDevice] systemVersion].floatValue

// 导航栏颜色
#define NavigationBarBackgroundColor UIColorFromRGB(0x5677fc)

// 背景颜色
#define GeneralBackgroundColor UIColorFromRGB(0xf4f4f4)

#define isIPhoneX [UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f

#define TabBarHeight self.tabBarController.tabBar.frame.size.height
// 实际宽度
#define kActualWidth(width)      width*SCREEN_WIDTH/375
#define kActualHeight(height)    height*SCREEN_HEIGHT/667

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define      NAV_HEIGHT        ([UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.frame.size.height)

#pragma mark - 颜色
//常用函数
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//十六进制数字转换成颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define COLOR_NAV_ALPHA(a)  RGBACOLOR(70, 87, 120, a)

// 服务器数据返回异常数据
#define Server_Return_Exception_Data    @"数据异常,程序员正在努力修复中(｡ì _ í｡)"

#pragma mark - 数据类型判断
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
// 判断是否是字符串
#define ValidStr(f) StrValid(f)
// 判断是否是字典
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
// 判断是否是数组
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
// 判断是否是数字类型
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
// 判断是否是类
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
// 判断是否是数据流
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

#pragma mark - 打印日志
// DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

#pragma mark - 强弱引用模块
/**
 *  强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 *  调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 *  示例：
 *  @weakify(object)
 *  [obj block:^{
 *      @strongify(object)
 *      strong_object = something;
 *  }];
 */
#ifndef    weakify
#if __has_feature(objc_arc)
#define weakify(object)    autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object)    autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#endif
#ifndef    strongify
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
#endif
#endif

#endif /* SystemDefine_h */
