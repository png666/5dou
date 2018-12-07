//
//  WDTaskFilterView.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENUM.h"
typedef void (^TaskFilterBlock) (NSInteger option,TaskFilterType taskFilterType);
/**
 1.5版本专用 ，2.0以后淘汰
 */
@interface WDTaskFilterView : UIView
@property (nonatomic,assign) TaskFilterType taskFilterType;
@property (nonatomic,assign) NSString *selectedOptionStr;
@property (nonatomic,copy) TaskFilterBlock taskFilterBlock;
@end
