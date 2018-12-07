//
//  WDCustomBar.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDCustomBar.h"

@implementation WDCustomBar
- (instancetype) initWithCount:(NSString *)count andName :(NSString *)name size:(CGSize)size{
    self = [super init];
    if (self) {
        [self createControlBarWithCount:count andName:name size:size];
    }
    return self;
}

- (void)createControlBarWithCount:(NSString *)count andName:(NSString *)name size:(CGSize)size{
    [self setSize:size];
    //数量
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 15)];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.font = [UIFont systemFontOfSize:18];
    _countLabel.text = count;
    [self addSubview:_countLabel];
    //标题
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.width, self.height)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = name;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.textColor = WDColorFrom16RGB(0x484848);
    _nameLabel.textColor = WDColorFrom16RGB(0x484848);
    [self addSubview:_nameLabel];
    
    //中间隔断线
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.width - 1, 5, 1, 40)];
    _lineView.backgroundColor = WDColorFrom16RGB(0x999999);
    [self addSubview:_lineView];
}

@end
