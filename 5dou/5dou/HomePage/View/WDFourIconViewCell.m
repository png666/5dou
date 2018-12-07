

//
//  WDFourIconViewCell.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDFourIconViewCell.h"
#import "UIView+Sizes.h"

@implementation WDFourIconViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
//        self.backgroundColor = kNavigationBarColor;
    }
    return self;
}

-(void)makeUI{
    
    _iconImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0,18,36,36)];
    //_headImageView.center = CGPointMake(self.frame.size.width/2, 0);
    _iconImage.centerX = self.contentView.width/2;
    _iconImage.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_iconImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_iconImage.frame)+8, 60, 18)];
    _nameLabel.centerX = self.contentView.width/2;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = kGrayColor;
    _nameLabel.font = kFont12;
    [self.contentView addSubview:_nameLabel];
    
    
}

-(void)configData:(WDFourIconModel *)model{
    
    _nameLabel.text = model.iconName;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil];

    
}

@end
