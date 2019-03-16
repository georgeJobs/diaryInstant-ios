//
//  RegisterViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/16.
//  Copyright © 2019 George. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic,strong) UITextField *usrField;
@property (nonatomic,strong) UITextField *pwdField;
@property (nonatomic,strong) UITextField *repwdField;
@property (nonatomic,strong) UITextField *mobileField;
@property (nonatomic,strong) UITextField *emailField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    
    _usrField = [[UITextField alloc]init];
    _usrField.borderStyle = UITextBorderStyleBezel;
    
    [self.view addSubview:_usrField];
    [_usrField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(40);
    }];
    
    _pwdField = [[UITextField alloc]init];
    _pwdField.borderStyle = UITextBorderStyleBezel;
    _pwdField.secureTextEntry = YES;
    
    [self.view addSubview:_pwdField];
    [_pwdField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self->_usrTextField.mas_bottom).offset(40);
    }];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"DIARY INSTANT";
    [lable sizeToFit];
    lable.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(150);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"LOGIN" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self->_pwdText.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
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
