
//
//  WDFeedbackCell.m
//  5dou
//
//  Created by rdyx on 16/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDFeedbackCell.h"
#import "Masonry.h"
#import "WDFeedbackModel.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface WDFeedbackCell()

@property(nonatomic,strong)UIImageView *headImg;
@property(nonatomic)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic)UILabel *contentLabel;
@property(nonatomic)UILabel *replyLabel;

@property(nonatomic,strong)UIButton *button;

@end

@implementation WDFeedbackCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    _headImg = [UIImageView new];
    [self.contentView addSubview:_headImg];
    _headImg.layer.cornerRadius = 26.f;
    _headImg.layer.masksToBounds = YES;
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.height.and.width.equalTo(@52);
    }];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = kLightGrayColor;
    _nameLabel.font = kFont14;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(12.5);
        make.top.equalTo(_headImg.mas_top);
        make.height.equalTo(@14);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = kLightGrayColor;
    _timeLabel.font = kFont14;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(25);
        make.top.equalTo(_nameLabel.mas_top);
        make.height.equalTo(_nameLabel.mas_height);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom).offset(12);
        make.right.equalTo(@-15);
    }];
    //确保大屏手机准确性
    _contentLabel.preferredMaxLayoutWidth = ScreenWidth-30.f;
    
    _replyLabel = [UILabel new];
    _replyLabel.numberOfLines = 0;
    _replyLabel.font = kFont13;
    _replyLabel.textColor = kLightGrayColor;
    [_replyLabel sizeToFit];
    [self.contentView addSubview:_replyLabel];
    [_replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        make.right.equalTo(@-15);
    }];
    _replyLabel.preferredMaxLayoutWidth = ScreenWidth-30.f;
    
    //最后一个控件
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:self.button];
    [self.button setTitle:@"" forState:UIControlStateNormal];
    [self.button setBackgroundColor:kWhiteColor];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.replyLabel.mas_bottom).offset(2);
    }];
    
    // 必须加上这句
    self.hyb_lastViewInCell = self.button;
    self.hyb_lastViewsInCell = @[self.button];
    self.hyb_bottomOffsetToCell = 20;
}


-(void)configCellWithModel:(WDFeedbackModel *)model
{
    
    [_headImg sd_setImageWithURL:WDURL(model.headImg) placeholderImage:nil];
    _nameLabel.text = model.nickName;
    _timeLabel.text = model.createDateStr;
    _contentLabel.text = model.message;
    _replyLabel.text = model.sysReply;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
