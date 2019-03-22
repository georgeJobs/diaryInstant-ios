//
//  AddNoteViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/20.
//  Copyright © 2019 George. All rights reserved.
//

#import "AddNoteViewController.h"
#import "AddResultViewController.h"

@interface AddNoteViewController (){
    UITextField *topic;
    UITextView *content;
    MBProgressHUD *_hud;
}
@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =UIColor.whiteColor;
    self.title = @"New Note";
    
    topic = [[UITextField alloc]init];
    topic.borderStyle = UITextBorderStyleBezel;
    topic.keyboardType = UIKeyboardTypeNumberPad;
    topic.autocapitalizationType = UITextAutocapitalizationTypeNone;
    topic.borderStyle = UITextBorderStyleBezel;
    [topic setPlaceholder:@"Topic:"];
    [self.view addSubview:topic];
    [topic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(130);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
    }];
    
    content = [[UITextView alloc]init];
    content.layer.borderColor = [UIColor grayColor].CGColor;
    content.layer.borderWidth = 1.0;
    content.keyboardType = UIKeyboardTypeNumberPad;
    content.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [content setPlaceholder:@"Content:"];
    [self.view addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topic.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(300);
        make.width.mas_equalTo(SCREEN_WIDTH-10);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColorFromRGB(0x4a72e2);
    [button setTitle:@"UPLOAD" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(content.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
    [self.view endEditing:YES];
}

-(void) uploadClick{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.label.text = @"Uploading...";
    
    NSDictionary *dic=@{@"content":content.text,@"topic":topic.text,@"type":@2};
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
    
    [manager POST:@"http://di.leizhenxd.com/api/resource/add" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jsonDict);
        if([[jsonDict[@"responseCode"] stringValue] isEqualToString:@"0"]){
            
            NSDictionary * imDic = [jsonDict objectForKey:@"data"];
            AddResultViewController *view = [[AddResultViewController alloc]init];
            view.topic = imDic[@"topic"];
            view.size = imDic[@"size"];
            view.timpStamp=imDic[@"createTime"];
            [self.navigationController pushViewController:view animated:YES];
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
