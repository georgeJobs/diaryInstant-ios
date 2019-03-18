//
//  PhotoViewController.m
//  DiaryInstant
//
//  Created by George on 2019/3/12.
//  Copyright © 2019 George. All rights reserved.
//

#import "PhotoViewController.h"
#import "PicShowCollectionViewCell.h"
#import "UploadViewController.h"
#import "MessagePhotoController.h"
#import "ShareViewController.h"
#import "LBPhotosBrowserViewController.h"

@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    NSMutableArray *_mulArr;
    NSInteger _selectedRow;
}
@property(nonatomic,strong) UITableView *table;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    // Do any additional setup after loading the view.
    _mulArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.title = @"PHOTO";
    UILabel *title = [[UILabel alloc]init];
    title.text = @"PHOTO";
    title.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(50);
    }];
    
    UIButton *message = [[UIButton alloc]init];
    [message setTitle:@"Your have 5 messages" forState:UIControlStateNormal];
    message.titleLabel.font = [UIFont systemFontOfSize:12];
    [message sizeToFit];
    [message setTitleColor:UIColorFromRGB(0x4a72e2) forState:UIControlStateNormal];
    [message addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(5);
        make.top.mas_equalTo(title.mas_bottom).offset(5);
        //make.height.mas_equalTo(10);
        //make.width.mas_equalTo(50);
    }];
    
    UIButton *share = [[UIButton alloc]init];
    [share setTitle:@"share" forState:UIControlStateNormal];
    share.titleLabel.font = [UIFont systemFontOfSize:12];
    [share sizeToFit];
    [share setTitleColor:UIColorFromRGB(0x4a72e2) forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:share];
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-5);
        make.top.mas_equalTo(title.mas_bottom).offset(5);
    }];
    
    [self makeCollectionView];
    [self makePicRequest];
}
-(void) messageClick{
    MessagePhotoController *view = [[MessagePhotoController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}
-(void) shareClick{
    ShareViewController *view = [[ShareViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)makeCollectionView{
    
    CGFloat itemWidth =(SCREEN_WIDTH - 5)/5;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 3.5f;
    flowLayout.minimumLineSpacing = 10.5f;
    [flowLayout setItemSize:CGSizeMake(itemWidth,itemWidth)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, NAV_HEIGHT+100, SCREEN_WIDTH-20, SCREEN_HEIGHT-NAV_HEIGHT-100) collectionViewLayout:flowLayout];
    _collectionView.delegate =self;
    _collectionView.dataSource =self;
    _collectionView.bounces =YES;
    _collectionView.backgroundColor =UIColor.whiteColor;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[PicShowCollectionViewCell class] forCellWithReuseIdentifier:@"PicShowCellIdentifier"];
    
    __weak typeof(self) weakSelf = self;
//    __weak UILabel *weakLabel = tisLabel;

    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [weakSelf makePicRequest];
//        weakLabel.text = @"以下为近1小时上传图像";
    }];

    // 上拉继续加载
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //[weakSelf makeMorePicRequest];
    }];

    _collectionView.mj_footer.hidden =YES;
}

-(void) makePicRequest{
    
    NSDictionary *dic=@{@"type":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    
    
    [_mulArr removeAllObjects];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    [manager POST:@"http://di.leizhenxd.com/api/resource/query" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", jsonDict);
        
        NSMutableArray *itemArr =[NSMutableArray arrayWithArray:[jsonDict objectForKey:@"data"]];
        PicShowModel * addImg = [[PicShowModel alloc]init];
        addImg.type=@"3";
        [itemArr addObject:addImg];
        [self->_mulArr addObjectsFromArray:[PicShowModel mj_objectArrayWithKeyValuesArray:itemArr]];
        
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
        
        if(itemArr.count<30){
            _collectionView.mj_footer.hidden=YES;
        }else{
            _collectionView.mj_footer.hidden=NO;
        }
        //_tablePlaceHolder.hidden =YES;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView ==_collectionView){
        
        return _mulArr.count;
    }
    
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1.5f, 0, 0, 0);
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"PicShowCellIdentifier";
    PicShowCollectionViewCell* picShowCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    picShowCell.delegate =self;
    picShowCell.indexPathRow = indexPath.row;
//    if(_selectedRow==indexPath.row){
//
//        picShowCell.showImage = [UIImage imageNamed:@"Intelligent_selected"];
//    }else{
//
//        picShowCell.showImage = [UIImage imageNamed:@"Intelligent_noselected"];
//    }

    PicShowModel *picModel =(PicShowModel*)[_mulArr objectAtIndex:indexPath.row];
    [picShowCell loadInterfaceWithModel:picModel];
    return picShowCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i=0; i<_mulArr.count-1; i++) {
        PicShowModel *model = [_mulArr objectAtIndex:i];
        [imageArr addObject:[NSString stringWithFormat:@"%@",model.content]];
    }
    
    if(indexPath.row == _mulArr.count-1){
        UploadViewController *view = [[UploadViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }else{
        LBPhotosBrowserViewController *photosBrowserVC = [[LBPhotosBrowserViewController alloc] init];
        photosBrowserVC.isPageScrolling = YES;
        photosBrowserVC.currentIndex = indexPath.row;
        photosBrowserVC.isURLImage = YES;
        photosBrowserVC.imgArr = [NSMutableArray arrayWithArray:imageArr];
        [self presentViewController:photosBrowserVC animated:YES completion:nil];
    }

}

@end
