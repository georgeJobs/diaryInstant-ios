//
//  SettingsViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/22.
//  Copyright © 2019 George. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UIView *_headView;
    UITableView *_tableView;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Settings";
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    [self makeTableView];
}

-(void)makeTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = GeneralBackgroundColor;
    [self.view addSubview:_tableView];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    _headView.backgroundColor = GeneralBackgroundColor;
    _tableView.tableHeaderView = _headView;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
}

#pragma mark  -TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==3){
        return 75;
    }
    return 54;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell ==nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_identifer"];
        
    }
    
    if(indexPath.row==3){
        
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        lineView.backgroundColor = GeneralBackgroundColor;
        [cell.contentView addSubview:lineView];

        UIView *whiteView =[[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 55)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:whiteView];
        
        UILabel *outLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        outLabel.text = @"Logot";
        outLabel.textColor = [UIColor redColor];
        outLabel.textAlignment = NSTextAlignmentCenter;
        outLabel.font  =[UIFont systemFontOfSize:16];
        [whiteView addSubview:outLabel];
        
    }else{
        
        NSArray *titleArr = @[@"Clean cache",@"Change pwd",@"theme"];
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = titleArr[indexPath.row];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(cell.contentView).with.offset(20);
            make.centerY.equalTo(cell.contentView);
        }];
        
        if(indexPath.row==1||indexPath.row==2){
            
//            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            
            UILabel *valueLabel = [UILabel new];
            valueLabel.text = [NSString stringWithFormat:@"%.2f M",[self folderSizeAtPath:@""]];
            valueLabel.textColor = [UIColor blackColor];
            valueLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:valueLabel];
            
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(cell.contentView).with.offset(-15);
                make.centerY.equalTo(cell.contentView);
            }];
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==0){
        
        [self clearCache:@""];
        
    }else if(indexPath.row ==1){
        [CXMProgressView showText:@"not finish yet"];
        
    }else if(indexPath.row ==2){
        [CXMProgressView showText:@"not finish yet"];
    }
    else{
        
        [self logOut];
        
    }
    
}
-(void)logOut{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WARMING" message:@"logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Comfirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
//        LoginViewController *loginVc = [[LoginViewController alloc] init];
//        // [[UIApplication sharedApplication] delegate].window.rootViewController = [[LoginViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
//
//        [self.navigationController presentViewController:nav animated:YES completion:^{
//
//        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma Mark - 关于缓存
-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    NSLog(@"cachePath===%@",cachePath);
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}

-(long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。
-(void)clearCache:(NSString *)path{
    
    [CXMProgressView showTextWithCircle:@""];
    
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
        
        [CXMProgressView showSuccessText:@"successfully clean cache"];
        [_tableView reloadData];
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
