//
//  WDTaskTimeCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskTimeCell.h"
@interface WDTaskTimeCell()
@property (weak, nonatomic) IBOutlet UILabel *taskTimeLabel;
@end
@implementation WDTaskTimeCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setCountdownTime:(NSInteger)countdownTime {
    _countdownTime = countdownTime;
    if (!_changeTimer) {
        _changeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_changeTimer forMode:NSRunLoopCommonModes];
    }
    if (countdownTime != 0) {
        [self changeTime];
    }else{
        _taskTimeLabel.text = [NSString stringWithFormat:@"任务限时:00:00:00"];
    }
}
- (NSString *)addZero:(NSInteger)number{
    if (number < 10) {
        return [NSString stringWithFormat:@"0%ld",(long)number];
    }
    return [NSString stringWithFormat:@"%ld",(long)number];
}
- (void)changeTime{
    NSInteger time = _countdownTime;
    //如果时间已经没有了
    if (time == -1) {
        [_changeTimer invalidate];
        _changeTimer = nil;
        if (_taskStopBlock) {
            _taskStopBlock();
        }
    }
    
    if (time >= 0) {
        int day = floor(time / (3600 * 24));
        int hours = floor(time / 3600) - floor(time / (3600 * 24)) * 24;
        int minutes = floor(time / 60) - floor(time / 3600) * 60;
        int second = floor(time) - floor(time / 60) * 60;
        if (day == 0) {
            if (_isLimitTime) {
                _taskTimeLabel.text = [NSString stringWithFormat:@"开抢倒计时:%@:%@:%@",[self addZero:hours],[self addZero:minutes],[self addZero:second]];
            }else{
                _taskTimeLabel.text = [NSString stringWithFormat:@"任务限时:%@:%@:%@",[self addZero:hours],[self addZero:minutes],[self addZero:second]];
            }
            
            
        }else{
            if (_isLimitTime) {
                _taskTimeLabel.text = [NSString stringWithFormat:@"开抢倒计时:%@天%@:%@:%@",[self addZero:day],[self addZero:hours],[self addZero:minutes],[self addZero:second]];
                
            }else{
                _taskTimeLabel.text = [NSString stringWithFormat:@"任务限时:%@天%@:%@:%@",[self addZero:day],[self addZero:hours],[self addZero:minutes],[self addZero:second]];
                
            }
        }
    }
    NSString *stateStr = [NSString stringWithFormat:@"%@",_taskTimeLabel.text];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:stateStr];
    if (_isLimitTime) {
        [attributeStr addAttribute:NSForegroundColorAttributeName  value:WDColorFrom16RGB(0x8B572A) range:NSMakeRange(6, _taskTimeLabel.text.length - 6)];
    }else{
        [attributeStr addAttribute:NSForegroundColorAttributeName  value:WDColorFrom16RGB(0x8B572A) range:NSMakeRange(5, _taskTimeLabel.text.length - 5)];
    }
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(5,_taskTimeLabel.text.length - 5)];
    
    _taskTimeLabel.attributedText = attributeStr;
    _countdownTime --;
}


- (void)dealloc{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
