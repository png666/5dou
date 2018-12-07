
//
//  WDActivityViewController.m
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDActivityViewController.h"
#import "WDActivityDetailController.h"
#import "ToolClass.h"
#import "WDActivityCell.h"

#import "MJRefresh.h"

#import "WDActivityModel.h"
#import "UITableViewCell+Ext.h"
#import "MJRefreshGifHeader+Ext.h"
#define kAngle (30.0 * M_PI) / 180.0

//默认页面
#define pageSize 15

@interface WDActivityViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isRefresh;
}
/**
 *  活动数组
 */
@property (nonatomic,strong) NSMutableArray *activityList;

/**
 *  活动列表
 */
@property (nonatomic,strong) UITableView *activityTableView;
/**
 *  最后滑动距离
 */
@property (nonatomic, assign) CGFloat lastScrollOffset;
/**
 *  cell的角度
 */
@property (nonatomic, assign) CGFloat angle;
/**
 *  设置Cell的锚点
 */
@property (nonatomic, assign) CGPoint cellAnchorPoint;


@end

@implementation WDActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithToPage:0];
    [self prepareUI];
    // Do any additional setup after loading the view.
}


- (void)prepareUI{
     _activityList = [NSMutableArray array];
    [self.navigationItem setItemWithTitle:@"玩转5dou" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self.view addSubview:self.activityTableView];
}


- (void)prepareDataWithToPage:(NSInteger)toPage{
    WeakStament(weakSelf);
    NSDictionary *dic = @{@"pageInfo.pageSize":@pageSize,@"pageInfo.toPage":[NSNumber numberWithInteger:toPage]};
    [WDNetworkClient postRequestWithBaseUrl:kActivityList setParameters:dic success:^(id responseObject) {
        //进行了刷新的操作
        if (toPage == 0) {
            [_activityList removeAllObjects];
            [weakSelf.activityTableView.mj_header endRefreshing];
            //进行刷新
            isRefresh = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                isRefresh = NO;
            });
        }
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        if (newArray.count != 0) {
            for (NSDictionary *commentDic in newArray) {
                WDActivityModel *model = [[WDActivityModel alloc] init];
                [model setValuesForKeysWithDictionary:commentDic];
                [weakSelf.activityList addObject:model];
            }
            [weakSelf.activityTableView.mj_footer endRefreshing];
        }else{
            [weakSelf.activityTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.activityTableView reloadData];
    } fail:^(NSError *error) {
    
    } delegater:self.view];

}

- (UITableView *)activityTableView{
    if (!_activityTableView) {
        WeakStament(weakSelf);
        _activityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth , ScreenHeight - 64) style:UITableViewStylePlain];
        _activityTableView.delegate = self;
        _activityTableView.dataSource = self;
        _activityTableView.rowHeight = 185.0f;
        _activityTableView.separatorColor = [UIColor clearColor];
        _activityTableView.backgroundColor = kBackgroundColor;
        _activityTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf prepareDataWithToPage:0];
        }];
        [MJRefreshGifHeader initGifImage:_activityTableView.mj_header];
        _activityTableView.showsVerticalScrollIndicator = NO;
        _activityTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //还有信息
            if (weakSelf.activityList.count % pageSize == 0) {
                NSInteger toPage = weakSelf.activityList.count/pageSize ;
                [weakSelf prepareDataWithToPage:toPage];
            }else{
                [weakSelf.activityTableView.mj_footer endRefreshingWithNoMoreData];
            }
         
        }];
    }
    return _activityTableView;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDActivityCell *activityCell = [WDActivityCell cellWithTableView:tableView];
    WDActivityModel *activityModel = _activityList[indexPath.row];
    activityCell.activityModel = activityModel;
    activityCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return activityCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _activityList.count;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isRefresh) {
        [ToolClass animateWithCell:cell];
    }
}
#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WDActivityModel *activityModel = _activityList[indexPath.row];
    WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
    activityDetailController.requestType =  ReuqestTypeActivity;
    activityDetailController.activityID = activityModel.activityID;
    activityDetailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityDetailController animated:YES];
    
}


@end
