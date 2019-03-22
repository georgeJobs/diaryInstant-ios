//
//  RegisterViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/16.
//  Copyright © 2019 George. All rights reserved.
//

#import "RegisterViewController.h"
#import "CompleteController.h"

@interface RegisterViewController ()<UITextFieldDelegate>{
    MBProgressHUD *_hud;
}
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
    self.title = @"Register New";
    UILabel *title=[[UILabel alloc]init];
    title.text=@"Register";
    [title sizeToFit];
    title.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(80);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _usrField = [[UITextField alloc]init];
    _usrField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _usrField.borderStyle = UITextBorderStyleBezel;
    //_usrField.delegate = self;
    _usrField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:_usrField];
    [_usrField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(title.mas_bottom).offset(30);
    }];
    
    _pwdField = [[UITextField alloc]init];
    _pwdField.borderStyle = UITextBorderStyleBezel;
    _pwdField.secureTextEntry = YES;
//    _pwdField.delegate = self;
    [self.view addSubview:_pwdField];
    [_pwdField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_usrField.mas_bottom).offset(40);
    }];
    
    _repwdField = [[UITextField alloc]init];
    _repwdField.borderStyle = UITextBorderStyleBezel;
    _repwdField.secureTextEntry = YES;
//    _repwdField.delegate = self;
    [self.view addSubview:_repwdField];
    [_repwdField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_pwdField.mas_bottom).offset(40);
    }];
    
    _mobileField = [[UITextField alloc]init];
    _mobileField.borderStyle = UITextBorderStyleBezel;
//    _mobileField.delegate = self;
    _mobileField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_mobileField];
    [_mobileField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_repwdField.mas_bottom).offset(40);
    }];
    
    _emailField = [[UITextField alloc]init];
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailField.borderStyle = UITextBorderStyleBezel;
    _emailField.delegate = self;
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_emailField];
    [_emailField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_mobileField.mas_bottom).offset(40);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"Register" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(_emailField.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *lbl1 = [[UILabel alloc]init];
    lbl1.text = @"User Name";
    [lbl1 sizeToFit];
    lbl1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lbl1];
    [lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_usrField.mas_top);
        make.left.mas_equalTo(_usrField.mas_left);
    }];
    
    UILabel *lbl2 = [[UILabel alloc]init];
    lbl2.text = @"Password";
    [lbl2 sizeToFit];
    lbl2.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lbl2];
    [lbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_pwdField.mas_top);
        make.left.mas_equalTo(_pwdField.mas_left);
    }];
    
    UILabel *lbl3 = [[UILabel alloc]init];
    lbl3.text = @"Comfirm Password";
    [lbl3 sizeToFit];
    lbl3.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lbl3];
    [lbl3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_repwdField.mas_top);
        make.left.mas_equalTo(_repwdField.mas_left);
    }];
    
    UILabel *lbl4 = [[UILabel alloc]init];
    lbl4.text = @"Mobile";
    [lbl4 sizeToFit];
    lbl4.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lbl4];
    [lbl4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_mobileField.mas_top);
        make.left.mas_equalTo(_mobileField.mas_left);
    }];
    
    UILabel *lbl5 = [[UILabel alloc]init];
    lbl5.text = @"Email";
    [lbl5 sizeToFit];
    lbl5.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lbl5];
    [lbl5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_emailField.mas_top);
        make.left.mas_equalTo(_emailField.mas_left);
    }];
    
    [self.view endEditing:YES];
}
-(void)registerClick{
    [_emailField resignFirstResponder];
    if(!ValidStr(_usrField.text)||!ValidStr(_pwdField.text)||!ValidStr(_repwdField.text)||!ValidStr(_mobileField.text)||!ValidStr(_emailField.text)){
        [CXMProgressView showText:@"fill all data please"];
        return;
    }
    if(![_pwdField.text isEqualToString:_repwdField.text]){
        [CXMProgressView showText:@"The two passwords you typed do not match"];
        return;
    }
    
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.label.text = @"Register...";
    
    NSDictionary *dic=@{@"name":_usrField.text,@"password":_pwdField.text,@"phone":_mobileField.text,@"email":_emailField.text};
    [[HttpManager sharedInstance] postWithCmd:cmd_register parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSLog(@"responseObject===%@",responseObject);
        //        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if([[responseObject[@"responseCode"] stringValue] isEqualToString:@"0"]){
            CompleteController *view = [[CompleteController alloc] init];
            view.name = self->_usrField.text;
//            //deviceViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }
        else{
            [CXMProgressView showErrorText:responseObject[@"responseMsg"]];
        }
        self->_hud.hidden =YES;
    } dataWrong:^(NSInteger code, NSString *msg) {
        self->_hud.hidden =YES;
        [CXMProgressView showErrorText:msg];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [CXMProgressView dismissLoading];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_emailField resignFirstResponder];
    [_usrField resignFirstResponder];
    [_pwdField resignFirstResponder];
    [_repwdField resignFirstResponder];
    [_mobileField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField ==_emailField){
        [self changeControllerViewHeightWithNum:1];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
