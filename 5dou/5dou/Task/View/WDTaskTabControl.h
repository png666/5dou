//
//  WDTaskTabControl.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENUM.h"
typedef void (^TaskTabControlBlock) (TaskFilterType taskFilterType);
/**
 1.5版本专用 ，2.0以后淘汰
 */
@interface WDTaskTabControl : UIView

@property (nonatomic,strong) TaskTabControlBlock controlBlock;
@property (weak, nonatomic) IBOutlet UIButton *kindButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
+ (WDTaskTabControl *)view;
/**
 *  改变一个按钮的状态
 *
 *  @param taskFilterType 改变按钮状态的类型
 */
- (void)buttonClick:(TaskFilterType )taskFilterType;
/**
 *  将所有的按钮状态置成正常的颜色
 */
- (void)closeFilterView;

@end
