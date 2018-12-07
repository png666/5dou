//
//  WDTaskChildController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskChildController.h"

#import "WDTaskModel.h"
#import "UITableViewCell+Ext.h"
#import "MJRefresh.h"

#import "WDCompleteCell.h"
#import "WDUnderWayCell.h"
#import "WDTaskDetailController.h"

#import "WDNoneData.h"
#import "WDNoData.h"
#import "WDNotLoginData.h"

#import "WDGainMoneyViewController.h"
#import "WDRegisterViewController.h"
#import "WDLoginViewController.h"
#import "WDUserInfoModel.h"
#import "MJRefreshGifHeader+Ext.h"
#import "ToolClass.h"

#define pageSize 15
@interface WDTaskChildController ()<UITableViewDataSource,UITableViewDelegate>

/**
 没有数据的时候显示的页面，点击进行刷新操作
 */
@property (nonatomic,strong) WDNoneData *noneDataView;
@property (nonatomic,strong) WDNoData *goMoneyDataView;
@property (nonatomic,strong) WDNotLoginData *notLoginView;


/**
 用于存放展示的数据
 */
@property (nonatomic,strong) NSMutableArray *taskListArray;

/**
 展示的列表
 */
@property (nonatomic,strong)UITableView *taskTableview;

/**
 页面中计时器的集合
 */
@property (nonatomic,strong) NSMutableSet *timerSet;
@property (nonatomic,assign) int currentPage;

@property (nonatomic,strong)UITableView *testTableView;
@end

@implementation WDTaskChildController


-(UITableView *)testTableView{
    if (!_testTableView) {
        
        _testTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth , ScreenHeight - 64-49) style:UITableViewStylePlain];
        _testTableView.delegate = self;
        _testTableView.dataSource = self;
        _testTableView.backgroundColor = kBackgroundColor;
//        [_testTableView registerNib:[UINib nibWithNibName:@"NMineCell" bundle:nil] forCellReuseIdentifier:@"jj"];
        [_testTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"jj"];
        
        _testTableView.showsVerticalScrollIndicator = NO;
        _testTableView.tableFooterView = [UIView new];
    }
    return _testTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //测试
    [self.view addSubview:self.testTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//实时同步状态每次进来同步到最新的状态
- (void)viewWillAppear:(BOOL)animated{
//    self.currentPage = 0;
//    [self prepareData];
}

#pragma mark ZJScrollPageViewChildVcDelegate
- (void)zj_viewWillAppearForIndex:(NSInteger)index{
    
}
- (void)zj_viewDidAppearForIndex:(NSInteger)index{
    
}
- (void)zj_viewWillDisappearForIndex:(NSInteger)index{
    
}
- (void)zj_viewDidDisappearForIndex:(NSInteger)index{
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index{
    
    
//    if (index == 0) {
//        //新版本进行中
//        _taskState = 5;
//    }else if(index == 1){
//        //新版本已完成
//        _taskState = 6;
//    }
//    self.view.backgroundColor = WDColorFrom16RGB(0xf4f4f4);
//    [self prepareUI];
//    self.currentPage = 0;
//    [self prepareData];
    
}

#pragma mark 布局
- (void)prepareUI{
    _taskListArray = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.taskTableview];
}


- (WDNoneData *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [WDNoneData view];
        _noneDataView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
        WeakStament(weakSelf);
        _noneDataView.noneDataBlock = ^(){
            weakSelf.currentPage = 0;
            [weakSelf prepareData];
        };
    }
    return _noneDataView;
}

- (WDNoData *)goMoneyDataView{
    if (!_goMoneyDataView) {
        _goMoneyDataView = [WDNoData view];
        _goMoneyDataView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
        [_goMoneyDataView.goMakeMoneyBtn addTarget:self action:@selector(goMoney) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goMoneyDataView;
}

- (void)goMoney{
    WDGainMoneyViewController *goMoneyController = [WDGainMoneyViewController new];
    goMoneyController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goMoneyController animated:YES];
}

- (WDNotLoginData *)notLoginView{
    if (!_notLoginView) {
        _notLoginView = [WDNotLoginData view];
        _notLoginView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
        [_notLoginView setImage:[UIImage imageNamed:@"rent_login"] withInfo:@"登录后,领取的任务都会在这里显示" withLeftBtn:@"注册" withRightBtn:@"登录"];
        [_notLoginView.resgisterBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
        [_notLoginView.loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _notLoginView;
}

- (void)registerClick{
    WDRegisterViewController *registerController = [[WDRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)loginClick{
    [self callLoginVC];
}

-(void)callLoginVC{
    WeakStament(weakSelf);
    WDLoginViewController *login = [[WDLoginViewController alloc]init];
    login.successLoginBlock = ^(){
        [weakSelf prepareUI];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    //解决present延迟弹出
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nav animated:YES completion:^{
        }];
    });
}




#pragma mark数据请求
- (void)prepareData{
    WeakStament(weakSelf);
    _timerSet = [[NSMutableSet alloc] init];
    NSDictionary *param = @{@"queryState":[NSNumber numberWithInteger:_taskState],
                            @"pageInfo.pageSize":@pageSize,
                            @"pageInfo.toPage":@(self.currentPage)};
    [WDNetworkClient postRequestWithBaseUrl:kMyTaskList setParameters:param success:^(id responseObject) {
        NSDictionary *result = responseObject[@"result"];
        NSString *code = result[@"code"];
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        //如果有数据的情况下
        if (self.currentPage == 0) {
            [weakSelf.taskListArray removeAllObjects];
            [weakSelf.taskTableview.mj_header endRefreshing];
        }
        if (newArray.count != 0) {
            for(NSDictionary *taskDict in newArray){
                WDTaskModel *model = [[WDTaskModel alloc] init];
                [model setValuesForKeysWithDictionary:taskDict];
                [weakSelf.taskListArray addObject:model];
            }
            [weakSelf.taskTableview.mj_footer endRefreshing];
        }else{
            [weakSelf.taskTableview.mj_footer endRefreshingWithNoMoreData];
        }
        if (_taskListArray.count == 0) {
            if ([WDUserInfoModel shareInstance].memberId) {
                weakSelf.taskTableview.tableFooterView = self.goMoneyDataView;
            }else{
                weakSelf.taskTableview.tableFooterView = self.notLoginView;
            }
        }else{
            weakSelf.taskTableview.tableFooterView = nil;
        }
        [weakSelf.taskTableview reloadData];
        
        if([code isEqualToString:@"1002"]){
            [self.taskTableview.mj_footer endRefreshingWithNoMoreData];
        }
    } fail:^(NSError *error) {
    } delegater:nil];
}


#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _taskListArray.count;
    return 10;
}



/**
 根据任务状态的不同，进行数据的返回
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jj" forIndexPath:indexPath];
    cell.textLabel.text = @"这是测试";
    return cell;
    
    
    
//    //taskState=6 已经完成
//    if(_taskState == 6){
//        static NSString * identifier = @"WDCompleteCell";
//        WDCompleteCell *completeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!completeCell) {
//            completeCell = [[WDCompleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        completeCell.taskModel = self.taskListArray[indexPath.row];
//        return completeCell;
//    //taskState=5 正在进行
//    }else if(_taskState == 5){
//        static NSString * identifier = @"WDUnderWayCell";
//        WDUnderWayCell *underWayCell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!underWayCell) {
//            underWayCell = [[WDUnderWayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        underWayCell.taskModel = self.taskListArray[indexPath.row];
//
//        //如果列表中Cell中有计时器，应该加入到对应的Set中，便于在Controller销毁的时候进行删除
//        if (underWayCell.changeTimer) {
//            [self.timerSet addObject:underWayCell.changeTimer];
//        }
//        return underWayCell;
//    }else{
//        return nil;
//    }
}

//点击进入详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
//    WDTaskModel *taskModel = _taskListArray[indexPath.row];
//    [self prepareDataDetail:taskModel.taskId];
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
        WDTaskDetailController *detailController = [WDTaskDetailController new];
        [detailController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailController animated:YES];
        detailController.taskDetailModel = taskDetailModel;
    } fail:^(NSError *error) {
    } delegater:self.view];
}


#pragma mark 封装页面

- (UITableView *)taskTableview{
    WeakStament(weakSelf);
    if (!_taskTableview) {
        _taskTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, self.view.height - 49 - 10) style:UITableViewStylePlain];
        _taskTableview.delegate = self;
        _taskTableview.dataSource = self;
        _taskTableview.rowHeight = 80;
        _taskTableview.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _taskTableview.backgroundColor = kBackgroundColor;
        _taskTableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            weakSelf.currentPage = 0;
            [weakSelf prepareData];
        }];
        [MJRefreshGifHeader initGifImage:_taskTableview.mj_header];
        _taskTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.currentPage++;
            [weakSelf prepareData];
        }];
    }
    return _taskTableview;
}

- (void)delloc{
    for (NSTimer *timer in self.timerSet){
        [timer invalidate];
    }
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
