//
//  WDTaskButtonCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/9.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskButtonCell.h"
#import "ToolClass.h"
@interface WDTaskButtonCell()
@end
@implementation WDTaskButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.doTaskButton.layer.cornerRadius = 8;
    self.doTaskButton.layer.borderColor = WDColorFrom16RGB(0x979797).CGColor;
    self.doTaskButton.layer.borderWidth = 0.5;
    self.doTaskButton.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
