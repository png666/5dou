//
//  WDDoubiRanking.m
//  5dou
//
//  Created by 黄新 on 16/11/25.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  逗币排行榜 没有使用现在使用的是H5
//

#import "WDDoubiRankingView.h"
#import "WDRankingCell.h"
#import "MJRefresh.h"
#import "WDRankingModel.h"
#import "WDNetworkClient.h"
#import "ToolClass.h"
#import "WDNoData.h"

@interface WDDoubiRankingView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *rankingTable;///< 好友收益
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int pageSize;

@property (nonatomic, strong) WDNoData *noDataView;///< 无数据时展示

@end

@implementation WDDoubiRankingView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
        [self refreshData];
    }
    return self;
}

- (void)initUI{
    self.dataArray = [NSMutableArray array];
    [self addSubview:self.rankingTable];
    [self.rankingTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark ======== TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"rankingCell";
    WDRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WDRankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    RankingDataModel *model = self.dataArray[indexPath.row];
//    [cell configWithModel:model IndexPath:indexPath];
    return cell;
}
#pragma mark ========== 刷新数据
/**
 刷新财富榜数据
 */
- (void)refreshData{
    self.pageSize = 0;
    [self.dataArray removeAllObjects];
    [self requestWealthDataTopage:self.pageSize];
}
- (void)loadMoreData{
    self.pageSize++;
    [self requestWealthDataTopage:self.pageSize];
}
#pragma mark ========== 数据请求
- (void)requestWealthDataTopage:(int )toPage{
    NSDictionary *dic = @{@"type":@"0",
                          @"pageInfo.pageSize":@"15",
                          @"pageInfo.toPage":[NSString stringWithFormat:@"%d",toPage]
                          };
    WeakStament(weakSelf);
    
    [WDNetworkClient postRequestWithBaseUrl:kGetMemberRank setParameters:dic success:^(id responseObject) {
        WDRankingModel *rankingModel = [[WDRankingModel alloc] initWithDictionary:responseObject error:nil];
        if ([rankingModel.result.code isEqualToString:@"1000"]) {
            
            for (RankingDataModel *item in rankingModel.data) {
                [weakSelf.dataArray addObject:item];
            }
            [weakSelf.rankingTable reloadData];
            
        }else if ([rankingModel.result.code isEqualToString:@"1002"]){
            
        }else{
            [ToolClass showAlertWithMessage:rankingModel.result.msg];
        }
        if (weakSelf.dataArray) {
            weakSelf.noDataView.alpha = 0;
        }else{
            weakSelf.noDataView.alpha = 1;
        }
        
        [weakSelf.rankingTable.mj_header endRefreshing];
        [weakSelf.rankingTable.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [weakSelf.rankingTable.mj_header endRefreshing];
        [weakSelf.rankingTable.mj_footer endRefreshing];
    } delegater:self];
}

#pragma mark ====== 无数据是点击邀请好友

- (void)inviteFriend{
    [ToolClass showAlertWithMessage:@"邀请好友"];
}

#pragma mark =======

- (UITableView *)rankingTable{
    if (!_rankingTable) {
        _rankingTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _rankingTable.delegate = self;
        _rankingTable.dataSource = self;
        _rankingTable.rowHeight = 40;
        _rankingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rankingTable.layer.cornerRadius = 8;
        _rankingTable.layer.masksToBounds = YES;
    
        [_rankingTable  setScrollEnabled:YES];
        //带GIF刷新
        WeakStament(wself);
        //        _wealthTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //            [wself refreshData];
        //        }];
        //        [MJRefreshGifHeader initGifImage:_messageTableView.mj_header];
        
        _rankingTable.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [wself refreshData];
        }];
        _rankingTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //还有信息
            if (wself.dataArray.count % 15 == 0
                &&wself.dataArray.count != 0) {
                [wself loadMoreData];
            }else{
                [wself.rankingTable.mj_footer endRefreshingWithNoMoreData];
            }
            
        }];
    }
    return _rankingTable;
}

- (WDNoData *)noDataView{
    if (!_noDataView) {
        _noDataView = [WDNoData view];
        _noDataView.alpha = 0;
        [_noDataView.goMakeMoneyBtn addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
        [_noDataView setImage:[UIImage imageNamed:@"invitation_empty"]
                     withInfo:@"空空如也，快去邀友取金！"
                      withBtn:@"邀请好友"];
        _noDataView.goMakeMoneyBtn.layer.cornerRadius = 15;
        _noDataView.goMakeMoneyBtn.layer.masksToBounds = YES;
        _noDataView.goMakeMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_noDataView.goMakeMoneyBtn setTitleColor:WDColorFrom16RGB(0xfdbb00) forState:UIControlStateNormal];
        _noDataView.goMakeMoneyBtn.layer.borderColor = WDColorFrom16RGB(0xfdbb00).CGColor;
        _noDataView.goMakeMoneyBtn.layer.borderWidth = 1.f;
    }

    return _noDataView;
}





@end
