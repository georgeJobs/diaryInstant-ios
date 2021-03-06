//
//  AddFriendViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/18.
//  Copyright © 2019 George. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
{
    UITextField *usrName;
    MBProgressHUD *_hud;
}
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Add Friend";
    self.view.backgroundColor = UIColor.whiteColor;
    
    usrName = [[UITextField alloc]init];
    usrName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usrName.borderStyle = UITextBorderStyleBezel;
    [self.view addSubview:usrName];
    [usrName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(60);
        make.centerY.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    
    UILabel *hourLbl = [[UILabel alloc]init];
    hourLbl.text = @"Username";
    [hourLbl sizeToFit];
    hourLbl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:hourLbl];
    [hourLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(usrName.mas_left).offset(10);
        make.centerY.mas_equalTo(self.view);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"add friend" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(120);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
}

-(void) addClick{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.label.text = @"ADDING...";
    NSDictionary *dic=@{@"addFriendName":usrName.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    [manager POST:@"http://di.leizhenxd.com/api/friend/add" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jsonDict);
        if([[jsonDict[@"responseCode"] stringValue] isEqualToString:@"0"]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [CXMProgressView showText:jsonDict[@"responseMsg"]];
        }
        
        //_tablePlaceHolder.hidden =YES;
        _hud.hidden=YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _hud.hidden=YES;
        NSLog(@"请求失败--%@",error);
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
