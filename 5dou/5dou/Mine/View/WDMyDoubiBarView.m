


//
//  WDMyDoubiBarView.m
//  5dou
//
//  Created by rdyx on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDMyDoubiBarView.h"

@implementation WDMyDoubiBarView

-(instancetype)initWithTitle:(NSString *)titleName withSize:(CGSize)size
{
    self = [super init];
    if (self) {
        [self makeUIWithTitle:titleName withSize:size];
    }
    return self;
}

-(void)makeUIWithTitle:(NSString *)titleName withSize:(CGSize)size
{
    
    [self setSize:size];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 15)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.font = kFont16;
    _titleLabel.text = titleName;
//    _titleLabel.textColor = KCoffeeColor;
    _titleLabel.centerY = self.centerY;
    [self addSubview:_titleLabel];
}



@end
