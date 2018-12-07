

//
//  WDSchoolNewsViewController.m
//  5dou
//
//  Created by rdyx on 16/9/1.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//  校园干活列表

#import "WDSchoolNewsViewController.h"
#import "WDSchoolNewsModel.h"
#import "WDFunnyNewsCell.h"
#import "WDActivityDetailController.h"
#import "MJRefresh.h"
#import "MJRefreshGifHeader+Ext.h"
#import "ToolClass.h"
#import "UITableViewCell+Ext.h"
@interface WDSchoolNewsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL _isRefresh;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger currentPage;

@end
static NSString *schoolNewsId = @"schoolNewsId";
@implementation WDSchoolNewsViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:0];
        _tableView.delegate = self;
        _tableView.backgroundColor = kClearColor;
        _tableView.dataSource = self;
        _tableView.rowHeight = 225.f;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        [_tableView registerClass:[WDShoolNewsCell class] forCellReuseIdentifier:schoolNewsId];
        WeakStament(wself);
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [wself refreshData];
//        }];
        
        //这个是
        _tableView.mj_header = [MJRefreshGifHeader
                                headerWithRefreshingBlock:^{
            [wself refreshData];
        }];
        [MJRefreshGifHeader initGifImage:_tableView.mj_header];

        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [wself loadMoreData];
        }];
        
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      [MobClick beginLogPageView:@"逗新闻"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"逗新闻"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    //    self.view.backgroundColor = kCyanColor;
    [self.navigationItem setItemWithTitle:@"逗新闻" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self.view addSubview:self.tableView];
    //    [self loadData];
    [_tableView.mj_header beginRefreshing];
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
    NSDictionary *para = @{@"pageInfo.pageSize":@15,@"pageInfo.toPage":@(_currentPage)};
    [WDNetworkClient postRequestWithBaseUrl:kSchoolNewsUrl setParameters:para success:^(id responseObject) {
        if (responseObject) {
            _isRefresh = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isRefresh = NO;
            });
            NSDictionary *result = responseObject[@"result"];
            NSString *code = result[@"code"];
            
            if ([code isEqualToString:@"1000"]){
                NSArray *array =(NSArray *) responseObject[@"data"];
                
                //只有刷新才清空数组
                if (_currentPage==0) {
                    [self.dataArray removeAllObjects];
                }
                
                for (NSDictionary *subDic in array) {
                    WDSchoolNewsModel *model = [WDSchoolNewsModel new];
                    [model setValuesForKeysWithDictionary:subDic];
                    [self.dataArray addObject:model];
                }
                [_tableView reloadData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                
            }else  if ([code isEqualToString:@"1002"]) {
                
                //1002服务端标识码没有更多数据
                [_tableView reloadData];
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }

        }
        
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } delegater:self.view];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDFunnyNewsCell *cell = [WDFunnyNewsCell cellWithTableView:tableView];
    if (self.dataArray.count>indexPath.row) {
    
    WDSchoolNewsModel *model = self.dataArray[indexPath.row];
    [cell configData:model];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //只有在没有数据请求的时候，才进行动画的展示
//    if (!_isRefresh) {
//        [ToolClass animateWithCell:cell];
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDActivityDetailController *schoolActivity = [[WDActivityDetailController alloc] init];
    WDSchoolNewsModel *model = self.dataArray[indexPath.row];
    schoolActivity.activityID = [model.newsId stringValue];
    schoolActivity.requestType = RequestTypeNews;
    [self.navigationController pushViewController:schoolActivity animated:YES];
}
@end
