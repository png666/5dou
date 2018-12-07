//
//  WDCompleteCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDCompleteCell.h"
#import "ENUM.h"
#import "ToolClass.h"


/**
 任务完成Cell
 */
@interface WDCompleteCell()

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
 任务拒绝理由
 */
@property (nonatomic,strong) UILabel *taskReasonLabel;

/**
 任务逗币
 */
@property (nonatomic,strong) UILabel *taskPayLabel;
@property (nonatomic,strong) UIView *lineView;
@end
@implementation WDCompleteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    
    [self.contentView addSubview:self.taskReasonLabel];
    [self.taskReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_taskImageView.mas_bottom);
        make.left.equalTo(_taskImageView.mas_right).offset(10.f);
    }];

    [self.contentView addSubview:self.taskStateLabel];
    [self.taskStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    if(taskType == TaskTypeFinish){
        _taskStateLabel.text = @"任务状态:审核通过";
        _taskReasonLabel.text = @"已获得逗币";
    }else if(taskType == TaskTypeGiveUp){
        _taskStateLabel.text = @"任务状态:已放弃";
        _taskReasonLabel.text = @"下次记得按时提交哦～";
    }else if(taskType == TaskTypeNotPass){
        _taskStateLabel.text = @"任务状态:审核不通过";
        //写原因
        if (_taskModel.refuseReason) {
            _taskReasonLabel.text = [NSString stringWithFormat:@"%@",_taskModel.refuseReason];
        }else{
            _taskModel.refuseReason = [NSString stringWithFormat:@"资料提交不合格"];
        }
    }else if(taskType == TaskTypeExpiryDate){
        _taskStateLabel.text = @"任务状态:已失效";
        _taskReasonLabel.text = @"任务已失效";
 
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
        _taskNameLabel.textColor = kFirstLevelBlack;
    }
    return _taskNameLabel;
}

- (UILabel *)taskStateLabel{
    if(!_taskStateLabel){
        _taskStateLabel = [[UILabel alloc] init];
        _taskStateLabel.font = [UIFont systemFontOfSize:12];
        _taskStateLabel.textColor = kThirdLevelBlack;
    }
    return _taskStateLabel;
}

- (UILabel *)taskReasonLabel{
    if (!_taskReasonLabel) {
        _taskReasonLabel = [[UILabel alloc] init];
        _taskReasonLabel.font = [UIFont systemFontOfSize:12];
        _taskReasonLabel.textColor = WDColorFrom16RGB(0xE93E53);
    }
    return _taskReasonLabel;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
