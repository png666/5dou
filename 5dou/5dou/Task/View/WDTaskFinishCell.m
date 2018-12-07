//
//  WDTaskFinishCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/10/11.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskFinishCell.h"
@interface WDTaskFinishCell()
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskReplyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taskStatusImageView;


@end
@implementation WDTaskFinishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTaskModel:(WDTaskModel *)taskModel{
    _taskModel = taskModel;
    [_taskImageView sd_setImageWithURL:[NSURL URLWithString:taskModel.imgUrl] placeholderImage:[UIImage imageNamed:@"task_failphoto"]];
    _taskNameLabel.text = taskModel.taskName;
    NSString *rewordStr = [NSString stringWithFormat:@"%@逗币",_taskModel.reward];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:rewordStr];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(rewordStr.length - 2, 2)];
    self.rewardLabel.attributedText = attributeStr;
    //设置相关的状态
    NSInteger taskType = [_taskModel.state integerValue];
    NSString *statusStr;
    NSString *replyStr;
    if(taskType == TaskTypeFinish){
        statusStr = [NSString stringWithFormat:@"审核状态:已通过"];
        replyStr = [NSString stringWithFormat:@"审核回复:已获得逗币"];
    }else if(taskType == TaskTypeNotPass){
        statusStr = [NSString stringWithFormat:@"审核状态:未通过"];
        if (_taskModel.refuseReason) {
            replyStr = [NSString stringWithFormat:@"审核回复:%@",_taskModel.refuseReason];
        }else{
            replyStr = [NSString stringWithFormat:@"审核回复:资料提交不合格"];
        }
    }
    _taskStatusImageView.image = [UIImage imageNamed:@"wancheng"];
    NSMutableAttributedString *statusMutableStr = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [statusMutableStr addAttribute:NSForegroundColorAttributeName  value:WDColorFrom16RGB(0x666666) range:NSMakeRange(0, 5)];
    _taskStatusLabel.attributedText = statusMutableStr;
    
     NSMutableAttributedString *replyMutaleStr = [[NSMutableAttributedString alloc] initWithString:replyStr];
    [replyMutaleStr addAttribute:NSForegroundColorAttributeName  value:WDColorFrom16RGB(0x666666) range:NSMakeRange(0, 5)];
    _taskReplyLabel.attributedText = replyMutaleStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
