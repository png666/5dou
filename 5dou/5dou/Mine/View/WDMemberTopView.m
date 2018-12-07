

//
//  WDMemberTopView.m
//  5dou
//
//  Created by rdyx on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDMemberTopView.h"
#import "WDUserInfoModel.h"
#import "ToolClass.h"
#import "UIColor+Hex.h"

@interface WDMemberTopView()

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomeView;

@end

static CGFloat BottomViewHeight = 60.f;

@implementation WDMemberTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kNavigationBarColor;
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"wave"ofType:@"png"];
//    UIImage *image = [UIImage imageNamed:@"wave"];
//    topView.layer.contents = (id)image.CGImage;
    UIImageView *bg = [[UIImageView alloc]initWithFrame:topView.bounds];
    bg.image = [UIImage imageNamed:@"wave.jpg"];
    [topView addSubview:bg];
    [self addSubview:topView];
    self.topView = topView;
    
    
    
    UIImageView *headImage = [UIImageView new];
    headImage.image = WDImgName(@"head");
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.topView addSubview:headImage];
    self.headerImage = headImage;
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@60);
        make.centerX.equalTo(topView);
        make.top.equalTo(self).offset(2);

    }];
    
    [ToolClass setView:headImage withRadius:30.f andBorderWidth:0 andBorderColor:kClearColor];
    
    
    UILabel *LoginLabel = [UILabel new];
    LoginLabel.backgroundColor = kClearColor;
    LoginLabel.textColor = kBlackColor;
    LoginLabel.font = kFont14;
    LoginLabel.textAlignment = NSTextAlignmentCenter;
    LoginLabel.text = @"请登录";
//    LoginLabel.hidden = YES;
    [self.topView addSubview:LoginLabel];
    self.loginLabel = LoginLabel;
    [LoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_bottom).offset(8);
        make.centerX.equalTo(headImage);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];

    
    //名字label
    UILabel *nameLabel = [UILabel new];
    nameLabel.backgroundColor = kClearColor;
    nameLabel.textColor = kBlackColor;
    nameLabel.font = kFont15;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = [WDUserInfoModel shareInstance].nickName;
    nameLabel.hidden = YES;
    [self.topView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_bottom).offset(5);
        make.centerX.equalTo(headImage);
        make.height.equalTo(@20);
    }];
    //性别
    UIImageView *genderImage = [UIImageView new];
    genderImage.hidden = YES;
    self.genderImage = genderImage;
    [self.topView addSubview:genderImage];
    [genderImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_top).offset(4);
        make.left.equalTo(nameLabel.mas_right).offset(3);
        make.width.and.height.equalTo(@10.5);
        
    }];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.bottom+3, ScreenWidth, BottomViewHeight)];
//    bottomView.backgroundColor = kCyanColor;
    [self addSubview:bottomView];
    self.bottomeView = bottomView;
    
}

@end
