//
//  TableViewPlaceholder.m
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import "TableViewPlaceholder.h"

@interface TableViewPlaceholder ()

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UILabel *tisLabel;


@end

@implementation TableViewPlaceholder

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeMainUI];
    }
    return self;
}
-(void)makeMainUI{
    
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _reloadButton.frame = CGRectMake(0, 0, 150, 150);
    _reloadButton.layer.cornerRadius = 75.0;
    [_reloadButton setBackgroundImage:[UIImage imageNamed:@"sure_placeholder_error"] forState:UIControlStateNormal];
    //    [_reloadButton setTitle:@"暂无数据，点击重新加载!" forState:UIControlStateNormal];
    //    [_reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //    [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
    [_reloadButton addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reloadButton];
    [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).with.offset(-90);
        make.centerX.equalTo(self);
    }];
    
    _tisLabel =[UILabel new];
    _tisLabel.text = @"It's no data here,click and reload!";
    _tisLabel.font =[UIFont systemFontOfSize:18];
    _tisLabel.textColor =[UIColor lightGrayColor];
    [self addSubview:_tisLabel];
    _tisLabel.userInteractionEnabled =YES;
    [_tisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_reloadButton.mas_bottom).with.offset(30);
    }];
    
    UITapGestureRecognizer *tapGes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadClick)];
    [_tisLabel addGestureRecognizer:tapGes];
    
}
//- (UIButton*)reloadButton {
//    if (!_reloadButton) {
//              CGRect rect = _reloadButton.frame;
//       // rect.origin.y -= 50;
//        _reloadButton.frame = rect;
//    }
//    return _reloadButton;
//}
-(void)setTitleStr:(NSString *)titleStr{
    
    _tisLabel.text = titleStr;
    
}
- (void)reloadClick {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}
@end
