//
//  WDStepView.m
//  5dou
//
//  Created by 黄新 on 17/1/3.
//  Copyright © 2017年 吾逗科技. All rights reserved.
//
//  新手引导页（首次使用的用户显示功能指导）
//
//

#import "WDGuideView.h"

@interface WDGuideView ()
@property (nonatomic, strong) UIButton *stepBtn;
@property (nonatomic, strong) UIImageView *guideImgView;
@property (nonatomic, assign) NSInteger stepCount;

@end

@implementation WDGuideView

- (instancetype)init{
    if (self = [super init]) {
        self.stepCount = 1;
        [self initUI];
    }
    return self;
}
#pragma mark ===== 初始化UI
- (void)initUI{
    [self addSubview:self.guideImgView];
    [self.guideImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    CGFloat stepBtnWidth = 100;
    CGFloat stepBtnHeight = 50;
    CGFloat stepBtnBottom = 87;
    if (device_is_iphone_4||device_is_iphone_5) {
        stepBtnBottom = 87;
        stepBtnWidth = 100;
        stepBtnHeight = 50;
    }else if (device_is_iphone_6){
        stepBtnBottom = 110;
        stepBtnWidth = 120;
        stepBtnHeight = 50;
    }else if (device_is_iphone_6p){
        stepBtnBottom = 120;
        stepBtnWidth = 135;
        stepBtnHeight = 55;
    }
    [self.guideImgView addSubview:self.stepBtn];
    [self.stepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.guideImgView);
        make.width.mas_equalTo(stepBtnWidth);
        make.height.mas_equalTo(stepBtnHeight);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-stepBtnBottom);
    }];
}

#pragma mark ==== 按钮点击事件
- (void)stepBtnDidClick:(UIButton *)sender{
    _stepCount++;
    if (_stepCount<=3) {
        self.guideImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%ld",_stepCount]];
    }else{
        if (self.dismissGuideView) {
            self.dismissGuideView();
        }
    }
}

#pragma mark ==== 懒加载
- (UIImageView *)guideImgView{
    if (!_guideImgView) {
        _guideImgView = [[UIImageView alloc] init];
        _guideImgView.image = [UIImage imageNamed:@"guide_1"];
        _guideImgView.userInteractionEnabled = YES;
    }
    return _guideImgView;
}
- (UIButton *)stepBtn{
    if (!_stepBtn) {
        _stepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stepBtn.backgroundColor = [UIColor clearColor];
        [_stepBtn addTarget:self action:@selector(stepBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stepBtn;
}


@end
