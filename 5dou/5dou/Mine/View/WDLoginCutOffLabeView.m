//
//  WDLoginCutOffLabeView.m
//  5dou
//
//  Created by 黄新 on 16/9/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  第三方登录分割线
//

#import "WDLoginCutOffLabeView.h"
#import "Masonry.h"

@interface WDLoginCutOffLabeView ()

// 左侧分割线
@property (nonatomic, weak) UIView *leftDivider;
// 右侧分割线
@property (nonatomic, weak) UIView *rightDivider;
// 内容label
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation WDLoginCutOffLabeView

#pragma mark - /*** 初始化方法 ***/
- (instancetype)init {
    if (self = [super init]) {
        
        // 更新UI
        [self updateUI];
    }
    
    return self;
}
#pragma mark - /*** 更新UI ***/
-(void)updateUI {
    UIView *leftDivider = [[UIView alloc]init];
    self.leftDivider = leftDivider;
    [self addSubview:leftDivider];
    leftDivider.backgroundColor = WDColorFrom16RGB(0x999999);
    
    // 布局
    [leftDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_centerX).offset(-50.0);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(self);
    }];
    
    UIView *rightDivider = [[UIView alloc]init];
    self.rightDivider = rightDivider;
    [self addSubview:rightDivider];
    rightDivider.backgroundColor = WDColorFrom16RGB(0x999999);
    
    // 布局
    [rightDivider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_centerX).offset(50.0);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(self);
    }];
    
    
    UILabel *contentLabel = [[UILabel alloc]init];
    self.contentLabel = contentLabel;
    [self addSubview:contentLabel];
    contentLabel.textColor = WDColorFrom16RGB(0x999999);
    contentLabel.font = kFont14;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    // 布局
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.leftDivider.mas_right);
        make.right.mas_equalTo(self.rightDivider.mas_left);
        make.centerY.mas_equalTo(self);
        
    }];
    
}

// 赋值
- (void)setText:(NSString *)text {
    
    _text = text;
    
    self.contentLabel.text = text;
    
}

@end
