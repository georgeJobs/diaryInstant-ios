//
//  SystemMessageTableViewCell.m
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@interface SystemMessageTableViewCell ()
{
    
    UIImageView *_headView;
    UILabel *_timeLabel;
    UILabel *_titlelaebl;
    UILabel *_subtitle;
    UIView *_redPoint;
    
}
@property(nonatomic,strong)UIView *constumView;

@end

@implementation SystemMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initData];
        [self makeMainUI];
    };

    return self;
}
-(void)initData{
    

}
-(void)makeMainUI{
    
    _headView = [UIImageView new];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_headView];
    _headView.layer.cornerRadius = 20;
    _headView.layer.masksToBounds = YES;
    _headView.image = [UIImage imageNamed:@"HomePage_logo"];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
        make.width.height.mas_equalTo(40);
    }];
    
//    _redPoint = [UIView new];
//    _redPoint.backgroundColor = [UIColor redColor];
//    _redPoint.layer.cornerRadius = 5;
//    _redPoint.layer.masksToBounds =YES;
//    [self.contentView addSubview:_redPoint];
//
//    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.width.height.mas_equalTo(10);
//        make.right.equalTo(_headView).with.offset(0);
//        make.top.equalTo(_headView).with.offset(-2);
//    }];
    
    _titlelaebl = [UILabel new];
    _titlelaebl.text = @"系统";
    _titlelaebl.font = [UIFont systemFontOfSize:15];
    _titlelaebl.textColor = UIColorFromRGB(0x333333);
    _titlelaebl.numberOfLines = 2;
    [self.contentView addSubview:_titlelaebl];
    
    [_titlelaebl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_headView);
        make.left.equalTo(_headView.mas_right).with.offset(15);
        make.right.equalTo(self.contentView.mas_right).with.offset(-15);
      //  make.height.mas_equalTo(40);
    }];
    
    
    _subtitle = [UILabel new];
    _subtitle.text = @"这是一条副标题！哈哈哈哈哈";
    _subtitle.font = [UIFont systemFontOfSize:13];
    _subtitle.textColor =  UIColorFromRGB(0x999999);
    [self.contentView addSubview:_subtitle];
    
    [_subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titlelaebl.mas_bottom).with.offset(1);
        make.left.equalTo(_headView.mas_right).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"";
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = UIColorFromRGB(0x666666);
    [self.contentView addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_subtitle);
        make.right.equalTo(self.contentView).with.offset(-15);
        
    }];
}
-(void)loadInterFaceWithModel:(HomeMessageModel*)model{

    _titlelaebl.text = [NSString stringWithFormat:@"%@",model.name];
    
    if(model.content.length > 40){
        
        if(SCREEN_WIDTH == 320.0){
            
            _titlelaebl.text = [NSString stringWithFormat:@"%@...",[model.name substringToIndex:30]];

        }else{
            
            _titlelaebl.text = [NSString stringWithFormat:@"%@...",[model.name substringToIndex:39]];

        }
    }
    _subtitle.text = [NSString stringWithFormat:@"%@",model.email];
    
    if(model.msgFrom.length > 35){
        
        if(SCREEN_WIDTH == 320.0){
            
            _subtitle.text = [NSString stringWithFormat:@"%@...",[model.email substringToIndex:30]];

        }else{
            
            _subtitle.text = [NSString stringWithFormat:@"%@...",[model.email substringToIndex:39]];
        }
    }
    
    //_timeLabel.text = [NSString stringWithFormat:@"%@",[NSString getFormatterTimeWithTimeSp:model.pushTime andDateFormat:@"YYYY-MM-dd"]];
    
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.profileUrl] placeholderImage:[UIImage imageNamed:@"Default_headImage"]];
    
//    if([[NSString stringWithFormat:@"%@",model.readStatus] isEqualToString:@"Readed"]){
//        
//        _redPoint.hidden = YES;
//    }else{
//        
//        _redPoint.hidden = NO;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
