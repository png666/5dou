//
//  WDRecordCell.m
//  5dou
//
//  Created by 黄新 on 16/12/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值记录 Cell
//
//

#import "WDRecordCell.h"
#import "WDFlowOrderListModel.h"

@interface WDRecordCell ()

@property (nonatomic, strong) UIImageView *iconImgView;///< 运营商
@property (nonatomic, strong) UILabel *rechargeTitle;///< 充值的标题
@property (nonatomic, strong) UILabel *discountLabel;///< 折扣
@property (nonatomic, strong) UILabel *timeLabel;///< 交易时间
@property (nonatomic, strong) UILabel *priceLabel;///< 价格
@property (nonatomic, strong) UIView *cutView;///< 分割

@end


@implementation WDRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = WDColorFrom16RGB(0xffffff);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
    }];
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(ScreenWidth>320?80:60);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    //充值标题
    [self.contentView addSubview:self.rechargeTitle];
    [self.rechargeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImgView);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(10);
        make.height.mas_equalTo(16);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(ScreenWidth>320?-10:0);
    }];
    
    [self.contentView addSubview:self.discountLabel];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.rechargeTitle);
        make.top.mas_equalTo(self.rechargeTitle.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rechargeTitle);
        make.top.mas_equalTo(self.discountLabel.mas_bottom).offset(7);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(17);
    }];
    [self.contentView addSubview:self.cutView];
    [self.cutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
        make.right.left.bottom.mas_equalTo(self);
    }];
    
}

#pragma mark ====== 配置数据

- (void)config:(WDFlowDataListModel *)model{
    self.discountLabel.text = [self getDiscountStringWithState:model];
    //运营商
    self.iconImgView.image = [self getOperation:model.operator];
    self.rechargeTitle.text = [NSString stringWithFormat:@"充值%@-%@",model.packageSize,model.mobile];
    //购买价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.onlinePayAmount];
    //订单状态
    NSString *orderState = [self getOrderState:model.state];
    //订单状态(0:待支付,1:待充值,2:充值成功,3:充值失败,4:超时取消,5:用户取消)
    NSString *string = [NSString stringWithFormat:@"%@   %@",model.createTime,[self getOrderState:model.state]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange rang = [string rangeOfString:[self getOrderState:model.state]];
    //设置订单状态的字体
    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:12] range:rang];
    if ([orderState isEqualToString:@"等待付款"]) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0xf5a623) range:rang];
    }else{
        [attributeString addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x999999) range:rang];
    }
    self.timeLabel.attributedText = attributeString;
    
}
//订单状态(0:待支付,1:待充值,2:充值成功,3:充值失败,4:超时取消,5:用户取消)
#pragma mark ====== 获取订单状态
- (NSString *)getOrderState:(NSString *)stateCode{
    if ([stateCode isEqualToString:@"0"]) {
        return @"等待付款";
    }else if ([stateCode isEqualToString:@"1"]){
        return @"正在充值";
    }else if ([stateCode isEqualToString:@"2"]){
        return @"充值成功";
    }else if ([stateCode isEqualToString:@"3"]){
        return @"充值失败";
    }else if ([stateCode isEqualToString:@"4"]){
        return @"交易超时";
    }else if ([stateCode isEqualToString:@"5"]){
        return @"交易关闭";
    }else{
        return @"";
    }
}
#pragma mark ==== 获取订单当前的状态
- (NSString *)getDiscountStringWithState:(WDFlowDataListModel *)model{
    NSString *orderState = [self getOrderState:model.state];
    //逗币返还
//    CGFloat discount = [model.packagePrice floatValue] - [model.discountPrice floatValue];
    if ([orderState isEqualToString:@"等待付款"] ||
        [orderState isEqualToString:@"充值成功"] ||
        [orderState isEqualToString:@"正在充值"]) {
        return  [NSString stringWithFormat:@"逗币抵扣：-%@  逗币返还：+%.2f",model.balanceAmount,[model.refundBalance floatValue]];
    }else if ([orderState isEqualToString:@"交易关闭"]){
        //超时取消的
        return [NSString stringWithFormat:@"已退还抵扣的逗币%@",model.balanceAmount];
    }else if ([orderState isEqualToString:@"充值失败"]||[orderState isEqualToString:@"交易超时"]){
       return  @"充值失败，已退款";
    }
    return nil;
}

//1:移动，2:联通 ，3:电信
#pragma mark ====== 获取运营商类型
- (UIImage *)getOperation:(NSString *)operationType{
    if ([operationType isEqualToString:@"1"]) {
        UIImage *img = [UIImage imageNamed:@"CM_icon"];
        return img;
    }else if ([operationType isEqualToString:@"2"]){
        UIImage *img = [UIImage imageNamed:@"CU_icon"];
        return img;
    }else if ([operationType isEqualToString:@"3"]){
        UIImage *img = [UIImage imageNamed:@"CT_icon"];
        return img;
    }
    return nil;
}


#pragma mark ====== 懒加载
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)rechargeTitle{
    if (!_rechargeTitle) {
        _rechargeTitle = [[UILabel alloc] init];
        _rechargeTitle.font = [UIFont boldSystemFontOfSize:15];
        _rechargeTitle.textColor = WDColorFrom16RGB(0x333333);
        _rechargeTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _rechargeTitle;
}

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _discountLabel.textColor = WDColorFrom16RGB(0x666666);
        _discountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _discountLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = WDColorFrom16RGB(0x999999);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        if (device_is_iphone_4||device_is_iphone_5) {
            _priceLabel.font = [UIFont boldSystemFontOfSize:15];
        }else{
            _priceLabel.font = [UIFont boldSystemFontOfSize:18];
        }
        
        _priceLabel.textColor = WDColorFrom16RGB(0xffc200);
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UIView *)cutView{
    if (!_cutView) {
        _cutView = [[UIView alloc] init];
        _cutView.backgroundColor = kBackgroundColor;
    }
    return _cutView;
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
