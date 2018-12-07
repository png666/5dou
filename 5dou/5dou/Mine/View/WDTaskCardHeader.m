//
//  WDTaskCardHeader.m
//  5dou
//
//  Created by 黄新 on 16/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  任务卡头部View  没有使用现在是H5替代
//

#import "WDTaskCardHeader.h"

@interface WDTaskCardHeader ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *briefLabel;///< 任务卡简介
@property (nonatomic, strong) UILabel *contentLabel;///<
@end

@implementation WDTaskCardHeader

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(130);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top);
    }];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(63);
        make.right.left.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
    [self.headerView addSubview:self.headerImgView];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(120);
        make.center.mas_equalTo(self.headerView);
    }];
    [self.contentView addSubview:self.briefLabel];
    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5.5);
    }];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(31);
        make.right.mas_equalTo(self.contentView.right).mas_equalTo(-10);
        make.left.mas_equalTo(self.contentView.left).mas_equalTo(10);
        make.top.mas_equalTo(self.briefLabel.mas_bottom).offset(2);
    }];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    //设置圆角
    [self setCornerRadius];
}
- (void)setCornerRadius{
    //headerView
    CGRect headerViewRect = CGRectMake(0, 0, ScreenWidth-20, 130);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerViewRect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headerViewRect;
    maskLayer.path = maskPath.CGPath;
    self.headerView.layer.mask = maskLayer;
    //contentView
    CGRect contentViewRect = CGRectMake(0, 0, ScreenWidth-20, 63);
    UIBezierPath *contentMaskPath = [UIBezierPath bezierPathWithRoundedRect:contentViewRect byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *contentMaskLayer = [[CAShapeLayer alloc] init];
    contentMaskLayer.frame = contentViewRect;
    contentMaskLayer.path = contentMaskPath.CGPath;
    self.contentView.layer.mask = contentMaskLayer;
    
}


#pragma mark ====== 懒加载

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = WDColorFrom16RGB(0xfdc000);
    }
    return _headerView;
}

- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"taskcard_header_img"];
    }
    return _headerImgView;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return _contentView;
}
- (UILabel *)briefLabel{
    if (!_briefLabel) {
        _briefLabel = [[UILabel alloc] init];
        _briefLabel.textAlignment = NSTextAlignmentLeft;
        _briefLabel.text = @"任务卡介绍：";
        _briefLabel.textColor = WDColorFrom16RGB(0x666666);
    }
    return _briefLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"我们目前分布国内城市的大、专院校，拥有千万级学生会员，实施会员等级管理制度，粘性较强。";
        _contentLabel.textColor = WDColorFrom16RGB(0x666666);
        _contentLabel.font = [UIFont systemFontOfSize:12];
    }
    return _contentLabel;
}


@end
