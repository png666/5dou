//
//  WDTaskLimitCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskLimitCell.h"

@implementation WDTaskLimitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
