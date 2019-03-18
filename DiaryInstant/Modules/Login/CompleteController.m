//
//  CompleteController.m
//  DiaryInstant
//
//  Created by George on 2019/3/16.
//  Copyright © 2019 George. All rights reserved.
//

#import "CompleteController.h"

@interface CompleteController ()

@end

@implementation CompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Completed";
    UILabel *title=[[UILabel alloc]init];
    title.text=@"Congratulations!";
    [title sizeToFit];
    title.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(110);
        make.centerX.mas_equalTo(self.view);
    }];
    UILabel *text=[[UILabel alloc]init];
    text.text=[NSString stringWithFormat:@"Hello! %@",self.name];
    [text sizeToFit];
    text.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_top).offset(100);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *text2=[[UILabel alloc]init];
    text2.text=@"Your account has been successfully created";
    text2.textAlignment = NSTextAlignmentCenter;
    text2.lineBreakMode = NSLineBreakByWordWrapping;
    text2.numberOfLines = 0;
    text2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:text2];
    [text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(text.mas_top).offset(120);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"VIEW DIARY INSTANT" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(text2.mas_bottom).offset(150);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    // Do any additional setup after loading the view.
}
-(void)jumpClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
