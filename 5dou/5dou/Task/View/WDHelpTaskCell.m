//
//  HelpTaskCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDHelpTaskCell.h"
@interface WDHelpTaskCell()
@property (weak, nonatomic) IBOutlet UILabel *stepTitle;
@property (weak, nonatomic) IBOutlet UILabel *stepInfo;

@end
@implementation WDHelpTaskCell

- (void)setStepModel:(WDTaskStepModel *)stepModel{
    _stepModel = stepModel;
    _stepTitle.text = stepModel.stepName;
    _stepInfo.text = stepModel.stepInfo;
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
