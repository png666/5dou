//
//  WDTaskDetailController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/16.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskDetailController.h"

#import "WDTaskDescribeCell.h"
#import "WDTaskTimeCell.h"

#import "WDTaskModel.h"
#import "WDTaskModulelView.h"
#import "WDLoginViewController.h"
#import "UMCustomManager.h"
#import "WDUserInfoModel.h"

@interface WDTaskDetailController ()
@property (nonatomic,strong) WDTaskDescribeCell *taskDescribeCell;
@property (nonatomic,strong) WDTaskTimeCell *taskTimeCell;

/**
 任务的相关的简介，步骤，提交
 */
@property (nonatomic,strong) WDTaskModulelView *taskMoudelView;

/**
 任务倒计时
 */
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation WDTaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"任务详情" textColor:kNavigationTitleColor fontSize:19 itemType:center];
//    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 29, 29) title:@"" Image:@"fenxiang" selectedIMG:@"" tartget:self action:@selector(shareTask:)];

    [self prepareUI];
    // Do any additional setup after loading the view.
}

- (void)prepareUI{
   
    //添加任务描述
    [self.view addSubview:self.taskDescribeCell];
    //添加限制时间
    [self.view addSubview:self.taskTimeCell];
    //添加任务下面的三个模块
    [self.view addSubview:self.taskMoudelView];
    
}



- (void)setTaskDetailModel:(WDTaskDetailModel *)taskDetailModel{
    _taskDetailModel = taskDetailModel;
    self.taskMoudelView.detailModel = taskDetailModel;
    //进行数据拼接
    [self initDescribeCell];
    [self initTimeCell];
}


- (void)initDescribeCell{
    //进行数据的拼接，完成描述信息的数据填充
    WDTaskModel *taskModel = [WDTaskModel new];
    taskModel.taskName = _taskDetailModel.taskName;
    taskModel.imgUrl = _taskDetailModel.imgUrl;
    taskModel.startTime = _taskDetailModel.startTime;
    taskModel.endTime = _taskDetailModel.endTime;
    taskModel.joinMemberCount = _taskDetailModel.joinMemberCount;
    taskModel.joinMemerLimit = _taskDetailModel.memberCountLimit;
    taskModel.reward = _taskDetailModel.reward;
    taskModel.isCountDownTask = _taskDetailModel.isCountDownTask;
    taskModel.countDownStartTime = _taskDetailModel.countDownStartTime;
    taskModel.taskCardId = _taskDetailModel.taskCardId;
    taskModel.countDownReceiveLeftSec = _taskDetailModel.countDownReceiveLeftSec;
    self.taskDescribeCell.taskModel = taskModel;
}

- (void)initTimeCell{
    //判断是否是倒计时任务
    NSString *time = @"";
    self.taskTimeCell.isLimitTime = NO;
    if ([_taskDetailModel.isCountDownTask isEqualToString:@"1"]) {
       _taskTimeCell.isLimitTime = YES;
        time = _taskDetailModel.countDownReceiveLeftSec;
    }else{
       _taskTimeCell.isLimitTime = NO;
        if (_taskDetailModel.taskSubmitLeftSec) {
            time = _taskDetailModel.taskSubmitLeftSec;
        }else{
            time = _taskDetailModel.countdownTime;
        }
    }
    BOOL isNeedRefresh = YES;
    
    //-1:用户没有领取该任务 0:未使用;1:进行中;2:已完成;3:已放弃;4:待审核;5:审核不通过;6:已失效;
    if (!([_taskDetailModel.taskStatus isEqualToString:@"-1"]
          || [_taskDetailModel.taskStatus isEqualToString:@"0"]
          || [_taskDetailModel.taskStatus isEqualToString:@"1"]
          || [_taskDetailModel.taskStatus isEqualToString:@"3"]
          || !_taskDetailModel.taskStatus)
        ) {
        time = @"0";
       _taskTimeCell.isLimitTime = NO;
        isNeedRefresh = NO;
    }
    
    //第一次如果为0的话是不会调用taskStopBlock
   _taskTimeCell.countdownTime = [time intValue];
    WeakStament(weakSelf);
   _taskTimeCell.taskStopBlock = ^(){
        if (isNeedRefresh) {
            [weakSelf prepareData];
        }
    };
    self.timer = _taskTimeCell.changeTimer;
    if ([self.taskDetailModel.taskStatus isEqualToString:@"1"] || [self.taskDetailModel.isCountDownTask isEqualToString:@"1"]) {
        [self.timer setFireDate:[NSDate date]];
    }else{
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - 描述cell
- (WDTaskDescribeCell *)taskDescribeCell{
    if (!_taskDescribeCell) {
        _taskDescribeCell = [[WDTaskDescribeCell alloc] init];
        _taskDescribeCell.frame = CGRectMake(0, 0, ScreenWidth, 100);
    }
    return _taskDescribeCell;
}
#pragma mark - 倒计时cell
- (WDTaskTimeCell *)taskTimeCell{
    if (!_taskTimeCell) {
        _taskTimeCell = [[[NSBundle mainBundle] loadNibNamed:@"WDTaskTimeCell" owner:nil options:nil] lastObject];
        _taskTimeCell.frame = CGRectMake(0, 100, ScreenWidth, 40);
        _taskTimeCell.backgroundColor = kWhiteColor;
    }
    return _taskTimeCell;
}
#pragma mark - 倒计时下面的View
-(WDTaskModulelView *)taskMoudelView{
    WeakStament(wSelf);
    if (!_taskMoudelView) {
        _taskMoudelView = [[WDTaskModulelView alloc] initWithFrame:CGRectMake(0, 155, ScreenWidth, ScreenHeight - 155)];
        //
        _taskMoudelView.taskStateRefreshBlock = ^(NSDictionary *dict){
            [wSelf prepareData];
        };
    }
    return _taskMoudelView;
}


- (void)prepareData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WeakStament(weakSelf);
    [param setObject:_taskDetailModel.taskId forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kTaskDetailUrl setParameters:param success:^(id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        weakSelf.taskDetailModel = [[WDTaskDetailModel alloc] initWithDictionary:dict error:nil];
    } fail:^(NSError *error) {
    } delegater:self.view];
    
}

/**
 调起登录界面
 */
-(void)callLoginVC
{
    WDLoginViewController *loginController = [WDLoginViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    [self presentViewController:navigationController animated:YES completion:nil];
    WeakStament(weakSelf);
    loginController.successLoginBlock = ^(){
        [weakSelf prepareData];
    };
    
}

@end
