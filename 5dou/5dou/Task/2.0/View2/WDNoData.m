//
//  WDNoData.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDNoData.h"

@implementation WDNoData

+ (WDNoData *)view{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WDNoData" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _goMakeMoneyBtn.layer.cornerRadius = _goMakeMoneyBtn.height * 0.5;
    _goMakeMoneyBtn.clipsToBounds = YES;
    _goMakeMoneyBtn.layer.borderColor = WDColorFrom16RGB(0x8B572A).CGColor;
    _goMakeMoneyBtn.layer.borderWidth = 0.5;

}

- (void)layoutSubviews{
    [super layoutSubviews];
    _goMakeMoneyBtn.layer.cornerRadius = _goMakeMoneyBtn.height * 0.5;
    _goMakeMoneyBtn.clipsToBounds = YES;
    _goMakeMoneyBtn.layer.borderColor = WDColorFrom16RGB(0x8B572A).CGColor;
    _goMakeMoneyBtn.layer.borderWidth = 0.5;

}

- (void)setImage:(UIImage *)image withInfo:(NSString *)infoStr withBtn:(NSString *)btnStr{
    _imageView.image = image;
    _infoLabel.text = infoStr;
    [_goMakeMoneyBtn setTitle:btnStr forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
