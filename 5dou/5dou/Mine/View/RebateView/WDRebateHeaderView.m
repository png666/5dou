//
//  WDRebateHeaderView.m
//  5dou
//
//  Created by 黄新 on 16/11/25.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  邀请返利 头部
//

#import "WDRebateHeaderView.h"
#import "WDInviteRebateModel.h"

@interface WDRebateHeaderView ()
@property (nonatomic, strong) UIImageView *imgView;///<
@property (nonatomic, strong) UILabel *incomeLabel;///< 收益

@property (nonatomic, strong) UIButton *inviteBtn;///< 邀请人数


@end

@implementation WDRebateHeaderView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = WDColorFrom16RGB(0xffffff);
        self.backgroundColor = [UIColor redColor];
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
    [self.imgView addSubview:self.incomeLabel];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self).offset(-20);
        make.left.mas_equalTo((ScreenWidth - 200)/2.0);
    }];
    //已邀请的好友
    [self.imgView addSubview:self.inviteBtn];
//    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.incomeLabel.mas_bottom).offset(0);
//        make.width.mas_equalTo(125);
//        make.height.mas_equalTo(26);
//        make.left.mas_equalTo(self.mas_left).offset((ScreenWidth-125)/2.0);
//    }];

}

- (void)configValue:(WDInviteRebateDataModel *)model {
    if (model) {
        //总收益
        NSString *textString = [NSString stringWithFormat:@"总收益：%@",model.totalRebate];
        NSMutableAttributedString *textAttribute = [[NSMutableAttributedString alloc] initWithString:textString];
        NSRange rang = [textString rangeOfString:model.totalRebate];
        [textAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:24] range:rang];
        [textAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x8b572a) range:rang];
        _incomeLabel.attributedText = textAttribute;
        //邀请的好友
        [_inviteBtn setTitle:[NSString stringWithFormat:@"已邀请%@好友》",model.inviteNumber] forState:UIControlStateNormal];
        CGFloat width = 115;
        if (model.inviteNumber.length==2) {
            width = 115;
        }else if (model.inviteNumber.length == 4){
            width = 140;
        }
        [self.inviteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.incomeLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(26);
            make.left.mas_equalTo(self.mas_left).offset((ScreenWidth-125)/2.0);
        }];
    }else{
        //总收益
        NSString *textString = @"总收益：0";
        NSMutableAttributedString *textAttribute = [[NSMutableAttributedString alloc] initWithString:textString];
        NSRange rang = [textString rangeOfString:@"0"];
        [textAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:24] range:rang];
        [textAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x8b572a) range:rang];
        _incomeLabel.attributedText = textAttribute;
        //邀请的好友
        [_inviteBtn setTitle:@"已邀请0好友》" forState:UIControlStateNormal];
        [self.inviteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.incomeLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(115);
            make.height.mas_equalTo(26);
            make.left.mas_equalTo(self.mas_left).offset((ScreenWidth-125)/2.0);
        }];
    }
    
}
#pragma mark ==== 邀请好友
- (void)inviteBtnDidClick:(UIButton *)sender{
    if (self.inviteNumBtnDidClickBlock) {
        self.inviteNumBtnDidClickBlock(sender);
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

- (UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.textColor = WDColorFrom16RGB(0x8b572a);
        _incomeLabel.textAlignment = NSTextAlignmentCenter;
        _incomeLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    }
    return _incomeLabel;
}
- (UIButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteBtn setTitleColor:WDColorFrom16RGB(0xffffff) forState:UIControlStateNormal];
        _inviteBtn.titleLabel.font = kFont12;
        [_inviteBtn setImage:[UIImage imageNamed:@"rebate_person_icon"] forState:UIControlStateNormal];
        _inviteBtn.layer.cornerRadius = 13;
        _inviteBtn.layer.masksToBounds = YES;
        _inviteBtn.layer.borderColor = WDColorFrom16RGB(0xffffff).CGColor;
        _inviteBtn.layer.borderWidth = 1;
        [_inviteBtn addTarget:self action:@selector(inviteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_inviteBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _inviteBtn;
}

@end
