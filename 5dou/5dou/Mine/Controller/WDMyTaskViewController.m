
//
//  WDMyTaskViewController.m
//  5dou
//
//  Created by rdyx on 16/9/4.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDMyTaskViewController.h"
#import "WDCustomBar.h"
#import "WDTaskListView.h"
#import "WDH5TaskViewController.h"
#import "WDUserInfoModel.h"
#import "WDTaskDetailModel.h"
#import "WDTaskDetailViewController.h"
#define barItemNumber 4
#define UnderWay    10000
#define UnderReview 10001
#define Completed   10002
#define Resigned    10003
@interface WDMyTaskViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *tableScrollView;
@property (nonatomic,strong) UIView *headerBarView;

@property (nonatomic,strong) WDTaskListView *underWayTaskView;
@property (nonatomic,strong) WDTaskListView *underReviewTaskView;
@property (nonatomic,strong) WDTaskListView *completedTaskView;
@property (nonatomic,strong) WDTaskListView *resignedTaskView;
@end

@implementation WDMyTaskViewController
{
    //进行中
    WDCustomBar *_underWayBar;
    //审核中
    WDCustomBar *_underReviewBar;
    //已完成
    WDCustomBar *_completedBar;
    //已放弃
    WDCustomBar *_resignedBar;
    //移动的线
    UIView *_movingLine;
    //记录初始化的位置
    NSInteger _index;
    UIView *_bottomLine;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"我的任务" textColor:kWhiteColor fontSize:19 itemType:center];
    [self prepareUI];
    [self prepareData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的任务"];
    [self prepareData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的任务"];
}

- (void)prepareUI{
    [self createHeaderBar];
    [self createTableScrollView];
}


- (void)prepareData{
    NSDictionary *param =  @{@"bi.mi":[WDUserInfoModel shareInstance].memberId};
    [WDNetworkClient postRequestWithBaseUrl:kMyTaskCount setParameters:param success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            NSDictionary *taskCountDict = responseObject[@"data"];
            _underWayBar.countLabel.text = [NSString stringWithFormat:@"%@",taskCountDict[@"doingCount"]];
            _underReviewBar.countLabel.text = [NSString stringWithFormat:@"%@",taskCountDict[@"auditingCount"]];
            _completedBar.countLabel.text = [NSString stringWithFormat:@"%@",taskCountDict[@"completedCount"]];
            _resignedBar.countLabel.text = [NSString stringWithFormat:@"%@",taskCountDict[@"cacelCount"]];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

#pragma mark 选项头
- (void)createHeaderBar{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 125)];
    backImageView.image  = [UIImage imageNamed:@"task_card"];
    [self.view addSubview:backImageView];
    _headerBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, ScreenWidth, 60)];
    _headerBarView.backgroundColor = kWhiteColor;
    [self.view addSubview:_headerBarView];
    
    CGFloat ControlBarWidth = ScreenWidth / barItemNumber;
    CGFloat ControlBarHeight = 30;
    CGFloat ControlBarY = 5;
    CGSize barSize = CGSizeMake(ControlBarWidth, ControlBarHeight);
    //进行中选项卡
    _underWayBar = [[WDCustomBar alloc] initWithCount:@"1" andName:@"进行中" size:barSize];
    [_underWayBar addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _underWayBar.tag = UnderWay;
    _underWayBar.nameLabel.textColor = WDColorFrom16RGB(0xF5A623);
    _underWayBar.countLabel.textColor = WDColorFrom16RGB(0xF5A623);
    [_underWayBar setOrigin:CGPointMake(0, ControlBarY)];
    [_headerBarView addSubview:_underWayBar];
    
    _underReviewBar = [[WDCustomBar alloc] initWithCount:@"2" andName:@"审核中" size:barSize];
    [_underReviewBar addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _underReviewBar.tag = UnderReview;
    [_underReviewBar setOrigin:CGPointMake(ControlBarWidth, ControlBarY)];
    [_headerBarView addSubview:_underReviewBar];
    
    
    _completedBar = [[WDCustomBar alloc] initWithCount:@"3" andName:@"已完成" size:barSize];
    [_completedBar addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _completedBar.tag = Completed;
    [_completedBar setOrigin:CGPointMake(ControlBarWidth * 2, ControlBarY)];
    [_headerBarView addSubview:_completedBar];
    
    _resignedBar = [[WDCustomBar alloc] initWithCount:@"4" andName:@"已放弃" size:barSize];
    [_resignedBar addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _resignedBar.tag = Resigned;
    [_resignedBar setOrigin:CGPointMake(ControlBarWidth * 3, ControlBarY)];
    [_headerBarView addSubview:_resignedBar];
    _resignedBar.lineView.hidden = YES;
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [_bottomLine setOrigin:CGPointMake(0, _headerBarView.height - 2)];
    [_headerBarView addSubview:_bottomLine];
    
    _movingLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ControlBarWidth - 30, 2)];
    _movingLine.backgroundColor = [UIColor orangeColor];
    _movingLine.center = CGPointMake(_underWayBar.centerX, - 10);
    _movingLine.backgroundColor = WDColorFrom16RGB(0xF5A623);
    [_bottomLine addSubview:_movingLine];
}

#pragma mark 选项列表
- (void)createTableScrollView{
    CGFloat tableScrollX = 0;
    CGFloat tableScrollY = 185;
    CGFloat tableScrollWidth = ScreenWidth;
    CGFloat tableScrollHeight = ScreenHeight - tableScrollY - 64;
    UIScrollView *tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(tableScrollX, tableScrollY, tableScrollWidth, tableScrollHeight)];
    tableScrollView.showsVerticalScrollIndicator = NO;
    tableScrollView.showsHorizontalScrollIndicator = NO;
    tableScrollView.delegate = self;
    tableScrollView.pagingEnabled = YES;
    tableScrollView.contentSize = CGSizeMake(barItemNumber * ScreenWidth, tableScrollHeight);
    _tableScrollView = tableScrollView;
    [self.view addSubview:_tableScrollView];
    
    //进行中
    WeakStament(weakSelf);
    _underWayTaskView = [[WDTaskListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableScrollHeight) withState:1];
    _underWayTaskView.selectTaskBlock = ^(NSString *taskId){
        [weakSelf prepareDataDetail:taskId];
    };
    [_tableScrollView addSubview:_underWayTaskView];
    
    //审核中
    _underReviewTaskView = [[WDTaskListView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, tableScrollHeight) withState:2];
    _underReviewTaskView.selectTaskBlock = ^(NSString *taskId){
        [weakSelf prepareDataDetail:taskId];
    };
    [_tableScrollView addSubview:_underReviewTaskView];
    
    //已完成
    _completedTaskView = [[WDTaskListView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, tableScrollHeight) withState:3];
    _completedTaskView.selectTaskBlock = ^(NSString *taskId){
        [weakSelf prepareDataDetail:taskId];
    };
    [_tableScrollView addSubview:_completedTaskView];
    
    //已放弃
    _resignedTaskView = [[WDTaskListView alloc] initWithFrame:CGRectMake(ScreenWidth * 3, 0, ScreenWidth, tableScrollHeight) withState:4];
     _resignedTaskView .selectTaskBlock = ^(NSString *taskId){
        [weakSelf prepareDataDetail:taskId];
    };
    [_tableScrollView addSubview:_resignedTaskView];
    
}

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


//点击上面的选项卡
- (void)changeView:(WDCustomBar *)sender{
    _index = sender.tag - 10000;
    [self moveLine:_index];
    if ([_underWayBar isEqual:sender]) {
        _underReviewBar.selected = NO;
        _completedBar.selected = NO;
        _resignedBar.selected = NO;
        [self changeItemTintColor:sender];
    }else if([_underReviewBar isEqual:sender]){
        _underWayBar.selected = NO;
        _completedBar.selected = NO;
        _resignedBar.selected = NO;
        [self changeItemTintColor:sender];
    }else if([_completedBar isEqual:sender]){
        _underWayBar.selected = NO;
        _underReviewBar.selected = NO;
        _resignedBar.selected = NO;
        [self changeItemTintColor:sender];
    }else if([_resignedBar isEqual:sender]){
        _underWayBar.selected = NO;
        _underReviewBar.selected = NO;
        _completedBar.selected = NO;
        [self changeItemTintColor:sender];
    }
    sender.nameLabel.textColor = WDColorFrom16RGB(0xF5A623);
    sender.countLabel.textColor =  WDColorFrom16RGB(0xF5A623);
    [_tableScrollView setContentOffset:CGPointMake(ScreenWidth * _index, 0) animated:NO];
    
}

//进行相应的改变
- (void)changeItemTintColor:(WDCustomBar *)sender{
    if (![_underWayBar isEqual:sender]) {
        _underWayBar.nameLabel.textColor = WDColorFrom16RGB(0x484848);
        _underWayBar.countLabel.textColor = WDColorFrom16RGB(0x484848);
    }
    if (![_underReviewBar isEqual:sender]) {
        _underReviewBar.nameLabel.textColor = WDColorFrom16RGB(0x484848);
        _underReviewBar.countLabel.textColor = WDColorFrom16RGB(0x484848);
    }
    if (![_completedBar isEqual:sender]) {
        _completedBar.nameLabel.textColor = WDColorFrom16RGB(0x484848);
        _completedBar.countLabel.textColor = WDColorFrom16RGB(0x484848);
    }
    if (![_resignedBar isEqual:sender]) {
        _resignedBar.nameLabel.textColor = WDColorFrom16RGB(0x484848);
        _resignedBar.countLabel.textColor = WDColorFrom16RGB(0x484848);
    }
}

- (void)moveLine:(NSInteger)sender{
    CGFloat lineX;
    if (sender == 0) {
        lineX = _underWayBar.centerX;
    }else if(sender == 1){
        lineX = _underReviewBar.centerX;
    }else if(sender == 2){
        lineX = _completedBar.centerX;
    }else if(sender == 3){
        lineX = _resignedBar.centerX;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _movingLine.center = CGPointMake(lineX, - 10);
    }];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_tableScrollView]) {
        _index = _tableScrollView.bounds.origin.x / _tableScrollView.width;
        [self moveLine:_index];
        return;
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:_tableScrollView]) {
        
        if (_index == 0) {
            [self changeView:_underWayBar];
        }else if (_index == 1){
            [self changeView:_underReviewBar];
        }else if (_index == 2){
            [self changeView:_completedBar];
        }else if (_index == 3){
            [self changeView:_resignedBar];
        }
        return;
    }
}


- (void)dealloc{
    if (_underWayTaskView.timerSet) {
        for (NSTimer *timer in _underWayTaskView.timerSet) {
            [timer invalidate];
        }
    }
}

@end
