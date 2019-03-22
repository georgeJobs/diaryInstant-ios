//
//  SelectPhotoController.m
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import "SelectPhotoController.h"
#import "PicShowCollectionViewCell.h"

@interface SelectPhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    NSMutableArray *_mulArr;
    NSInteger _selectedRow;
    MBProgressHUD *_hud;
}
@property(nonatomic,strong) UITableView *table;
@end

@implementation SelectPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Select Photo";
    // Do any additional setup after loading the view.
    _mulArr = [[NSMutableArray alloc] initWithCapacity:0];
    //[self makeNav];
    [self makeCollectionView];
    [self makePicRequest];
}

-(void)makeCollectionView{
    
    CGFloat itemWidth =(SCREEN_WIDTH - 5)/5;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 3.5f;
    flowLayout.minimumLineSpacing = 10.5f;
    [flowLayout setItemSize:CGSizeMake(itemWidth,itemWidth)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, NAV_HEIGHT, SCREEN_WIDTH-20, SCREEN_HEIGHT-NAV_HEIGHT) collectionViewLayout:flowLayout];
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
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.label.text = @"Load...";
    
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
        
        [self->_mulArr addObjectsFromArray:[PicShowModel mj_objectArrayWithKeyValuesArray:itemArr]];
        
        [_collectionView reloadData];
        [_collectionView.mj_header endRefreshing];
        
        if(itemArr.count<30){
            _collectionView.mj_footer.hidden=YES;
        }else{
            _collectionView.mj_footer.hidden=NO;
        }
        //_tablePlaceHolder.hidden =YES;
        _hud.hidden=YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _hud.hidden=YES;
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
    //picModel.imageId = _mulArr[indexPath.row][@"id"];
    [picShowCell loadInterfaceWithModel:picModel];
    return picShowCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
    PicShowModel *model = [_mulArr objectAtIndex:indexPath.row];
    if(self.showPicBlock){
        self.showPicBlock(model.resourceId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeNav{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTintColor:[UIColor whiteColor]];
    sureBtn.frame =CGRectMake(0, 0, 50, 25);
    [sureBtn setTitle:@"Selecte" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn addTarget:self action:@selector(sureBtnDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem =rightItem;
    
}

#pragma mark - 导航栏右侧按钮事件
-(void)sureBtnDown{
    
    NSLog(@"Selected");
    if(_mulArr.count>0){
        
        PicShowModel *model = [_mulArr objectAtIndex:_selectedRow];
        if(self.showPicBlock){
            self.showPicBlock(model.resourceId);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
