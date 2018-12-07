


//
//  WDMemeberCenterCell.m
//  5dou
//
//  Created by rdyx on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDMemeberCenterCell.h"
#import "UIView+Sizes.h"
@interface WDMemeberCenterCell()


@property(nonatomic,strong)UIImageView *accesoryImage;

@end
@implementation WDMemeberCenterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.left+20, 0, 25.f, 25.f)];
    _headImage.centerY = self.contentView.centerY+3;
    
    [self.contentView addSubview:_headImage];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImage.right+15, 0, 100.f, 44.f)];
    _nameLabel.textColor = kGrayColor;
    _nameLabel.font = kFont15;
    _nameLabel.centerY = self.contentView.centerY+3;
    
    [self.contentView addSubview:_nameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.height+5, ScreenWidth, 0.5)];
    self.lineView = lineView;
    lineView.backgroundColor = WDColorRGB(221.f, 221.f, 221.f);
    [self.contentView addSubview:lineView];
    
//    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40.f, self.contentView.centerY-5, 15.f, 20.f)];\
//    arrowImage.image = WDImgName(@"arrow");
//    [self.contentView addSubview:arrowImage];
    
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.lineView.width = ScreenWidth;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
