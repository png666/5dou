//
//
//
//
////
////  WDCashBarView.m
////  5dou
////
////  Created by rdyx on 16/11/19.
////  Copyright © 2016年 吾逗科技. All rights reserved.
////
//
#import "WDCashBarView.h"

#import <Colours/Colours.h>
@implementation WDCashBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

-(void)makeUI
{
#pragma mark - doubiView
    CGFloat viewHeight = self.frame.size.height;
    UIView *cardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3, viewHeight)];
    //    cardView.backgroundColor = kWhiteColor;
    cardView.tag = 1001;
    [self addSubview:cardView];
    
    UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(cardView.right, 10, 0.5, viewHeight-20)];
    sepratorLine.backgroundColor = kLightGrayColor;
    [cardView addSubview:sepratorLine];
    
    UIImageView *cardImag = [UIImageView new];
    cardImag.image = WDImgName(@"taskCard");
    [cardView addSubview:cardImag];
    [cardImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView.mas_centerY);
        make.centerX.equalTo(cardView.mas_centerX).offset(-25);
        make.height.and.width.equalTo(@40);
    }];
    

    UILabel *cardNumLabel = [UILabel new];
    cardNumLabel.text = @"0";
    cardNumLabel.font = kFont16;
    cardNumLabel.textColor = WDColorFrom16RGB(0xFF8564);
    self.cardNumLabel = cardNumLabel;
    [cardView addSubview:cardNumLabel];
    
    [cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardView.mas_centerX).offset(20);
        make.bottom.equalTo(cardView.mas_bottom).offset(-12);
        make.height.equalTo(@14);
    }];
    
    
    UILabel *card = [UILabel new];
    card.text = @"任务卡";
    card.textColor = kGrayColor;
    card.font = kFont14;
    card.backgroundColor = kClearColor;
    [cardView addSubview:card];
    
    [card mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardNumLabel.mas_top).offset(-8);
        make.centerX.equalTo(cardNumLabel.mas_centerX);
        make.height.equalTo(@14);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardTap:)];
    [cardView addGestureRecognizer:tap];
    
    
    
    UIView *cashView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, viewHeight)];
    //    cashView.backgroundColor = kLightGrayColor;
    cashView.tag = 1002;
    [self addSubview:cashView];
    UITapGestureRecognizer *tapCash = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cashTap:)];
    [cashView addGestureRecognizer:tapCash];
    
    UIImageView *cashImag = [UIImageView new];
    cashImag.image = WDImgName(@"doubii");
    [cashView addSubview:cashImag];
    [cashImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cashView.mas_centerY);
        make.centerX.equalTo(cashView.mas_centerX).offset(-25);
        make.height.and.width.equalTo(@40);
    }];

    
    UILabel *cashNumLabel = [UILabel new];
    cashNumLabel.text = @"2002";
    cashNumLabel.font = kFont16;
    cashNumLabel.textColor = WDColorFrom16RGB(0xFF8564);
    self.cashNumLabel = cashNumLabel;
    [cashView addSubview:cashNumLabel];
    
    [cashNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cashView.mas_centerX).offset(20);
        make.bottom.equalTo(cashView.mas_bottom).offset(-12);
        make.height.equalTo(@14);
    }];

    
    UILabel *cash = [UILabel new];
    cash.text = @"我的逗币";
    cash.textColor = kGrayColor;
    cash.font = kFont14;
    cash.backgroundColor = kClearColor;
    [cashView addSubview:cash];
    
    [cash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cashNumLabel.mas_top).offset(-8);
        make.centerX.equalTo(cashNumLabel.mas_centerX);
        make.height.equalTo(@14);
    }];
    
    
    
    UIView *signView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, viewHeight)];
    //    signView.backgroundColor = kCyanColor;
    signView.tag = 1003;
    [self addSubview:signView];//
    
    UITapGestureRecognizer *tapSign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signTap:)];
    [signView addGestureRecognizer:tapSign];
    
    UIImageView *signImag = [UIImageView new];
    signImag.image = WDImgName(@"sign");
    [signView addSubview:signImag];
    [signImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(signView.mas_centerY);
        make.centerX.equalTo(signView.mas_centerX).offset(-25);
        make.height.and.width.equalTo(@40);
    }];

    UILabel *signLabel = [UILabel new];
    signLabel.text = @"签到";
    signLabel.font = kFont14;
    signLabel.textColor = WDColorFrom16RGB(0xFF8564);
    self.isSignLabel = signLabel;
    [signView addSubview:signLabel];
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(signView.mas_centerX).offset(20);
        make.bottom.equalTo(signView.mas_bottom).offset(-12);
        make.height.equalTo(@14);
    }];

    
    UILabel *sign = [UILabel new];
    sign.text = @"签到有礼";
    sign.textColor = kGrayColor;
    sign.font = kFont14;
    sign.backgroundColor = kClearColor;
    [signView addSubview:sign];
    
    [sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(signLabel.mas_top).offset(-8);
        make.centerX.equalTo(signLabel.mas_centerX);
        make.height.equalTo(@14);
    }];
    
    
    UIView *seprator = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*2, 10, 0.5, viewHeight-20)];
    seprator.backgroundColor = kLightGrayColor;
    [self addSubview:seprator];
    
}
-(void)cardTap:(UITapGestureRecognizer *)tap
{
    YYLog(@"car");
    if (_block) {
        _block(tap.view.tag);
    }
}


-(void)cashTap:(UITapGestureRecognizer *)tap
{
    YYLog(@"cahs");
    if (_block) {
        _block(tap.view.tag);
    }
}

-(void)signTap:(UITapGestureRecognizer *)tap
{
    YYLog(@"cs");
    if (_block) {
        _block(tap.view.tag);
    }
}


@end
