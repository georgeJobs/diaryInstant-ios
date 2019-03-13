//
//  CXMProgressView.m
//  MBProgressHud_Demo
//
//  Created by 陈小明 on 2016/12/12.
//  Copyright © 2016年 bitauto. All rights reserved.
//

#import "CXMProgressView.h"
#import "AppDelegate.h"

@interface CXMProgressView()

@end


@implementation CXMProgressView

+ (void)showTextWithCircle:(NSString *)aText{
    
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
        hud.label.numberOfLines = 0;
        
        // Set the label text.
        hud.label.text = aText;
    });
    
}
+ (void)showText:(NSString *)aText{
    
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        
        // Move to bottm center.
        // hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        // Set the label text.
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
    });
    
}

+(void)dismissLoading{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [MBProgressHUD hideHUDForView:[self getCurrentViewController].view animated:YES];
    });
    
}
+(void)showErrorText:(NSString *)aText{
    
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
        
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeCustomView;
        // Set an image view with a checkmark.
        UIImage *image = [[UIImage imageNamed:@"progressView_error@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        
        hud.customView =complateView;
        
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        
        [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
        
    });
    
    
}
+ (void)showSuccessText:(NSString *)aText{
    
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
        
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeCustomView;
        // Set an image view with a checkmark.
        UIImage *image = [[UIImage imageNamed:@"progressView_success@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        
        hud.customView =complateView;
        
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:[self displayDurationForString:aText]];
    });
    
}
// 根据 提示文字字数，判断 HUD 显示时间
+ (NSTimeInterval)displayDurationForString:(NSString*)string
{
    if(ValidStr(string)){
        
        return MAX((float)string.length*0.06 + 0.5, 2.0);
    }
    
    return 1;
}

+(void)showText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        
        NSTimeInterval time = [self displayDurationForString:aText];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                if(complete ==nil){
                    return ;
                }
                complete();
            });
        });
        
    });
    
}
+(void)showErrorText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
        
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeCustomView;
        // Set an image view with a checkmark.
        UIImage *image = [[UIImage imageNamed:@"progressView_error@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        
        hud.customView =complateView;
        
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        
        NSTimeInterval time = [self displayDurationForString:aText];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                if(complete ==nil){
                    return ;
                }
                complete();
            });
        });
        
    });
}
+(void)showSuccessText:(NSString *)aText hideComplete:(ProgressHideComplete)complete{
    
    [self dismissLoading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getCurrentViewController].view animated:YES];
        
        // Set the custom view mode to show any view.
        hud.mode = MBProgressHUDModeCustomView;
        // Set an image view with a checkmark.
        UIImage *image = [[UIImage imageNamed:@"progressView_success@2x.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
        UIImageView *complateView =[[UIImageView alloc] initWithImage:image];
        
        hud.customView =complateView;
        
        hud.label.text = aText;
        hud.label.numberOfLines = 0;
        NSTimeInterval time = [self displayDurationForString:aText];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            sleep(time);
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                if(complete ==nil){
                    return ;
                }
                complete();
            });
        });
        
    });
    
}
// 获取当前显示页面的根视图控制器
+ (UIViewController *)getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)getCurrentViewController{
    
    UIViewController* currentViewController = [self getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}

@end
