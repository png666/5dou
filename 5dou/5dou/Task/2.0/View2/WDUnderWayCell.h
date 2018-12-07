//
//  WDUnderWayCell.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTaskModel.h"
@interface WDUnderWayCell : UITableViewCell
/**
 数据模型，在set方法中进行数据的复制和初始化
 */
@property (nonatomic,strong) WDTaskModel *taskModel;
@property (nonatomic,strong) NSTimer *changeTimer;
@end
