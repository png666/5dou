



//
//  WDDoubiBarView.m
//  5dou
//
//  Created by rdyx on 16/11/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDDoubiBarView.h"

@implementation WDDoubiBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        self.backgroundColor = kClearColor;
    }
    return self;
}

-(void)makeUI
{
#pragma mark - doubiView
    CGFloat viewHeight = self.frame.size.height;
    UIView *cardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3, viewHeight)];
    //    cardView.backgroundColor = kWhiteColor;
//    cardView.tag = 1001;
    [self addSubview:cardView];
    
    UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(cardView.right, 10, 0.5, viewHeight-20)];
    sepratorLine.backgroundColor = kLightGrayColor;
    [cardView addSubview:sepratorLine];
    
    
    UILabel *card = [UILabel new];
    
    card.text = @"收入合计";
    card.textColor = KCoffeeColor;
    card.font = kFont14;
    card.backgroundColor = kClearColor;
    [cardView addSubview:card];
    
    [card mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardView.mas_centerX);
        make.bottom.equalTo(cardView.mas_bottom).offset(-10);
        make.height.equalTo(@14);
    }];
    
    UILabel *cardNumLabel = [UILabel new];
    cardNumLabel.text = @"";
    cardNumLabel.font = kFont14;
    cardNumLabel.textColor =kBlackColor;
    self.cardNumLabel = cardNumLabel;
    [cardView addSubview:cardNumLabel];
    
    [cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(card.mas_top).offset(-8);
        make.centerX.equalTo(card.mas_centerX);
        make.height.equalTo(@14);
    }];

    UIView *cashView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, viewHeight)];
    //    cashView.backgroundColor = kLightGrayColor;
//    cashView.tag = 1002;
    [self addSubview:cashView];
    
    
    UILabel *cash = [UILabel new];
    cash.text = @"逗币";
    cash.textColor = WDColorRGB(138, 87, 47);
    cash.font = kFont14;
    cash.backgroundColor = kClearColor;
    [cashView addSubview:cash];
    
    [cash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cashView.mas_centerX);
        make.bottom.equalTo(cashView.mas_bottom).offset(-10);
        make.height.equalTo(@14);
    }];
    
    UILabel *cashNumLabel = [UILabel new];
    cashNumLabel.text = @"";
    cashNumLabel.font = [UIFont systemFontOfSize:36];
    cashNumLabel.textColor = WDColorRGB(138, 87, 47);
    self.cashNumLabel = cashNumLabel;
    [cashView addSubview:cashNumLabel];
    
    [cashNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cash.mas_top).offset(-8);
        make.centerX.equalTo(cash.mas_centerX);
        make.height.equalTo(@14);
    }];
    
    
    UIView *signView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*2, 0, ScreenWidth/3, viewHeight)];
    //    signView.backgroundColor = kCyanColor;
//    signView.tag = 1003;
    [self addSubview:signView];//
    
    UILabel *sign = [UILabel new];
    sign.text = @"提现合计";
    sign.textColor = WDColorRGB(138, 87, 47);
    sign.font = kFont14;
    sign.backgroundColor = kClearColor;
    [signView addSubview:sign];
    
    [sign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(signView.mas_centerX);
        make.bottom.equalTo(signView.mas_bottom).offset(-10);
        make.height.equalTo(@14);
    }];
    
    UILabel *signLabel = [UILabel new];
    signLabel.text = @"";
    signLabel.font = kFont14;
    signLabel.textColor = WDColorRGB(138, 87, 47);
    self.isSignLabel = signLabel;
    [signView addSubview:signLabel];
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sign.mas_top).offset(-8);
        make.centerX.equalTo(sign.mas_centerX);
        make.height.equalTo(@14);
    }];
    
    
    UIView *seprator = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*2, 10, 0.5, viewHeight-20)];
    seprator.backgroundColor = kLightGrayColor;
    [self addSubview:seprator];
    
}

@end
