//
//  WDBuyCell.m
//  5dou
//
//  Created by 黄新 on 16/12/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值页面的购买Cell  流量详情的显示目前有两种类型（全国流量和本地流量）
//

#import "WDBuyCell.h"
#import "WDFlowPackageModel.h"
#import "UIButton+EnlargeTouchArea.h"

@interface WDBuyCell ()

//@property (nonatomic, strong) UILabel *priceLabel;///< 所需支付的金额
@property (nonatomic, strong) UILabel *flowTypeLabel;///< 流量类型标签
@property (nonatomic, strong) UIButton *bugBtn;///< 购买的按钮
@property (nonatomic, strong) UILabel *infoLabel;///< 说明
//@property (nonatomic, strong) UILabel *discountLabel;///< 逗币抵扣
@property (nonatomic, strong) UIButton *discountBtn; ///< 逗币抵扣按钮
@property (nonatomic, strong) UILabel *rewardLabel;///< 奖励逗币
@property (nonatomic, strong) WDFlowWholeKeyModel *model;///< 当前cell的model

@end

@implementation WDBuyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.backgroundColor = WDColorFrom16RGB(0xffffff);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark ===== 初始化UI
- (void)initUI{
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(self.contentView.top).offset(16);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];
//    self.priceLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.flowTypeLabel];
    [self.flowTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(23);
//        make.centerY.mas_equalTo(self.priceLabel);
        make.top.mas_equalTo(self.priceLabel).offset(-3);
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(5);
    }]; 
    [self.contentView addSubview:self.bugBtn];
    [self.bugBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
    }];
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel);
        make.right.mas_equalTo(self.bugBtn.mas_left).offset(-20);
        make.height.mas_equalTo(14);
        make.bottom.mas_equalTo(self.bugBtn.mas_bottom);
    }];
    [self.contentView addSubview:self.discountBtn];
    [self.discountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.left.mas_equalTo(self.priceLabel);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(10);
    }];
    //增加按钮的触控区域
    [self.discountBtn setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    [self.contentView addSubview:self.discountLabel];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self.discountBtn);
        make.left.mas_equalTo(self.discountBtn.mas_right).offset(7);
    }];
    [self.contentView addSubview:self.rewardLabel];
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.discountLabel.mas_bottom);
        make.height.mas_equalTo(14);
        make.left.mas_equalTo(self.discountLabel.mas_right).offset(15);
    }];
    
}

/**
 Cell绑定数据

 @param model        数据源
 @param walletAmount 用于剩余的逗币数量
 @param indexPath    当前cell的索引
 */
- (void)configValuesWith:(WDFlowWholeKeyModel *)model WalletAmount:(NSString *)walletAmount IndexPath:(NSIndexPath *)indexPath{
    _bugBtn.backgroundColor = WDColorFrom16RGB(0xffffff);
    self.model = model;
//    NSString *priceString = [NSString stringWithFormat:@"%@元", model.price];
//    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:priceString];
//    NSRange rang = [priceString rangeOfString:[NSString stringWithFormat:@"%@",model.price]];
//    [priceAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size:24] range:rang];
//    [priceAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x8b572a) range:rang];
    //价格
//    NSString *priceString = [NSString stringWithFormat:@"%@元 %@元",model.discount,model.price];
//    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:priceString];
//    NSRange rang = [priceString rangeOfString:[NSString stringWithFormat:@"%@",model.discount]];
//    [priceAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size:24] range:rang];
//    [priceAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x8b572a) range:rang];
    //添加中划线
//    NSRange discountRang = [priceString rangeOfString:[NSString stringWithFormat:@"%@元",model.price] options:NSBackwardsSearch];
//    //原价
//    NSRange priceRang = [priceString rangeOfString:[NSString stringWithFormat:@"%@",model.price] options:NSBackwardsSearch];
//    [priceAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size:15] range:priceRang];
//    [priceAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0xd1d0d0) range:discountRang];
//    [priceAttribute addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:discountRang];
//    [priceAttribute addAttribute:NSStrikethroughColorAttributeName value:WDColorFrom16RGB(0x464646) range:discountRang];
    
    //流量的使用类型
    if ([model.key isEqualToString:@"local"]) {
        self.flowTypeLabel.text = @"本地";
    }else if ([model.key isEqualToString:@"whole"]){
        self.flowTypeLabel.text = @"全国";
    }
    //生效时间 ---- 根据数据返回判断
//    NSString *infoString = nil;
//    if ([model.startDataTime isEqualToString:@"NaturalMonth"]) {
//        infoString = [NSString stringWithFormat:@"%@可用，即时生效，%@天有效",self.flowTypeLabel.text,model.validityPeriod];
//    }else if ([model.startDataTime isEqualToString:@"SameMonth"]){
//        infoString = [NSString stringWithFormat:@"%@可用，即时生效，当月生效",self.flowTypeLabel.text];
//    }else if ([model.startDataTime isEqualToString:@"NextMonth"]){
//        infoString = [NSString stringWithFormat:@"%@可用，次月生效，%@有效",self.flowTypeLabel.text,model.validityPeriod];
//    }
    self.infoLabel.text = [NSString stringWithFormat:@"%@可用，当月有效",self.flowTypeLabel.text];
    //流量价格
    NSString *price = @"";
    if (_discountBtn.selected) {
        if ([walletAmount isEqualToString:@"0"]) {
            price = [NSString stringWithFormat:@"%.2f",[model.sellPrice floatValue]];
        }else{
            if ([walletAmount floatValue] >= [model.sellPrice floatValue]) {
                price = @"0.00";
            }else{
                price = [NSString stringWithFormat:@"%.2f",[model.sellPrice floatValue] - [walletAmount floatValue]];
            }
        }
    }else{
        price = [NSString stringWithFormat:@"%.2f", [model.sellPrice floatValue]];
    }
    //流量价格
    NSString *priceString = [NSString stringWithFormat:@"%@元",price];
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSRange rang = [priceString rangeOfString:price];
    [priceAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size:24] range:rang];
    [priceAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x8b572a) range:rang];
    self.priceLabel.attributedText = priceAttribute;
    //逗币抵扣
    NSString *amount = @"";
    if ([walletAmount isEqualToString:@"0"]) {
        amount = @"0";
    }else{
        if ([walletAmount floatValue] >= [model.sellPrice floatValue]) {
            amount = [NSString stringWithFormat:@"%.2f",[model.sellPrice floatValue]];
        }else{
            amount = walletAmount;
        }
    }
    self.discountLabel.text = [NSString stringWithFormat:@"逗币抵扣：%@",amount];
    //奖励逗币
    self.rewardLabel.text = [NSString stringWithFormat:@"奖励%@逗币", model.refundBalance];
}
#pragma mark ======= 购买按钮点击事件
- (void)buyBtnDidClick:(UIButton *)sender{
    _bugBtn.backgroundColor = WDColorFrom16RGB(0xfdc000);
    if (self.buyBtnDidClickBlock) {
//        _bugBtn.backgroundColor = WDColorFrom16RGB(0xfdc000);
        self.buyBtnDidClickBlock(sender ,self.model , self.discountBtn.selected);
    }
}
#pragma mark ======= 逗币抵扣点击事件
- (void)discountBtnDidClick:(UIButton *)sender{
    [sender setSelected:!sender.selected];
    //刷新流量的购买价格
    if (self.reloadPriceCountBlock) {
        self.reloadPriceCountBlock(sender, self.model);
    }
}

#pragma mark ====== 懒加载
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = WDColorFrom16RGB(0x999999);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
//        _priceLabel.backgroundColor = [UIColor redColor];
    }
    return _priceLabel;
}
- (UILabel *)flowTypeLabel{
    if (!_flowTypeLabel) {
        _flowTypeLabel = [[UILabel alloc] init];
        _flowTypeLabel.backgroundColor = WDColorFrom16RGB(0xfdc000);
        _flowTypeLabel.layer.cornerRadius = 5.5;
        _flowTypeLabel.layer.masksToBounds = YES;
        _flowTypeLabel.textAlignment = NSTextAlignmentCenter;
        _flowTypeLabel.textColor = [UIColor whiteColor];
        _flowTypeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _flowTypeLabel;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.layer.cornerRadius = 5.5;
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = WDColorFrom16RGB(0x999999);
        _infoLabel.font = [UIFont systemFontOfSize:12];
    }
    return _infoLabel;
}
- (UIButton *)bugBtn{
    if (!_bugBtn) {
        _bugBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bugBtn.layer.cornerRadius = 7.5;
        _bugBtn.layer.masksToBounds = YES;
        _bugBtn.layer.borderWidth = 1;
        _bugBtn.layer.borderColor = WDColorFrom16RGB(0xfdc000).CGColor;
        _bugBtn.backgroundColor = WDColorFrom16RGB(0xffffff);
        [_bugBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];

        _bugBtn.titleLabel.font = kFont18;
        [_bugBtn setTitle:@"购买" forState:UIControlStateNormal];
        [_bugBtn addTarget:self action:@selector(buyBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bugBtn;
}
- (UIButton *)discountBtn{
    if (!_discountBtn) {
        _discountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_discountBtn setBackgroundImage:[UIImage imageNamed:@"flowdikou_selected"] forState:UIControlStateSelected];
        [_discountBtn setBackgroundImage:[UIImage imageNamed:@"flowdikou_nor"] forState:UIControlStateNormal];
        [_discountBtn addTarget:self action:@selector(discountBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_discountBtn setSelected:YES];///  逗币抵扣默认选中
    }
    return _discountBtn;
}


- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.font = [UIFont systemFontOfSize:13];
        _discountLabel.textColor = WDColorFrom16RGB(0x999999);
        _discountLabel.textAlignment = NSTextAlignmentLeft;
//        _discountLabel.backgroundColor = [UIColor redColor];
    }
    return _discountLabel;
}
- (UILabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [[UILabel alloc] init];
        _rewardLabel.textAlignment = NSTextAlignmentRight;
        _rewardLabel.textColor = WDColorFrom16RGB(0x8B572A);
        _rewardLabel.font = kFont13;
//        _rewardLabel.backgroundColor = [UIColor redColor];
    }
    return _rewardLabel;
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
