//
//  WDTaskTitleCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskTitleCell.h"
@interface WDTaskTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation WDTaskTitleCell

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
