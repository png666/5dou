//
//  WDTaskChildController.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDBaseViewController.h"

/**
    我的任务分栏子页面
 */
#import "ZJScrollPageViewDelegate.h"
@interface WDTaskChildController : WDBaseViewController<ZJScrollPageViewChildVcDelegate>

/**
 1:进行中;2:审核中;3:已完成;4:已放弃
 */
@property (nonatomic,assign)  NSInteger taskState;
@end
