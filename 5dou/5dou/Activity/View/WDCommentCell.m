//
//  WDCommentCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDCommentCell.h"
@interface WDCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
@implementation WDCommentCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _headerImageView.layer.cornerRadius = 16;
    _headerImageView.clipsToBounds = YES;
}

- (void)setCommentModel:(WDCommentModel *)commentModel{
    _commentModel = commentModel;
    _headerImageView.contentMode =   UIViewContentModeScaleAspectFill;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_commentModel.photo] placeholderImage:[UIImage imageNamed:@"head"]];
    _nameLabel.text = _commentModel.account;
    YYLog(@"time = %@",_commentModel.time);
    _timeLabel.text = _commentModel.time;
    _contentLabel.text = commentModel.content;
}
@end
