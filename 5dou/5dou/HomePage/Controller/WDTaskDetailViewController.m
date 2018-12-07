//
//  WDTaskDetailViewController.m
//  5dou
//
//  Created by rdyx on 16/8/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskDetailViewController.h"
#import "LrdOutputView.h"
#import "UITableViewCell+Ext.h"

#import "WDTaskHeadCell.h"
#import "WDTaskTitleCell.h"
#import "WDTaskTimeCell.h"
#import "WDQuestionCell.h"
#import "WDTaskStepCell.h"
#import "WDTaskMaterialCell.h"
#import "WDTaskButtonCell.h"

#import "WDTaskStepModel.h"
#import "WDSearchTextCell.h"

#import "WDUserInfoModel.h"

#import "WDTaskCommentController.h"
#import "WDCommitTaskController.h"
#import "WDSCWebViewController.h"
#import "WDH5DoTaskViewController.h"

#import "UMCustomManager.h"

#import "ToolClass.h"
#import "SYFavoriteButton.h"
#import "WDLoginViewController.h"

@interface WDTaskDetailViewController ()<LrdOutputViewDelegate,UITableViewDelegate,UITableViewDataSource,WDSearchTextCellDelegate>
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) LrdOutputView *outPutView;
@property (nonatomic,strong) UIButton *functionButton;
@property (nonatomic,strong) UITableView *taskDetailTableView;
@property (nonatomic,strong) NSArray *stepArray;
@property (nonatomic,assign) int hasSearchText;
@property (nonatomic,strong) NSTimer *timer;
//@property (nonatomic,strong) SYFavoriteButton *favoriteButton;
@property (nonatomic,strong) UIButton *favoriteButton;
//@property (nonatomic,strong) UIImageView *firstSuccessGetTaskView;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,assign) int stepIndex;
@end

@implementation WDTaskDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self prepareUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareData) name:@"RefreshTaskDetial" object:nil];
    //[self prepareData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"任务详情"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"任务详情"];
    
}
- (void)prepareUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setItemWithTitle:@"任务详情" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
    //    _functionButton = [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 29, 29) title:nil Image:@"home_down" selectedIMG:nil tartget:self action:@selector(functionBtnClick:)];
    //    LrdCellModel *collectBtn = [[LrdCellModel alloc] initWithTitle:@"收藏" imageName:@"huodong"];
    //    LrdCellModel *shareBtn = [[LrdCellModel alloc] initWithTitle:@"分享" imageName:@"huodong"];
    //    LrdCellModel *commentBtn = [[LrdCellModel alloc] initWithTitle:@"评论" imageName:@"huodong"];
    //    self.dataArr = @[collectBtn,shareBtn,commentBtn];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.favoriteButton];
    self.navigationItem.rightBarButtonItem = item;
    [self.view addSubview:self.taskDetailTableView];
}

- (void)setTaskDetailModel:(WDTaskDetailModel *)taskDetailModel{
    _taskDetailModel = taskDetailModel;
    NSMutableArray *newStepArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *stepDict in self.taskDetailModel.steps) {
        WDTaskStepModel *stepModel = [WDTaskStepModel new];
        [stepModel setValuesForKeysWithDictionary:stepDict];
        [newStepArray addObject:stepModel];
    }
    self.stepArray = newStepArray;

    if ([_taskDetailModel.isCollected integerValue] == 0) {
        self.favoriteButton.selected = NO;
    }else{
        self.favoriteButton.selected = YES;
    }
    _taskId = _taskDetailModel.taskId;
    [self.taskDetailTableView reloadData];
}

- (void)prepareData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WeakStament(weakSelf);
    NSString *memberId = [WDUserInfoModel shareInstance].memberId;
    if (!memberId) {
        memberId = @"";
    }
    _stepIndex = 0;
    [param setObject:_taskId forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kTaskDetailUrl setParameters:param success:^(id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        weakSelf.taskDetailModel = [[WDTaskDetailModel alloc] initWithDictionary:dict error:nil];
        
        //处理步骤
        NSMutableArray *newStepArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *stepDict in weakSelf.taskDetailModel.steps) {
            WDTaskStepModel *stepModel = [WDTaskStepModel new];
            [stepModel setValuesForKeysWithDictionary:stepDict];
            [newStepArray addObject:stepModel];
        }
        weakSelf.stepArray = newStepArray;
        
        if ([weakSelf.taskDetailModel.isCollected integerValue] == 0) {
            weakSelf.favoriteButton.selected = NO;
        }else{
            weakSelf.favoriteButton.selected = YES;
        }
        
        [weakSelf.taskDetailTableView reloadData];
    } fail:^(NSError *error) {
    } delegater:self.view];
    
}
#pragma mark - 字典转json
- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)functionBtnClick:(UIButton *)button{
    CGFloat x = _functionButton.center.x + 15 ;
    CGFloat y = _functionButton.frame.origin.y + _functionButton.bounds.size.height + 20;
    _outPutView = [[LrdOutputView alloc] initWithDataArray:self.dataArr origin:CGPointMake(x, y) width:100 height:44 direction:kLrdOutputViewDirectionRight];
    _outPutView.delegate = self;
    _outPutView.dismissOperation = ^(){
        _outPutView = nil;
    };
    [_outPutView pop];
}


- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YYLog(@"选择了收藏");
    }else if(indexPath.row == 1){
        YYLog(@"选择了分享");
    }else if(indexPath.row == 2){
        YYLog(@"选择评论");
    }
}


- (UITableView *)taskDetailTableView{
    if (!_taskDetailTableView) {
        _taskDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _taskDetailTableView.delegate = self;
        _taskDetailTableView.dataSource = self;
        _taskDetailTableView.separatorColor = [UIColor whiteColor];
        _taskDetailTableView.separatorColor = kWhiteColor;
        _taskDetailTableView.backgroundColor = WDColorRGB(254, 249, 250);
    }
    return _taskDetailTableView;
}

//- (SYFavoriteButton *)favoriteButton{
//    if(!_favoriteButton){
//        _favoriteButton = [[SYFavoriteButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _favoriteButton.image = [UIImage imageNamed:@"collect_nor"];
//        _favoriteButton.duration = 1;
//        _favoriteButton.defaultColor = [UIColor whiteColor];
//        _favoriteButton.lineColor = [UIColor purpleColor];
//        _favoriteButton.favoredColor = [UIColor yellowColor];
//        _favoriteButton.circleColor = [UIColor yellowColor];
//        _favoriteButton.userInteractionEnabled = YES;
//        [_favoriteButton addTarget:self action:@selector(collectionTask) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _favoriteButton;
//}

- (UIButton *)favoriteButton{
    if (!_favoriteButton) {
        _favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favoriteButton.frame = CGRectMake(0, 0, 40, 40);
        [_favoriteButton setImage:[UIImage imageNamed:@"collect_nor"] forState:UIControlStateNormal];
        [_favoriteButton setImage:[UIImage imageNamed:@"collect_pre"] forState:UIControlStateSelected];
        [_favoriteButton addTarget:self action:@selector(collectionTask) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favoriteButton;
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
#pragma mark -  WDSearchTextCellDelegate

#pragma mark - 10.15号上线后后台的bug，临时添加了这个方法：在copy的时候也调用一下接口，通知后台

/**
 点击copy跳转appstore之前进行一次接口的请求
 */
-(void)didClickedCopyOnSerachTextCell:(WDSearchTextCell *)cell
{
    //判断是否登录
    if (![WDUserInfoModel shareInstance].memberId || [WDUserInfoModel shareInstance].memberId.length == 0) {
        [self callLoginVC];
        return ;
    }
    
    NSDictionary *param = @{@"taskId":_taskId};
    [WDNetworkClient postRequestWithBaseUrl:kDownloadTask setParameters:param  success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            YYLog(@"开始监控");
        }
    } fail:^(NSError *error) {
    } delegater:self.view];
    
    //跳转appstore
    NSString *appStore = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@#software",[cell.searchTextStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:appStore];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
    
}

#pragma mark UITableViewDelegate ,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [WDTaskHeadCell cellWithTableView:tableView];
        //进行拼装
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
        ((WDTaskHeadCell *)cell).taskModel= taskModel;
        
    }else if(indexPath.row == 1){
        
        cell = [WDTaskTimeCell cellWithTableView:tableView];
        //任务
        //判断是否是倒计时任务
        NSString *time = @"";
        ((WDTaskTimeCell *)cell).isLimitTime = NO;
//        if ([_taskDetailModel.isCountDownTask isEqualToString:@"1"]) {            if([_taskDetailModel.countDownReceiveLeftSec intValue] > 0){
//                ((WDTaskTimeCell *)cell).isLimitTime = YES;
//                time = _taskDetailModel.countDownReceiveLeftSec;
//            }else{
//                 ((WDTaskTimeCell *)cell).isLimitTime = NO;
//                if (_taskDetailModel.taskSubmitLeftSec) {
//                    time = _taskDetailModel.taskSubmitLeftSec ;
//                }else{
//                    time = _taskDetailModel.countdownTime;
//                }
//            }
//        }else{
//            ((WDTaskTimeCell *)cell).isLimitTime = NO;
//            if (_taskDetailModel.taskSubmitLeftSec) {
//                time = _taskDetailModel.taskSubmitLeftSec;
//            }else{
//                time = _taskDetailModel.countdownTime;
//            }
//        }
        if ([_taskDetailModel.isCountDownTask isEqualToString:@"1"]) {
            ((WDTaskTimeCell *)cell).isLimitTime = YES;
            time = _taskDetailModel.countDownReceiveLeftSec;
        }else{
            ((WDTaskTimeCell *)cell).isLimitTime = NO;
            if (_taskDetailModel.taskSubmitLeftSec) {
                time = _taskDetailModel.taskSubmitLeftSec;
            }else{
                time = _taskDetailModel.countdownTime;
            }
        }
        BOOL isNeedRefresh = YES;
        if (!([_taskDetailModel.taskStatus isEqualToString:@"-1"]
            || [_taskDetailModel.taskStatus isEqualToString:@"0"]
            || [_taskDetailModel.taskStatus isEqualToString:@"1"]
            || !_taskDetailModel.taskStatus)
            ) {
            time = @"0";
            ((WDTaskTimeCell *)cell).isLimitTime = NO;
            isNeedRefresh = NO;
        }
        
        //第一次如果为0的话是不会调用taskStopBlock
        ((WDTaskTimeCell *)cell).countdownTime = [time intValue];
        
        WeakStament(weakSelf);
        ((WDTaskTimeCell *)cell).taskStopBlock = ^(){
            //转换状态
            if (isNeedRefresh) {
                [weakSelf prepareData];
                YYLog(@"进行了刷新");
            }
        };
        self.timer = ((WDTaskTimeCell *)cell).changeTimer;
        if ([self.taskDetailModel.taskStatus isEqualToString:@"1"] || [self.taskDetailModel.isCountDownTask isEqualToString:@"1"]) {
            [self.timer setFireDate:[NSDate date]];
        }else{
            [self.timer setFireDate:[NSDate distantFuture]];
        }
        
        
    }else if(indexPath.row == 3 ||
             indexPath.row == 6 ){
        
        cell = [WDTaskTitleCell cellWithTableView:tableView];
        
        if (indexPath.row == 3) {
            ((WDTaskTitleCell *)cell).title = @"简介";
        }else if(indexPath.row == 6){
            ((WDTaskTitleCell *)cell).title = @"任务步骤";
        }
        
    }else if(indexPath.row == 2 ||
             indexPath.row == 5 ||
             indexPath.row == 7){
        
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 7) {
            cell.backgroundColor = kWhiteColor;
        }else{
            cell.backgroundColor = WDColorRGB(254, 249, 250);
        }
    }else if(indexPath.row == 4){
        
        cell = [WDTaskMaterialCell cellWithTableView:tableView];
        ((WDTaskMaterialCell *)cell).materialStr = _taskDetailModel.taskInfo;
        ((WDTaskMaterialCell *)cell).materialHeight.constant = [self getCellHeight:_taskDetailModel.taskInfo withWidth:ScreenWidth - 20];
        
    }
    //判断有多少任务的步骤，步骤分为多步，每一个Cell中可以包含对应的文字和图片描述信息
    else if(indexPath.row >= 8 && indexPath.row < 8 + _stepArray.count && _stepArray.count != 0){
        
        cell = [WDTaskStepCell cellWithTableView:tableView];
        NSInteger step = indexPath.row - 8;
        WDTaskStepModel *stepModel = _stepArray[step];
        if ([stepModel.isImg intValue] != 1) {
            _stepIndex ++;
        }
        ((WDTaskStepCell *)cell).stepLabel.text = [NSString stringWithFormat:@"%d",_stepIndex];
       
        ((WDTaskStepCell *)cell).stepModel = stepModel;
      
        //判断是否是最后一个，如果是最后一个隐藏时间线
        if (indexPath.row == 8 + _stepArray.count - 1) {
            ((WDTaskStepCell *)cell).lineView.backgroundColor = kWhiteColor;
        }else{
             ((WDTaskStepCell *)cell).lineView.backgroundColor = kNavigationBarColor;
        }
    }
    else{
        if (_taskDetailModel.textSearch.length > 0 && (indexPath.row == 8 + _stepArray.count)) {
            //展示第三方跳转的按钮
            _hasSearchText = 1;
            cell = [[WDSearchTextCell alloc] init];
            
            ((WDSearchTextCell *)cell).searchTextStr = _taskDetailModel.textSearch;
            //10.15号添加代理方法
            ((WDSearchTextCell *)cell).delegate = self;
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        //判断是否有素材
        if ([_taskDetailModel.isMaterial intValue] == 1 && !_taskDetailModel.material.materialUrl) {
            //暗色条
            if (indexPath.row == 8 + _stepArray.count + _hasSearchText) {
                cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = WDColorRGB(254, 249, 250);
            }else if(indexPath.row == 8 + _stepArray.count + 1 + _hasSearchText){
                cell = [WDTaskTitleCell cellWithTableView:tableView];
                ((WDTaskTitleCell *)cell).title = @"素材";
            }else if(indexPath.row == 8 + _stepArray.count + 2 + _hasSearchText){
                cell = [WDTaskMaterialCell cellWithTableView:tableView];
                ((WDTaskMaterialCell *)cell).materialHeight.constant = [self getCellHeight:_taskDetailModel.material.materialInfo withWidth:ScreenWidth - 20];
                ((WDTaskMaterialCell *)cell).materialModel = _taskDetailModel.material;
            }else {
                cell = [WDTaskButtonCell cellWithTableView:tableView];
                [self buttonStausChange:(WDTaskButtonCell *)cell];
            }
        }else{
            //如果没有素材
            cell = [WDTaskButtonCell cellWithTableView:tableView];
            [self buttonStausChange:(WDTaskButtonCell *)cell];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)buttonStausChange:(WDTaskButtonCell *)cell{
//    cell.jumpUrl = _taskDetailModel.jumpUrl;
//    cell.buttonType = [_taskDetailModel.taskStatus intValue];
//    [cell.taskButton addTarget:self action:@selector(taskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.doTaskButton addTarget:self action:@selector(doTaskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90.0f;
    }else if(indexPath.row == 1){
        return 40.0f;
    }else if(indexPath.row == 3 || indexPath.row == 6){
        return 36.0f;
    }else if(indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 7){
        if (indexPath.row == 7) {
            return 5.0f;
        }
        return 10.0f;
    }else if(indexPath.row == 4){
        return [self getCellHeight:_taskDetailModel.taskInfo withWidth:ScreenWidth - 20] + 10 * 2;
    }else if(indexPath.row >= 8 && indexPath.row < 8 + _stepArray.count && _stepArray.count != 0){
        NSInteger step = indexPath.row - 8;
        WDTaskStepModel *stepModel = _stepArray[step];
        if ([stepModel.isImg intValue] == 1) {
            //要判断要有多少张图片确认布局,每行放置三个图片
            return 80.0f + [ToolClass getCellHeight:stepModel.stepName withFont:15 withWidth:ScreenWidth - 45];
        }else {
            return [self getCellHeight:stepModel.stepInfo withWidth:ScreenWidth - 62.5] + 15 + [ToolClass getCellHeight:stepModel.stepName withFont:15 withWidth:ScreenWidth - 45];
        }
    }else {
        if (_taskDetailModel.textSearch.length && (indexPath.row == 8 + _stepArray.count)) {
            //展示第三方跳转的按钮
            _hasSearchText = 1;
            return 50.0f;
        }
        //如果有素材
        if ([_taskDetailModel.isMaterial intValue] == 1 && !_taskDetailModel.material.materialUrl) {
            //暗色条
            if (indexPath.row == 8 + _stepArray.count + _hasSearchText) {
                return 10.0f;
            }else if(indexPath.row == 8 + _stepArray.count + 1 + _hasSearchText){
                return 30.0f;
            }else if(indexPath.row == 8 + _stepArray.count + 2 + _hasSearchText){
                CGFloat labelHeight = [self getCellHeight:_taskDetailModel.material.materialInfo withWidth:ScreenWidth - 20];
                NSInteger line  = _taskDetailModel.material.materialPics.count > 0 ? 1:0;
                return labelHeight + 100 * line  + 20;
            }else{
                //任务条
                if ([self.taskDetailModel.taskStatus isEqualToString:@"1"] && self.taskDetailModel.jumpUrl.length > 0) {
                    return 100.0f;
                }else{
                    return 60.0f;
                }
            }
        }else {
            if ([self.taskDetailModel.taskStatus isEqualToString:@"1"] && self.taskDetailModel.jumpUrl.length > 0) {
                return 100.0f;
            }else{
                return 60.0f;
            }
        }
        
    }
    return 0.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断是否有素材
    if (_taskDetailModel.textSearch.length > 0) {
        _hasSearchText = 1;
    }
    if([_taskDetailModel.isMaterial intValue] == 1 && !_taskDetailModel.material.materialUrl){
        return 11 + _stepArray.count + 1 + _hasSearchText;
    }else{
        return 8 + _stepArray.count + 1 + _hasSearchText;
        
    }
    
}


- (CGFloat)getCellHeight:(NSString *)str withWidth:(CGFloat)width{
    CGSize size = CGSizeMake(width,MAXFLOAT); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceil(labelsize.height);
}

#pragma mark 点击领取任务的按钮；
- (void)taskButtonClick:(UIButton *)button{
    [MobClick event:@"getTask"];
    //判断是否登录
    if (![WDUserInfoModel shareInstance].memberId || [WDUserInfoModel shareInstance].memberId.length == 0) {
        [self callLoginVC];
        return ;
    }
    
    //如果有弹窗的话
    
    if ([self.taskDetailModel.taskStatus isEqualToString:@"-1"] || [self.taskDetailModel.taskStatus isEqualToString:@"0"]||
        [self.taskDetailModel.taskStatus isEqualToString:@"3"]) {
        if ([_taskDetailModel.isPopup intValue] == 1) {
            WeakStament(weakSelf);
            UIAlertController *controllerAlert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:_taskDetailModel.popupWord preferredStyle:UIAlertControllerStyleAlert];
            [controllerAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [controllerAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //首先要判断是否登陆了，如果没有登录的话，要先跳转到登录界面
                [weakSelf getTask];
            }]];
            [self presentViewController:controllerAlert animated:YES completion:nil];
            return;
        }else{
            //如果没有弹窗，直接请求任务
            [self getTask];
        }
        //已经开始任务了，可以进行任务的提交
    }else if([self.taskDetailModel.taskStatus isEqualToString:@"1"]){
        //进行任务的提交
        [self commitTask];
    }
}


- (void)getTask{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WeakStament(weakSelf);
    NSString *memberId = [WDUserInfoModel shareInstance].memberId;
    if (!memberId) {
        memberId = @"";
    }
    [param setObject:_taskId forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kTaskGetTaskUrl setParameters:param success:^(id responseObject) {
        NSInteger code = [responseObject[@"result"][@"code"] intValue];
        if(code == 1000){
            //成功的领取任务以后，重新加载
            NSDictionary *dataDic = responseObject[@"data"];
            weakSelf.taskDetailModel.joinMemberCount = dataDic[@"joinMemberCount"];
            weakSelf.taskDetailModel.taskStatus = @"1";
            NSInteger lastIndex;
            if([_taskDetailModel.isMaterial intValue] == 1 && !_taskDetailModel.material.materialUrl){
                lastIndex =  11 + _stepArray.count  + _hasSearchText;
            }else{
                lastIndex = 8 + _stepArray.count  + _hasSearchText;
            }
            [self.taskDetailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
            [self.taskDetailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            self.taskDetailModel.taskSubmitLeftSec = nil;
            [self.taskDetailTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.timer setFireDate:[NSDate date]];
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
            [weakSelf firstGetTask];
        }else{
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
        };
    } fail:^(NSError *error) {
    } delegater:self.view];
}

#pragma mark 第一次成功领取了任务
- (void)firstGetTask{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstGetTask"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstGetTask"];
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        UIImageView *firstSuccessGetTaskView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 40, ScreenHeight - 64)];
        firstSuccessGetTaskView.userInteractionEnabled = YES;
        firstSuccessGetTaskView.image = [UIImage imageNamed:@"doGood"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageRemove)];
        [firstSuccessGetTaskView addGestureRecognizer:tapGesture];
        [_coverView addSubview:firstSuccessGetTaskView];
        [self.view addSubview:_coverView];
        [self.view bringSubviewToFront:_coverView];
    }
}
- (void)imageRemove{
    [_coverView removeFromSuperview];
}
#pragma mark 点击了评论任务
- (void)commentButtonClick:(UIButton *)button{
    
    if (![WDUserInfoModel shareInstance].memberId || [WDUserInfoModel shareInstance].memberId.length == 0) {
        [self callLoginVC];
        return ;
    }
    
    WDTaskCommentController *commentController = [WDTaskCommentController new];
    commentController.taskId = _taskId ;
    [self.navigationController pushViewController:commentController animated:YES];
}
#pragma mark 点击了分享按钮
-(void)shareButtonClick:(UIButton *)button{
    if (![WDUserInfoModel shareInstance].memberId || [WDUserInfoModel shareInstance].memberId.length == 0) {
        [self callLoginVC];
        return ;
    }
    UIImage *image = [UIImage imageNamed:@"iicon"];
//    [UMCustomManager shareWebWithViewController:self ShareTitle:_taskDetailModel.taskName Content:_taskDetailModel.taskInfo ThumbImage:image Url:_taskDetailModel.shareUrl];
}
#pragma mark 任务收藏
- (void)collectionTask{
    if (![WDUserInfoModel shareInstance].memberId || [WDUserInfoModel shareInstance].memberId.length == 0) {
        [self callLoginVC];
        return ;
    }
    NSDictionary *param = @{@"bi.mi":[WDUserInfoModel shareInstance].memberId,@"type":@2,@"productId":_taskId};
    //判断是否是收藏
    WeakStament(weakSelf);
    if ([self.taskDetailModel.isCollected integerValue] == 0) {
        [WDNetworkClient postRequestWithBaseUrl:kAddMemberCollectionUrl setParameters:param  success:^(id responseObject) {
            if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
                [ToolClass showAlertWithMessage:@"收藏成功"];
                weakSelf.favoriteButton.selected = YES;
                weakSelf.taskDetailModel.isCollected = @"1";
            }else{
                [ToolClass showAlertWithMessage:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"msg"]]];
            }
        } fail:^(NSError *error) {
        } delegater:self.view];
    }else{
        [WDNetworkClient postRequestWithBaseUrl:kCancelMemberCollectionUrl setParameters:param  success:^(id responseObject) {
            [ToolClass showAlertWithMessage:@"取消收藏"];
            weakSelf.favoriteButton.selected = NO;
            weakSelf.taskDetailModel.isCollected = @"0";
        } fail:^(NSError *error) {
        } delegater:self.view];
    }
}
#pragma mark 提交任务
- (void)commitTask{
    WDCommitTaskController *controller = [[WDCommitTaskController alloc]  init];
    NSArray *images;
    //默认上传截图都是最后一步
    for (NSInteger index = _stepArray.count - 1; index >= 0; index--) {
        WDTaskStepModel *stepModel = _stepArray[index];
        if ([stepModel.isImg intValue] == 1) {
            images = stepModel.images;
            break;
        }
    }
 
    
    controller.imageArray = images;
    controller.isNeedPic = self.taskDetailModel.isNeedPic;
    controller.isNeedCommet = self.taskDetailModel.isNeedCommet;
    controller.isNeedUserAccount = self.taskDetailModel.isNeedUserAccount;
    controller.taskId = self.taskId;
    controller.stepArray = _stepArray;
    WeakStament(weakSelf);
    controller.successBlock = ^(){
        //进入审核状态
        [weakSelf prepareData];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 去做任务
- (void)doTaskButtonClick:(UIButton *)button{
    //判断是否是调查问卷，如果是调查问卷的话
    //进行监控
    [MobClick event:@"doTask"];
    NSDictionary *param = @{@"taskId":_taskId};
    [WDNetworkClient postRequestWithBaseUrl:kDownloadTask setParameters:param  success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            YYLog(@"开始监控");
        }
    } fail:^(NSError *error) {
    } delegater:self.view];
    
    if ([self.taskDetailModel.taskType isEqualToString:@"3"]) {
        WDUserInfoModel *userModel = [WDUserInfoModel shareInstance];
        NSString *surveyUrl =[NSString stringWithFormat:@"%@&taskId=%@&mobile=%@&memberId=%@",self.taskDetailModel.jumpUrl,self.taskDetailModel.taskId,userModel.mobile,userModel.memberId];
        dispatch_async(dispatch_get_main_queue(), ^{
            WDSCWebViewController *webViewController = [[WDSCWebViewController alloc] init];
            webViewController.url = surveyUrl;
            //如果成功的情况下进行刷线
            WeakStament(weakSelf);
            webViewController.successblock = ^(){
                weakSelf.taskDetailModel.taskStatus = @"2";
                [weakSelf.taskDetailTableView reloadData];
            };
            [self.navigationController pushViewController:webViewController animated:YES];
        });
        
        return;
    }
    
    //获取原生的字符串,如果含有itunes.apple.com，需要跳转到应用市场去下载应用
    if ([self.taskDetailModel.jumpUrl containsString:@"itunes.apple.com"]) {
        NSURL *url = [NSURL URLWithString:self.taskDetailModel.jumpUrl];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        return;
    }
    
    //应该进行分享
    if (_taskDetailModel.material.materialTitle) {
        
        UIImage *image = [UIImage imageNamed:@"iicon"];
        if (_taskDetailModel.material.materialPic) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_taskDetailModel.material.materialPic]]];
        }
//        [UMCustomManager shareWebWithViewController:self ShareTitle:_taskDetailModel.material.materialTitle Content:_taskDetailModel.material.materialInfo ThumbImage:image Url:_taskDetailModel.jumpUrl];
        return ;
    }
    
    WDH5DoTaskViewController *doTaskViewController = [[ WDH5DoTaskViewController alloc] init];
    doTaskViewController.url = self .taskDetailModel.jumpUrl;
    doTaskViewController.navTitle = @"任务详情";
    [self.navigationController pushViewController:doTaskViewController animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
}

@end
