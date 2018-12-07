//
//  MessageTypeCell.m
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  消息类型  （ 2.0已废弃）
//

#import "WDMessageTypeCell.h"

@interface WDMessageTypeCell ()

@end

@implementation WDMessageTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)createUI{
    
    [self.contentView addSubview:self.unReadLabel];
    self.unReadLabel.frame = CGRectMake(33, 12, 10, 10);
    //消息图标
    [self.contentView addSubview:self.messageImg];
    [self.messageImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(27.f);
        make.height.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).mas_equalTo(10.f);
    }];
    //消息标题
    [self.contentView addSubview:self.titleLabe];
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.messageImg.mas_right).offset(10.f);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(16.f);
        make.centerY.mas_equalTo(self.contentView);
    }];
    //时间
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10.f);
        make.height.mas_equalTo(16.f);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10.f);
        make.width.mas_equalTo(100.f);
    }];
    //消息内容
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabe);
        make.right.mas_equalTo(self.timeLabel.mas_left).offset(-10.f);
        make.height.mas_equalTo(16.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10.f);
    }];
    [self.contentView addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10.f);
    }];
}

- (void)remakeConstraint{
    [self.titleLabe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.messageImg.mas_right).offset(10.f);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(16.f);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(100.f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10.f);

    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabe.mas_left);
        make.top.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.timeLabel.mas_left).offset(-7.f);
        make.height.mas_equalTo(16.f);
    }];
    
}
- (void)configWithMemberModel:(WDUnReadMessageModel *)model{
    
    if (model.data.title) {
        [self remakeConstraint];
    }
    self.timeLabel.text = [model.data.time substringToIndex:10];
    self.contentLabel.text = model.data.content;
    self.titleLabe.text = @"系统消息";
    
    if ([model.data.count integerValue] > 0) {
        self.unReadLabel.hidden = NO;
    }else{
        self.unReadLabel.hidden = YES;
    }
}

#pragma mark --- 懒加载

- (UIImageView *)messageImg{
    if (!_messageImg) {
        _messageImg = [[UIImageView alloc] init];
        
    }
    return _messageImg;
}
- (UILabel *)titleLabe{
    if (!_titleLabe) {
        _titleLabe = [[UILabel alloc] init];
        _titleLabe.font = kFont16;
        _titleLabe.textAlignment = NSTextAlignmentLeft;
//        _titleLabe.backgroundColor = [UIColor redColor];
    }
    return _titleLabe;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = kFont12;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
//        _contentLabel.backgroundColor = [UIColor redColor];
    }
    return _contentLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kFont12;
        _timeLabel.textAlignment = NSTextAlignmentRight;
//        _timeLabel.backgroundColor = [UIColor redColor];
    }
    return _timeLabel;
}
- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _lineLabel;
}
//未读消息红点
- (UILabel *)unReadLabel{
    if (!_unReadLabel) {
        _unReadLabel = [[UILabel alloc] init];
        _unReadLabel.backgroundColor = WDColorFrom16RGB(0xfd5073);
        _unReadLabel.layer.cornerRadius = 5.f;
        _unReadLabel.layer.masksToBounds = YES;
        _unReadLabel.hidden = YES;
    }
    return _unReadLabel;
}


@end
