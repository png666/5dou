//
//  WDIncomeViewController.m
//  5dou
//
//  Created by 黄新 on 16/12/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  好友收益
//
//

#import "WDIncomeViewController.h"
#import "WDRankingCell.h"
#import "WDRankingModel.h"
#import "WDIncomeHeaderView.h"
#import "ToolClass.h"
#import "WDNoData.h"
#import "WDInviteRebateModel.h"
#import "UMCustomManager.h"
#import "WDNoInviteView.h"

@interface WDIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WDNoInviteView *noDataView;///< 无数据缺省页
@property (nonatomic, assign) CGFloat headerH; ///< 头部的高度
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WDIncomeHeaderView *headerView; ///< 头部

@property (nonatomic, strong) UIView *coverView;



@end

@implementation WDIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"好友收益" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.dataArray.count > 0) {
        self.noDataView.hidden = YES;
        self.coverView.hidden = YES;
    }else{
        self.noDataView.hidden = NO;
        self.coverView.hidden = NO;
    }
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.headerH = 130;
    if (device_is_iphone_4||device_is_iphone_5) {
        self.headerH = 130;
    }else if (device_is_iphone_6){
        self.headerH = 150;
    }else if (device_is_iphone_6p){
        self.headerH = 170;
    }
    //没有数据的时候
    [self.view addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(self.view);
        make.height.mas_equalTo(self.headerH);
    }];
    
    [self.view addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(self.headerH);
    }];
    [self.view bringSubviewToFront:self.noDataView];
    //页面赋值
    self.headerView = [[WDIncomeHeaderView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, self.headerH);
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView configValue:self.inviteModel];
}



#pragma mark ===== TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierID = @"rankingCellID";
    WDRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (!cell) {
        cell = [[WDRankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierID];
    }
    if (self.dataArray.count) {
        [cell configValue:self.dataArray[indexPath.row] IndexPath:indexPath];
    }
    return cell;
}

- (void)inviteBtnDidClick:(UIButton *)sender{
//    UIImage *shareImg = [UIImage imageNamed:@"iicon"];
//    [UMCustomManager shareWebWithViewController:self
//                                         ShareTitle:app_Name
//                                            Content:self.inviteModel.share_content
//                                         ThumbImage:shareImg
//                                                Url:self.inviteModel.share_url];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ====== 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 64;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}
- (WDNoInviteView *)noDataView{
    WeakStament(wself);
    if (!_noDataView) {
        _noDataView = [[WDNoInviteView alloc] init];
        _noDataView.backgroundColor = WDColorFrom16RGB(0xffffff);
        _noDataView.inviteBtnDidClickBlock = ^(){
            [wself.navigationController popViewControllerAnimated:YES];
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
