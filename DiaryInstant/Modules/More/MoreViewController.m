//
//  MoreViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/12.
//  Copyright © 2019 George. All rights reserved.
//

#import "MoreViewController.h"

#define CELL_IDENTIFER  @"Cell_Identifer"
static const NSInteger HeadViewHeight = 376/2;
@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    UITableView *_tableView;
    UIImageView *_headImageView;
    UIImageView *_headView;
    NSMutableArray *list;
    MBProgressHUD *_hud;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self makeTable];
}

-(void)makeTable{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TabBarHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor.whiteColor;//GeneralBackgroundColor;
    [self.view addSubview:_tableView];
    
    CGRect headerRect = CGRectMake(0, 0,SCREEN_WIDTH, kActualHeight(HeadViewHeight));
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,kActualHeight(HeadViewHeight))];
    //    _headImageView.image = [UIImage imageNamed:@"Bitmap"];
    _headImageView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_headImageView];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"More";
    title.font = [UIFont systemFontOfSize:30];
    [_headImageView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_headImageView);
        make.centerY.mas_equalTo(_headImageView);
    }];
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:headerRect];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if(System_Version>=11){
        
        _tableView.contentInset = UIEdgeInsetsMake(-StatusBarHeight, 0, 0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        //        _headImageView.frame = CGRectMake(offsetY/2, offsetY, SCREEN_WIDTH - offsetY, kActualHeight(HeadViewHeight) - offsetY);  // 修改头部的frame值就行了
    }
    
    /* 往上滑动contentOffset值为正，大多数都是监听这个值来做一些事 */
}


#pragma mark - TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        
        return 4;
    }
    else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0) return 0;
    return 7;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section==0) return nil;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
    headView.backgroundColor = GeneralBackgroundColor;
    return headView;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFER];
    
    if(cell ==nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFER];
        
    }
    
    for(UIView *view in cell.contentView.subviews){
        
        [view removeFromSuperview];
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    
    NSArray *oneArr = @[@"Profile.",@"Settings.",@"Help.",@"Term&Conditions."];
    
    if(indexPath.section ==0){
        
        UILabel *tisLabel = [UILabel new];
        tisLabel.text = oneArr[indexPath.row];
        tisLabel.textColor =UIColorFromRGB(0x333333);
        tisLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:tisLabel];
        [tisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).with.offset(20);
        }];
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            
            if(indexPath.row==0){
            }
        }
            break;
        case 1:
        {
            
            if(indexPath.row ==0){
                
            }else if (indexPath.row==1){
                
            }else{
                
            }
        }
            break;
        case 2:
        {
            if(indexPath.row==0){
                
                
            }else if (indexPath.row==1){
                [CXMProgressView showText:@"程序猿正在努力开发中(｡ì _ í｡)"];
                
            }else{
                
            }
        }
            break;
        default:
            break;
    }
    
}

@end
