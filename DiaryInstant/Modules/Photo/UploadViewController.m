//
//  UploadViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/14.
//  Copyright © 2019 George. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImage *_uploadImage;
}
@property(nonatomic, strong)UIImagePickerController *avaterPicker;
@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"New Photo";
    UILabel *label = [[UILabel alloc]init];
    label.text = @"ADD NEW PHOTO";
    label.font=[UIFont systemFontOfSize:30];
    [label sizeToFit];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
    }];
    
    UIButton *addPic  = [[UIButton alloc]init];
    [addPic setBackgroundColor:UIColorFromRGB(0xdddddd)];
    [addPic setImage:[UIImage imageNamed:@"photoBtn"] forState:UIControlStateNormal];
    addPic.tag = 1;
    [addPic addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPic];
    
    [addPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(label.mas_bottom).offset(50);
    }];
    
    UIButton *addCam  = [[UIButton alloc]init];
    [addCam setBackgroundColor:UIColorFromRGB(0xdddddd)];
    [addCam setImage:[UIImage imageNamed:@"cameraBtn"] forState:UIControlStateNormal];
    addCam.tag = 2;
    [addCam addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCam];
    
    [addCam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(addPic.mas_bottom).offset(20);
    }];
    
    UIButton *photoBtn = [[UIButton alloc]init];
    photoBtn.backgroundColor=UIColorFromRGB(0x4a72e2);
    [photoBtn setTitle:@"Photo" forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    [photoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(addCam.mas_bottom).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
    }];
    
}
-(void) uploadClick{
    if(_uploadImage==nil){
        [CXMProgressView showText:@"NO Picture select"];
        return;
    }
    NSData *imgData = UIImageJPEGRepresentation(_uploadImage, 0.01f);
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *dic=@{@"content":[encodedImageStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""],@"type":@"1"};
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
-(void) photoClick:(UIButton *)btn{
    
    _avaterPicker = [[UIImagePickerController  alloc]init];
    _avaterPicker.delegate = self;
    _avaterPicker.allowsEditing = YES;
    
    if ([_avaterPicker.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [_avaterPicker.navigationBar setBarTintColor:UIColorFromRGB(0x5677fc)];
        //  [_avaterPicker.navigationBar setTranslucent:YES];
        [_avaterPicker.navigationBar setTintColor:[UIColor whiteColor]];
    }else{
        [_avaterPicker.navigationBar setBackgroundColor:UIColorFromRGB(0x5677fc)];
    }
    // 更改titieview的字体颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [_avaterPicker.navigationBar setTitleTextAttributes:attrs];
    
    _avaterPicker.navigationBar.translucent = NO;
    if(btn.tag==1){//图像
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _avaterPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_avaterPicker animated:YES completion:^{
                
            }];
        }
        
    }else if (btn.tag==2){//照相
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

#pragma mark- ImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        _uploadImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];// 编辑后的图片
        //  UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];// 未编辑图片
    }];
    
}

@end
