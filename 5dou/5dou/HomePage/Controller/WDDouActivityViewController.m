
//
//  WDDouActivityViewController.m
//  5dou
//
//  Created by rdyx on 16/11/23.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDDouActivityViewController.h"
#import "WDDouActivityCell.h"
#import "MJRefresh.h"
#import "MJRefreshGifHeader+Ext.h"
#import "WDActivityModel.h"
#import "WDActivityDetailController.h"
#import "ToolClass.h"
#import "WDAbout5douViewController.h"
#import "WDAboutPlatformViewController.h"
@interface WDDouActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
     BOOL _isRefresh;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger currentPage;

@end
static NSString *cellIdentifier = @"cellIdentifier";

@implementation WDDouActivityViewController
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:0];
        _tableView.delegate = self;
        _tableView.backgroundColor = kClearColor;
        _tableView.dataSource = self;
        _tableView.rowHeight = 180.f;
        _tableView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_tableView registerClass:[WDDouActivityCell class] forCellReuseIdentifier:cellIdentifier];
        WeakStament(wself);
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
    [MobClick beginLogPageView:@"逗活动"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"逗活动"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"逗活动" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [_tableView.mj_header beginRefreshing];
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
    [WDNetworkClient postRequestWithBaseUrl:kActivityList setParameters:para success:^(id responseObject) {
        if (responseObject) {
            YYLog(@"%@",responseObject);
            NSDictionary *result = responseObject[@"result"];
            NSString *code = result[@"code"];
            
            if ([code isEqualToString:@"1000"]){
                NSArray *array =(NSArray *) responseObject[@"data"];
                //刷新cai清空数组
                if (_currentPage==0) {
                    [self.dataArray removeAllObjects];
                }
                
                for (NSDictionary *subDic in array) {
                    WDActivityModel *model = [WDActivityModel new];
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
            }else{
                [ToolClass showAlertWithMessage:result[@"msg"]];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
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
    //cell复用数据重复
    static NSString *cellId = @"ACT";
    WDDouActivityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[WDDouActivityCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
       if (self.dataArray.count>indexPath.row) {
        WDActivityModel *model = self.dataArray[indexPath.row];
        [cell configData:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDActivityModel *activityModel = self.dataArray[indexPath.row];
    
    if (activityModel.activityUrl.length>2) {
        
        WDAboutPlatformViewController *about = [WDAboutPlatformViewController new];
        about.productUrl = activityModel.activityUrl;
        if (activityModel.withHead==1) {
            about.withHead = YES;
        }else{
            about.withHead = false;
        }
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
        
    }else{
        WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
        activityDetailController.requestType =  ReuqestTypeActivity;
        activityDetailController.activityID = activityModel.activityID;
        activityDetailController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityDetailController animated:YES];
    }
}

@end
