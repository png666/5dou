//
//  WDTaskDetailViewController.h
//  5dou
//
//  Created by rdyx on 16/8/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
#import "WDTaskDetailModel.h"
@interface WDTaskDetailViewController : WDBaseViewController
@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,strong) WDTaskDetailModel *taskDetailModel;
@end
