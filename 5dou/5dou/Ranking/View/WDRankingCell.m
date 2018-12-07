//
//  WDRankingCell.m
//  5dou
//
//  Created by 黄新 on 16/11/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDRankingCell.h"
#import "WDRankingModel.h"
#import "WDHotRankingModel.h"
#import "UIImageView+WebCache.h"
#import "WDInviteRebateModel.h"

@interface WDRankingCell ()

@property (nonatomic, strong) UIButton    *topBtn;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel     *incomeLabel;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, assign) CGFloat paddingWidth;


@end


@implementation WDRankingCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)initUI{
    self.paddingWidth = (ScreenWidth-286)/5.0;
    //排名
    [self.contentView addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    //头像
    [self.contentView addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(75);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(42);
    }];
    //切圆角
    [self.iconImgView layoutIfNeeded];
    [self.iconImgView setAllCorner];

    //姓名
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.iconImgView);
    }];
    //收益
    [self.contentView addSubview:self.incomeLabel];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(8);
    }];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)configValue:(RankingListModel *)model IndexPath:(NSIndexPath *)indexPath{
    //Top
    if (indexPath.row > 2) {
        [self.topBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(16);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.topBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.topBtn setTitle:[NSString stringWithFormat:@"NO.%ld",indexPath.row+1] forState:UIControlStateNormal];
    }else{
        [self.topBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(29);
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        [self.topBtn setTitle:@"" forState:UIControlStateNormal];
        [self.topBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"top%ld",indexPath.row + 1]] forState:UIControlStateNormal];
    }
    //头像
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@""]];
    //姓名
    self.nameLabel.text = model.nickName;
    //收益
    NSString *textString = [NSString stringWithFormat:@"收益￥%@逗币",model.walletAmount];
    NSMutableAttributedString *textAttribute = [[NSMutableAttributedString alloc] initWithString:textString];
    NSRange rang = [textString rangeOfString:[NSString stringWithFormat:@"￥%@",model.walletAmount]];
//    [textAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:24] range:rang];
    [textAttribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rang];
    self.incomeLabel.attributedText = textAttribute;

}

#pragma mark ===== 懒加载

- (UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topBtn.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:14];
        [_topBtn setTitleColor:WDColorFrom16RGB(0x666666) forState:UIControlStateNormal];
        _topBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _topBtn;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = WDColorFrom16RGB(0x666666);
    }
    return _nameLabel;
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc] init];
        _incomeLabel.textAlignment = NSTextAlignmentLeft;
        _incomeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _incomeLabel.textColor = WDColorFrom16RGB(0x999999);
    }
    return _incomeLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = WDColorFrom16RGB(0xededed);
    }
    return _lineView;
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
