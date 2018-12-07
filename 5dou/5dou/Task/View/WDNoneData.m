//
//  WDNoneData.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDNoneData.h"

@implementation WDNoneData
+ (WDNoneData *)view{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WDNoneData" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    //增加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noDataViewClick)];
    [self addGestureRecognizer:tapGesture];
}

- (void)noDataViewClick{
    if(_noneDataBlock){
        _noneDataBlock();
        YYLog(@"进行了刷新");
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
