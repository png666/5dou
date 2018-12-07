//
//  WDTaskDescribeCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/16.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskDescribeCell.h"
#import "THProgressView.h"
@interface WDTaskDescribeCell()
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

/**
  参与的人数
 */
@property (nonatomic,strong) UILabel *taskPersonLabel;

/**
  参与任务获取的金额
 */
@property (nonatomic,strong) UILabel *taskPayLabel;

@property (nonatomic,strong) UIView *lineView;
@end
@implementation WDTaskDescribeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI{
    self.contentView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:self.taskImageView];
    [self.taskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-3.f);
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
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = kThirdLevelBlack;
    label.text = @"参与人数:";
    label.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_taskImageView.mas_bottom).offset(3.f);
        make.left.equalTo(_taskImageView.mas_right).offset(10.f);
    }];
    
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(5.f);
        make.centerY.mas_equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 15));
    }];
    
    [self.contentView addSubview:self.precentLabel];
    [self.precentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label.mas_centerY);
        make.width.mas_equalTo(60);
        make.left.mas_equalTo(self.progressView.mas_left);
    }];
    
    [self.contentView addSubview:self.taskPersonLabel];
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
    
//    [self.contentView addSubview:self.lineView];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-10.f);
//        make.left.mas_equalTo(self.contentView.mas_left).offset(10.f);
//    }];

}

#pragma mark 进行数据
- (void)setTaskModel:(WDTaskModel *)taskModel{
    _taskModel = taskModel;
    
    [_taskImageView sd_setImageWithURL:[NSURL URLWithString:taskModel.imgUrl] placeholderImage:[UIImage imageNamed:@"task_failphoto"]];
    if (taskModel.taskLabel.length > 0) {
        _taskNameLabel.text = [NSString stringWithFormat:@"[%@]%@",taskModel.taskLabel,taskModel.taskName];

    }else{
        _taskNameLabel.text = [NSString stringWithFormat:@"%@",taskModel.taskName];
    }
       if ([taskModel.isCountDownTask isEqualToString:@"1"]) {
         _taskTimeLabel.text = [NSString stringWithFormat:@"开启时间:%@",[_taskModel.countDownStartTime substringToIndex:19]];
    }else{
        _taskTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[_taskModel.endTime substringToIndex:10]];

    }
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
    _precentLabel.text = [NSString stringWithFormat:@"%.1f%%",percentage * 100];
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
        _taskPersonLabel.font = [UIFont systemFontOfSize:10];
        _taskPersonLabel.textColor = kSecondLevelBlack;
    }
    return _taskPersonLabel;
}


- (UILabel *)taskPayLabel{
    if (!_taskPayLabel) {
        _taskPayLabel = [[UILabel alloc] init];
        _taskPayLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        _taskPayLabel.textColor = WDColorFrom16RGB(0xFF8767);
    }
    return _taskPayLabel;
}

//- (UIView *)lineView{
//    if (!_lineView) {
//        _lineView = [[UILabel alloc] init];
//        _lineView.backgroundColor = WDColorFrom16RGB(0xdddddd);
//    }
//    return _lineView;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
