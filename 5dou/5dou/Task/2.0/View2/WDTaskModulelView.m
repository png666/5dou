//
//  WDTaskMoudelView.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/17.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskModulelView.h"
#import "WDTaskButton.h"
#import "WDTaskStepModel.h"
#import "ToolClass.h"
#import "WDTaskAccountCell.h"
#import "WDTaskStepCell.h"
#import "WDSearchTextCell.h"
#import "WDSelectPhotoViewCell.h"
#import "WDInputViewCell.h"
#import "WDPhotosViewCell.h"
#import "WDTaskLimitCell.h"
#import "WDTaskMaterialModel.h"
#import "UITableViewCell+Ext.h"
#import "WDSCWebViewController.h"
#import "CKAlertViewController.h"

/**登陆页面*/
#import "WDLoginViewController.h"
#import "WDUserInfoModel.h"
#import "UMCustomManager.h"
#import "WDH5DoTaskViewController.h"
#import "WDNoneData.h"
#import "WDH5BaseController.h"
#define TaskInfo   10001
#define TaskStep   10002
#define TaskCommit 10003
#define ModuleHeight  ScreenHeight - 38.5 - 155 - 64
@interface WDTaskModulelView() <UITableViewDelegate,UITableViewDataSource,WDSearchTextCellDelegate>{
    WDTaskButton *_infoButton;
    WDTaskButton *_stepButton;
    WDTaskButton *_commitButton;
    /**是否有搜索拷贝的文字*/
    int _hasSearchText;
    /**是否包含素材*/
    int _hasMaterial;
    /**是否需要上传图片*/
    int _hasPic;
    /**是否需要账号*/
    int _hasAccount;
    /**上传图片的坐标*/
    int _needPhotoIndex;
    //    NSString *_leaveMessageStr;
    //    NSString *_userAccountStr;
}
@property (nonatomic,strong) UIScrollView *taskScrollView;
/**任务按钮，根据状态的不同，显示也不同*/
@property (nonatomic,strong) UIButton *taskStateButton;
/**提交任务按钮，根据状态的不同，限时的也不同*/
@property (nonatomic,strong) UIButton *commitTaskButton;
@property (nonatomic,strong) UIButton *doTaskButton;
/**
 信息模块相关的操作
 */
@property (nonatomic,strong) UIView *infoView;
/**
 信息列表
 */
@property (nonatomic,strong) UITableView *infoTableView;

/**
 步骤模块相关的操作
 */
@property (nonatomic,strong) UIView *stepView;
/**
 任务步骤列表
 */
@property (nonatomic,strong) UITableView *stepTableView;
/**
 提交任务相关模块操作
 */
@property (nonatomic,strong) UIView *commitView;
/**
 提交任务列表
 */
@property (nonatomic,strong) UITableView *commitTableView;
/**步骤的数组*/
@property (nonatomic,strong) NSArray *stepArray;
/**素材*/
@property (nonatomic,strong) WDTaskMaterialModel *materialModel;
/**用来记录选择的图片*/
@property (nonatomic,strong) WDSelectPhotoViewCell *photoCell;
/**记录用户的信息*/
@property (nonatomic,strong) WDInputViewCell *userAccountCell;

@property (nonatomic,strong) WDInputViewCell *levelMessageCell;
/**缺省的页面*/
@property (nonatomic,strong) WDNoneData *noneDataView;
/**任务提交按钮底部*/
@property (nonatomic,strong) UIView *buttonBg;

@end
@implementation WDTaskModulelView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI{
    //初始化切换导航
    [self steupTaskBar];
    //初始化具体的页面信息
    [self steupTaskScrollView];
    [self changeButton:_infoButton];
}

#pragma mark - 上个页面传过来的数据源
- (void)setDetailModel:(WDTaskDetailModel *)detailModel{
    //这个model执行了两次
    _detailModel = detailModel;
    NSMutableArray *newStepArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *stepDict in _detailModel.steps) {
        WDTaskStepModel *stepModel = [WDTaskStepModel new];
        [stepModel setValuesForKeysWithDictionary:stepDict];
        [newStepArray addObject:stepModel];
    }
    //任务步骤
    self.stepArray = newStepArray;
    //任务素材
    self.materialModel = _detailModel.material;
    //判断是否有拷贝的文字
    if (detailModel.textSearch.length > 0) {
        _hasSearchText = 1;
    }
    //如果存在素材的话
    if ([detailModel.isMaterial isEqualToString:@"1"]) {
        _hasMaterial = 1;
    }
    //是否需要上传图片
    if ([detailModel.isNeedPic isEqualToString:@"1"]) {
        _hasPic = 1;
    }
    //是否需要提交支付宝账号
    if ([detailModel.isNeedUserAccount isEqualToString:@"1"]) {
        _hasAccount = 1;
    }
    //改变领取的状态
    //如果当前状态需要跳转做任务的页面
    if ([_detailModel.taskStatus intValue] == 1 && _detailModel.jumpUrl.length > 0) {
            [self changeButtonStatus:8];
    }else{
        [self changeButtonStatus:[_detailModel.taskStatus intValue]];
    }
}


- (void)steupTaskBar{
    CGFloat buttonWidth = (ScreenWidth - 17.5 * 2) / 3;
    CGFloat buttonHeight = 38.5;
    _infoButton = [WDTaskButton buttonWithType:UIButtonTypeCustom];
    _infoButton.frame = CGRectMake(17.5, 0, buttonWidth, buttonHeight);
    _infoButton.tag = TaskInfo;
    [_infoButton createWithTitle:@"基本信息"
                       withImage:@"jiben_normal"
                 withSelectImage:@"jiben_select"
                withDisableImage:@"jiben_normal"
                   withBackImage:@"button_yellow_left"];
    [_infoButton addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_infoButton];
    
    _stepButton = [WDTaskButton buttonWithType:UIButtonTypeCustom];
    _stepButton.frame = CGRectMake(17.5 + buttonWidth, 0, buttonWidth, buttonHeight);
    _stepButton.tag = TaskStep;
    [_stepButton createWithTitle:@"任务步骤"
                       withImage:@"buzhou_normal"
                 withSelectImage:@"buzhou_select"
                withDisableImage:@"buzhou_normal"
                   withBackImage:@"button_yellow"];
    [_stepButton addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_stepButton setTitle:@"任务步骤" forState:UIControlStateNormal];
    [self addSubview:_stepButton];
    
    _commitButton = [WDTaskButton buttonWithType:UIButtonTypeCustom];
    _commitButton.frame = CGRectMake(17.5 + buttonWidth * 2, 0, buttonWidth, buttonHeight);
    _commitButton.tag = TaskCommit;
    [_commitButton createWithTitle:@"提交任务"
                         withImage:@"tijiao_normal"
                   withSelectImage:@"tijiao_select"
                  withDisableImage:@"tijiao_normal"
                     withBackImage:@"button_yellow_right"];
    [_commitButton addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_commitButton setTitle:@"提交任务" forState:UIControlStateNormal];
    [self addSubview:_commitButton];
}

- (void)steupTaskScrollView{
    [self addSubview:self.taskScrollView];
    //基本信息
    [self.taskScrollView addSubview:self.infoView];
    //任务步骤
    [self.taskScrollView addSubview:self.stepView];
    //提交任务
    [self.taskScrollView addSubview:self.commitView];
}

/**
  改变标题按钮的状态
 @param sender 选中的具体的按钮
 */
- (void)changeButton:(UIButton *)sender{
    _infoButton.layer.shadowOffset = CGSizeZero;
    _infoButton.layer.shadowOpacity = 0.0;
    _infoButton.layer.shadowColor =  [UIColor clearColor].CGColor;
    
    _stepButton.layer.shadowOffset = CGSizeZero;
    _stepButton.layer.shadowOpacity = 0.0;
    _stepButton.layer.shadowColor =  [UIColor clearColor].CGColor;
    
    _commitButton.layer.shadowOffset = CGSizeZero;
    _commitButton.layer.shadowOpacity = 0.0;
    _commitButton.layer.shadowColor =  [UIColor clearColor].CGColor;
    
    if(sender.tag == TaskInfo){
        _infoButton.selected = YES;
        _stepButton.selected = NO;
        _commitButton.selected = NO;
        [_taskScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else if(sender.tag == TaskStep){
        _infoButton.selected = NO;
        _stepButton.selected = YES;
        _commitButton.selected = NO;
        [_taskScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    }else if(sender.tag == TaskCommit){
        _infoButton.selected = NO;
        _stepButton.selected = NO;
        _commitButton.selected = YES;
        [_taskScrollView setContentOffset:CGPointMake(ScreenWidth * 2, 0) animated:NO];
    }
    
    sender.layer.shadowOffset =  CGSizeMake(0.5, 0.5);
    sender.layer.shadowOpacity = 0.5;
    sender.layer.shadowColor =  kNavigationBarColor.CGColor;
    
}

#pragma mark 页面中，切换页面的UI布局
/*滑动的视图
 taskScrollView---->infoView---->infoTableView
              |
              |---->stepView---->stepTableView
              |            |---->stepButton
              |
              |---->commitView-->commitTableView
                           |----->commitButton
 
 */
- (UIScrollView *)taskScrollView{
    if (!_taskScrollView) {
        _taskScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 38.5, ScreenWidth, ModuleHeight)];
        _taskScrollView.showsVerticalScrollIndicator = NO;
        _taskScrollView.showsHorizontalScrollIndicator = NO;
        _taskScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
        _taskScrollView.pagingEnabled = YES;
        _taskScrollView.delegate = self;
        _taskScrollView.backgroundColor = WDColorFrom16RGB(0xf4f4f4);
    }
    return _taskScrollView;
}

#pragma mark - 基本信息View
- (UIView *)infoView{
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ModuleHeight)];
        _infoView.backgroundColor = [UIColor clearColor];
        [_infoView addSubview:self.infoTableView];
    }
    return _infoView;
}

#pragma mark - 基本信息View子视图上table
- (UITableView *)infoTableView{
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ModuleHeight - 60) style:UITableViewStylePlain];
        _infoTableView.tag = TaskInfo;
        _infoTableView.dataSource = self;
        _infoTableView.delegate = self;
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _infoTableView.backgroundColor = WDColorFrom16RGB(0xf4f4f4);
        _infoTableView.showsHorizontalScrollIndicator = NO;
        _infoTableView.showsVerticalScrollIndicator = NO;
        _infoTableView.bounces = NO;
    }
    return _infoTableView;
}
#pragma mark - 步骤View
- (UIView *)stepView{
    if (!_stepView) {
        _stepView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ModuleHeight)];
        _stepView.backgroundColor = [UIColor clearColor];
        [_stepView addSubview:self.stepTableView];
        [self steupStateButton];
    }
    return _stepView;
}
#pragma mark - 步骤View 上的table
- (UITableView *)stepTableView{
    if (!_stepTableView) {
        _stepTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ModuleHeight - 70) style:UITableViewStylePlain];
        _stepTableView.tag = TaskStep;
        _stepTableView.dataSource = self;
        _stepTableView.delegate = self;
        _stepTableView.backgroundColor = WDColorFrom16RGB(0xf4f4f4);
        _stepTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _stepTableView.showsHorizontalScrollIndicator = NO;
        _stepTableView.showsVerticalScrollIndicator = NO;
        _stepTableView.bounces = NO;
    }
    return _stepTableView;
}

#pragma mark 任务状态和去做任务按钮的初始化
- (void)steupStateButton{
    UIView *buttonBg = [[UIView alloc] init];
    buttonBg.backgroundColor = kWhiteColor;
    buttonBg.frame = CGRectMake(0, ModuleHeight - 60, ScreenWidth, 60);
    [_stepView addSubview:buttonBg];
    //任务状态按钮
    _taskStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _taskStateButton.frame = CGRectMake((ScreenWidth - 165) * 0.5,(60 - 40) * 0.5,165,40);
    [_taskStateButton addTarget:self action:@selector(getTaskButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_taskStateButton setTitleColor:kFirstLevelBlack forState:UIControlStateNormal];
    //去做任务按钮
    _doTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doTaskButton.frame = CGRectMake((ScreenWidth - 165) * 0.5,(60 - 40) * 0.5,165,40);
    [_doTaskButton setTitleColor:kFirstLevelBlack forState:UIControlStateNormal];
    [_doTaskButton setBackgroundImage:[UIImage imageNamed:@"buttonState_yellow"] forState:UIControlStateNormal];
    [_doTaskButton setTitle:@"去做任务" forState:UIControlStateNormal];
    [_doTaskButton addTarget:self action:@selector(doTaskButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonBg addSubview:_taskStateButton];
    [buttonBg addSubview:_doTaskButton];
}

- (UIView *)commitView{
    if (!_commitView) {
        _commitView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ModuleHeight)];
        _commitView.backgroundColor = [UIColor clearColor];
        [_commitView addSubview:self.commitTableView];
        [self steupCommitButton];
        [_commitView addSubview:self.noneDataView];
    }
    return _commitView;
    
}

- (void)steupCommitButton{
    _buttonBg = [[UIView alloc] init];
    _buttonBg.backgroundColor = kWhiteColor;
    _buttonBg.frame = CGRectMake(0, ModuleHeight - 50, ScreenWidth, 50);
    [_commitView addSubview:_buttonBg];
    
    _commitTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitTaskButton.frame = CGRectMake((ScreenWidth - 165) * 0.5,(50 - 35) * 0.5,165,35);
    [_commitTaskButton setTitle:@"提交任务" forState:UIControlStateNormal];
    [_commitTaskButton setBackgroundImage:[UIImage imageNamed:@"buttonState_yellow"] forState:UIControlStateNormal];
    [_commitTaskButton addTarget:self action:@selector(commitTaskButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_buttonBg addSubview:_commitTaskButton];
}

- (UITableView *)commitTableView{
    if (!_commitTableView) {
        _commitTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ModuleHeight - 60) style:UITableViewStylePlain];
        _commitTableView.tag = TaskCommit;
        _commitTableView.dataSource = self;
        _commitTableView.delegate = self;
        _commitTableView.backgroundColor = WDColorFrom16RGB(0xf4f4f4);
        _commitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commitTableView.showsHorizontalScrollIndicator = NO;
        _commitTableView.showsVerticalScrollIndicator = NO;
        _commitTableView.bounces = YES;
    }
    return _commitTableView;
}


- (WDNoneData *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [WDNoneData view];
        _noneDataView.frame = CGRectMake(10, 0, ScreenWidth - 20 , ModuleHeight - 20);
        _noneDataView.backgroundColor = [UIColor whiteColor];
        _noneDataView.layer.cornerRadius = 10;
        _noneDataView.clipsToBounds = YES;
    }
    return _noneDataView;
}
#pragma mark UITableViewDelegate,UITableViewDataSource
/**三个TableView的代理都有本UIView担当，分别用tableview的tag进行区分*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case TaskInfo:
        {
            if (indexPath.row == 0) {
                return 80;
            }else if(indexPath.row == 1){
                CGFloat taskAccountHeight = [ToolClass getSpaceLabelHeight:_detailModel.taskInfo withFont:[UIFont systemFontOfSize:14] withWidth:ScreenWidth - 50];
                return taskAccountHeight + 50;
            }
        }
        case TaskStep:
        {
            //如果是素材的话，返回素材
            if (indexPath.row < _stepArray.count) {
                WDTaskStepModel *stepModel = _stepArray[indexPath.row];
                CGFloat padding = 45;
                CGFloat stepNameHeight = [ToolClass getCellHeight:stepModel.stepName withFont:16 withWidth:ScreenWidth - 70];
                CGFloat stepInfoHeight = [ToolClass getSpaceLabelHeight:stepModel.stepInfo withFont:[UIFont systemFontOfSize:14] withWidth:ScreenWidth - 50];
                if (stepInfoHeight != 0) {
                    padding += 10;
                }
                //如果有图片
                if ([stepModel.isImg intValue] == 1) {
                    padding = padding + 80 + 10;
                }else{
                    padding += 15;
                }
                return padding + stepInfoHeight + stepNameHeight ;
            }
            
            if (_hasMaterial && (indexPath.row == _stepArray.count)) {
                CGFloat padding = 45;
                CGFloat stepNameHeight = [ToolClass getCellHeight:@"任务素材" withFont:16 withWidth:ScreenWidth - 70];
                CGFloat stepInfoHeight = [ToolClass getSpaceLabelHeight:_detailModel.material.materialInfo withFont:[UIFont systemFontOfSize:14] withWidth:ScreenWidth - 50];
                if (stepInfoHeight != 0) {
                    padding += 10;
                }
                //如果有图片
                if (_materialModel.materialPics.count > 0) {
                    padding = padding + 80 + 10;
                }
                return padding + stepInfoHeight + stepNameHeight;
            }
            
            
            if (_hasSearchText && (indexPath.row == _stepArray.count + _hasMaterial)) {
                return 100;
            }
            
        }
            break;
        case TaskCommit:
        {
            
            if (_hasPic && (indexPath.row == 0)) {
                return 120;
            }
            
            if (_hasPic && (indexPath.row == 1)) {
                return 120;
            }
            
            if (_hasAccount && (indexPath.row == _hasPic * 2)) {
                return 90;
            }
            
            if (indexPath.row == _hasPic * 2 + _hasAccount) {
                return 145;
            }
            
        }
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (tableView.tag) {
        case TaskInfo:
        {
            if (indexPath.row == 0) {
                //返回任务限制
                cell = [WDTaskLimitCell cellWithTableView:tableView];
                return cell;
            }else if(indexPath.row == 1){
                //返回任务简介
                cell = [WDTaskAccountCell cellWithTableView:tableView];
                NSString *infoStr = [[_detailModel.taskInfo stringByReplacingOccurrencesOfString:@"<br>" withString:@""] stringByReplacingOccurrencesOfString:@"</br>" withString:@""] ;
                [ToolClass setLabelSpace: ((WDTaskAccountCell *)cell).accountLabel withValue:infoStr withFont:[UIFont systemFontOfSize:14]];
                return cell;
            }
        }
        case TaskStep:
        {
            //返回任务步骤，如果任务存在素材的话，返回任务素材
            if (indexPath.row < _stepArray.count) {
                cell = [WDTaskStepCell cellWithTableView:tableView];
                WDTaskStepModel *stepModel = _stepArray[indexPath.row];
                ((WDTaskStepCell *)cell).stepLabel.text = [self addZero:(indexPath.row + 1)];
                ((WDTaskStepCell *)cell).stepModel = stepModel;
                ((WDTaskStepCell *)cell).stepImageView.hidden = YES;
                return cell;
            }
            
            if (_hasMaterial && (indexPath.row == _stepArray.count)) {
                cell = [WDTaskStepCell cellWithTableView:tableView];
                WDTaskStepModel *stepModel = [[WDTaskStepModel alloc] init];
                stepModel.stepInfo = _materialModel.materialInfo;
                stepModel.stepName = @"任务素材";
                stepModel.images = _materialModel.materialPics;
                if (stepModel.images.count > 0) {
                    stepModel.isImg = @"1";
                }
                ((WDTaskStepCell *)cell).stepModel = stepModel;
                ((WDTaskStepCell *)cell).stepImageView.hidden = NO;
                return cell;
                
            }
            
            if (_hasSearchText && (indexPath.row == _stepArray.count + _hasMaterial)) {
                
                cell = [[WDSearchTextCell alloc] init];
                ((WDSearchTextCell *)cell).searchTextStr = _detailModel.textSearch;
                ((WDSearchTextCell *)cell).delegate = self;
                return cell;
            }
        }
            
            
            break;
            
        case TaskCommit:
        {
            //返回截图示例
            if (_hasPic && (indexPath.row == 0)) {
                cell = [WDPhotosViewCell cellWithTableView:tableView];
                //默认上传的图片应该取图片的最后一步中的
                WDTaskStepModel *lastModel = [_stepArray lastObject];
                ((WDPhotosViewCell *)cell).photoArray = lastModel.images;
                return cell;
            }
            
            //返回上传的图片列表
            if (_hasPic && (indexPath.row == 1)) {
                _photoCell = [WDSelectPhotoViewCell cellWithTableView:tableView];
                return _photoCell;
            }
            
            //返回填写用户信息
            if (_hasAccount && (indexPath.row == _hasPic * 2)) {
                _userAccountCell = [WDInputViewCell cellWithTableView:tableView];
                _userAccountCell.inputTitleLabel.text = @"填写注册账号";
                _userAccountCell.inputPlaceLabel.text = @"请输入手机号";
                return _userAccountCell;
            }
            
            //返回用户留言
            if (indexPath.row == _hasPic * 2 + _hasAccount) {
                _levelMessageCell = [WDInputViewCell cellWithTableView:tableView];
                _levelMessageCell.inputTitleLabel.text = @"填写留言（选填）";
                _levelMessageCell.inputPlaceLabel.text = @"写点留言吧";
                return _levelMessageCell;
            }
            
        }
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case TaskInfo:
        {
            return 2;
        }
        case TaskStep:
        {
            return _stepArray.count + _hasSearchText + _hasMaterial ;
        }
            break;
        case TaskCommit:
        {
            return _hasPic * 2 + _hasAccount + 1;
        }
            break;
        default:
            break;
    }
    return 0;
}



#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:_taskScrollView]) {
        int index = 0;
        index = _taskScrollView.contentOffset.x / ScreenWidth;
        if (index == 0) {
            [self changeButton:_infoButton];
        }else if(index == 1){
            [self changeButton:_stepButton];
        }else if(index == 2){
            [self changeButton:_commitButton];
    }
        return;
    }
}

#pragma mark -  WDSearchTextCellDelegate
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
    
    NSDictionary *param = @{@"taskId":_detailModel.taskId};
    [WDNetworkClient postRequestWithBaseUrl:kDownloadTask setParameters:param  success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            YYLog(@"开始监控");
        }
    } fail:^(NSError *error) {
    } delegater:self];
    //跳转appstore
    NSString *appStore = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@#software",[cell.searchTextStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:appStore];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma mark **********任务状态改变按钮*********

//[需要登录] :用户任务卡状态 -1:用户没有领取该任务 0:未使用;1:进行中;2:已完成;3:已放弃;4:待审核;5:审核不通过;6:已失效;
- (void)changeButtonStatus:(NSInteger)buttonType{
    if(buttonType == 0 || buttonType == -1){
        [_taskStateButton setTitle:@"领取任务" forState:UIControlStateNormal];
    }else if (buttonType == 1) {
        [_taskStateButton setTitle:@"已领取" forState:UIControlStateNormal];
    }else if(buttonType == 2){
        [_taskStateButton setTitle:@"已完成" forState:UIControlStateNormal];
    }else if(buttonType == 3){
        [_taskStateButton setTitle:@"重新领取" forState:UIControlStateNormal];
    }else if(buttonType == 4){
        [_taskStateButton setTitle:@"审核中" forState:UIControlStateNormal];
    }else if(buttonType == 5){
        [_taskStateButton setTitle:@"审核不通过" forState:UIControlStateNormal];
    }else if(buttonType == 6){
        [_taskStateButton setTitle:@"已失效" forState:UIControlStateNormal];
    }else if(buttonType == 7){
        [_taskStateButton setTitle:@"限时领取" forState:UIControlStateNormal];
    }
    
    [_taskStateButton setBackgroundImage:[UIImage imageNamed:@"buttonState_yellow"] forState:UIControlStateNormal];
    [_taskStateButton setBackgroundImage:[UIImage imageNamed:@"buttonState_grey"] forState:UIControlStateDisabled];
    //当任务没有领取或重新领取按钮可点击
    if (buttonType == 0 || buttonType == -1 || buttonType == 3 || buttonType == 8) {
        _taskStateButton.enabled = YES;
    }else{
        _taskStateButton.enabled = NO;
    }
    
    if (buttonType == 1 || buttonType == 7 || buttonType == 8)  {
        _noneDataView.hidden = YES;
        _buttonBg.hidden = NO;
    }
    
    
    if (buttonType == 2 || buttonType == 4 || buttonType == 5 || buttonType == 6) {
        _buttonBg.hidden = YES;
        _noneDataView.hidden = NO;
        _commitTaskButton.hidden = YES;
        [_noneDataView.imageView setImage:[UIImage imageNamed:@"rent_submit"]];
        _noneDataView.infoLabel.text = @"任务已提交";
    }
    
    //从新领取任务
    if (buttonType == 0 || buttonType == -1 || buttonType == 3) {
       
        _buttonBg.hidden = YES;
        [self.noneDataView.imageView setImage:[UIImage imageNamed:@"rent_receive"]];
        self.noneDataView.infoLabel.text = @"请先领取任务再来提交吧～";
        self.noneDataView.hidden = NO;
    }

    
    if (buttonType == 8) {
        _doTaskButton.hidden = NO;
        _taskStateButton.hidden = YES;
    }else{
        _doTaskButton.hidden = YES;
        _taskStateButton.hidden = NO;
    }
}


#pragma mark 去做任务
/*
 为了迎合后面调查问卷商家的接入
 “去做任务”按钮做如下修改：
 前端在URL后拼装一个参数：uid
 也就是URL里有问号的，则加上 &uid=xxxxxx
 URL里没有问号的，则加上 ?uid=xxxxx
 
 其中值为： 会员号@任务号
 比如：cd107acf-c66b-4866-98e1-e80b4004bd5c@000000AVD
 */
- (void)doTaskButtonClick{
    //进行监控
    [MobClick event:@"doTask"];
    NSDictionary *param = @{@"taskId":_detailModel.taskId};
    //点击去做任务按钮以后，进行监测
    [WDNetworkClient postRequestWithBaseUrl:kDownloadTask setParameters:param  success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            YYLog(@"成功点击按钮了");
        }
    } fail:^(NSError *error) {
    } delegater:self];
    //如果是问卷调查，跳转到问卷调查页面
    WeakStament(weakSelf);
    if ([self.detailModel.taskType isEqualToString:@"3"]) {
        WDUserInfoModel *userModel = [WDUserInfoModel shareInstance];
        NSString *surveyUrl = @"";
        if ([self.detailModel.jumpUrl containsString:@"?"]) {
              surveyUrl =[NSString stringWithFormat:@"%@&taskId=%@&mobile=%@&memberId=%@",self.detailModel.jumpUrl,self.detailModel.taskId,userModel.mobile,userModel.memberId];
        }else{
            surveyUrl =[NSString stringWithFormat:@"%@?1=1&taskId=%@&mobile=%@&memberId=%@",self.detailModel.jumpUrl,self.detailModel.taskId,userModel.mobile,userModel.memberId];
        }
      
        dispatch_async(dispatch_get_main_queue(), ^{
            WDSCWebViewController *webViewController = [[WDSCWebViewController alloc] init];
            webViewController.url = surveyUrl;
            webViewController.isNotSC = YES;
            //如果成功页面跳转以后
            webViewController.successblock = ^(){
                if (weakSelf.taskStateRefreshBlock) {
                    weakSelf.taskStateRefreshBlock(nil);
                }
            };
            [[self currentController].navigationController pushViewController:webViewController animated:YES];
        });
        
        return;
    }
    
    //获取原生的字符串,如果含有itunes.apple.com，需要跳转到应用市场去下载应用
    if ([self.detailModel.jumpUrl containsString:@"itunes.apple.com"]) {
        NSURL *url = [NSURL URLWithString:self.detailModel.jumpUrl];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        return;
    }
    
    //如果是分享活动的任务，需要进行分享
    if (_detailModel.material.materialTitle) {
        
        UIImage *image = [UIImage imageNamed:@"iicon"];
        if (_detailModel.material.materialPic) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_detailModel.material.materialPic]]];
        }
//        [UMCustomManager shareWebWithViewController:[self currentController] ShareTitle:_detailModel.material.materialTitle  Content:_detailModel.material.materialInfo ThumbImage:image Url:_detailModel.jumpUrl];
        return ;
    }
    
    //如果显示的是apk，那应该是安卓的任务
    if ([_detailModel.jumpUrl containsString:@".apk"]) {
        [ToolClass showAlertWithMessage:@"这个任务是安卓专属哦～"];
        return;
    }
    WDH5BaseController *doTaskViewController = [WDH5BaseController new];
    doTaskViewController.url = _detailModel.jumpUrl;
    doTaskViewController.title = @"任务详情";
    [[self currentController].navigationController pushViewController:doTaskViewController animated:YES];
}
#pragma mark 领取任务
- (void)getTaskButtonClick{
    
    [MobClick event:@"getTask"];
    //判断是否登录
    //如果没有登录的话,需要进行登录
    if (![WDUserInfoModel shareInstance].memberId || [WDUserInfoModel shareInstance].memberId.length == 0) {
        [self callLoginVC];
        return ;
    }
    //判断是不是限时任务
    if ([_detailModel.isCountDownTask isEqualToString:@"1"]) {
        [ToolClass showAlertWithMessage:@"任务尚未开始，请亲耐心等待"];
        return ;
    }
    //判断是否人数已经满了
    CGFloat joinNum = [_detailModel.joinMemberCount intValue];
    CGFloat limitNum = [_detailModel.memberCountLimit intValue];
    if (joinNum >= limitNum) {
        [ToolClass showAlertWithMessage:@"参与人数已满，下次手速快点哦~"];
        return;
    }
    //如果有弹窗的话，很奇怪，不知道为什么要后台判断是否进行弹窗提示
    __weak typeof (self) weakSelf = self;
    if ([_detailModel.isPopup intValue] == 1) {
        CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:_detailModel.popupWord];
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
            
        }];
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
            [weakSelf getTask];
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        [[self currentController] presentViewController:alertVC animated:NO completion:nil];
        return;
    }else{
        //如果没有弹窗，直接请求任务
        [self getTask];
    }
}

#pragma mark 登录页面
-(void)callLoginVC{
    __weak typeof (self) weakSelf = self;
    WDLoginViewController *login = [[WDLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    login.successLoginBlock = ^(){
        if (weakSelf.taskStateRefreshBlock) {
            weakSelf.taskStateRefreshBlock(nil);
        }
    };
    //解决present延迟弹出
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self currentController] presentViewController:nav animated:YES completion:^{
        }];
    });
}


#pragma mark 领取任务
- (void)getTask{
    WeakStament(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_detailModel.taskId forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kTaskGetTaskUrl setParameters:param success:^(id responseObject) {
        NSInteger code = [responseObject[@"result"][@"code"] intValue];
        if(code == 1000){
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
            
            //如果成功的话，去要判断是否有去做任务的按钮
            if (weakSelf.taskStateRefreshBlock) {
                weakSelf.taskStateRefreshBlock(nil);
            } 
            
        }else{
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
        };
    } fail:^(NSError *error) {
    } delegater:self];
}

#pragma mark 判断是否进行了点击的操作
- (void)isClickTaskButton{
    WeakStament(weakSelf);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:_detailModel.taskStatus forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kClickTaskUrl setParameters:param success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            if ([responseObject[@"data"][@"isClick"] isEqualToString:@"1"] ||
                [responseObject[@"data"][@"isClick"] isEqualToString:@"2"]) {
                [weakSelf commitTaskFirst];
            }else{
                [ToolClass showAlertWithMessage:@"亲~~点击去做任务，完成后才能提交哦~~"];
            }
        };
    } fail:^(NSError *error) {
        
    } delegater:self];
}

#pragma mark 任务提交页面
#pragma mark Click Event
- (void)commitTaskButtonClick {
    if (_detailModel.jumpUrl.length > 0) {
        [self isClickTaskButton];
    }else{
        [self commitTaskFirst];
    }
       //如果需要上传页面的话
}

- (void)commitTaskFirst{
    if ([_detailModel.isNeedPic isEqualToString:@"1"]) {
        if (_photoCell.selectedPhotos.count == 0) {
            [ToolClass showAlertWithMessage:@"没有选择图片哦~"];
            return;
        }
    }
    if ([_detailModel.isNeedUserAccount isEqualToString:@"1"]) {
        if (_userAccountCell.inputTextView.text.length == 0) {
            [ToolClass showAlertWithMessage:@"请填写上注册帐号信息"];
            return;
        }
    }
    if ([_detailModel.isNeedPic isEqualToString:@"0"]) {
        [self commitTask];
    }else{
        _needPhotoIndex = 0;
        [self uploadImage];
    }
}
//递归方式上传图片，后台设计的必须是1.2.3顺序上传
- (void)uploadImage{
    UIImage *image = _photoCell.selectedPhotos[_needPhotoIndex];
    NSData  *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSString  *base64ImageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSDictionary *picDict = @{@"taskId":_detailModel.taskId,@"index":[NSNumber numberWithInteger:(_needPhotoIndex + 1)],@"taskImg":base64ImageString};
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kUploadTaskPicture setParameters:picDict success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            _needPhotoIndex++;
            //如果上传成功了以后
            if (_needPhotoIndex == _photoCell.selectedPhotos.count) {
                [weakSelf commitTask];
            }else{
                [self uploadImage];
            }
        }else{
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
            _needPhotoIndex = 0;
        }
    } fail:^(NSError *error) {
        
    } delegater:self];
}
#pragma mark - 提交任务
- (void)commitTask{
    //判断是否上传成功了，要保证上传的图片和需要的图片一致，后台对图片有严格的限制，必须按照顺序来
    [MobClick event:@"commitTask"];
    WeakStament(weakSelf);
    NSString *message = _levelMessageCell.inputTextView.text ? _levelMessageCell.inputTextView.text : @"";
    NSString *account = _userAccountCell.inputTextView.text ?
    _userAccountCell.inputTextView.text : @"";
    NSDictionary *commitDict = @{@"taskId":_detailModel.taskId,@"comment":message,@"userAccount":account};
    _needPhotoIndex = 0;
    [WDNetworkClient postRequestWithBaseUrl:kSubmitTask setParameters:commitDict success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            
            [ToolClass showAlertWithMessage:@"3天内发布结果，请耐心等待"];
            
            //如果存在下一步任务
            if ([responseObject[@"data"][@"hasNextTask"] isEqualToString:@"1"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"你获得一张专属任务卡，\r\n请到我的－任务卡查看哦!"];
                    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"朕知道了" handler:^(CKAlertAction *action) {
                    }];
                    [alertVC addAction:sure];
                    [[self currentController] presentViewController:alertVC animated:NO completion:nil];
                });
            }else{
                
            }
            if (weakSelf.taskStateRefreshBlock) {
                weakSelf.taskStateRefreshBlock(nil);
            }
        }
        //自动审核失败
        else if([responseObject[@"result"][@"code"] isEqualToString:@"1023"]){
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
            
            if (weakSelf.taskStateRefreshBlock) {
                weakSelf.taskStateRefreshBlock(nil);
            }
        }else{
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self];
}


/**
 获取当前view所在的VC

 获取当前
 @return
 */
- (UIViewController *)currentController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

//任务步骤前面添加0
- (NSString *)addZero:(NSInteger)number{
    if (number < 10) {
        return [NSString stringWithFormat:@"0%ld",(long)number];
    }
    return [NSString stringWithFormat:@"%ld",(long)number];
}

- (void)dealloc{
    YYLog(@"Controller销毁");
}

@end
