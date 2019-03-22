//
//  ShareNoteController.m
//  DiaryInstant
//
//  Created by George on 2019/3/22.
//  Copyright © 2019 George. All rights reserved.
//

#import "ShareNoteController.h"
#import "NoteViewController.h"
#import "FriendViewController.h"

@interface ShareNoteController (){
    NSString *resourceId;
    NSString *friendId;
    UITextField *hourField;
    UITextField *minField;
    MBProgressHUD *_hud;
}

@end

@implementation ShareNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =UIColor.whiteColor;
    self.title = @"Share with Other";
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"Choose Note";
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).offset(-150);
        make.centerX.mas_equalTo(self.view).offset(-80);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"Choose Friend";
    [label1 sizeToFit];
    label1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label1];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(50);
        make.left.mas_equalTo(label.mas_left);
    }];
    
    UIButton *photoBtn = [[UIButton alloc]init];
    [photoBtn setTitle:@"+" forState:UIControlStateNormal];
    photoBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    photoBtn.backgroundColor = UIColorFromRGB(0xdddddd);
    [photoBtn setTitleColor:UIColorFromRGB(0x4a72e2) forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoJump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label);
        make.centerX.mas_equalTo(self.view).offset(40);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *friendBtn = [[UIButton alloc]init];
    [friendBtn setTitle:@"+" forState:UIControlStateNormal];
    friendBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    friendBtn.backgroundColor = UIColorFromRGB(0xdddddd);
    [friendBtn setTitleColor:UIColorFromRGB(0x4a72e2) forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendJump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendBtn];
    [friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label1);
        make.centerX.mas_equalTo(self.view).offset(40);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"Select Time Period";
    [label2 sizeToFit];
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).offset(50);
        make.left.mas_equalTo(label1.mas_left);
    }];
    
    hourField = [[UITextField alloc]init];
    hourField.borderStyle = UITextBorderStyleBezel;
    hourField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:hourField];
    [hourField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label2.mas_bottom).offset(30);
        make.left.mas_equalTo(label2.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *hourLbl = [[UILabel alloc]init];
    hourLbl.text = @"Hours";
    [hourLbl sizeToFit];
    hourLbl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:hourLbl];
    [hourLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(hourField);
        make.left.mas_equalTo(hourField.mas_right);
    }];
    
    minField = [[UITextField alloc]init];
    minField.borderStyle = UITextBorderStyleBezel;
    minField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:minField];
    [minField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label2.mas_bottom).offset(30);
        make.left.mas_equalTo(hourLbl.mas_right).offset(30);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *minLbl = [[UILabel alloc]init];
    minLbl.text = @"Mins";
    [minLbl sizeToFit];
    minLbl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:minLbl];
    [minLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(minField);
        make.left.mas_equalTo(minField.mas_right);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"SEND" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(minLbl.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    [self.view endEditing:YES];
}

-(void) photoJump{
    NoteViewController *view = [[NoteViewController alloc]init];
    view.noteBlock=^(NSString *noteId) {
        self->resourceId= noteId;
        //        intelligentCell.imageUrl = model.content;
        //        NSDictionary *dic = @{[NSString stringWithFormat:@"%ld",indexPath.row]:@(indexRow)};
    };
    [self.navigationController pushViewController:view animated:YES];
}

-(void) friendJump{
    FriendViewController *view= [[FriendViewController alloc]init];
    view.isMainCall = NO;
    view.friendBlock=^(NSString *friid){
        self->friendId = friid;
    };
    [self.navigationController pushViewController:view animated:YES];
}

-(void) sendClick{
    if(!ValidStr(hourField.text)||!ValidStr(minField.text)||!ValidStr(resourceId)||!ValidStr(friendId)){
        [CXMProgressView showText:@"fill data"];
        return;
    }
    
    /*转换时间 +时间间隔 */
    NSDate * nowDate = [[NSDate date] initWithTimeInterval: [minField.text intValue] * 60+[hourField.text intValue] * 3600 sinceDate:[NSDate date]];
    /*获取时区*/
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: nowDate];
    NSDate *localeDate = [nowDate  dateByAddingTimeInterval: interval];
    
    NSDictionary *dic=@{@"expireTime":[NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]*1000]
                        ,@"resourceId":resourceId,@"toUserIds":@[friendId]};
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
    
    [manager POST:@"http://di.leizhenxd.com/api/share/share" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
