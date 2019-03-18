//
//  FriendViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/12.
//  Copyright © 2019 George. All rights reserved.
//

#import "FriendViewController.h"
#import "AddFriendViewController.h"
#import "SystemMessageTableViewCell.h"
#import "MyScrollView.h"
#import "HomeMessageModel.h"
#import "TableViewPlaceholder.h"

#define LABEL_TAG 9000
static CGFloat HeadViewHeight = 68;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
@interface FriendViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UIView *_headView;
    MyScrollView *_mainScrollView;
    UITableView *_msgTableView;// 消息列表
    NSMutableArray *_msgArr;
    
    UILabel *_messagelabel;
    UIView *_actorView;
    CGRect _leftRect;
    CGRect _rightRect;
    
    TableViewPlaceholder *_msgPlaceHolder;

}
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置


@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Friend";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initData];
    [self makeHeadView];
    [self makeScrollView];

    [self makeMsgTableView];
    [self makeMsgTableRequest];
    [self readMessage];
    [self makeTablePlaceHolder];
}

-(void) addClick{
    AddFriendViewController *view= [[AddFriendViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}


-(void) readMessage{
//    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    _hud.mode = MBProgressHUDModeAnnularDeterminate;
//    _hud.label.text = @"Reading...";
//
//    [list removeAllObjects];
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

    [manager POST:@"http://di.leizhenxd.com/api/user/getMyFriends" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jsonDict);
//        _hud.hidden =YES;
        if([[jsonDict[@"responseCode"] stringValue] isEqualToString:@"0"]){
            NSDictionary * imDic = [jsonDict objectForKey:@"data"];
            [HomeMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            [_msgArr addObjectsFromArray:[HomeMessageModel mj_objectArrayWithKeyValuesArray:imDic]];
           [_msgTableView reloadData];
        }else{
            [CXMProgressView showText:jsonDict[@"responseMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        _hud.hidden =YES;
        NSLog(@"请求失败--%@",error);
    }];
}

-(void)makeTablePlaceHolder{
    
    _msgPlaceHolder = [[TableViewPlaceholder alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - HeadViewHeight)];
    _msgPlaceHolder.hidden = YES;
    
    __weak FriendViewController *weakSelf = self;
    _msgPlaceHolder.reloadClickBlock = ^{
        
        [weakSelf makeMsgTableRequest];
    };
    [_mainScrollView addSubview:_msgPlaceHolder];
}
-(void)initData{
    
    _msgArr = [[NSMutableArray alloc] initWithCapacity:0];
    
}
-(void)makeHeadView{
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, HeadViewHeight)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HeadViewHeight-7,SCREEN_WIDTH , 7)];
    lineView.backgroundColor = GeneralBackgroundColor;
    [_headView addSubview:lineView];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"Friend";
    title.font = [UIFont systemFontOfSize:30];
    [_headView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_headView);
        make.centerY.mas_equalTo(_headView);
    }];

    UIButton *add = [[UIButton alloc]init];
    [add setTitle:@"Add New" forState:UIControlStateNormal];
    add.titleLabel.font = [UIFont systemFontOfSize:12];
    [add sizeToFit];
    [add setTitleColor:UIColorFromRGB(0x4a72e2) forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headView.mas_left).offset(5);
        make.bottom.mas_equalTo(_headView.mas_bottom).offset(-15);
        //make.height.mas_equalTo(10);
        //make.width.mas_equalTo(50);
    }];

}
-(void)makeScrollView{
    
    _mainScrollView = [[MyScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT+HeadViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT  - HeadViewHeight)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.bounces =NO;
    _mainScrollView.scrollEnabled = NO;
    [_mainScrollView setDelaysContentTouches:NO];
    [_mainScrollView setCanCancelContentTouches:NO];
    _mainScrollView.contentSize= CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT  - HeadViewHeight);
    [self.view addSubview:_mainScrollView];
    
}
-(void)makeMsgTableView{
    
    _msgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - HeadViewHeight)];
    _msgTableView.delegate = self;
    _msgTableView.dataSource = self;
    _msgTableView.backgroundColor= [UIColor whiteColor];
    [_mainScrollView addSubview:_msgTableView];
    
    _msgTableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark  - 网络请求
-(void)makeMsgTableRequest{
    
//    NSDictionary *parameters = @{@"doctorId":[NSString stringWithFormat:@"%ld",[UserInfo currentUserId]],@"msgType":@"3"};
//
//    [[HttpManager sharedInstance] getWithCmd:cmd_doctorMsgGet parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
//        [_msgArr removeAllObjects];
//
//        NSLog(@"responseObject===%@",responseObject);
//        if(ValidArray([responseObject objectForKey:@"result"])){
//
//            NSArray *resultArr = [responseObject objectForKey:@"result"];
//            [HomeMessageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//                return @{@"ID":@"id"};
//            }];
//            [_msgArr addObjectsFromArray:[HomeMessageModel mj_objectArrayWithKeyValuesArray:resultArr]];
//            [_msgTableView reloadData];
//
//        }else{
//
//            _msgPlaceHolder.hidden =NO;
//        }
//
//    } dataWrong:^(NSInteger code, NSString *msg) {
//
//        [CXMProgressView showErrorText:msg];
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        [CXMProgressView showErrorText:Connection_Network_Fail];
//    }];
}

#pragma mark - TAPGES
-(void)tapGesDown:(UITapGestureRecognizer*)tapGes{
    
    if(tapGes.view.tag == LABEL_TAG){
        
        _messagelabel.textColor = NavigationBarBackgroundColor;
    
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            _actorView.frame = _leftRect;
        } completion:nil];
        
        [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else{
        
        _messagelabel.textColor = UIColorFromRGB(0x333333);
        [_mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            _actorView.frame = _rightRect;
        } completion:nil];
    }
}
#pragma mark - TavleView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _msgArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_Identifer"];
    if(cell ==nil){
        
        cell = [[SystemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_Identifer"];
        
    }
    //Cell_delate
    //NSString *str = [NSString stringWithFormat:@"%@",[_msgArr objectAtIndex:indexPath.row]];
    HomeMessageModel *model = [_msgArr objectAtIndex:indexPath.row];
    [cell loadInterFaceWithModel:model];
    
    return cell;

}


#pragma mark - 左滑动 删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView setEditing:NO animated:YES];

    // 私信 消息
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WARMING" message:@"Delete your friend？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Comfirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"indexc===%ld",indexPath.row);
            HomeMessageModel *model = [_msgArr objectAtIndex:indexPath.row];
            [self makeDeleMsgRequestWithModel:model];
            [_msgArr removeObjectAtIndex:indexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 从列表中删除
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                if(_msgArr.count==0){
                    
                    _msgPlaceHolder.hidden = NO;
                }
            });
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
#pragma mark -  消息删除请求
-(void)makeDeleMsgRequestWithModel:(HomeMessageModel*)model{
    
//    NSDictionary *parameters = @{@"msgId":[NSString stringWithFormat:@"%@",model.ID]};
//
//    [[HttpManager sharedInstance] getWithCmd:cmd_msgMarkDelete parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
//
//        NSLog(@"responseObject===%@",responseObject);
//
//    } dataWrong:^(NSInteger code, NSString *msg) {
//
//        [CXMProgressView showErrorText:msg];
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        [CXMProgressView showErrorText:Connection_Network_Fail];
//    }];
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"      ";//展示的宽度
}
#pragma mark - 自定义左滑删除功能

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}
- (void)configSwipeButtons
{
    
    // 获取选项按钮的reference
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
    {
        
        if(_mainScrollView.contentOffset.x ==SCREEN_WIDTH){
//
//            // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
//            for (UIView *subview in _sysMegTableView.subviews)
//            {
//                if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
//                {
//                    // 和iOS 10的按钮顺序相反
//                    UIButton *deleteButton = subview.subviews[0];
//
//                    [self configDeleteButton:deleteButton];
//
//                }
//            }
        }else{
            
            // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
            for (UIView *subview in _msgTableView.subviews)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
                {
                    // 和iOS 10的按钮顺序相反
                    UIButton *deleteButton = subview.subviews[0];
                    
                    [self configDeleteButton:deleteButton];
                    
                }
            }
        }
        
    }
    else
    {
        if(_mainScrollView.contentOffset.x ==SCREEN_WIDTH){
//
//            // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
//            SystemMessageTableViewCell *tableCell = [_sysMegTableView cellForRowAtIndexPath:self.editingIndexPath];
//            for (UIView *subview in tableCell.subviews)
//            {
//                if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
//                {
//                    UIButton *deleteButton = subview.subviews[0];
//                    [self configDeleteButton:deleteButton];
//                    [subview setBackgroundColor:[UIColor redColor]];
//                    // [subview setBackgroundColor:[[ColorUtil instance] colorWithHexString:@"E5E8E8"]];
//                }
//            }
        }else{
            
            // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
            SystemMessageTableViewCell *tableCell = [_msgTableView cellForRowAtIndexPath:self.editingIndexPath];
            for (UIView *subview in tableCell.subviews)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
                {
                    UIButton *deleteButton = subview.subviews[0];
                    [self configDeleteButton:deleteButton];
                    [subview setBackgroundColor:[UIColor redColor]];
                    // [subview setBackgroundColor:[[ColorUtil instance] colorWithHexString:@"E5E8E8"]];
                }
            }
        }
    }
    
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = nil;
}
- (void)configDeleteButton:(UIButton*)deleteButton
{
    if (deleteButton)
    {
        //  [deleteButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:12.0]];
        // [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"Cell_delate"] forState:UIControlStateNormal];
        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
        //  [self centerImageAndTextOnButton:deleteButton];
    }
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    /*
     if([scrollView isKindOfClass:[UITableView class]]){
     
     return;
     }
     NSInteger currentIndex =scrollView.contentOffset.x/SCREEN_WIDTH;
     NSLog(@"currentIndex===%ld",currentIndex);
     
     if(currentIndex == 0){
     
     _messagelabel.textColor = NavigationBarBackgroundColor;
     _sysMsgLabel.textColor = [UIColor colorFromHexCode:@"333333"];
     
     [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
     
     _actorView.frame = _leftRect;
     } completion:nil];
     
     }else{
     
     _sysMsgLabel.textColor = NavigationBarBackgroundColor;
     _messagelabel.textColor = [UIColor colorFromHexCode:@"333333"];
     [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
     _actorView.frame = _rightRect;
     
     } completion:nil];
     }
     */
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(tableView ==_msgTableView){
        
        HomeMessageModel *messageModel = [_msgArr objectAtIndex:indexPath.row];
        [self setReadRequestWithID:messageModel.ID];// 已读消息
        
//        ChangeDegDetailViewController *detailVc = [[ChangeDegDetailViewController alloc] init];
//        detailVc.transferId = messageModel.transferId;
//
//        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
}
//设置消息已读
-(void)setReadRequestWithID:(NSString*)msgId{
    
//    NSDictionary *parameters = @{@"msgId":[NSString stringWithFormat:@"%@",msgId]};
//
//    [[HttpManager sharedInstance] getWithCmd:cmd_msgMarkRead parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
//
//        NSLog(@"url===%@",operation.currentRequest.URL);
//        NSLog(@"responseObject===%@",responseObject);
//
//    } dataWrong:^(NSInteger code, NSString *msg) {
//
//        [CXMProgressView dismissLoading];
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        [CXMProgressView dismissLoading];
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
