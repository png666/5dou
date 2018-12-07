//
//  WDUnderWayCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDUnderWayCell.h"
#import "ENUM.h"
#import "ToolClass.h"
@interface WDUnderWayCell()

/**
 任务图片
 */
@property (nonatomic,strong) UIImageView *taskImageView;

/**
 任务名称
 */
@property (nonatomic,strong) UILabel *taskNameLabel;

/**
 任务状态
 */
@property (nonatomic,strong) UILabel *taskStateLabel;

/**
 任务倒计时
 */
@property (nonatomic,strong) UILabel *taskTimeLabel;

/**
 任务逗币
 */
@property (nonatomic,strong) UILabel *taskPayLabel;

/**
 任务现实时间
 */
@property (nonatomic,assign) int time;

@property (nonatomic,strong) UIView *lineView;
@end
@implementation WDUnderWayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self prepareUI];
        self.backgroundColor = WDColorFrom16RGB(0xffffff);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)prepareUI{
    
    [self.contentView addSubview:self.taskImageView];
    [self.taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
    }];
    
    [self.contentView addSubview:self.taskNameLabel];
    [self.taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_taskImageView.mas_top);
        make.left.equalTo(_taskImageView.mas_right).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-80.f);
    }];
    
    [self.contentView addSubview:self.taskStateLabel];
    [self.taskStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_taskImageView.mas_bottom);
        make.left.equalTo(_taskImageView.mas_right).offset(10.f);
    }];
    
    [self.contentView addSubview:self.taskTimeLabel];
    [self.taskTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(2.f);
        make.left.equalTo(_taskImageView.mas_right).offset(10.f);
    }];
    
    [self.contentView addSubview:self.taskPayLabel];
    [self.taskPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
    }];
    
    UIImageView *douImageView = [[UIImageView alloc] init];
    douImageView.image = [UIImage imageNamed:@"douzi"];
    [self.contentView addSubview:douImageView];
    [douImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.taskPayLabel.mas_centerY);
        make.right.mas_equalTo(self.taskPayLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(17.5, 17.5));
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10.f);
    }];
}

- (void)setTaskModel:(WDTaskModel *)taskModel{
    _taskModel = taskModel;
    [_taskImageView sd_setImageWithURL:[NSURL URLWithString:taskModel.imgUrl] placeholderImage:[UIImage imageNamed:@"task_failphoto"]];
    _taskNameLabel.text = [NSString stringWithFormat:@"[%@]%@",taskModel.taskLabel,taskModel.taskName];
    NSInteger taskType = [_taskModel.state integerValue];
    if(taskType == TaskTypeChecking){
        _taskStateLabel.text = @"任务状态:审核中";
        _taskTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[_taskModel.endTime substringToIndex:10]];
    }else if(taskType == TaskTypeNone ){
        _taskStateLabel.text = @"任务状态:未领取";
        _taskTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[_taskModel.endTime substringToIndex:10]];
    }else if(taskType ==  TaskTypeGiveUp){
        _taskStateLabel.text = @"任务状态:已放弃";
        _taskTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[_taskModel.endTime substringToIndex:10]];
    }
    else if(taskType == TaskTypeDoing){
        _taskStateLabel.text = @"任务状态:进行中";
        _taskTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[_taskModel.endTime substringToIndex:10]];
//        WeakStament(weakSelf);
//        _time = [_taskModel.taskSubmitLeftSec intValue];
//        if (!_changeTimer) {
//            _changeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(changeTime) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop]addTimer:_changeTimer forMode:NSRunLoopCommonModes];
//            [_changeTimer fire];
//        }
    }
    _taskPayLabel.text = _taskModel.reward;
}

- (UIImageView *)taskImageView{
    if (!_taskImageView) {
        _taskImageView = [[UIImageView alloc] init];
        _taskImageView.layer.cornerRadius = 8.0;
        _taskImageView.clipsToBounds = YES;
    }
    return _taskImageView;
}

- (UILabel *)taskNameLabel{
    if (!_taskNameLabel) {
        _taskNameLabel = [[UILabel alloc] init];
        _taskNameLabel.font = [UIFont systemFontOfSize:15];
        _taskNameLabel.textColor = WDColorFrom16RGB(0x333333);
    }
    return _taskNameLabel;
}

- (UILabel *)taskStateLabel{
    if(!_taskStateLabel){
        _taskStateLabel = [[UILabel alloc] init];
        _taskStateLabel.font = [UIFont systemFontOfSize:12];
        _taskStateLabel.textColor = WDColorFrom16RGB(0x999999);
    }
    return _taskStateLabel;
}


- (UILabel *)taskTimeLabel{
    if (!_taskTimeLabel) {
        _taskTimeLabel = [[UILabel alloc] init];
        _taskTimeLabel.font = [UIFont systemFontOfSize:12];
        _taskTimeLabel.textColor = WDColorFrom16RGB(0x999999);
    }
    return _taskTimeLabel;
}

- (UILabel *)taskPayLabel{
    if (!_taskPayLabel) {
        _taskPayLabel = [[UILabel alloc] init];
        _taskPayLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        _taskPayLabel.textColor = WDColorFrom16RGB(0xFF8767);
    }
    return _taskPayLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UILabel alloc] init];
        _lineView.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _lineView;
}

#pragma mark 业务逻辑代码
#pragma mark 计时器，进行修改

- (void)changeTime{
    int time = _time;
    if (time >= 0) {
        int day = floor(time / (3600 * 24));
        int hours = floor(time / 3600) - floor(time / (3600 * 24)) * 24;
        int minutes = floor(time / 60) - floor(time / 3600) * 60;
        int second = floor(time) - floor(time / 60) * 60;
        if (day == 0) {
            _taskTimeLabel.text = [NSString stringWithFormat:@"任务限时:%d小时%d分%d秒",hours,minutes,second];
            
        }else{
            _taskTimeLabel.text = [NSString stringWithFormat:@"任务限时:%d天%d小时%d分%d秒",day,hours,minutes,second];
        }
    }
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
