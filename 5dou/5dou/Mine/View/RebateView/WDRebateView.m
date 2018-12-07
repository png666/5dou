//
//  WDRebateHeaderView.m
//  5dou
//
//  Created by 黄新 on 16/11/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDRebateView.h"
#import "YYText.h"
#import "ToolClass.h"

@interface WDRebateView ()

@property (nonatomic, strong) UIImageView *headerView;///<
@property (nonatomic, strong) YYLabel *incomeLabel;///< 收益
@property (nonatomic, strong) UIImageView *personImgView;
@property (nonatomic, strong) UILabel *inviteNumLabel;///< 邀请人数

@property (nonatomic, strong) UIImageView *inviteImgView;///< 邀请图标
@property (nonatomic, strong) UILabel *inviteTitleLabel;
@property (nonatomic, strong) UIImageView *cardImgView;///< 邀请背景
@property (nonatomic, strong) UILabel *inviteInfoLabel;
@property (nonatomic, strong) UIImageView *inviteImg;
@property (nonatomic, strong) UILabel *inviteCodeLabel;///< 邀请码
@property (nonatomic, strong) UIImageView *barCodeImgView;///< 二维码
@property (nonatomic, strong) UIButton *saveBtn;///< 保存到手机按钮
@property (nonatomic, strong) UIButton *inviteBtn;///< 立即邀请按钮
@property (nonatomic, strong) UILabel *inviteBriefLabel;///< 邀请好友说明


@end

@implementation WDRebateView

- (instancetype)init{
    if (self = [super init]) {
        self.incomeTotal = @"200";
        self.backgroundColor = WDColorFrom16RGB(0xffffff);
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.right.mas_equalTo(self);
        make.height.mas_equalTo(110);
    }];
    //总收益
    [self.headerView addSubview:self.incomeLabel];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).mas_equalTo(14);
    }];
    //已邀请的好友
    [self.headerView addSubview:self.personImgView];
    [self.personImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(54);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(14);
        make.left.mas_equalTo(self.mas_left).offset((ScreenWidth-113)/2);
    }];
    [self.headerView addSubview:self.inviteNumLabel];
    [self.inviteNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.personImgView.mas_right).offset(3);
        make.centerY.mas_equalTo(self.personImgView);
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(17);
    }];
    //邀请好友扫描注册
    [self addSubview:self.inviteImgView];
    [self.inviteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset((ScreenWidth - 205)/2);
        make.width.mas_equalTo(53);
        make.height.mas_equalTo(46);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(8);
    }];
    [self addSubview:self.inviteTitleLabel];
    [self.inviteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.inviteImgView.mas_centerY);
        make.left.mas_equalTo(self.inviteImgView.mas_right).offset(12);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(15);
    }];
    //二维码 底部视图
    [self addSubview:self.cardImgView];
    [self.cardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(225);
        make.height.mas_equalTo(250);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(55);
    }];
    [self.cardImgView addSubview:self.inviteInfoLabel];
    [self.inviteInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.cardImgView);
        make.top.mas_equalTo(self.cardImgView.mas_top).offset(12);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(13);
    }];
    [self.cardImgView addSubview:self.inviteImg];
    [self.inviteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cardImgView.mas_left).offset((225-96)/2.0);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(17);
        make.top.mas_equalTo(self.inviteInfoLabel.mas_bottom).offset(6);
    }];
    //邀请码
    [self.cardImgView addSubview:self.inviteCodeLabel];
    [self.inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(19);
        make.centerY.mas_equalTo(self.inviteImg);
        make.left.mas_equalTo(self.inviteImg.mas_right).offset(7);
    }];
    [self.cardImgView addSubview:self.barCodeImgView];
    [self.barCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.mas_equalTo(self.cardImgView);
        make.top.mas_equalTo(self.cardImgView.mas_top).offset(77);
    }];
    //保存邀请按钮
    [self.cardImgView addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(35);
        make.centerX.mas_equalTo(self.cardImgView.mas_centerX).offset(-50);
        make.top.mas_equalTo(self.barCodeImgView.mas_bottom).offset(20);
    }];
    [self.cardImgView addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.height.mas_equalTo(self.saveBtn);
        make.centerX.mas_equalTo(self.cardImgView.mas_centerX).offset(50);
    }];
    //邀请返利介绍
    [self addSubview:self.inviteBriefLabel];
    [self.inviteBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(190);
        make.height.mas_equalTo(32);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.cardImgView.mas_bottom).offset(12);
    }];
}

#pragma mark ======= 点击事件
- (void)saveBtnClick:(UIButton *)sender{
    [ToolClass showAlertWithMessage:@"保存到手机"];
}
- (void)inviteBtnClick:(UIButton *)sender{
    [ToolClass showAlertWithMessage:@"立即邀请"];
}

#pragma mark ======= 懒加载

- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@""];
    }
    return _headerView;
}

- (YYLabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[YYLabel alloc] init];
        _incomeLabel.textColor = WDColorFrom16RGB(0x8b572a);
        NSString *textString = [NSString stringWithFormat:@"总收益：%@",self.incomeTotal];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textString];
        NSRange rang = [textString rangeOfString:self.incomeTotal];
        text.yy_font = [UIFont systemFontOfSize:15];
        text.yy_color = WDColorFrom16RGB(0x8b572a);
        text.yy_alignment = NSTextAlignmentCenter;
        [text yy_setFont:[UIFont boldSystemFontOfSize:36] range:rang];
        
        _incomeLabel.attributedText = text;
    }
    return _incomeLabel;
}
- (UIImageView *)personImgView{
    if (!_personImgView) {
        _personImgView = [[UIImageView alloc] init];
        _personImgView.image = [UIImage imageNamed:@"rebate_person_icon"];
    }
    return _personImgView;
}
- (UILabel *)inviteNumLabel{
    if (!_inviteNumLabel) {
        _inviteNumLabel = [[UILabel alloc] init];
        _inviteNumLabel.textAlignment = NSTextAlignmentLeft;
        _inviteNumLabel.font = [UIFont systemFontOfSize:12];
        _inviteNumLabel.textColor = WDColorFrom16RGB(0xffffff);
        _inviteNumLabel.text = @"已邀请2000好友";
    }
    return _inviteNumLabel;
}
- (UIImageView *)inviteImgView{
    if (!_inviteImgView) {
        _inviteImgView = [[UIImageView alloc] init];
        _inviteImgView.image = [UIImage imageNamed:@"rebate_invite_img"];
    }
    return _inviteImgView;
}
- (UILabel *)inviteTitleLabel{
    if (!_inviteTitleLabel) {
        _inviteTitleLabel = [[UILabel alloc] init];
        _inviteTitleLabel.textAlignment = NSTextAlignmentCenter;
        _inviteTitleLabel.font = [UIFont systemFontOfSize:15];
        _inviteTitleLabel.textColor = WDColorFrom16RGB(0x666666);
        _inviteTitleLabel.text = @"邀请好友扫码注册";
    }
    return _inviteTitleLabel;
}
- (UIImageView *)cardImgView{
    if (!_cardImgView) {
        _cardImgView = [[UIImageView alloc] init];
        _cardImgView.userInteractionEnabled = YES;
        _cardImgView.image = [UIImage imageNamed:@"rebate_card_img"];
    }
    return _cardImgView;
}
- (UILabel *)inviteInfoLabel{
    if (!_inviteInfoLabel) {
        _inviteInfoLabel = [[UILabel alloc] init];
        _inviteInfoLabel.textAlignment = NSTextAlignmentCenter;
        _inviteInfoLabel.textColor = WDColorFrom16RGB(0x8b572a);
        _inviteInfoLabel.font = [UIFont systemFontOfSize:13];
        _inviteInfoLabel.text = @"您的邀请码";
    }
    return _inviteInfoLabel;
}

- (UIImageView *)inviteImg{
    if (!_inviteImg) {
        _inviteImg = [[UIImageView alloc] init];
        _inviteImg.image = [UIImage imageNamed:@"rebate_invite_icon"];
    }
    return _inviteImg;
}
- (UILabel *)inviteCodeLabel{
    if (!_inviteCodeLabel) {
        _inviteCodeLabel = [[UILabel alloc] init];
        _inviteCodeLabel.text = @"00115Y";
        _inviteCodeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _inviteCodeLabel;
}

- (UIImageView *)barCodeImgView{
    if (!_barCodeImgView) {
        _barCodeImgView = [[UIImageView alloc] init];
        _barCodeImgView.image = [UIImage imageNamed:@""];
    }
    return _barCodeImgView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _saveBtn.backgroundColor = WDColorFrom16RGB(0xf5a623);
        _saveBtn.layer.cornerRadius = 4;
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn setTitle:@"保存手机" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:WDColorFrom16RGB(0xffffff) forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _saveBtn;
}
- (UIButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _inviteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _inviteBtn.backgroundColor = WDColorFrom16RGB(0xf5a623);
        _inviteBtn.layer.cornerRadius = 4;
        _inviteBtn.layer.masksToBounds = YES;
        [_inviteBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
        [_inviteBtn setTitleColor:WDColorFrom16RGB(0xffffff) forState:UIControlStateNormal];
        [_inviteBtn addTarget:self action:@selector(inviteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteBtn;
}
- (UILabel *)inviteBriefLabel{
    if (!_inviteBriefLabel) {
        _inviteBriefLabel = [[UILabel alloc] init];
        _inviteBriefLabel.numberOfLines= 0;
        _inviteBriefLabel.textColor = WDColorFrom16RGB(0x666666);
        _inviteBriefLabel.font = [UIFont systemFontOfSize:13];
        NSString *textString = @"邀请好友注册，最高可获得好友收益15%的额外奖励。";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:textString];
        NSRange highlightRang = [textString rangeOfString:@"15%"];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:highlightRang];
        _inviteBriefLabel.attributedText = attributeString;
    }
    return _inviteBriefLabel;
}

@end
