//
//  WDTaskTimeCell.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/8.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^theTaskStopBlock)();
@interface WDTaskTimeCell : UITableViewCell
@property (nonatomic,assign) NSInteger countdownTime;
@property (nonatomic,strong) NSTimer *changeTimer;
/**
   是否是限制时间
 */
@property (nonatomic,assign) BOOL isLimitTime;
@property (nonatomic,copy) theTaskStopBlock taskStopBlock;
@end
