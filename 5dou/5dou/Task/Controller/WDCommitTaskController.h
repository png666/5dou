//
//  WDCommitTaskController.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
typedef void (^CommitTaskSuccessBlock)();
@interface WDCommitTaskController : WDBaseViewController
@property (nonatomic,strong) CommitTaskSuccessBlock successBlock;
@property (nonatomic,strong) NSArray *imageArray;
/**
 *  提交任务是否需要图片
 */
@property (nonatomic,copy) NSString *isNeedPic;
/**
 *  提交任务是否需要留言
 */
@property (nonatomic,copy) NSString *isNeedCommet;
/**
 *  提交任务是否需要试玩账号
 */
@property (nonatomic,copy) NSString *isNeedUserAccount;
@property (nonatomic,copy) NSString *taskId;
/**
 *  步骤
 */
@property (nonatomic,strong) NSArray *stepArray;
@end
