//
//  MainViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/12.
//  Copyright © 2019 George. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoViewController.h"
#import "NoteViewController.h"
#import "FriendViewController.h"
#import "HistoryViewController.h"
#import "MoreViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PhotoViewController *photo = [[PhotoViewController alloc]init];
    UIImage *image1 = [UIImage imageNamed:@"photo.png" ];
    photo.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"PHOTO" image:[image1  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[image1  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    NoteViewController *note= [[NoteViewController alloc]init];
    note.isMainCall = YES;
    UIImage *image2 = [UIImage imageNamed:@"note.png" ];
    note.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"NOTE" image:[image2  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[image2  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    FriendViewController *friend = [[FriendViewController alloc]init];
    friend.isMainCall = YES;
    UIImage *image3 = [UIImage imageNamed:@"friend.png" ];
    friend.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FRIEND" image:[image3  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[image3  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    HistoryViewController *history = [[HistoryViewController alloc]init];
    UIImage *image4 = [UIImage imageNamed:@"history.png" ];
    history.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"HISTORY" image:[image4  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[image4  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    MoreViewController * more = [[MoreViewController alloc]init];
    UIImage *image5 = [UIImage imageNamed:@"more.png" ];
    more.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"MORE" image:[image5  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[image5  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    self.viewControllers = @[photo,note,friend,history,more];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
