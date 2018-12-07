//
//  WDTitleView.m
//  5dou
//
//  Created by 黄新 on 16/11/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTitleView.h"


@interface WDTitleView ()

@end

@implementation WDTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.userInteractionEnabled = YES;
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self).offset(4);
        make.left.mas_equalTo(self.mas_left).offset(15);
    }];
    [self addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.imgView);
        make.left.mas_equalTo(self.imgView.mas_right).offset(4);
    }];
    
}

#pragma mark ======== 懒加载

- (UIButton *)imgView{
    if (!_imgView) {
        _imgView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgView setAdjustsImageWhenHighlighted:NO];
    }
    return _imgView;
}
- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}


@end
