//
//  AddFriendViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/18.
//  Copyright © 2019 George. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Add Friend";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"username";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
