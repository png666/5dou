//
//  WDTaskCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskCell.h"
#import "AMTagListView.h"
#import "AMTagView.h"
#import "YYText.h"
@interface WDTaskCell()
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *taskTime;
//@property (weak, nonatomic) IBOutlet UILabel *taskType;
@property (weak, nonatomic) IBOutlet UIProgressView *taskProgress;
@property (weak, nonatomic) IBOutlet UILabel *taskProgressNum;
@property (weak, nonatomic) IBOutlet UIView *rewardView;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *takePartLabel;

@property (nonatomic,assign) int time;

@end

@implementation WDTaskCell

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
    self.stateLabel.hidden = YES;
}

- (void)setTaskType:(TaskType)taskType{
    _taskType = taskType;
    if(taskType == TaskTypeCollection){
        _statusImageView.image = [UIImage imageNamed:@"shoucang"];
        _stateLabel.hidden = YES;
    }
}
- (void)setTaskModel:(WDTaskModel *)taskModel{
    _taskModel = taskModel;
    [_taskImageView sd_setImageWithURL:[NSURL URLWithString:taskModel.imgUrl] placeholderImage:[UIImage imageNamed:@"task_failphoto"]];
    _taskName.text = taskModel.taskName;
    //截取为XXXX-XX-XX 并替换为XXXX.XX.XX
    NSString *rewordStr = [NSString stringWithFormat:@"%@逗币",[NSString stringWithFormat:@"%@",@(_taskModel.reward.floatValue)]];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:rewordStr];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(rewordStr.length - 2, 2)];
    self.rewardLabel.attributedText = attributeStr;
    
    //设置相关的状态
    
    NSString *stateStr = [NSString stringWithFormat:@"%@",_stateLabel.text];
    attributeStr = [[NSMutableAttributedString alloc] initWithString:stateStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName  value:WDColorFrom16RGB(0x666666) range:NSMakeRange(0, 5)];
    _stateLabel.attributedText = attributeStr;
    
    
    //如果是限时任务并且还没有开始
    if ([_taskModel.isCountDownTask isEqualToString:@"1"]) {
      
        if ([_taskModel.countDownReceiveLeftSec intValue] > 0) {
            [self installLimitTime];
        }else{
            [self installNormal];
        }
    }else{
        [self installNormal];
    }
    
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
    
    NSInteger taskType = [_taskModel.state integerValue];
    if(taskType == TaskTypeFinish){
        _statusImageView.image = [UIImage imageNamed:@"wancheng"];
        _stateLabel.hidden = NO;
        _stateLabel.text = @"审核状态:已获得逗币";
    }else if(taskType == TaskTypeExpiryDate){
        _statusImageView.image = [UIImage imageNamed:@"shixiao"];
    }else if(taskType == TaskTypeGiveUp){
        _statusImageView.image = [UIImage imageNamed:@"fangqi"];
        _stateLabel.hidden = NO;
        _stateLabel.text = @"审核状态:已放弃";
    }else if(taskType == TaskTypeChecking){
        _stateLabel.hidden = NO;
        _stateLabel.text = @"审核状态:审核中";
    }else if(taskType == TaskTypeDoing){
        _stateLabel.hidden = NO;
        WeakStament(weakSelf);
        _time = [_taskModel.taskSubmitLeftSec intValue];
        if (!_changeTimer) {
            _changeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(changeTime) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop]addTimer:_changeTimer forMode:NSRunLoopCommonModes];
            [_changeTimer fire];
        }
    }else if(taskType == TaskTypeNotPass){
        _stateLabel.hidden = NO;
        _stateLabel.text = @"审核状态:审核不通过";
        _statusImageView.image = [UIImage imageNamed:@"wancheng"];
    }
}


- (void)installNormal{
    NSString *startTimeStr = [[_taskModel.startTime substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTimeStr = [[_taskModel.endTime substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *dateStr = [NSString stringWithFormat:@"有效时间:%@-%@",startTimeStr,endTimeStr];
    
    if (device_is_iphone_4 || device_is_iphone_5) {
        NSMutableAttributedString *attributeDateStr = [[NSMutableAttributedString alloc] initWithString:dateStr];
        [attributeDateStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(5, dateStr.length - 5)];
        self.taskTime.attributedText = attributeDateStr;
    }else{
        self.taskTime.text = dateStr;
    }

    NSString *joinMemberStr = [NSString stringWithFormat:@"%@",_taskModel.joinMemberCount];
    
    NSString *joinMemberLimitStr = [NSString stringWithFormat:@"%@",_taskModel.joinMemerLimit];
    _taskProgressNum.text = [NSString stringWithFormat:@"%@/%@",joinMemberStr,joinMemberLimitStr];
    float joinMember = [_taskModel.joinMemberCount floatValue];
    float totalMember = [_taskModel.joinMemerLimit floatValue];
    CGFloat percentage = joinMember  / totalMember ;
    [_taskProgress setProgress:percentage animated:NO];
    if (percentage <= 0.7) {
        _taskProgress.progressTintColor = WDColorRGB(69, 220, 91);
    }else if(percentage <= 0.8){
        _taskProgress.progressTintColor = WDColorRGB(210, 170, 0);
    }else{
        _taskProgress.progressTintColor = WDColorRGB(251, 57, 37);
    }
    _taskProgress.hidden = NO;
    _taskProgressNum.hidden = NO;
    _takePartLabel.text = [NSString stringWithFormat:@"参与人数:"];
}

- (void)installLimitTime{
    _taskProgress.hidden = YES;
    _taskProgressNum.hidden = YES;
    NSString *stateStr = [NSString stringWithFormat:@"任务状态:即将开始"];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:stateStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName  value:WDColorFrom16RGB(0xF5A623) range:NSMakeRange(5, attributeStr.length - 5)];
    _takePartLabel.attributedText = attributeStr;
    _taskTime.text = [NSString stringWithFormat:@"开启时间:%@",[_taskModel.countDownStartTime substringToIndex:16]];
}

#pragma mark 计时器，进行修改
- (void)changeTime{
    int time = _time;
    if (time >= 0) {
        int day = floor(time / (3600 * 24));
        int hours = floor(time / 3600) - floor(time / (3600 * 24)) * 24;
        int minutes = floor(time / 60) - floor(time / 3600) * 60;
        int second = floor(time) - floor(time / 60) * 60;
        if (day == 0) {
            _stateLabel.text = [NSString stringWithFormat:@"任务限时:%d小时%d分%d秒",hours,minutes,second];
            
        }else{
            _stateLabel.text = [NSString stringWithFormat:@"任务限时:%d天%d小时%d分%d秒",day,hours,minutes,second];
        }
    }
    NSString *stateStr = [NSString stringWithFormat:@"%@",_stateLabel.text];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:stateStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName  value:WDColorFrom16RGB(0x666666) range:NSMakeRange(0, 5)];
    _stateLabel.attributedText = attributeStr;
    _time --;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc{
    [_changeTimer invalidate];
    _changeTimer = nil;
}






@end
