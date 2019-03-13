//
//  LoginViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/7.
//  Copyright © 2019 George. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import <Masonry.h>
#import "MainViewController.h"

@interface LoginViewController ()
@property (nonatomic,strong) UITextField *usrTextField;
@property (nonatomic,strong) UITextField *pwdText;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    _usrTextField = [[UITextField alloc]init];
    _usrTextField.borderStyle = UITextBorderStyleBezel;
    _usrTextField.text=@"lilei";
    
    [self.view addSubview:_usrTextField];
    [_usrTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(40);
    }];
    
    _pwdText = [[UITextField alloc]init];
    _pwdText.borderStyle = UITextBorderStyleBezel;
    _pwdText.secureTextEntry = YES;
    _pwdText.text=@"123";
    
    [self.view addSubview:_pwdText];
    [_pwdText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self->_usrTextField.mas_bottom).offset(40);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"LOGIN" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forgetPassBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self->_pwdText.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *photoBtn = [[UIButton alloc]init];
    photoBtn.backgroundColor=UIColorFromRGB(0x4a72e2);
    [photoBtn setTitle:@"Photo" forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(button.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void) jump{
    ViewController *view = [[ViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void) forgetPassBtnClcik{
    NSDictionary *dic=@{@"loginName":_usrTextField.text,@"password":_pwdText.text};
    [[HttpManager sharedInstance] postWithCmd:@"/api/user/login" parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {

        NSLog(@"responseObject===%@",responseObject);
        NSDictionary *imDic = [responseObject objectForKey:@"data"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:imDic[@"token"] forKey:@"token"];
        [defaults synchronize];
        
        MainViewController *deviceViewController = [[MainViewController alloc] init];
        //deviceViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:deviceViewController animated:YES];

    } dataWrong:^(NSInteger code, NSString *msg) {
        [CXMProgressView showErrorText:msg];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [CXMProgressView dismissLoading];
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //一但用了这个返回的那个responseObject就是NSData，如果不用就是简单的
//    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
//    NSDictionary *dic=@{@"loginName":@"lilei",@"password":@"123"};
//    [manager POST:@"http://di.leizhenxd.com/api/user/login" parameters:dic progress:nil success:
//     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//         NSDictionary *dict = (NSDictionary *)responseObject;
//
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         NSLog(@"请求失败--%@",error);
//     }];
}
@end
