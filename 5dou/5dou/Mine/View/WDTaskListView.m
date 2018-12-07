//
//  WDTaskListView.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskListView.h"
#import "WDTaskModel.h"

#import "WDTaskCell.h"
#import "WDTaskFinishCell.h"

#import "UITableViewCell+Ext.h"
#import "MJRefresh.h"
#import "WDUserInfoModel.h"
#import "WDNoneData.h"

#import "ToolClass.h"

#define pageSize 15
@interface WDTaskListView()
@property (nonatomic,strong) NSMutableArray *taskListArray;
@property (nonatomic,strong) WDNoneData *noneDataView;
@end
@implementation WDTaskListView
- (instancetype)initWithFrame:(CGRect)frame withState:(NSInteger)taskState{
    self = [super initWithFrame:frame];
    if (self) {
        _taskState = taskState;
        [self prepareUI];
        [self prepareDataToPage:0];
    }
    return self;
}

- (void)prepareUI{
    _taskListArray = [NSMutableArray arrayWithCapacity:0];
    [self addSubview:self.taskTableview];
    _noneDataView = [WDNoneData view];
    _noneDataView.frame = CGRectMake(0, 0, ScreenWidth, self.height);
    _noneDataView.alpha = 1;
    WeakStament(weakSelf);
    _noneDataView.noneDataBlock = ^(){
        [weakSelf prepareDataToPage:0];
    };
    [self addSubview:_noneDataView];
}



- (void)prepareDataToPage:(NSInteger)toPage{
    WeakStament(weakSelf);
    _timerSet = [[NSMutableSet alloc] init];
    NSDictionary *param = @{@"queryState":[NSNumber numberWithInteger:_taskState],
                            @"bi.mi":[WDUserInfoModel shareInstance].memberId,
                            @"pageInfo.pageSize":@pageSize,
                            @"pageInfo.toPage":[NSNumber numberWithInteger:toPage]};
    [WDNetworkClient postRequestWithBaseUrl:kMyTaskList setParameters:param success:^(id responseObject) {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        //如果有数据的情况下
        if (toPage == 0) {
            [weakSelf.taskListArray removeAllObjects];
            [weakSelf.taskTableview.mj_header endRefreshing];
        }
        if (newArray.count != 0) {
            for(NSDictionary *taskDict in newArray){
                WDTaskModel *model = [[WDTaskModel alloc] init];
                [model setValuesForKeysWithDictionary:taskDict];
                [weakSelf.taskListArray addObject:model];
            }
            [weakSelf.taskTableview.mj_footer endRefreshing];
        }else{
            [weakSelf.taskTableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (_taskListArray.count == 0) {
            weakSelf.noneDataView.alpha = 1;
        }else{
            weakSelf.noneDataView.alpha = 0;
        }
        [weakSelf.taskTableview reloadData];
    } fail:^(NSError *error) {
    } delegater:self];
}
#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果是已经完成
    UITableViewCell *cell;
    if (_taskState == 3) {
        cell = [WDTaskFinishCell cellWithTableView:tableView];
        ((WDTaskFinishCell *)cell).taskModel = _taskListArray[indexPath.row];
    }else{
        cell = [WDTaskCell cellWithTableView:tableView];
        ((WDTaskCell *)cell).taskModel = _taskListArray[indexPath.row];
        if (((WDTaskCell *)cell).changeTimer) {
            [self.timerSet addObject:((WDTaskCell *)cell).changeTimer];
        }
    }
   
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WDTaskModel *taskModel = _taskListArray[indexPath.row];
    if (_selectTaskBlock) {
       _selectTaskBlock(taskModel.taskId);
    }
}

#pragma mark 封装页面

- (UITableView *)taskTableview{
    WeakStament(weakSelf);
    if (!_taskTableview) {
        _taskTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height) style:UITableViewStylePlain];
        _taskTableview.delegate = self;
        _taskTableview.dataSource = self;
        _taskTableview.rowHeight = 110;
        _taskTableview.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _taskTableview.backgroundColor = kBackgroundColor;
        _taskTableview.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf prepareDataToPage:0];
        }];
        _taskTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //还有信息
            if (weakSelf.taskListArray.count % pageSize == 0) {
                NSInteger toPage = weakSelf.taskListArray.count / pageSize;
                [weakSelf prepareDataToPage:toPage];
            }else{
                [weakSelf.taskTableview.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _taskTableview;
}

- (void)delloc{
    for (NSTimer *timer in self.timerSet){
        [timer invalidate];
    }
}
@end
