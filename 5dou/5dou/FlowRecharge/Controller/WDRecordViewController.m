//
//  WDRecordViewController.m
//  5dou
//
//  Created by 黄新 on 16/12/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值记录 
//
//

#import "WDRecordViewController.h"
#import "WDRecordCell.h"
#import "WDContactServiceView.h"
#import "ToolClass.h"
#import "WDFlowOrderListModel.h"
#import "WDNoneData.h"
#import "WDOrderDetailViewController.h"
#import "MJRefresh.h"
#import "MJRefreshGifHeader+Ext.h"
#import "WDDefaultAccount.h"

@interface WDRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *recordTableView;///< 充值记录
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *corverView;///< 蒙层
@property (nonatomic, strong) WDContactServiceView *contactServiceView;///< 联系客服

@property (nonatomic, strong) WDNoneData *noDataView;///< 没有数据的时候

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) WDFlowOrderListModel *listModel;


@end

@implementation WDRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"充值记录" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 35, 35) title:@"客服" Image:nil selectedIMG:nil tartget:self action:@selector(contactService:)];
    [self initUI];
    self.dataArray = [NSMutableArray array];
//    [self refreshData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)initUI{
    [self.view addSubview:self.recordTableView];
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
#pragma mark ====== 客服
- (void)contactService:(UIButton *)sender{
    [self.view addSubview:self.corverView];
    [self.corverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.corverView addSubview:self.contactServiceView];
    [self.contactServiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(250);
        make.center.mas_equalTo(self.corverView);
    }];
}


#pragma mark ====== 请求充值列表
- (void)requestOrderListPage:(NSInteger)page{
    WeakStament(wself);
    NSDictionary *param = @{@"pageInfo.pageSize":@"15",
                            @"pageInfo.toPage":[NSString stringWithFormat:@"%ld",page]
                            };
    [WDNetworkClient postRequestWithBaseUrl:kFlowOrderList setParameters:param success:^(id responseObject) {
        WDFlowOrderListModel *model = [[WDFlowOrderListModel alloc] initWithDictionary:responseObject error:nil];
        self.listModel = model;
        if ([model.result.code isEqualToString:@"1000"]) {
            for (WDFlowDataListModel *item in model.data.list) {
                [wself.dataArray addObject:item];
            }
            [wself.recordTableView reloadData];
            wself.noDataView.alpha = 0;
        }
        else if ([model.result.code isEqualToString:@"1002"]){
            wself.noDataView.alpha = 1;
        }
        else{
            wself.noDataView.alpha = 1;
            [ToolClass showAlertWithMessage:model.result.msg];
        }
        [wself.recordTableView.mj_header endRefreshing];
        [wself.recordTableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [ToolClass showAlertWithMessage:@"网络请求失败"];
        [wself.recordTableView.mj_header endRefreshing];
        [wself.recordTableView.mj_footer endRefreshing];
    } delegater:self.view];
}

#pragma mark ===== 向客服提交反馈信息
- (void)submitFeedback{
    WeakStament(wself);
    NSString *feedbackString = @"";
    if ([self.contactServiceView.feedbackTextView hasText]) {
        feedbackString = self.contactServiceView.feedbackTextView.text;
    }else{
        [ToolClass showAlertWithMessage:@"请输入反馈信息"];
        return;
    }
    NSDictionary *param = @{
                            @"type":@"1",
                            @"description":feedbackString
                            };
    [WDNetworkClient postRequestWithBaseUrl:KFeedBackUrl setParameters:param success:^(id responseObject) {
        NSDictionary *result = responseObject[@"result"];
        if ([result[@"code"] isEqualToString:@"1000"]) {
            [wself.corverView removeFromSuperview];
            wself.corverView = nil;
            [ToolClass showAlertWithMessage:@"提交成功"];
        }else{
            [ToolClass showAlertWithMessage:@"提交失败"];
        }
        
    } fail:^(NSError *error) {
        [ToolClass showAlertWithMessage:@"网络请求失败"];
    } delegater:self.view];
}

#pragma mark ==== 刷新数据
///刷新数据
- (void)refreshData{
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self requestOrderListPage:self.page];
}
#pragma mark ==== 加载更多数据
/**
 *加载更多数据
 */
- (void)loadMoreData{
    self.page++;
    [self requestOrderListPage:self.page];
}


#pragma mark ========== TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"recordCell";
    WDRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WDRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.dataArray.count) {
        [cell config:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WDOrderDetailViewController *orderDetailVC = [[WDOrderDetailViewController alloc] init];
    orderDetailVC.orderModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark ========== 懒加载
- (UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.rowHeight = 100;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recordTableView.backgroundColor = kBackgroundColor;
        WeakStament(wself);
        //无动画刷新
//        _recordTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            [wself refreshData];
//        }];
        //有动画刷新
        _recordTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [wself refreshData];
        }];
        [MJRefreshGifHeader initGifImage:self.recordTableView.mj_header];
        
        _recordTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (wself.listModel.pageInfo.totalPage > self.page+1) {
               [wself loadMoreData];
            }else{
                [wself.recordTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _recordTableView;
}

- (WDContactServiceView *)contactServiceView{
    if (!_contactServiceView) {
        _contactServiceView = [[WDContactServiceView alloc] init];
        _contactServiceView.layer.masksToBounds = YES;
        _contactServiceView.layer.cornerRadius = 5;;
        WeakStament(wself);
        //取消反馈
        _contactServiceView.cancelBtnDidClickBlock = ^(){
            [wself.corverView removeFromSuperview];
            wself.corverView = nil;
        };
        //提交反馈信息
        _contactServiceView.sendBtnDidClickBlock = ^(){
            [wself submitFeedback];
        };
    }
    return _contactServiceView;
}

- (UIView *)corverView{
    if (!_corverView) {
//        UIView *bgView = [[UIView alloc] init];
        _corverView = [[UIView alloc] init];
//        _corverView.backgroundColor = WDColorFrom16RGB(0x0e0e0e);
        _corverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    return _corverView;
}

- (WDNoneData *)noDataView{
    if (!_noDataView) {
        _noDataView = [WDNoneData view];
        _noDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _noDataView.alpha = 0;
        WeakStament(weakSelf);
        _noDataView.noneDataBlock = ^(){
            [weakSelf refreshData];
        };
    }
    return _noDataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
