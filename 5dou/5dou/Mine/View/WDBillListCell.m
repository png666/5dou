
//
//  WDBillListCell.m
//  5dou
//
//  Created by rdyx on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBillListCell.h"
@interface WDBillListCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UILabel *refuseInfoLabel;

@end
@implementation WDBillListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBillListModel:(WDBillListModel *)billListModel{
    _billListModel = billListModel;
    _dateLabel.text = [NSString stringWithFormat:@"%@日",[billListModel.createDate substringWithRange:NSMakeRange(8, 2)]];;
    _hourLabel.text = [billListModel.createDate substringWithRange:NSMakeRange(11, 5)];
    
    CGFloat money = _billListModel.amount;
    //收到
    if ([_billListModel.tradeType isEqualToString:@"0"]) {
        _typeImageView.image = [UIImage imageNamed:@"shou"];
        _refuseButton.hidden = YES;
        _refuseInfoLabel.hidden = YES;
        _moneyLabel.text = [NSString stringWithFormat:@"+%.2lf",money];
        _feeLabel.text = _billListModel.productName;
    }
    //提取
    else if([_billListModel.tradeType isEqualToString:@"1"]){
        _typeImageView.image = [UIImage imageNamed:@"tixian"];
        _refuseButton.hidden = YES;
        _refuseInfoLabel.hidden = YES;
        _moneyLabel.text = [NSString stringWithFormat:@"-%.2lf",money];
        _feeLabel.text = _billListModel.productName;
    }
    else if ([_billListModel.tradeType isEqualToString:@"2"]){
        _typeImageView.image = [UIImage imageNamed:@"tixian"];
        _refuseButton.hidden = NO;
        _refuseInfoLabel.hidden = YES;
        CGFloat fee = [_billListModel.counterFee floatValue];
        _feeLabel.text = [NSString stringWithFormat:@"手续费-%.2f",fee];
        if ([_billListModel.withdrawalsStatus isEqualToString:@"3"]) {
            [_refuseButton setTitle:@"提现失败" forState:UIControlStateNormal];
            _refuseInfoLabel.hidden = NO;
            if (_billListModel.refuseReason) {
            _refuseInfoLabel.text = _billListModel.refuseReason;
            }
        }else if([_billListModel.withdrawalsStatus isEqualToString:@"2"]){
            [_refuseButton setTitle:@"提现成功" forState:UIControlStateNormal];
        }else if([_billListModel.withdrawalsStatus isEqualToString:@"1"]){
            [_refuseButton setTitle:@"申请中" forState:UIControlStateNormal];
        }
         _moneyLabel.text = [NSString stringWithFormat:@"-%.2lf",money];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
