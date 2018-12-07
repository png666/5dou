
//
//  WDMessageCell.m
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  消息cell
//

#import "WDMessageCell.h"


@interface WDMessageCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unReadLabel;///未读标记小红点
@property (nonatomic, strong) UIView *bgview;///< 底部视图

@end

@implementation WDMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.backgroundColor = kBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initUI{
    
    //时间
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(15.f);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8.f);
        make.width.mas_equalTo(160.f);
    }];
    
    [self.contentView addSubview:self.bgview];
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10.f);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8.f);
        make.height.mas_equalTo(50.f);
    }];
    //标题
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgview.mas_left).offset(15.f);
        make.right.mas_equalTo(self.bgview.mas_right).offset(-15.f);
        make.top.mas_equalTo(self.bgview.mas_top).mas_equalTo(8.f);
        make.height.mas_equalTo(16.f);
    }];
    [self.contentView addSubview:self.unReadLabel];
    [self.unReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.title.mas_top).offset(3);
        make.centerY.mas_equalTo(self.title);
        make.width.height.mas_equalTo(8.f);
        make.left.mas_equalTo(self.bgview.mas_left).offset(3.f);
    }];
    //内容
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.title);
        make.height.mas_equalTo(17);
        make.top.mas_equalTo(self.title.mas_bottom).offset(5);
    }];
}

- (void)configWithMemberModel:(MemberDataModel *)memberDataModel{
    if (memberDataModel.msgStatus) {
        if ([memberDataModel.msgStatus integerValue] == 0) {
            self.unReadLabel.hidden = NO;
        }else{
            self.unReadLabel.hidden = YES;
        }
    }
    _contentLabel.text = memberDataModel.msgDesc;
    _title.text = memberDataModel.msgTitle;
    _timeLabel.text = memberDataModel.sendTime;
}

#pragma mark --- 懒加载
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = WDColorFrom16RGB(0x666666);
        _timeLabel.font = kFont12;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = WDColorFrom16RGB(0x999999);
        _contentLabel.font = kFont12;
//        _contentLabel.numberOfLines = 2;
//        _contentLabel.backgroundColor = [UIColor greenColor];
    }
    return _contentLabel;
}
- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = kFont14;
        _title.textColor = WDColorFrom16RGB(0x666666);
        _title.textAlignment = NSTextAlignmentLeft;
    }
    return _title;
}

- (UILabel *)unReadLabel{
    if (!_unReadLabel) {
        _unReadLabel = [[UILabel alloc] init];
        _unReadLabel.backgroundColor = WDColorFrom16RGB(0xfd5073);
        _unReadLabel.layer.cornerRadius = 4;
        _unReadLabel.layer.masksToBounds = YES;
        _unReadLabel.hidden = YES;
    }
    return _unReadLabel;
}
- (UIView *)bgview{
    if (!_bgview) {
        _bgview = [[UILabel alloc] init];
        _bgview.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return _bgview;
}

@end
