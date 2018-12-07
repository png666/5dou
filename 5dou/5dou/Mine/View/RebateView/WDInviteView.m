//
//  WDInviteView.m
//  5dou
//
//  Created by 黄新 on 16/11/25.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  邀请返利下面的View
//

#import "WDInviteView.h"
#import "ToolClass.h"
#import "WDDefaultAccount.h"
#import "WDInviteRebateModel.h"
#import "UIImageView+WebCache.h"
#import "UMCustomManager.h"

@interface WDInviteView ()

                         
@property (nonatomic, strong) UIImageView *cardImgView;///< 邀请背景
@property (nonatomic, strong) UILabel *inviteInfoLabel;
@property (nonatomic, strong) UIImageView *inviteImg;
@property (nonatomic, strong) UILabel *inviteCodeLabel;///< 邀请码
@property (nonatomic, strong) UIImageView *barCodeImgView;///< 二维码
@property (nonatomic, strong) UIButton *saveBtn;///< 保存到手机按钮
@property (nonatomic, strong) UIButton *inviteBtn;///< 立即邀请按钮
@property (nonatomic, strong) UILabel *inviteBriefLabel;///< 邀请好友说明

@property (nonatomic, assign) CGFloat marginTop;///< 距离上边距
@property (nonatomic, assign) CGFloat cardImgWidth;
@property (nonatomic, assign) CGFloat cardImgHeight;
@property (nonatomic, assign) CGFloat inviteTop;///< 邀请码之间的间距



@end

@implementation WDInviteView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    if (device_is_iphone_5) {
        self.marginTop = 0;
        self.cardImgWidth = 225;
        self.cardImgHeight = 250;
        self.inviteTop = 12;
    }else if (device_is_iphone_6){
        self.marginTop = 15;
        self.cardImgWidth = 270;
        self.cardImgHeight = 300;
        self.inviteTop = 15;
    }else if (device_is_iphone_6p) {
        self.marginTop = 20;
        self.cardImgWidth = 300;
        self.cardImgHeight = 330;
        self.inviteTop = 20;
    }
    //二维码 底部视图
    [self addSubview:self.cardImgView];
    [self.cardImgView mas_makeConstraints:^(MASConstraintMaker *make) {;
        make.width.mas_equalTo(self.cardImgWidth);
        make.height.mas_equalTo(self.cardImgHeight);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(self.marginTop);
    }];
    [self.cardImgView layoutIfNeeded];
    [self.cardImgView addSubview:self.inviteInfoLabel];
    [self.inviteInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.cardImgView);
        make.top.mas_equalTo(self.cardImgView.mas_top).offset(self.inviteTop);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(13);
    }];
    [self.cardImgView addSubview:self.inviteImg];
    [self.inviteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(17);
        make.centerX.mas_equalTo(self.cardImgView).offset(-32);
        make.top.mas_equalTo(self.inviteInfoLabel.mas_bottom).offset(6);
    }];
    //邀请码
    [self.cardImgView addSubview:self.inviteCodeLabel];
    [self.inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(19);
        make.centerY.mas_equalTo(self.inviteImg);
        make.left.mas_equalTo(self.inviteImg.mas_right);
    }];
    //二维码
    [self.cardImgView addSubview:self.barCodeImgView];
    [self.barCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.cardImgWidth/2-10, self.cardImgWidth/2-10));
        make.centerX.mas_equalTo(self.cardImgView);
        make.top.mas_equalTo(self.cardImgView.mas_top).offset(ScreenWidth>320?(ScreenWidth>375?115:95):77);
    }];
    //邀请返利介绍
    [self addSubview:self.inviteBriefLabel];
    [self.inviteBriefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(190);
        make.height.mas_equalTo(32);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.cardImgView.mas_bottom).offset(-20);
    }];
    
    //保存邀请按钮
    [self addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((self.cardImgView.width-40)/2.0);
        make.height.mas_equalTo(ScreenWidth>320?45:35);
        make.centerX.mas_equalTo(self.cardImgView.mas_centerX).offset(-self.cardImgView.width/4.0);
        make.top.mas_equalTo(self.cardImgView.mas_bottom).offset(ScreenWidth>320?15:14);
    }];
    [self addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.height.mas_equalTo(self.saveBtn);
        make.centerX.mas_equalTo(self.cardImgView.mas_centerX).offset(self.cardImgView.width/4.0);
    }];
}

- (void)configValue:(WDInviteRebateDataModel *)model{
    _inviteCodeLabel.text = [[WDDefaultAccount getUserInfo] objectForKey:@"inviteCode"];
    [_barCodeImgView sd_setImageWithURL:[NSURL URLWithString:model.qrCodePath] placeholderImage:[UIImage imageNamed:@""]];
}

#pragma mark ======= 点击事件
//保存二维码到本地
- (void)saveBtnDidClick:(UIButton *)sender{
    //将图片保存到手机
    UIImageWriteToSavedPhotosAlbum(self.barCodeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
//邀请好友
- (void)inviteBtnDidClick:(UIButton *)sender{
    if (self.inviteBtnDidClickBlock) {
        self.inviteBtnDidClickBlock(sender);
    }
}
#pragma mark ===== 保存二维码回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [ToolClass showAlertWithMessage:@"保存到手机失败"];
    }else{
        [ToolClass showAlertWithMessage:@"保存到手机成功"];
    }
}

#pragma mark ======= 懒加载

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
        _inviteCodeLabel.text = [[WDDefaultAccount getUserInfo] objectForKey:@"inviteCode"];
        _inviteCodeLabel.textAlignment = NSTextAlignmentRight;
        _inviteCodeLabel.textColor = WDColorFrom16RGB(0x8b572a);
        _inviteCodeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    }
    return _inviteCodeLabel;
}

- (UIImageView *)barCodeImgView{
    if (!_barCodeImgView) {
        _barCodeImgView = [[UIImageView alloc] init];
    }
    return _barCodeImgView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _saveBtn.backgroundColor = WDColorFrom16RGB(0xFDC000);
        _saveBtn.layer.cornerRadius = 4;
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn setTitle:@"保存手机" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:WDColorFrom16RGB(0xffffff) forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (UIButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _inviteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _inviteBtn.backgroundColor = WDColorFrom16RGB(0xFDC000);
        _inviteBtn.layer.cornerRadius = 4;
        _inviteBtn.layer.masksToBounds = YES;
        [_inviteBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
        [_inviteBtn setTitleColor:WDColorFrom16RGB(0xffffff) forState:UIControlStateNormal];
        [_inviteBtn addTarget:self action:@selector(inviteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
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
