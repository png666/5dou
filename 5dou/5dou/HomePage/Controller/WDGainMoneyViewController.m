


//
//  WDGainMoneyViewController.m
//  5dou
//
//  Created by rdyx on 16/11/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDGainMoneyViewController.h"
#import "WDTaskDescribeCell.h"
#import "WDGainMoneyCell.h"
#import "MJRefresh.h"
#import "MJRefreshGifHeader+Ext.h"
@interface WDGainMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger currentPage;

@end

static NSString *cellId = @"gainMoney";

@implementation WDGainMoneyViewController

-(UITableView *)table
{
    if (!_table) {
        
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = false;
        [_table registerClass:[WDGainMoneyCell class] forCellReuseIdentifier:cellId];
        _table.rowHeight = 90;
        WeakStament(wself);
        _table.mj_header = [MJRefreshGifHeader
                                headerWithRefreshingBlock:^{
                                    [wself refreshData];
                                }];
        [MJRefreshGifHeader initGifImage:_table.mj_header];
        
        _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [wself loadMoreData];
        }];
        
    }
    return _table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"去赚钱" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    _currentPage = 0;
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)refreshData
{
    _currentPage = 0;
    [self loadData];
}

-(void)loadMoreData
{
    _currentPage++;
    [self loadData];
}

-(void)loadData
{
    NSDictionary *para = @{@"queryCategory":@0,@"queryOrderType":@0,@"queryOrderSort":@1,@"cityCode":@0,@"queryHot":@0,@"queryAppType":@2,@"keyword":@"",@"pageInfo.pageSize":@15,@"pageInfo.toPage":@(_currentPage)};
    [WDNetworkClient postRequestWithBaseUrl:kTaskList setParameters:para success:^(id responseObject) {
        if (responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSString *code = dic[@"result"][@"code"];
            if ([code isEqualToString:@"1000"]) {
                NSArray *ListArray =(NSArray *) responseObject[@"data"];
                
                //刷新每次需要都是新数据
                if (_currentPage==0) {
                     [self.dataArray removeAllObjects];
                }
               
                for (NSDictionary *subDic in ListArray) {
                    WDTaskModel *model = [WDTaskModel new];
                    [model setValuesForKeysWithDictionary:subDic];
                    [self.dataArray addObject:model];
                }
                [_table reloadData];
                [_table.mj_header endRefreshing];
                [_table.mj_footer endRefreshing];
                
            }else  if ([code isEqualToString:@"1002"]) {
                //1002服务端标识码没有更多数据
                [_table reloadData];
                [_table.mj_footer endRefreshingWithNoMoreData];
            }

        }
    } fail:^(NSError *error) {
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
    } delegater:self.view];

}

-(void)refresh
{
    
}
-(void)loadMore
{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDGainMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (self.dataArray.count>indexPath.row) {
        WDTaskModel *model = self.dataArray[indexPath.row];
        cell.taskModel = model;
    }

    return cell;
}

#pragma mark - delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDTaskModel *taskModel = self.dataArray[indexPath.row];
    [self prepareDataDetail:taskModel.taskId];
}

-(void)dealloc
{
    YYLog(@"你好,测试******");  
}


@end
