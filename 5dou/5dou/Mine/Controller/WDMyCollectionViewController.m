
//
//  WDMyCollectionViewController.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  我的收藏列表
//

#import "WDMyCollectionViewController.h"

#import "MJRefresh.h"
#define pageSize 15

#import "WDTaskCell.h"
#import "WDTaskModel.h"
#import "WDTaskRequestModel.h"
#import "WDTaskFilterView.h"
#import "WDTaskTabControl.h"
#import "WDTaskDetailViewController.h"
#import "ToolClass.h"
#import "UIColor+Hex.h"
#import "WDNoneData.h"
#import "WDTaskModel.h"


#import "WDTaskSearchKeyController.h"
#import "WDTaskDetailViewController.h"

#import "WDCommanData.h"

#import "WDUserCollectModel.h"
#import "WDDefaultAccount.h"
#import "MJRefreshGifHeader+Ext.h"


@interface WDMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


/**
 *  任务列表
 */
@property (nonatomic,strong) UITableView *taskListTableView;
/**
 *  存储收藏信息
 */
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) WDNoneData *noDataView;
@property (nonatomic,strong) WDTaskRequestModel *taskReqeustModel;
@property (nonatomic,strong) NSMutableDictionary *requestDict;
@property (nonatomic,strong) NSArray *kindArray;

@property (nonatomic, assign) NSInteger page;///翻页

@end

@implementation WDMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    [self.navigationItem setItemWithTitle:@"我的收藏" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self prepareUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的收藏"];
    [self refreshData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的收藏"];
    //将TableViewCell的编辑状态关闭 不关闭可能会出现崩溃
    self.taskListTableView.editing = NO;
}

- (void)prepareUI{
    _dataArray = [NSMutableArray array];
    _requestDict = [NSMutableDictionary dictionary];
    [self.view addSubview:self.taskListTableView];
    [self.view addSubview:self.noDataView];
    
}
#pragma mark --- 数据请求
- (void)prepareDataWithPage:(NSInteger )toPage{
    WeakStament(weakSelf);
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"mi":mi,
                          @"pageInfo.pageSize":@"15",
                          @"pageInfo.toPage":[NSString stringWithFormat:@"%ld",(long)toPage]
                          };
    [WDNetworkClient postRequestWithBaseUrl:kUserCollectList setParameters:dic success:^(id responseObject) {
        
        WDUserCollectModel *model = [[WDUserCollectModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1002"]) {
            
        }else if ([model.result.code isEqualToString:@"1000"]) {
            
            //            NSMutableArray *newArray = [NSMutableArray arrayWithArray:[responseObject[@"data"]]];
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            for(NSDictionary *taskDict in newArray){
                WDTaskModel *model = [[WDTaskModel alloc] init];
                [model setValuesForKeysWithDictionary:taskDict[@"productBean"]];
                [weakSelf.dataArray addObject:model];
            }
        }else{
            [ToolClass showAlertWithMessage:@"请求失败"];
            return ;
        }
        //        for (productModel *item in model.data) {
        //            [self.dataArray addObject:item];
        //        }
        if (weakSelf.dataArray.count) {
            weakSelf.noDataView.alpha = 0;
        }else{
            weakSelf.noDataView.alpha = 1;
        }
        [weakSelf.taskListTableView.mj_header endRefreshing];
        [weakSelf.taskListTableView.mj_footer endRefreshing];
        [weakSelf.taskListTableView reloadData];
        
    } fail:^(NSError *error) {
        [weakSelf.taskListTableView.mj_header endRefreshing];
        [weakSelf.taskListTableView.mj_footer endRefreshing];
    } delegater:self.view];
}
- (UITableView *)taskListTableView{
    if (!_taskListTableView) {
        WeakStament(weakSelf);
        _taskListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _taskListTableView.delegate = self;
        _taskListTableView.dataSource = self;
        _taskListTableView.rowHeight = 90;
        _taskListTableView.separatorColor = [UIColor clearColor];
        _taskListTableView.backgroundColor = kBackgroundColor;
        //        _taskListTableView.bounces = NO;
        [_taskListTableView registerNib:[UINib nibWithNibName:@"WDTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WDTaskCell"];
        
        //带GIF刷新
        _taskListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
        [MJRefreshGifHeader initGifImage:_taskListTableView.mj_header];
        //        _taskListTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        //            [weakSelf refreshData];
        //        }];
        //        _taskListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //            //还有信息
        //            if (weakSelf.dataArray.count % pageSize == 0
        //                &&weakSelf.dataArray.count != 0) {
        //                [self loadMoreData];
        //            }else{
        //                [weakSelf.taskListTableView.mj_footer endRefreshingWithNoMoreData];
        //            }
        //
        //        }];
    }
    return _taskListTableView;
}

#pragma mark ==== 刷新数据
///刷新数据
- (void)refreshData{
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self prepareDataWithPage:self.page];
}
#pragma mark ==== 加载更多数据
/**
 *加载更多数据
 */
- (void)loadMoreData{
    self.page++;
    [self prepareDataWithPage:self.page];
}


- (WDNoneData *)noDataView{
    if (!_noDataView) {
        _noDataView = [WDNoneData view];
        _noDataView.alpha = 0;
        _noDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        WeakStament(weakSelf);
        _noDataView.noneDataBlock = ^(){
            [weakSelf refreshData];
        };
    }
    return _noDataView;
}


#pragma mark UITableViewDelegate,UITableViewDataSourse
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDTaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:@"WDTaskCell"];
    WDTaskModel *model = _dataArray[indexPath.row];
    taskCell.taskModel = model;
    //收藏
    taskCell.taskType = TaskTypeCollection;
    taskCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return taskCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
//点击选中进入详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //使用URL的方式
    WDTaskModel *taskModel = _dataArray[indexPath.row];
    [self prepareDataDetail:taskModel.taskId];
}
//点击进入详情页面
- (void)prepareDataDetail:(NSString *)taskId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:taskId forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kTaskDetailUrl setParameters:param success:^(id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        WDTaskDetailModel *taskDetailModel = [[WDTaskDetailModel alloc] initWithDictionary:dict error:nil];
        WDTaskDetailViewController *detailController = [WDTaskDetailViewController new];
        [detailController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailController animated:YES];
         detailController.taskDetailModel = taskDetailModel;
    } fail:^(NSError *error) {
    } delegater:self.view];
}

//左滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    YYLog(@"删除cell");
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //        productBeanModel *beanModel = [self.dataArray[indexPath.row] productBean];
        WDTaskModel *taskModel = self.dataArray[indexPath.row];
        //取消收藏
        [self cancelCollectionWithProductId:taskModel.taskId TableView:tableView IndexPath:indexPath];
    }
}

#pragma mark --- 取消收藏

- (void)cancelCollectionWithProductId:(NSString *)productId TableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"mi":mi,
                          @"type":@"2",
                          @"productId":productId
                          };
    [WDNetworkClient postRequestWithBaseUrl:kCancelMemberCollectionUrl setParameters:dic success:^(id responseObject) {
        NSString *code = responseObject[@"result"][@"code"];
        NSString *msg = responseObject[@"result"][@"msg"];
        if ([code isEqualToString:@"1000"]) {
            //删除本地数据
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [ToolClass showAlertWithMessage:@"取消收藏成功"];
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        [ToolClass showAlertWithMessage:@"请求失败"];
    } delegater:self.view];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}


@end
