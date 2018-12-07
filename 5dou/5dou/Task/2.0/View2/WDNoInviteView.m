//
//  WDNoInviteView.m
//  5dou
//
//  Created by 黄新 on 17/1/5.
//  Copyright © 2017年 吾逗科技. All rights reserved.
//

#import "WDNoInviteView.h"

@interface WDNoInviteView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *inviteBtn;

@end

@implementation WDNoInviteView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{

    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(140);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(ScreenWidth>320?70:40);
    }];
    [self addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(20);
    }];
    [self addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth>320?260:200);
        make.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(30);
    }];
}

- (void)inviteBtnDidClick:(UIButton *)sender{
    if (self.inviteBtnDidClickBlock) {
        self.inviteBtnDidClickBlock();
    }
}

#pragma mark ==== 懒加载
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"invitation_empty"];
    }
    return _imgView;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:14];
        _infoLabel.textColor = WDColorFrom16RGB(0x999999);
        _infoLabel.text = @"空空如也，快去邀友取金！";
    }
    return _infoLabel;
}
- (UIButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:17];
        _inviteBtn.layer.masksToBounds = YES;
        _inviteBtn.layer.cornerRadius = 22.f;
        [_inviteBtn setBackgroundColor:WDColorFrom16RGB(0xffd300)];
        [_inviteBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
        [_inviteBtn setTitleColor:WDColorFrom16RGB(0x8d592b) forState:UIControlStateNormal];
        [_inviteBtn addTarget:self action:@selector(inviteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteBtn;
}

@end
