

//
//  WDTaskViewController.m
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskViewController.h"
#import "WDUserInfoModel.h"
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
#import "WDNoneData.h"
#import "WDDefaultAccount.h"


#import "WDTaskSearchKeyController.h"


#import "WDTaskDetailViewController.h"

#import "MJRefreshGifHeader+Ext.h"

#import "WDCommanData.h"
@interface WDTaskViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
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
 *  筛选列表
 */
@property (nonatomic,strong) WDTaskFilterView *taskFilterView;
/**
 *  没有数据的页面
 */
@property (nonatomic,strong) WDNoneData *noDataView;
@property (nonatomic,strong) WDTaskTabControl *taskTabControl;
@property (nonatomic,strong) WDTaskRequestModel *taskReqeustModel;
@property (nonatomic,strong) NSMutableDictionary *requestDict;
@property(nonatomic,strong)UIView *searchBarView;
@property(nonatomic,strong)WDCustomSearchBar *searchBar;


//@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,strong) NSArray *kindArray;
@property (nonatomic,strong) NSArray *sortArray;
@end

@implementation WDTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    [self prepareData:[self createReqWithtoPage:0]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTabBarHidden:NO];
     [MobClick beginLogPageView:self.navigationItem.title];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navigationItem.title];
}

- (void)prepareUI{
    [self.navigationItem setItemWithTitle:@"任务" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
    self.navigationItem.leftBarButtonItem = nil;
    _taskListArray = [NSMutableArray array];
    _requestDict = [NSMutableDictionary dictionary];
    [self.view addSubview:self.taskTabControl];
    [self.view addSubview:self.taskListTableView];
    [self.view addSubview:self.noDataView];
    [self setNavigationSearchBar];
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 29, 29) title:nil Image:@"search" selectedIMG:nil tartget:self action:@selector(searchBtnPress:)];
    
}


-(void)setNavigationSearchBar
{
    self.searchBarView = [ToolClass getSearchBarWithPlaceholder:@"欢迎来到吾逗" hasLeftButton:NO];
    self.searchBar = [self.searchBarView viewWithTag:kSearchBarTag];
    self.searchBar.delegate = self;
    //self.navigationItem.titleView = self.searchBarView;
}


- (void)prepareData:(NSMutableDictionary *)requestDict  {
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kTaskList setParameters:requestDict success:^(id responseObject) {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        //如果有数据的情况下
        if ([requestDict[@"pageInfo.toPage"] intValue] == 0) {
            [weakSelf.taskListArray removeAllObjects];
            [weakSelf.taskListTableView setContentOffset:CGPointMake(0, 0)];
            [weakSelf.taskListTableView.mj_header endRefreshing];
        }
        if (newArray.count != 0) {
            for(NSDictionary *taskDict in newArray){
                WDTaskModel *model = [[WDTaskModel alloc] init];
                [model setValuesForKeysWithDictionary:taskDict];
                [weakSelf.taskListArray addObject:model];
            }
            [weakSelf.taskListTableView.mj_footer endRefreshing];
        }else{
            [weakSelf.taskListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_taskListArray.count == 0) {
            _noDataView.alpha = 1;
        }else{
            _noDataView.alpha = 0;
        }
        [weakSelf.taskListTableView reloadData];
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
        _taskListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 64 - 44 - 49) style:UITableViewStylePlain];
        _taskListTableView.delegate = self;
        _taskListTableView.dataSource = self;
        _taskListTableView.rowHeight = 90;
        _taskListTableView.separatorColor = [UIColor clearColor];
        _taskListTableView.backgroundColor = kBackgroundColor;
        [_taskListTableView registerNib:[UINib nibWithNibName:@"WDTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WDTaskCell"];
        _taskListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf prepareData:[self createReqWithtoPage:0]];
        }];
        [MJRefreshGifHeader initGifImage:_taskListTableView.mj_header];
        _taskListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //还有信息
            if (weakSelf.taskListArray.count % pageSize == 0) {
                NSInteger toPage = weakSelf.taskListArray.count / pageSize;
                [weakSelf prepareData:[self createReqWithtoPage:toPage]];
            }else{
                [weakSelf.taskListTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }];
    }
    return _taskListTableView;
}

- (WDTaskTabControl *)taskTabControl{
    
    if (!_taskTabControl) {

            _kindArray = @[@"全部分类",
                           @"应用试客",
                           @"观影体验",
                           @"市场调研",
                           @"营销推广"];

        _taskTabControl = [WDTaskTabControl view];
        WeakStament(weakSelf);
        _taskTabControl.controlBlock = ^(TaskFilterType type){
            if (type == TaskFilterKind) {
                [weakSelf.view addSubview:weakSelf.taskFilterView];
                weakSelf.taskFilterView.taskFilterType = TaskFilterKind;
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.taskFilterView.alpha = 1;
                }];
            }else if(type == TaskFilterTypeSort){
                [weakSelf.view addSubview:weakSelf.taskFilterView];
                weakSelf.taskFilterView.taskFilterType = TaskFilterTypeSort;
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.taskFilterView.alpha = 1;
                }];
                
            }else if(type == TaskFilterRemove){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.taskFilterView.alpha = 0;
                } completion:^(BOOL finished) {
                }];
            }
        };
    }
    _taskTabControl.frame = CGRectMake(0, 0, ScreenWidth, 44);
    return _taskTabControl;
}
//WDTaskFilterView
- (WDTaskFilterView *)taskFilterView{
    if (!_taskFilterView) {
        _sortArray = @[@"智能排序",
                       @"酬劳最高",
                       @"最新发布",
                       @"优质推荐",
                       @"最快结算",
                       @"最火任务"];
        WeakStament(weakSelf);
        _taskFilterView = [[WDTaskFilterView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth,ScreenHeight - 49)];
        _taskFilterView.alpha = 0;
        _taskFilterView.taskFilterBlock = ^(NSInteger option,TaskFilterType taskFilterType){
            //全部分类
            if (taskFilterType == TaskFilterRemove) {
                weakSelf.taskFilterView.alpha = 0;
                [weakSelf.taskTabControl closeFilterView];
                return;
            }else if (taskFilterType == TaskFilterKind) {
                [weakSelf.taskTabControl.kindButton setTitle:weakSelf.kindArray[option] forState:UIControlStateNormal];
                weakSelf.taskReqeustModel.queryCategory = [NSNumber numberWithInteger:option];
                [weakSelf.taskTabControl buttonClick:TaskFilterKind];
            }else if(taskFilterType == TaskFilterTypeSort){
                [weakSelf.taskTabControl.sortButton setTitle:weakSelf.sortArray[option] forState:UIControlStateNormal];
                weakSelf.taskReqeustModel.queryOrderType = [NSNumber numberWithInteger:option];
                [weakSelf.taskTabControl buttonClick:TaskFilterTypeSort];
            }
            
            [weakSelf prepareData:[weakSelf createReqWithtoPage:0]];
            weakSelf.taskFilterView.alpha = 0;
        };
        
    }
    return _taskFilterView;
};


- (void)setQueryCategory:(NSInteger)queryCategory{
    _queryCategory = queryCategory;
    self.taskReqeustModel.queryCategory  = [NSNumber numberWithInteger:queryCategory];
    //进行刷新
    [self prepareData:[self createReqWithtoPage:0]];
    [self.taskTabControl.kindButton setTitle:_kindArray[queryCategory] forState:UIControlStateNormal];
    //进行修改标题
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
        _noDataView.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44);
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
    WDTaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:@"WDTaskCell"];
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


/**
  在当前页面拿到下个页面的数据，直接将对应的数据模型传到详情页面，优化下个页面的用户体验
 */
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

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.view addSubview:self.taskTabControl];
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self goSearchKeyController];
    return NO;
}

- (void)searchBtnPress:(UIButton *)button{
    self.taskFilterView.alpha = 0;
    [self.taskTabControl closeFilterView];
    [self goSearchKeyController];
}

- (void)goSearchKeyController{
    WeakStament(weakSelf);
    WDTaskSearchKeyController *searchKeyController = [[WDTaskSearchKeyController alloc] init];
    searchKeyController.filterKeyChange = ^(NSString *key){
        [weakSelf taskListResetWithKey:key];
        
    };
    searchKeyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchKeyController animated:YES];
}

- (void)taskListResetWithKey:(NSString *)key{
    if ([key isEqualToString:@"全部"] || [key isEqualToString:@""]) {
        key = @"";
        self.taskReqeustModel.queryCategory = @0;
        self.taskReqeustModel.queryOrderType = @0;
        self.taskReqeustModel.queryOrderSort = @1;
        self.taskReqeustModel.queryAppType = @2;
        [self.taskTabControl.kindButton setTitle:self.kindArray[0] forState:UIControlStateNormal];
        [self.taskTabControl.sortButton setTitle:self.sortArray[0] forState:UIControlStateNormal];
        self.searchBar.text = @"";
        self.navigationItem.titleView = nil;
        [self.navigationItem setItemWithTitle:@"任务" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
    }else{
        self.searchBar.text = key;
        self.navigationItem.titleView = self.searchBarView;
    }
    self.taskReqeustModel.keyword = key;
    [self prepareData:[self createReqWithtoPage:0]];
}


#pragma mark 显示
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    
    if ([tab.subviews count] < 2) {
        return;
    }
    UIView *view;
    
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
    }
    self.view.frame = view.frame;
    self.tabBarController.tabBar.hidden = hidden;
}

@end
