//
//  WDPayCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDPayCell.h"
@interface WDPayCell()
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIButton *selectImage;

@end
@implementation WDPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setPayModel:(WDPayModel *)payModel{
    _payModel = payModel;
    if([payModel.type isEqualToString:@"1"]){
        _payIcon.image = [UIImage imageNamed:@"weixin"];
    }else if([payModel.type isEqualToString:@"2"]){
        _payIcon.image = [UIImage imageNamed:@"zhifubao"];
    }
     _payName.text = payModel.name;
    if (_payModel.select) {
        [_selectImage setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }else{
        [_selectImage setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
