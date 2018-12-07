//
//  WDTaskCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskHeadCell.h"
@interface WDTaskHeadCell()
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *taskTime;
@property (weak, nonatomic) IBOutlet UIProgressView *taskProgress;
@property (weak, nonatomic) IBOutlet UILabel *taskProgressNum;
@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *takePartLabel;
@end

@implementation WDTaskHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.taskProgress.layer.cornerRadius = 3;
    self.taskProgress.clipsToBounds = YES;
    self.taskProgress.layer.masksToBounds = YES;
    self.taskProgress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    
    self.taskImageView.layer.cornerRadius = 10;
    self.taskImageView.layer.masksToBounds = YES;
    self.taskImageView.clipsToBounds = YES;
}



- (void)setTaskModel:(WDTaskModel *)taskModel{
    _taskModel = taskModel;
    [_taskImageView sd_setImageWithURL:[NSURL URLWithString:taskModel.imgUrl] placeholderImage:[UIImage imageNamed:@"task_failphoto"]];
    _taskName.text = taskModel.taskName;
    //截取为XXXX-XX-XX 并替换为XXXX.XX.XX
    
    if ([_taskModel.isCountDownTask isEqualToString:@"1"]) {
//        NSString *countDownStartStr = _taskModel.countDownStartTime;
//        NSString *serverNowStr = _taskModel.serverNowTime;
//        //转化为日期
//        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh"]];
//        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate* countDownDate = [inputFormatter dateFromString:countDownStartStr];
//        NSDate *serverNowDate = [inputFormatter dateFromString:serverNowStr];
//        if ([countDownDate timeIntervalSinceDate:serverNowDate] > 0.0) {
        if([_taskModel.countDownReceiveLeftSec intValue] > 0) {
            [self installLimitTime];
        }else{
            [self installNormal];
        }
    }else{
        [self installNormal];
    }
    NSString *joinMemberStr = [NSString stringWithFormat:@"%@",taskModel.joinMemberCount];
    
    NSString *joinMemberLimitStr = [NSString stringWithFormat:@"%@",taskModel.joinMemerLimit];
    _taskProgressNum.text = [NSString stringWithFormat:@"%@/%@",joinMemberStr,joinMemberLimitStr];
    float joinMember = [taskModel.joinMemberCount floatValue];
    float totalMember = [taskModel.joinMemerLimit floatValue];
    CGFloat percentage = joinMember  / totalMember ;
    [_taskProgress setProgress:percentage animated:NO];
    if (percentage <= 0.7) {
        _taskProgress.progressTintColor = WDColorRGB(69, 220, 91);
    }else if(percentage <= 0.8){
        _taskProgress.progressTintColor = WDColorRGB(210, 170, 0);
    }else{
        _taskProgress.progressTintColor = WDColorRGB(251, 57, 37);
    }
    NSString *rewordStr = [NSString stringWithFormat:@"%@逗币",[NSString stringWithFormat:@"%@",@(_taskModel.reward.floatValue)]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:rewordStr];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(rewordStr.length - 2, 2)];
    self.rewardLabel.attributedText = attributeStr;
    
    //判断是否是专属任务
    if ([_taskModel.taskCardId isEqualToString:@"000000005"]) {
        _statusImageView.image = [UIImage imageNamed:@"zhuanshu"];
        //判断是否是新手任务卡
    }else if([_taskModel.taskCardId isEqualToString:@"000000004"]){
        _statusImageView.image = [UIImage imageNamed:@"new"];
    }else if([_taskModel.isCountDownTask isEqualToString:@"1"]){
        _statusImageView.image = [UIImage imageNamed:@"xianshi"];
    }else{
        _statusImageView.image = nil;
    }
}

- (void)installNormal{
    NSString *startTimeStr = [[_taskModel.startTime substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTimeStr = [[_taskModel.endTime substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *dateStr = [NSString stringWithFormat:@"有效时间:%@-%@",startTimeStr,endTimeStr];
    
    _taskTime.text = [NSString stringWithFormat:@"开启时间:%@",[_taskModel.countDownStartTime substringToIndex:16]];
    if (device_is_iphone_4 || device_is_iphone_5) {
        NSMutableAttributedString *attributeDateStr = [[NSMutableAttributedString alloc] initWithString:dateStr];
        [attributeDateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5, dateStr.length - 5)];
        self.taskTime.attributedText = attributeDateStr;
    }else{
        self.taskTime.text = dateStr;
    }
}


- (void)installLimitTime{
     _taskTime.text = [NSString stringWithFormat:@"开启时间:%@",[_taskModel.countDownStartTime substringToIndex:16]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
