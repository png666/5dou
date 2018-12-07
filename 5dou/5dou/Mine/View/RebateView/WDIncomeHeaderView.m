//
//  WDIncomeHeaderView.m
//  5dou
//
//  Created by 黄新 on 16/12/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  好友收益 头部
//

#import "WDIncomeHeaderView.h"
#import "WDInviteRebateModel.h"

@interface WDIncomeHeaderView ()

//表头
@property (nonatomic, strong) UIImageView *imgView; ///< 底图
@property (nonatomic, strong) UILabel *totalLabel; ///< 总收益
@property (nonatomic, strong) UIButton *inviteBtn; ///< 邀请好友

@end

@implementation WDIncomeHeaderView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    //总收益
    [self.imgView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.imgView.centerY).offset(-30);
        make.left.mas_equalTo((ScreenWidth - 200)/2.0);
    }];
    //已邀请的好友
    [self.imgView addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(26);
        make.left.mas_equalTo(self.mas_left).offset((ScreenWidth-150)/2.0);
    }];
}

- (void)configValue:(WDInviteRebateDataModel *)model{
    if (model) {
        //总收益
        NSString *textString = [NSString stringWithFormat:@"总收益：%@",model.totalRebate];
        NSMutableAttributedString *textAttribute = [[NSMutableAttributedString alloc] initWithString:textString];
        NSRange rang = [textString rangeOfString:model.totalRebate];
        [textAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:24] range:rang];
        [textAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x8b572a) range:rang];
        _totalLabel.attributedText = textAttribute;
        //邀请的好友
        [_inviteBtn setTitle:[NSString stringWithFormat:@"已邀请%@好友",model.inviteNumber] forState:UIControlStateNormal];
    }
}

#pragma mark ======= 懒加载
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"rebate_header_icon"];
        _imgView.userInteractionEnabled = YES;
    }
    return _imgView;
}
- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = WDColorFrom16RGB(0x8b572a);
        _totalLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLabel;
}
- (UIButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteBtn setTitleColor:WDColorFrom16RGB(0xffffff) forState:UIControlStateNormal];
        _inviteBtn.titleLabel.font = kFont12;
        [_inviteBtn setImage:[UIImage imageNamed:@"rebate_person_icon"] forState:UIControlStateNormal];
    }
    return _inviteBtn;
    
}

@end
