//
//  AddResultViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/20.
//  Copyright © 2019 George. All rights reserved.
//

#import "AddResultViewController.h"
#import "MainViewController.h"

@interface AddResultViewController (){
    MBProgressHUD *_hud;
}

@end

@implementation AddResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =UIColor.whiteColor;
    self.title = @"Detail";
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"Topic: %@",self.topic];;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = [NSString stringWithFormat:@"File Size: %@",self.size];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.lineBreakMode = NSLineBreakByWordWrapping;
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(label.mas_bottom).offset(100);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = [NSString stringWithFormat:@"Time Stamp: %@",self.timpStamp];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.lineBreakMode = NSLineBreakByWordWrapping;
    label3.numberOfLines = 0;
    label3.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(label2.mas_bottom).offset(10);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(label3.mas_bottom).offset(150);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
}
-(void)backClick{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MainViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

@end
