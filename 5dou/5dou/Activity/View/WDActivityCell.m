//
//  WDActivityCell.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/29.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDActivityCell.h"
static NSString * const activityCell = @"WDActivityCell";
@interface WDActivityCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activitySource;
@end
@implementation WDActivityCell

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.contentView.layer.cornerRadius = 5.f;
//    self.contentView.layer.masksToBounds = YES;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
   //    _bgView.layer.contentsScale = [UIScreen mainScreen].scale;
//    _bgView.layer.shadowOpacity = 0.75f;
//    _bgView.layer.shadowRadius = 2.0f;
//    _bgView.layer.shadowOffset = CGSizeMake(0,0);
//    _bgView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_bgView.bounds].CGPath;
//    _bgView.layer.shouldRasterize = YES;
//    _bgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setActivityModel:(WDActivityModel *)activityModel{
    _activityModel = activityModel;
    [_activityImageView sd_setImageWithURL:[NSURL URLWithString:activityModel.thumbUrl] placeholderImage:[UIImage imageNamed:@"activity_failphoto"]];
    _activityTitle.text = _activityModel.title;
    _activityTime.text = _activityModel.createTime;
    _activitySource.text = [NSString stringWithFormat:@"发布者:%@",_activityModel.source];
}

+ (instancetype)cellFromXib:(UITableView *)tableView cellAnchorPoint:(CGPoint)cellAnchorPoint angle:(CGFloat)angle
{
    
    WDActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    //动画设置
    CATransform3D transform = CATransform3DMakeRotation(angle, 0.0, 0.5, 0.3);
    /**
     
     struct CATransform3D
     {
     CGFloat m11, m12, m13, m14;
     CGFloat m21, m22, m23, m24;
     CGFloat m31, m32, m33, m34;
     CGFloat m41, m42, m43, m44;
     };
     
     typedef struct CATransform3D CATransform3D;
     
     m34:实现透视效果(意思就是:近大远小), 它的值默认是0, 这个值越小越明显
     
     */
    transform.m34 = -1.0/500.0; // 设置透视效果
    cell.layer.transform = transform;
    cell.layer.anchorPoint = cellAnchorPoint;
    [UIView animateWithDuration:0.6 animations:^{
        cell.layer.transform = CATransform3DIdentity;
    }];
    
    return cell;
}


@end
