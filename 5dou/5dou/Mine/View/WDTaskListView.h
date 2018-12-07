//
//  WDTaskListView.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ SelectTaskBlock)(NSString * taskId);
@interface WDTaskListView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *taskTableview;
//(1:进行中;2:审核中;3:已完成;4:已放弃)
@property (nonatomic,assign) NSInteger taskState;
@property (nonatomic,copy) SelectTaskBlock selectTaskBlock;
- (instancetype)initWithFrame:(CGRect)frame withState:(NSInteger)taskState;
@property (nonatomic,strong) NSMutableSet *timerSet;
@end
