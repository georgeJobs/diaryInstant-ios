//
//  ViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/5.
//  Copyright © 2019 George. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>


@interface ViewController ()
@property(nonatomic, strong)UIImagePickerController *avaterPicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor=UIColor.brownColor;
    [button setTitle:@"上传照片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(forgetPassBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(100);
    }];
}
-(void) forgetPassBtnClcik{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    actionSheet.delegate=self;
    [actionSheet showInView:self.view];
}
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    self.avaterPicker = [[UIImagePickerController  alloc]init];
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
        //  UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];// 未编辑图片

        NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
        NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //NSString *encodedImageStr = [self image2DataURL:image];

        NSDictionary *dic=@{@"content":[encodedImageStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""],@"type":@"1"};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //一但用了这个返回的那个responseObject就是NSData，如果不用就是简单的
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];

        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];

        [manager POST:@"http://di.leizhenxd.com/api/resource/add" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(responseObject);
             NSDictionary *dict = (NSDictionary *)responseObject;

         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"请求失败--%@",error);
         }];
    }];
        
}

//- (BOOL) imageHasAlpha: (UIImage *) image
//{
//        CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
//        return (alpha == kCGImageAlphaFirst ||
//                            alpha == kCGImageAlphaLast ||
//                            alpha == kCGImageAlphaPremultipliedFirst ||
//                            alpha == kCGImageAlphaPremultipliedLast);
//}
//
//- (NSString *) image2DataURL: (UIImage *) image
//{
//        NSData *imageData = nil;
//        NSString *mimeType = nil;
//        if ([self imageHasAlpha: image]) {
//                imageData = UIImagePNGRepresentation(image);
//                mimeType = @"image/png";
//            } else {
//                    imageData = UIImageJPEGRepresentation(image, 1.0f);
//                    mimeType = @"image/jpeg";
//                }
//        return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,[imageData base64EncodedStringWithOptions: 0]];
//}

@end
