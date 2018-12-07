//
//  HelpTaskCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTaskStepModel.h"
/**
 1.5版本专用 ，2.0以后淘汰
 */
@interface WDHelpTaskCell : UITableViewCell
@property (nonatomic,strong) WDTaskStepModel *stepModel;
@end
