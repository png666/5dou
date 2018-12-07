//
//  WDFunnyNewsCell.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDFunnyNewsCell.h"
@interface WDFunnyNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *browseLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitLabel;

@end

@implementation WDFunnyNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)configData:(WDSchoolNewsModel*)model{
    _dateLabel.text = model.createTime;
    [_newsImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb_url] placeholderImage:[UIImage imageNamed:@"activity_failphoto"]];
    _newsNameLabel.text = model.title;
    _browseLabel.text = [model.pageView stringValue];
    _commitLabel.text = [model.commentCount stringValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
