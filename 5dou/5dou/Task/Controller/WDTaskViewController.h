//
//  WDTaskViewController.h
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"

@interface WDTaskViewController : WDBaseViewController
/**
 *查询任务分类(0:全部;1:APP试用;2: 院线观影; 3: 问卷调查;4:营销推广)
 */
@property (nonatomic,assign) NSInteger queryCategory;
- (void)taskListResetWithKey:(NSString *)key;
@end
