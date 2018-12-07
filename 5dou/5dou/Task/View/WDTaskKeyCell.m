//
//  WDTaskKeyCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskKeyCell.h"
#import "ToolClass.h"
@interface WDTaskKeyCell()
@property (nonatomic,strong) UIButton *keyButton;
@end
@implementation WDTaskKeyCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI{
    
    _keyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_keyButton];
    [_keyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    [_keyButton addTarget:self action:@selector(keyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _keyButton.titleLabel.font = kFont14;
    _keyButton.enabled = NO;
}

- (void)setKeyTitle:(NSString *)title{
    [_keyButton setTitle:title forState:UIControlStateNormal];
}


- (void)select{
    _keyButton.backgroundColor = kNavigationBarColor;
    [_keyButton setTitleColor:WDColorFrom16RGB(0x8B572A) forState:UIControlStateNormal];
    [ToolClass setView:_keyButton withRadius:8.0f andBorderWidth:.25f andBorderColor:WDColorFrom16RGB(0x8B572A)];
    
}

- (void)inverse{
    _keyButton.backgroundColor = kWhiteColor;
    [_keyButton setTitleColor:WDColorFrom16RGB(0x8B572A) forState:UIControlStateNormal];
    [ToolClass setView:_keyButton withRadius:8.0f andBorderWidth:.25f andBorderColor:kGrayColor];
}

- (void)keyButtonClick:(UIButton *)button{
    if (_taskKeyCellClick) {
        _taskKeyCellClick(button.titleLabel.text);
    }
}

@end
