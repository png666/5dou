//
//  WDActivityCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/29.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDActivityCell.h"
#import "WDActivityModel.h"
@interface WDActivityCell : UITableViewCell
+ (instancetype)cellFromXib:(UITableView *)tableView cellAnchorPoint:(CGPoint)cellAnchorPoint angle:(CGFloat)angle;
@property (nonatomic,strong) WDActivityModel *activityModel;
@end
