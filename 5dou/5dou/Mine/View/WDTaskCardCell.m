//
//  WDTaskCardCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  任务卡cell现在是H5实现
//

#import "WDTaskCardCell.h"

@interface WDTaskCardCell()

@end
@implementation WDTaskCardCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];

    }
    return self;
}

/**
 初始化UI
 */
- (void)initUI{
    [self addSubview:self.taskBgView];
    [self.taskBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.taskBgView addSubview:self.cardTitleLabel];
    [self.cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_equalTo(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-18);
        make.height.mas_equalTo(18.f);
    }];
    [self.taskBgView addSubview:self.cardCountLabel];
    [self.cardCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cardTitleLabel.mas_bottom).offset(22);
        make.size.mas_equalTo(CGSizeMake(26, 65));
        make.left.mas_equalTo(self.contentView.mas_left).offset(60);
    }];
    [self.taskBgView addSubview:self.cardBriefLabel];
    [self.cardBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.taskBgView.mas_top).offset(114);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.right).mas_equalTo(-10);
    }];
    [self.taskBgView addSubview:self.cardContentLabel];
    [self.cardContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cardBriefLabel.mas_bottom).offset(2);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark ====== 懒加载

- (UIImageView *)taskBgView{
    if (!_taskBgView) {
        _taskBgView = [[UIImageView alloc] init];
    }
    return _taskBgView;
}
- (UILabel *)cardTitleLabel{
    if (!_cardTitleLabel) {
        _cardTitleLabel = [[UILabel alloc] init];
        _cardTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _cardTitleLabel.font = [UIFont systemFontOfSize:18];
        _cardTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        _cardTitleLabel.textColor = WDColorFrom16RGB(0xffffff);
    }
    return _cardTitleLabel;
}
- (UILabel *)cardCountLabel{
    if (!_cardCountLabel) {
        _cardCountLabel = [[UILabel alloc] init];
        _cardCountLabel.textAlignment = NSTextAlignmentCenter;
        _cardCountLabel.textColor = WDColorFrom16RGB(0xffffff);
        _cardCountLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:65];
        _cardCountLabel.text = @"5";
    }
    return _cardCountLabel;
}
- (UILabel *)cardBriefLabel{
    if (!_cardBriefLabel) {
        _cardBriefLabel = [[UILabel alloc] init];
        _cardBriefLabel.textAlignment = NSTextAlignmentLeft;
        _cardBriefLabel.font = [UIFont systemFontOfSize:13];
        _cardBriefLabel.textColor = WDColorFrom16RGB(0x666666);
        _cardBriefLabel.text = @"任务卡介绍：";
    }
    return _cardBriefLabel;
}
- (UILabel *)cardContentLabel{
    if (!_cardContentLabel) {
        _cardContentLabel = [[UILabel alloc] init];
        _cardContentLabel.numberOfLines = 2;
        _cardContentLabel.textColor = WDColorFrom16RGB(0x999999);
        _cardContentLabel.font = [UIFont systemFontOfSize:12];
        _cardContentLabel.text = @"我们目前实施会员等级管理制度，粘性较强。";
    }
    return _cardContentLabel;
}

@end
