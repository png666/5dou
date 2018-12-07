//
//  WDRankingViewController.m
//  5dou
//
//  Created by 黄新 on 16/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  排行榜现在已替换成H5
//

#import "WDRankingViewController.h"
#import "WDTitleView.h"
#import "ToolClass.h"
#import "WDRankingModel.h"
#import "WDRankingCell.h"
#import "WDHotRankingModel.h"
#import "MJRefresh.h"

@interface WDRankingViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIImageView *headerImgView;

@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) WDTitleView *wealthTitleView;
@property (nonatomic, strong) WDTitleView *hotTitleView;
@property (nonatomic, strong) UITableView *wealthTableView;
@property (nonatomic, strong) UITableView *hotTableView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat titleViewHeight;

@property (nonatomic, strong) NSMutableArray *wealthArray;
@property (nonatomic, strong) NSMutableArray *hotArray;

@property (nonatomic, assign) int wealthPage;
@property (nonatomic, assign) int hotPage;

@end

@implementation WDRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"月排行榜" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.wealthArray = [[NSMutableArray alloc] init];
    self.hotArray= [[NSMutableArray alloc] init];
    [self initUI];
    [self refreshWealthData];
//    [self refreshHotData];
    
}

- (void)initUI{
    if (device_is_iphone_4|device_is_iphone_5) {
        self.headerViewHeight = 150;
        self.titleViewHeight = 40;
    }else if (device_is_iphone_6){
        self.titleViewHeight = 44;
        self.headerViewHeight = 175;
    }else if (device_is_iphone_6p){
        self.titleViewHeight = 46;
        self.headerViewHeight = 200;
    }
    [self.view addSubview:self.headerImgView];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(self.headerViewHeight);
        make.top.left.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.titleViewHeight);
        make.top.mas_equalTo(self.headerImgView.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(190);
    }];
    [self.titleView addSubview:self.wealthTitleView];
    [self.wealthTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(self.titleView);
        make.width.mas_equalTo(110);
        make.centerX.mas_equalTo(self.titleView).offset(-55);
    }];
    [self.titleView addSubview:self.hotTitleView];
    [self.hotTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.mas_equalTo(self.wealthTitleView);
        make.left.mas_equalTo(self.wealthTitleView.mas_right);
    }];
    [self.view addSubview:self.pageScrollView];
    [self createWealthTableView];
    [self createHotTableView];
    [self.pageScrollView addSubview:self.wealthTableView];
    [self.pageScrollView addSubview:self.hotTableView];
}

- (void)createWealthTableView{
    self.wealthTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, ScreenHeight-self.headerViewHeight-self.titleViewHeight-12-64-10) style:UITableViewStylePlain];
    self.wealthTableView .delegate = self;
    self.wealthTableView .dataSource = self;
    self.wealthTableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    self.wealthTableView .rowHeight = 35;
    self.wealthTableView .layer.cornerRadius = 8;
    self.wealthTableView .layer.masksToBounds = YES;
    [self.wealthTableView  setScrollEnabled:YES];
    //带GIF刷新
    WeakStament(wself);
    //        _wealthTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    //            [wself refreshData];
    //        }];
    //        [MJRefreshGifHeader initGifImage:_messageTableView.mj_header];
    
    self.wealthTableView .mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [wself refreshWealthData];
    }];
    self.wealthTableView .mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //还有信息
        if (wself.wealthArray.count % 15 == 0
            &&wself.wealthArray.count != 0) {
            [wself loadWealthMoreData];
        }else{
            [wself.wealthTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}
- (void)createHotTableView{
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth+10, 0, ScreenWidth-20, ScreenHeight-self.headerViewHeight-self.titleViewHeight-12-64-10) style:UITableViewStylePlain];
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    self.hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hotTableView.rowHeight = 35;
    self.hotTableView.layer.cornerRadius = 8;
    self.hotTableView.layer.masksToBounds = YES;
    [self.hotTableView setScrollEnabled:YES];
    //带GIF刷新
    WeakStament(wself);
    //        _wealthTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    //            [wself refreshData];
    //        }];
    //        [MJRefreshGifHeader initGifImage:_messageTableView.mj_header];
    
    self.hotTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [wself refreshHotData];
    }];
    self.hotTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //还有信息
        if (wself.hotArray.count % 15 == 0
            &&wself.hotArray.count != 0) {
            [wself loadHotMoreData];
        }else{
            [wself.hotTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

- (void)pageButtonClick:(UIButton *)sender{
    if (sender.tag == WealthTitleType) {
        [self refreshWealthData];
        [self.hotTitleView setSelected:NO];
        [self.hotTitleView.imgView setSelected:NO];
        [self.wealthTitleView setSelected:YES];
        [self.wealthTitleView.imgView setSelected:YES];
        [self.pageScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        if (_wealthTitleView.selected) {
            _wealthTitleView.title.textColor = WDColorFrom16RGB(0xfed200);
            _hotTitleView.title.textColor = WDColorFrom16RGB(0xffffff);
        }else{
            _wealthTitleView.title.textColor = WDColorFrom16RGB(0xffffff);
            _hotTitleView.title.textColor = WDColorFrom16RGB(0xfed200);
        }
    }else{
        [self refreshHotData];
        [self.wealthTitleView setSelected:NO];
        [self.wealthTitleView.imgView setSelected:NO];
        [self.hotTitleView setSelected:YES];
        [self.hotTitleView.imgView setSelected:YES];
        [self.pageScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        if (_hotTitleView.selected) {
            _hotTitleView.title.textColor = WDColorFrom16RGB(0xfed200);
            _wealthTitleView.title.textColor = WDColorFrom16RGB(0xffffff);
        }else{
            _hotTitleView.title.textColor = WDColorFrom16RGB(0xffffff);
            _wealthTitleView.title.textColor = WDColorFrom16RGB(0xfed200);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    YYLog(@"%lf",scrollView.contentOffset.x);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    YYLog(@"%lf",scrollView.contentOffset.x);
    if (scrollView == self.pageScrollView) {
        int index = scrollView.contentOffset.x/ScreenWidth;
        if (index == 0) {
            [self pageButtonClick:self.wealthTitleView];
        }else{
            [self pageButtonClick:self.hotTitleView];
        }
    }
}
#pragma mark ========== 刷新数据
/**
 刷新财富榜数据
 */
- (void)refreshWealthData{
    self.wealthPage = 0;
    [self.wealthArray removeAllObjects];
    [self requestWealthDataTopage:self.wealthPage];
}
- (void)refreshHotData{
    self.hotPage = 0;
    [self.hotArray removeAllObjects];
    [self requestHotDataTopage:self.hotPage];
}
/**
 刷新人气榜数据
 */
#pragma mark ========== 加载更多数据
/**
 *财富榜加载更多数据
 */
- (void)loadWealthMoreData{
    self.wealthPage++;
    [self requestWealthDataTopage:self.wealthPage];
}
/**
 *人气榜加载更多数据
 */
- (void)loadHotMoreData{
    self.hotPage++;
    [self requestHotDataTopage:self.hotPage];
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
                [weakSelf.wealthArray addObject:item];
            }
            [weakSelf.wealthTableView reloadData];

        }else if ([rankingModel.result.code isEqualToString:@"1002"]){
            
        }else{
            [ToolClass showAlertWithMessage:rankingModel.result.msg];
        }
        [weakSelf.wealthTableView.mj_header endRefreshing];
        [weakSelf.wealthTableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        [weakSelf.wealthTableView.mj_header endRefreshing];
        [weakSelf.wealthTableView.mj_footer endRefreshing];
    } delegater:self.view];
}

- (void)requestHotDataTopage:(int )toPage{
    NSDictionary *dic = @{@"type":@"1",
                          @"pageInfo.pageSize":@"15",
                          @"pageInfo.toPage":[NSString stringWithFormat:@"%d",toPage]
                          };
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kGetMemberRank setParameters:dic success:^(id responseObject) {
        WDHotRankingModel *model = [[WDHotRankingModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1000"]) {
            
            for (HotRankingDataModel *item in model.data) {
                [weakSelf.hotArray addObject:item];
            }
            [weakSelf.hotTableView reloadData];
        }else if ([model.result.code isEqualToString:@"1002"]){
            
        }else{
            [ToolClass showAlertWithMessage:model.result.msg];
        }
        [weakSelf.hotTableView.mj_header endRefreshing];
        [weakSelf.hotTableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
        [weakSelf.hotTableView.mj_header endRefreshing];
        [weakSelf.hotTableView.mj_footer endRefreshing];
    } delegater:self.view];
}

#pragma mark ====== TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.wealthTableView]) {
        return self.wealthArray.count;
    }else{
        return self.hotArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.wealthTableView]) {
        static NSString *wealthIdentifier = @"wealthRankingCell";
        WDRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:wealthIdentifier];
        if (!cell) {
            cell = [[WDRankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wealthIdentifier];
        }
        cell.isShowInviteImg = NO;
//        RankingDataModel *model = self.wealthArray[indexPath.row];
//        [cell configWithModel:model IndexPath:indexPath];
        return cell;
    }else{
        static NSString *hotIdentifier = @"hotRankingCell";
        WDRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:hotIdentifier];
        if (!cell) {
            cell = [[WDRankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotIdentifier];
        }
//        HotRankingDataModel *model = self.hotArray[indexPath.row];
        cell.isShowInviteImg = YES;
//        [cell configWithHotRankingModel:model IndexPath:indexPath];
        
        return cell;
    }
    
}


#pragma mark ===== 懒加载

- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"ranking_header_banner"];
    }
    return _headerImgView;
}

- (UIScrollView *)pageScrollView{
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerViewHeight+self.titleViewHeight+12, ScreenWidth, ScreenHeight - self.headerViewHeight-self.titleViewHeight - 12)];
        _pageScrollView.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeight-self.headerViewHeight-self.titleViewHeight-12);
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.delegate = self;
        _pageScrollView.bounces = NO;
    }
    return _pageScrollView;
}
- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}
- (WDTitleView *)wealthTitleView{
    if (!_wealthTitleView) {
        _wealthTitleView = [[WDTitleView alloc] init];
        _wealthTitleView.tag = WealthTitleType;
        [_wealthTitleView setSelected:YES];
        [_wealthTitleView.imgView setBackgroundImage:[UIImage imageNamed:@"ranking_wealth_selected_img"] forState:UIControlStateSelected];
        [_wealthTitleView.imgView setBackgroundImage:[UIImage imageNamed:@"ranking_wealth_nor_img"] forState:UIControlStateNormal];
        if (_wealthTitleView.selected) {
            _wealthTitleView.title.textColor = WDColorFrom16RGB(0xfed200);
        }else{
            _wealthTitleView.title.textColor = WDColorFrom16RGB(0xffffff);
        }
        _wealthTitleView.title.text = @"财富榜";
        [_wealthTitleView setBackgroundImage:[UIImage imageNamed:@"button_yellow_left"] forState:UIControlStateNormal];
        [_wealthTitleView setBackgroundImage:[UIImage imageNamed:@"button_tap"] forState:UIControlStateSelected];
        
        [_wealthTitleView addTarget:self action:@selector(pageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _wealthTitleView;
}

- (WDTitleView *)hotTitleView{
    if (!_hotTitleView) {
        _hotTitleView = [[WDTitleView alloc] init];
        [_hotTitleView setSelected:NO];
        [_hotTitleView.imgView setBackgroundImage:[UIImage imageNamed:@"ranking_hot_selected_img"] forState:UIControlStateSelected];
        [_hotTitleView.imgView setBackgroundImage:[UIImage imageNamed:@"ranking_hot_nor_img"] forState:UIControlStateNormal];
        [_hotTitleView setBackgroundImage:[UIImage imageNamed:@"button_yellow_right"] forState:UIControlStateNormal];
        [_hotTitleView setBackgroundImage:[UIImage imageNamed:@"button_tap"] forState:UIControlStateSelected];
        _hotTitleView.title.text = @"人气榜";
        if (_hotTitleView.selected) {
            _hotTitleView.title.textColor = WDColorFrom16RGB(0xfed200);
        }else{
            _hotTitleView.title.textColor = WDColorFrom16RGB(0xffffff);
        }
        [_hotTitleView addTarget:self action:@selector(pageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hotTitleView;
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
