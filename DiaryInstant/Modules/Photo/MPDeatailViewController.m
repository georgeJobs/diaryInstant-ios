//
//  MPDeatailViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/14.
//  Copyright © 2019 George. All rights reserved.
//

#import "MPDeatailViewController.h"

@interface MPDeatailViewController ()

@end

@implementation MPDeatailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"From: %@",self.userName];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).offset(-200);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = [NSString stringWithFormat:@"Time Stamp: %@",self.timeStamp];
    [label1 sizeToFit];
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).offset(-150);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = [NSString stringWithFormat:@"Time Left: %@",self.timeleft];
    [label2 sizeToFit];
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).offset(-100);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.content] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
    imageView.hidden = !self.isPhoto;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH-100 );
        make.height.mas_equalTo(SCREEN_WIDTH-100);
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(50);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = [NSString stringWithFormat:@"Topic: %@",self.topic];
    [label3 sizeToFit];
    label3.font = [UIFont systemFontOfSize:15];
    label3.hidden = self.isPhoto;
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).offset(-50);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = [NSString stringWithFormat:@"Content: %@",self.content];
    [label4 sizeToFit];
    label4.font = [UIFont systemFontOfSize:15];
    label4.hidden = self.isPhoto;
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"OK" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(imageView.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
}
-(void) okClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
