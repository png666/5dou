

//
//  WDSubMemeberCenterCell.m
//  5dou
//
//  Created by rdyx on 16/9/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDSubMemeberCenterCell.h"
#import "UIView+Sizes.h"

@implementation WDSubMemeberCenterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configCell];
        
    }
    return  self;
}

-(void)configCell{
 
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, 0, 25.f, 25.f)];
    icon.centerY = self.contentView.centerY;
    [self.contentView addSubview:icon];
    self.iconImage = icon;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(icon.right+5,0, 200.f, 20.f)];
    title.centerY = self.contentView.centerY;
    title.textColor = kGrayColor;
    title.font = kFont14;
    [self.contentView addSubview:title];
    self.nameLabel = title;
    
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.height, ScreenWidth, 0.5)];
    bottomLine.backgroundColor = WDColorRGB(221.f, 221.f, 221.f);
    [self.contentView addSubview:bottomLine];
    
    self.accessoryType = 1;
    self.selectionStyle = 0;
    
    //用户信息
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth- (ScreenWidth>375?170.f:165.f), 0, 140.f, 30.f)];
    messageLabel.centerY = self.contentView.centerY;
    messageLabel.textColor = kGrayColor;
    messageLabel.font = kFont14;
    messageLabel.backgroundColor = kClearColor;
    messageLabel.hidden = YES;
    messageLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
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
