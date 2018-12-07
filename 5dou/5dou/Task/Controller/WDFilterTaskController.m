

//
//  WDTaskViewController.m
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDFilterTaskController.h"

#import "MJRefresh.h"
#define pageSize 15
#define kSearchBarTag 201

#import "WDTaskCell.h"
#import "WDTaskModel.h"
#import "WDTaskRequestModel.h"
#import "WDTaskFilterView.h"
#import "WDTaskTabControl.h"
#import "WDTaskDetailViewController.h"
#import "ToolClass.h"
#import "UIColor+Hex.h"
#import "UITableViewCell+Ext.h"
#import "WDNoneData.h"
#import "WDDefaultAccount.h"
#import "ToolClass.h"


#import "WDTaskSearchKeyController.h"

#import "WDCommanData.h"
#import "WDUserInfoModel.h"
#import "WDTaskDetailModel.h"
@interface WDFilterTaskController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
}
/**
 *  任务列表
 */
@property (nonatomic,strong) UITableView *taskListTableView;
/**
 *  存储任务信息
 */
@property (nonatomic,strong) NSMutableArray *taskListArray;

/**
 *  没有数据的页面
 */
@property (nonatomic,strong) WDNoneData *noDataView;
@property (nonatomic,strong) WDTaskRequestModel *taskReqeustModel;
@property (nonatomic,strong) NSMutableDictionary *requestDict;
@property(nonatomic,strong)UIView *searchBarView;
@property(nonatomic,strong)WDCustomSearchBar *searchBar;

@end

@implementation WDFilterTaskController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    [self prepareData:[self createReqWithtoPage:0]];
    // Do any additional setup after loading the view.
}

- (void)prepareUI{
    _taskListArray = [NSMutableArray array];
    _requestDict = [NSMutableDictionary dictionary];
    [self.view addSubview:self.taskListTableView];
    [self.view addSubview:self.noDataView];
    [self setNavigationSearchBar];    
}


-(void)setNavigationSearchBar
{
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 49, 49) title:@"确认" Image:nil selectedIMG:nil tartget:self action:@selector(confirmBtnPress:)];
    self.searchBarView = [ToolClass getSearchBarWithPlaceholder:@"欢迎来到吾逗" hasLeftButton:YES];
    self.searchBar = [self.searchBarView viewWithTag:kSearchBarTag];
    self.searchBar.delegate = self;
    self.searchBar.text = _key;
    self.navigationItem.titleView = self.searchBarView;
}


- (void)prepareData:(NSMutableDictionary *)requestDict  {
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kTaskList setParameters:requestDict success:^(id responseObject) {
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        //如果有数据的情况下
        if ([requestDict[@"pageInfo.toPage"] intValue] == 0) {
            [self.taskListArray removeAllObjects];
            [self.taskListTableView setContentOffset:CGPointMake(0, 0)];
            [self.taskListTableView.mj_header endRefreshing];
        }
        if (newArray.count != 0) {
            for(NSDictionary *taskDict in newArray){
                WDTaskModel *model = [[WDTaskModel alloc] init];
                [model setValuesForKeysWithDictionary:taskDict];
                [weakSelf.taskListArray addObject:model];
            }
            [self.taskListTableView.mj_footer endRefreshing];
        }else{
            [self.taskListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.taskListArray.count == 0) {
            self.noDataView.alpha = 1;
        }else{
            self.noDataView.alpha = 0;
        }
        [self.taskListTableView reloadData];
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)taskListTableView{
    if (!_taskListTableView) {
        WeakStament(weakSelf);
        _taskListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _taskListTableView.delegate = self;
        _taskListTableView.dataSource = self;
        _taskListTableView.rowHeight = 90;
        _taskListTableView.separatorColor = [UIColor clearColor];
        _taskListTableView.backgroundColor = kBackgroundColor;

        _taskListTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf prepareData:[weakSelf createReqWithtoPage:0]];
        }];
        _taskListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //还有信息
            if (weakSelf.taskListArray.count % pageSize == 0) {
                NSInteger toPage = weakSelf.taskListArray.count / pageSize;
                [weakSelf prepareData:[weakSelf createReqWithtoPage:toPage]];
            }else{
                [weakSelf.taskListTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _taskListTableView;
}



//网络请求类 设置公共的参数
- (WDTaskRequestModel *)taskReqeustModel{
    if (!_taskReqeustModel) {
        _taskReqeustModel = [[WDTaskRequestModel alloc] init];
        _taskReqeustModel.queryCategory = @0;
        _taskReqeustModel.queryOrderType = @0;
        _taskReqeustModel.queryOrderSort = @0;
        _taskReqeustModel.queryAppType = @2;
    }
    _taskReqeustModel.keyword = self.key;
    if ([WDDefaultAccount cityId]) {
        _taskReqeustModel.cityCode = [WDDefaultAccount cityId];
    }else{
        //如果没有 默认上海
        _taskReqeustModel.cityCode = @"310";
    }
    return _taskReqeustModel;
}


- (WDNoneData *)noDataView{
    if (!_noDataView) {
        _noDataView = [WDNoneData view];
        _noDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _noDataView.alpha = 0;
        WeakStament(weakSelf);
        _noDataView.noneDataBlock = ^(){
            [weakSelf createReqWithtoPage:0];
        };
    }
    return _noDataView;
}

- (NSMutableDictionary *)createReqWithtoPage:(NSInteger)toPage{
    _requestDict = [NSMutableDictionary dictionaryWithDictionary:[self.taskReqeustModel toDictionary]];
    [_requestDict setObject:@pageSize forKey:@"pageInfo.pageSize"];
    [_requestDict setObject:[NSNumber numberWithInteger:toPage] forKey:@"pageInfo.toPage"];
    return _requestDict;
}


#pragma mark UITableViewDelegate,UITableViewDataSourse
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDTaskCell *taskCell = [WDTaskCell cellWithTableView:tableView];
    WDTaskModel *taskModel = _taskListArray[indexPath.row];
    taskCell.taskModel = taskModel;
    taskCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return taskCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskListArray.count;
}


//点击选中进入详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WDTaskModel *taskModel = _taskListArray[indexPath.row];
    [self prepareDataDetail:taskModel.taskId];

}

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

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}


#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBtnPress:(UIButton *)button{
    
    [MobClick event:@"search"];
    _key = self.searchBar.text;
    //去除左右空格
    _key = [_key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([_key isEqualToString:@""]) {
        [ToolClass showAlertWithMessage:@"搜索内容不能为空"];
        return ;
    }
    [self prepareData:[self createReqWithtoPage:0]];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _key = self.searchBar.text;
    _key = [_key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [_searchBar endEditing:YES];
    if ([_key isEqualToString:@""]) {
        [ToolClass showAlertWithMessage:@"搜索内容不能为空"];
        return ;
    }
    [self prepareData:[self createReqWithtoPage:0]];}

- (void)confirmBtnPress:(UIButton *)button{
    _key = self.searchBar.text;
    _key = [_key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [_searchBar endEditing:YES];
    if ([_key isEqualToString:@""]) {
        [ToolClass showAlertWithMessage:@"搜索内容不能为空"];
        return ;
    }
    [self prepareData:[self createReqWithtoPage:0]];
}

@end
