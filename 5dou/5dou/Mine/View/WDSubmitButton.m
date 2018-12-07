//
//  WDSubmitButton.m
//  5dou
//
//  Created by 黄新 on 16/9/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  底层button  设置一些基本的属性
//

#import "WDSubmitButton.h"

@implementation WDSubmitButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    WDSubmitButton *btn = [super buttonWithType:buttonType];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = WDColorFrom16RGB(0xffc200);
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
    btn.titleLabel.font = kFont15;
    return btn;
}

@end
