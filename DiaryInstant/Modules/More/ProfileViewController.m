//
//  ProfileViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/22.
//  Copyright © 2019 George. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_mainTableView;
    UIImageView *_headView;
    MBProgressHUD *_hud;
}
@property(nonatomic, strong)UIImagePickerController *avaterPicker;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    [self makeTableView];
    
}
-(void)makeTableView{
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = GeneralBackgroundColor;
    [self.view addSubview:_mainTableView];
    
    _mainTableView.tableFooterView = [[UIView alloc] init];
    
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        
        return  78;
    }else if(indexPath.row==7){
        
        return 65;
    }else{
        
        return 57;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_identifer"];
    
    if(cell==nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSArray *titleArr = @[@"head image",@"user name"];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = titleArr[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.centerY.equalTo(cell.contentView);
    }];
    
    
    if(indexPath.row==0){
        
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, 9)];
        lineView.backgroundColor = GeneralBackgroundColor;
        [cell.contentView addSubview:lineView];
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 10, 53, 53)];
        _headView.backgroundColor = [UIColor cyanColor];
        _headView.layer.masksToBounds =YES;
        _headView.layer.cornerRadius =26.5;
        [cell.contentView addSubview:_headView];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *profileUrl = [defaults objectForKey:@"profileUrl"];
        
        [_headView sd_setImageWithURL:[NSURL URLWithString:profileUrl] placeholderImage:[UIImage imageNamed:@"Default_headImage"]];
        
    }else if(indexPath.row==1){
        UILabel *valueLabel = [UILabel new];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *name = [defaults objectForKey:@"name"];
        valueLabel.text = [NSString stringWithFormat:@"%@",name];
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:valueLabel];
        
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(cell.contentView).with.offset(-15);
            make.centerY.equalTo(cell.contentView);
        }];
    }
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row ==0){
        
        [self selectImageTapGes];
        return;
    }
}

#pragma mark - 图片选择
-(void)selectImageTapGes{
    
    NSLog(@"pick headimage");
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"pick headimage" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"photo",@"camera", nil];
    actionSheet.delegate=self;
    [actionSheet showInView:self.view];
}
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    self.avaterPicker = [[UIImagePickerController  alloc]init];
    _avaterPicker.delegate = self;
    _avaterPicker.allowsEditing = YES;
    
    if ([_avaterPicker.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [_avaterPicker.navigationBar setBarTintColor:NavigationBarBackgroundColor];
        //  [_avaterPicker.navigationBar setTranslucent:YES];
        [_avaterPicker.navigationBar setTintColor:[UIColor whiteColor]];
    }else{
        [_avaterPicker.navigationBar setBackgroundColor:NavigationBarBackgroundColor];
    }
    // 更改titieview的字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [_avaterPicker.navigationBar setTitleTextAttributes:attrs];
    
    _avaterPicker.navigationBar.translucent = NO;
    if (buttonIndex == 0) {
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _avaterPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_avaterPicker animated:YES completion:^{
                
            }];
        }
        
    }else if (buttonIndex == 1){
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            _avaterPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_avaterPicker animated:YES completion:^{
                
            }];
        }
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (_avaterPicker) {
        [picker dismissViewControllerAnimated:YES completion:^{}];
        return;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if (picker == _avaterPicker) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
#pragma mark- ImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];// 编辑后的图片
        
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.label.text = @"Upload...";
        
        NSData *imgData = UIImageJPEGRepresentation(image, 0.01f);
        NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSDictionary *dic=@{@"content":[encodedImageStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]};
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
        
        [manager POST:@"http://di.leizhenxd.com/api/user/edit" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", jsonDict);
            _hud.hidden =YES;
            if([[jsonDict[@"responseCode"] stringValue] isEqualToString:@"0"]){
                [jsonDict objectForKey:@"data"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[jsonDict objectForKey:@"data"] forKey:@"profileUrl"];
                
                [_mainTableView reloadData];
            }else{
                [CXMProgressView showText:jsonDict[@"responseMsg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            _hud.hidden =YES;
            NSLog(@"请求失败--%@",error);
        }];
        
    }];
}

@end
