//
//  WDTaskMoudelView.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/17.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTaskDetailModel.h"
/**通知Controller进行刷新的操作*/
typedef void(^TaskStateRefreshBlock)(NSDictionary *updateDict);
/**
 任务模块，分为三个部分，分别是基本信息，任务步骤，提交任务
 */
@interface WDTaskModulelView : UIView
@property (nonatomic,strong) WDTaskDetailModel *detailModel;
@property (nonatomic,copy) TaskStateRefreshBlock taskStateRefreshBlock;
@end
