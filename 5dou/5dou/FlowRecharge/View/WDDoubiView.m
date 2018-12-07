//
//  WDDoubiView.m
//  5dou
//
//  Created by 黄新 on 16/12/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值页面 显示逗币的View
//
//


#import "WDDoubiView.h"
#import "WDFlowPackageModel.h"

@interface WDDoubiView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imgView; 
@property (nonatomic, strong) UILabel *doubiLabel; ///< 逗币数量

@end

@implementation WDDoubiView



- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

#pragma mark ===== 初始化视图
- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(300);
    }];
    [self.bgView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(81);
        make.height.mas_equalTo(68);
        make.centerY.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView.mas_left).offset(21);
    }];
    [self.bgView addSubview:self.doubiLabel];
    [self.doubiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgView.mas_right).offset(10);
        make.height.mas_equalTo(34);
        make.centerY.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
    }];
}

/**
 填充数据

 @param model 数据源
 */
- (void)config:(WDFlowPackageModel *)model{
    if (model) {
        CGFloat walletAmount = [model.data.walletAmount floatValue];
        NSString *doubiString = [NSString stringWithFormat:@"我的逗币:%.2f",walletAmount];
        NSMutableAttributedString *doubiAttribute = [[NSMutableAttributedString alloc] initWithString:doubiString];
        NSRange rang = [doubiString rangeOfString:[NSString stringWithFormat:@"%.2f",walletAmount]];
        [doubiAttribute addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:28] range:rang];
        [doubiAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0xfec100) range:rang];
        self.doubiLabel.attributedText = doubiAttribute;
    }
    
}
#pragma  mark  ====== 懒加载
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [_imgView setImage:[UIImage imageNamed:@"flow_doubi"]];
    }
    return _imgView;
}
- (UILabel *)doubiLabel{
    if (!_doubiLabel) {
        _doubiLabel = [[UILabel alloc] init];
        _doubiLabel.text = @"0";
        _doubiLabel.textAlignment = NSTextAlignmentLeft;
        _doubiLabel.textColor = WDColorFrom16RGB(0x999999);
        _doubiLabel.font = kFont14;
    }
    return _doubiLabel;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}




@end
