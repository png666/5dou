//
//  WDNotLoginData.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDNotLoginData.h"

@implementation WDNotLoginData


+ (WDNotLoginData *)view{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WDNotLoginData" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _resgisterBtn.layer.cornerRadius = _resgisterBtn.height * 0.5;
    _loginBtn.layer.cornerRadius = _loginBtn.height * 0.5;
    _resgisterBtn.layer.borderColor = WDColorFrom16RGB(0xFDBB00).CGColor;
    _loginBtn.layer.borderColor = WDColorFrom16RGB(0x8B572A).CGColor;
    _resgisterBtn.layer.borderWidth = 0.5;
    _loginBtn.layer.borderWidth = 0.5;
    _resgisterBtn.clipsToBounds = YES;
    _loginBtn.clipsToBounds = YES;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _resgisterBtn.layer.cornerRadius = _resgisterBtn.height * 0.5;
    _loginBtn.layer.cornerRadius = _loginBtn.height * 0.5;
    _resgisterBtn.layer.borderColor = WDColorFrom16RGB(0xFDBB00).CGColor;
    _loginBtn.layer.borderColor = WDColorFrom16RGB(0x8B572A).CGColor;
    _resgisterBtn.layer.borderWidth = 0.5;
    _loginBtn.layer.borderWidth = 0.5;
    _resgisterBtn.clipsToBounds = YES;
    _loginBtn.clipsToBounds = YES;

}
- (void)setImage:(UIImage *)image withInfo:(NSString *)infoStr withLeftBtn:(NSString *)leftStr withRightBtn:(NSString *)rightStr{
    _imageView.image = image;
    _infoLabel.text = infoStr;
    [_resgisterBtn setTitle:leftStr forState:UIControlStateNormal];
    [_loginBtn setTitle:rightStr forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
