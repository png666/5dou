//
//  WDTaskSearchKeyController.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
/**
 *  关键字进行了修改
 *
 *  @param key 关键字
 */
typedef void (^FilterKeyChange) (NSString *key);
@interface WDTaskSearchKeyController : WDBaseViewController
@property (nonatomic,copy) FilterKeyChange filterKeyChange;
@end
