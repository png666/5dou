//
//  WDTaskCardListView.h
//  5dou
//
//  Created by ChunXin Zhou on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDTaskCardListView : UIView
typedef void (^ SelectTaskBlock)(NSString * taskId);
@property (nonatomic,strong)UITableView *taskTableview;
//(1:进行中;2:审核中;3:已完成;4:已放弃)
@property (nonatomic,assign) NSInteger taskState;
@property (nonatomic,copy) SelectTaskBlock selectTaskBlock;
- (instancetype)initWithFrame:(CGRect)frame withState:(NSInteger)taskState;
@end
