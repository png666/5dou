//
//  WDQuestionCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDQuestionCell.h"

@implementation WDQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = kBackgroundColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
