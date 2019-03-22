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
#import "RegisterViewController.h"
#import "ForgotViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    MBProgressHUD *_hud;
}
@property (nonatomic,strong) UITextField *usrTextField;
@property (nonatomic,strong) UITextField *pwdText;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    _usrTextField = [[UITextField alloc]init];
    _usrTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _usrTextField.borderStyle = UITextBorderStyleBezel;
    _usrTextField.text=@"george";
    [_usrTextField setPlaceholder:@"Username/Mobile Number"];
    
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
    _pwdText.delegate= self;
    [_pwdText setPlaceholder:@"Password"];
    
    [self.view addSubview:_pwdText];
    [_pwdText mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    
//    UIButton *photoBtn = [[UIButton alloc]init];
//    photoBtn.backgroundColor=UIColorFromRGB(0x4a72e2);
//    [photoBtn setTitle:@"Photo" forState:UIControlStateNormal];
//    [photoBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
//    //[self.view addSubview:photoBtn];
//    [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.mas_equalTo(button.mas_bottom).offset(40);
//        make.width.mas_equalTo(300);
//        make.height.mas_equalTo(50);
//    }];
    
    UIButton *forgotBtn = [[UIButton alloc]init];
    [forgotBtn setTitle:@"Forgot Password" forState:UIControlStateNormal];
    forgotBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgotBtn sizeToFit];
    [forgotBtn setTitleColor:UIColorFromRGB(0x4a72e2) forState:UIControlStateNormal];
    [forgotBtn addTarget:self action:@selector(forgotClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotBtn];
    [forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(button.mas_left);
        make.top.mas_equalTo(button.mas_bottom).offset(15);
        //make.height.mas_equalTo(10);
        //make.width.mas_equalTo(50);
    }];
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitle:@"Register" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerBtn sizeToFit];
    [registerBtn setTitleColor:UIColorFromRGB(0x4a72e2) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(button.mas_right);
        make.top.mas_equalTo(button.mas_bottom).offset(15);
    }];
    
    [self.view endEditing:YES];
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

-(void) loginClick{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.label.text = @"Logging in...";
    
    NSDictionary *dic=@{@"loginName":_usrTextField.text,@"password":_pwdText.text};
    [[HttpManager sharedInstance] postWithCmd:cmd_login parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {

        NSLog(@"responseObject===%@",responseObject);
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if([[responseObject[@"responseCode"] stringValue] isEqualToString:@"0"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * imDic = [responseObject objectForKey:@"data"];
            [defaults setObject:imDic[@"token"] forKey:@"token"];
            [defaults setObject:imDic[@"profileUrl"] forKey:@"profileUrl"];
            [defaults setObject:imDic[@"name"] forKey:@"name"];
            [defaults synchronize];
            MainViewController *deviceViewController = [[MainViewController alloc] init];
            //deviceViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:deviceViewController animated:YES];
        }
        else{
            [CXMProgressView showErrorText:responseObject[@"responseMsg"]];
        }
        _hud.hidden =YES;
    } dataWrong:^(NSInteger code, NSString *msg) {
        _hud.hidden =YES;
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

-(void) forgotClick{
    ForgotViewController *view = [[ForgotViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void) registerClick{
    RegisterViewController *view = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_pwdText resignFirstResponder];
    [_usrTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField ==_pwdText){
        [self changeControllerViewHeightWithNum:4.2f];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    UIViewController *superController = [self getViewController];
    [UIView animateWithDuration:0.3 animations:^{
        superController.view.frame = CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

-(void)changeControllerViewHeightWithNum:(float)num{
    UIViewController *superController = [self getViewController];
    if(SCREEN_HEIGHT==IPhoneX_Height){
        num = num+1;
    }
    [UIView animateWithDuration:0.3 animations:^{
        if(SCREEN_HEIGHT==IPhoneX_Height){
            superController.view.frame = CGRectMake(0,-(IPhoneX_Height*42*num/SCREEN_HEIGHT),SCREEN_WIDTH, SCREEN_HEIGHT);
        }else{
            if(SCREEN_HEIGHT>667){
                superController.view.frame = CGRectMake(0,-(667*50*num/SCREEN_HEIGHT),SCREEN_WIDTH, SCREEN_HEIGHT);
            }else{
                superController.view.frame = CGRectMake(0,-(667*42*num/SCREEN_HEIGHT),SCREEN_WIDTH, SCREEN_HEIGHT);
            }
        }
    }];
}

-(UIViewController*)getViewController{
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
