//
//  WDHeadViewCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/10/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WDTaskModel.h"

/**
 1.5版本专用 ，2.0以后淘汰
 */
@interface WDTaskHeadCell : UITableViewCell
@property (nonatomic,strong) WDTaskModel *taskModel;
@end
