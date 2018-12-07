



//
//  WDHomeListCell.m
//  5dou
//
//  Created by rdyx on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDHomeListCell.h"
#import "ToolClass.h"
#import "THProgressView.h"

@interface WDHomeListCell()

/**
 任务图片
 */
@property (nonatomic,strong) UIImageView *taskImageView;

/**
 任务名称
 */
@property (nonatomic,strong) UILabel *taskNameLabel;

/**
 截止时间
 */
@property (nonatomic,strong) UILabel *taskTimeLabel;

/**
 进度条
 */
@property (nonatomic,strong) THProgressView *progressView;

/**
 参与人数的百分比
 */
@property (nonatomic,strong) UILabel *precentLabel;

//参与人数
@property(nonatomic,strong)UILabel *attendLabel;

/**
 参与的人数数量
 */
@property (nonatomic,strong) UILabel *taskPersonLabel;

/**
 参与任务获取的金额
 */
@property (nonatomic,strong) UILabel *taskPayLabel;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation WDHomeListCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
        
    }
    return self;
}

- (void)makeUI{
    self.contentView.backgroundColor = kWhiteColor;
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
    
    [self.contentView addSubview:self.taskTimeLabel];
    [self.taskTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(2.f);
        make.left.equalTo(_taskImageView.mas_right).offset(10.f);
    }];
    
    //参与人数四个字的label
    UILabel *label = [UILabel new];
    label.textColor = kThirdLevelBlack;
    label.hidden = YES;
    self.attendLabel = label;
    label.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_taskImageView.mas_bottom);
        make.left.equalTo(_taskImageView.mas_right).offset(10.f);
    }];
    
    [self.contentView addSubview:self.progressView];
    self.progressView.hidden = YES;
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5.f);
        make.centerY.mas_equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 15));
    }];
    
    [self.contentView addSubview:self.precentLabel];
    self.precentLabel.hidden = YES;
    [self.precentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label.mas_centerY);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(self.progressView.mas_left);
    }];
    
    [self.contentView addSubview:self.taskPersonLabel];
    self.taskPersonLabel.hidden = YES;
    [self.taskPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label.mas_centerY);
        make.left.mas_equalTo(self.progressView.mas_right).offset(5.f);
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
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, self.contentView.height-1, ScreenWidth, 0.5);
    [self.contentView addSubview:line];
}

#pragma mark 进行数据
- (void)setTaskModel:(WDTaskModel *)taskModel{
    _taskModel = taskModel;
    //task_failphoto
    [_taskImageView sd_setImageWithURL:WDURL(taskModel.imgUrl) placeholderImage:WDImgName(@"task_failphoto")];
    _taskNameLabel.text = [NSString stringWithFormat:@"[%@]%@",taskModel.taskLabel,taskModel.taskName];
    
    //两种cell样式  倒计时任务状态和普通任务状态
    //人为修改数据测试用
//    if ([_taskModel.isCountDownTask isEqualToString:@"0"]){
//        _taskModel.isCountDownTask = @"1";
    
//    }
    if ([_taskModel.isCountDownTask isEqualToString:@"0"]) {
        
        _taskTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[_taskModel.endTime substringToIndex:10]];
        self.attendLabel.hidden = false;
        self.attendLabel.text = @"参与人数:";
        self.progressView.hidden = false;
        self.precentLabel.hidden = false;
        self.taskPersonLabel.hidden = false;
        
    }else{
        //倒计时任务状态
        _taskTimeLabel.text = @"开启时间";
        self.attendLabel.hidden = false;
        self.attendLabel.text = [NSString stringWithFormat:@"%@",[_taskModel.countDownStartTime substringToIndex:19]];
    }
    
    //参与人数
    NSString *joinMemberStr = [NSString stringWithFormat:@"%@",taskModel.joinMemberCount];
    NSString *joinMemberLimitStr = [NSString stringWithFormat:@"%@",taskModel.joinMemerLimit];
    _taskPersonLabel.text = [NSString stringWithFormat:@"%@/%@",joinMemberStr,joinMemberLimitStr];
    float joinMember = [taskModel.joinMemberCount floatValue];
    float totalMember = [taskModel.joinMemerLimit floatValue];
    CGFloat percentage = joinMember  / totalMember ;
    if (percentage == 0) {
        [_progressView setProgressTintColor:kBackgroundColor];
    }else{
        [_progressView setProgressTintColor:kNavigationBarColor];
    }
    [_progressView setProgress:percentage];
    _precentLabel.text = [NSString stringWithFormat:@"%.0f%%",percentage * 100];
    _taskPayLabel.text = taskModel.reward;
}

#pragma mark 懒加载控件
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

- (THProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[THProgressView alloc] init];
        _progressView.borderTintColor = kNavigationBarColor;
        _progressView.progressTintColor = kNavigationBarColor;
        _progressView.progressBackgroundColor = kBackgroundColor;
    }
    return _progressView;
}

- (UILabel *)precentLabel{
    if (!_precentLabel) {
        _precentLabel = [[UILabel alloc] init];
        _precentLabel.font = [UIFont systemFontOfSize:9];
        _precentLabel.textColor = WDColorFrom16RGB(0x8B572A);
        _precentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _precentLabel;
}

- (UILabel *)taskTimeLabel{
    if (!_taskTimeLabel) {
        _taskTimeLabel = [[UILabel alloc] init];
        _taskTimeLabel.font = [UIFont systemFontOfSize:12];
        _taskTimeLabel.textColor = kThirdLevelBlack;
    }
    return _taskTimeLabel;
}

- (UILabel *)taskPersonLabel{
    if (!_taskPersonLabel) {
        _taskPersonLabel = [[UILabel alloc] init];
        _taskPersonLabel.font = [UIFont systemFontOfSize:12];
        _taskPersonLabel.textColor = kSecondLevelBlack;
    }
    return _taskPersonLabel;
}


- (UILabel *)taskPayLabel{
    if (!_taskPayLabel) {
        _taskPayLabel = [[UILabel alloc] init];
        _taskPayLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        _taskPayLabel.textColor = kSecondLevelBlack;
    }
    return _taskPayLabel;
}

@end
