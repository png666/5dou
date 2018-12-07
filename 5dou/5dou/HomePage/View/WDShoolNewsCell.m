


//
//  WDShoolNewsCell.m
//  5dou
//
//  Created by rdyx on 16/9/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDShoolNewsCell.h"

@interface WDShoolNewsCell()
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *eyeCountLabel;
@property(nonatomic,strong)UILabel *commentCountLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@end

@implementation WDShoolNewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self configCell];
        self.backgroundColor = kClearColor;
        
    }
    return  self;
}

-(void)configCell
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 170.f)];
    bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:bgView];
    
    
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 140.f)];
    self.headImage = headImage;
    [bgView addSubview:headImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, headImage.bottom+8, ScreenWidth<375 ?200.f:220.f, 20.f)];
    nameLabel.font = kFont14;
    nameLabel.textColor = kGrayColor;
    self.nameLabel = nameLabel;
    [bgView addSubview:nameLabel];
    
//    UIImageView *eyeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, nameLabel.bottom+5, 22.f, 22.f)];
//    eyeImage.image = WDImgName(@"head");
//    [self.contentView addSubview:eyeImage];
    
//    UILabel *eyeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(eyeImage.right+3, nameLabel.bottom+5, 50.f, 20.f)];
//    self.eyeCountLabel = eyeCountLabel;
//    [self.contentView addSubview:eyeCountLabel];
    
    
//    UIImageView *commentImage = [[UIImageView alloc]initWithFrame:CGRectMake(eyeCountLabel.right+3, nameLabel.bottom+5, 22.f, 22.f)];
//    commentImage.image = WDImgName(@"head");
//    [self.contentView addSubview:commentImage];
    
//    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(commentImage.right+3, nameLabel.bottom+5, 50.f, 20.f)];
//    self.commentCountLabel = commentLabel;
//    [self.contentView addSubview:commentLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-100.f, headImage.bottom+8, 100.f, 20.f)];
    dateLabel.font = kFont14;
    dateLabel.textColor = kLightGrayColor;
    self.dateLabel = dateLabel;
    [bgView addSubview:dateLabel];

    self.selectionStyle = 0;
}

-(void)configData:(WDSchoolNewsModel *)model
{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.thumb_url] placeholderImage:[UIImage imageNamed:@"activity_failphoto"]];
    self.nameLabel.text = model.title;
    self.eyeCountLabel.text = [model.pageView stringValue];
    self.commentCountLabel.text = [model.commentCount stringValue];
    self.dateLabel.text = model.createTime;
    
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
