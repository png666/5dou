//
//  WDTaskFinishCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/10/11.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTaskModel.h"
#import "ENUM.h"
/**
 1.5版本专用 ，2.0以后淘汰
 */
@interface WDTaskFinishCell : UITableViewCell
@property (nonatomic,strong) WDTaskModel *taskModel;
@property (nonatomic,assign) TaskType taskType;
@end

