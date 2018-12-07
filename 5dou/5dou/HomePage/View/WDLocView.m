//
//  WDLocView.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDLocView.h"

@implementation WDLocView
+ (WDLocView *)view{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WDLocView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
