//
//  PicShowCollectionViewCell.m
//  DiaryInstant
//
//  Created by George on 2019/3/14.
//  Copyright © 2019 George. All rights reserved.
//

#import "PicShowCollectionViewCell.h"

@interface PicShowCollectionViewCell ()
{
    UIImageView *_imageView;
    UIButton *_selectedBtn;
    UILabel *timeLabel;
    
}
@end
@implementation PicShowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadInterface];
    }
    return self;
}
-(void)loadInterface{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _imageView =[[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];
    
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn setImage:[UIImage imageNamed:@"Intelligent_noselected"] forState:UIControlStateNormal];
    _selectedBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)-40, 10, 30, 30);
    //[_selectedBtn addTarget:self action:@selector(selectedBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    //[self addSubview:_selectedBtn];
    
    timeLabel = [UILabel new];
    timeLabel.text = @"0000-00-00 00:00:00";
    timeLabel.numberOfLines = 2;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView);
    }];
}
-(void)setIndexPathRow:(NSInteger)indexPathRow{
    _indexPathRow =indexPathRow;
    
}
-(void)setShowImage:(UIImage *)showImage{
    
    _showImage = showImage;
    [_selectedBtn setImage:showImage forState:UIControlStateNormal];
}
-(void)loadInterfaceWithModel:(PicShowModel*)picModel{
    
    if([picModel.type isEqual:@"1"]){
        [_imageView sd_setImageWithURL:[NSURL URLWithString:picModel.content] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
    }else{
//        _imageView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"add-pic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:picModel.content] placeholderImage:[UIImage imageNamed:@"add-pic"]];
    }
    
    timeLabel.text = picModel.createTime;//[NSString getFormatterTimeWithTimeSp:picModel.createTime];
    
}
#pragma mark - 点击事件
-(void)selectedBtnClcik:(UIButton*)btn{
    NSLog(@"选中");
    UIImage *selectedImage =[UIImage imageNamed:@"Intelligent_selected"];
    [btn setImage:selectedImage forState:UIControlStateNormal];
    [self.delegate clickSelectedBtnWithInteger:self.indexPathRow];
    
}
@end
