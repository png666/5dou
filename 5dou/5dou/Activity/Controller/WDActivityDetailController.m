//
//  WDActivityDetailController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDActivityDetailController.h"
#import "WDLoginViewController.h"

#import "MJRefresh.h"
#import "WDDefaultAccount.h"
#import "UMCustomManager.h"
#import "ToolClass.h"

#import "WDCommentCell.h"
#import "WDTaskButtonCell.h"
#import "WDActDetailView.h"
#import "WDNoneData.h"
#import "WDAboutPlatformViewController.h"
#import "WDCommentModel.h"

//#import "IQKeyboardManager.h"
#import "WDSCWebViewController.h"
#import "UITableViewCell+Ext.h"




#define pageSize 15
@interface WDActivityDetailController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic,strong) NSMutableArray *commentList;
/**
 *  详情页上面的视图
 */
@property (nonatomic,strong) WDActDetailView *actDetailView;
@property (nonatomic, strong) WDNoneData *noneDataView;
@property (nonatomic,strong) UIButton *joinActivityButton;
//标记是跳转外链还是内部页面 1 外链  0 内部页面
@property(nonatomic,copy)NSString *clickTo;
//外链链接
@property(nonatomic,copy)NSString *productUrl;
//内部跳转，产品id,需要跳转到产品详情
@property(nonatomic,copy)NSString *productCode;
@property(nonatomic,strong)UIView *bottomBtnBg;//底部背景View

@end
@implementation WDActivityDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareActData];
    [self prepareCommentList:0];
    [self prepareUI];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"活动详情"];
    self.navigationController.navigationBarHidden = false;
    
}

//该方法处理下面参加活动按钮的点击隐藏
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.productCode.length>1||self.productUrl.length>1) {
        [self steupJoinActivityButton];
    }else{
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"活动详情"];
}


- (void)prepareUI{
    NSString *title = @"";
    if(_requestType == RequestTypeNews){
        title = @"逗新闻";
    }else if(_requestType == ReuqestTypeActivity){
        title = @"活动详情";
    }
    [self.navigationItem setItemWithTitle:title textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 29, 29) title:@"" Image:@"fenxiang" selectedIMG:@"" tartget:self action:@selector(shareActivity:)];
    [self.view addSubview:self.commentTableView];
    _commentList = [NSMutableArray array];
}

- (void)shareActivity:(UIBarButtonItem *)button{
    YYLog(@"进行分享");
    NSDictionary *dict = self.actDetailView.actDetailDict;
    UIImage *image = [UIImage imageNamed:@"iicon"];
    NSString *title ;
    if (_requestType == RequestTypeNews) {
        title = @"逗新闻";
    }else if(_requestType == ReuqestTypeActivity){
        //        title = @"5dou活动";
        title= @"逗活动";
    }
    
    //分享操作
//    [UMCustomManager shareWebWithViewController:self ShareTitle:title Content:[dict objectForKey:@"title"] ThumbImage:image Url:[dict objectForKey:@"shareUrl"]];
}

#pragma mrak - 底部参加活动按钮
- (void)steupJoinActivityButton{
    UIView *buttonBg = [[UIView alloc] init];
    buttonBg.backgroundColor = kWhiteColor;
    buttonBg.frame = CGRectMake(0, ScreenHeight - 64 - 50, ScreenWidth, 50);
    self.bottomBtnBg = buttonBg;
    [self.view addSubview:buttonBg];
    
    UIButton *commitTaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitTaskButton.frame = CGRectMake((ScreenWidth - 165) * 0.5,(50 - 35) * 0.5,165,35);
    [commitTaskButton setTitle:@"参加活动" forState:UIControlStateNormal];
    [commitTaskButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [commitTaskButton addTarget:self action:@selector(participateActivity) forControlEvents:UIControlEventTouchUpInside];
    [commitTaskButton setBackgroundImage:[UIImage imageNamed:@"buttonState_yellow"] forState:UIControlStateNormal];
    [buttonBg addSubview:commitTaskButton];
}

#pragma mark - 参加活动
/**
 点击参加活动按钮
 */
-(void)participateActivity
{
    //参加活动按钮：两种情况：h5（外链）和任务详情
    if ([self.clickTo isEqualToString:@"1"]) {
        WDAboutPlatformViewController *h5 = [WDAboutPlatformViewController new];
        //
        h5.productUrl = self.productUrl;
        [self.navigationController pushViewController:h5 animated:YES];
    }else{
        
        [super prepareDataDetail:self.productCode];
        
    }
    
}
#pragma mark - 评论列表数据
- (void)prepareCommentList:(NSInteger)toPage{
    WeakStament(weakSelf);
    NSDictionary *param = @{@"productId":_activityID,@"type":[NSString stringWithFormat:@"%ld",(long)_requestType],@"pageInfo.pageSize":[NSNumber numberWithInteger:pageSize],@"pageInfo.toPage":[NSNumber numberWithInteger:toPage]};
    [WDNetworkClient postRequestWithBaseUrl:kCommentList setParameters:param success:^(id responseObject) {
        if (toPage == 0) {
            [weakSelf.commentList removeAllObjects];
        }
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        //如果有数据的情况下
        if (newArray.count != 0) {
            for (NSDictionary *commentDic in newArray) {
                WDCommentModel *model = [[WDCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:commentDic];
                [weakSelf.commentList addObject:model];
            }
            [weakSelf.commentTableView.mj_footer endRefreshing];
        }else{
            [weakSelf.commentTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.commentTableView reloadData];
        if (weakSelf.commentList.count == 0) {
            self.commentTableView.tableFooterView = self.noneDataView;
        }else{
            self.commentTableView.tableFooterView = nil;
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

#pragma mark - 头部webview数据
- (void)prepareActData{
    WeakStament(weakSelf);
    //请求详情
    NSDictionary *param;
    NSString *url;
    if (_requestType == RequestTypeNews) {
        param = @{@"newsId":_activityID};
        url = kFindNewsDetail;
    }else{
        param = @{@"activityId":_activityID};
        YYLog(@"activityId = %ld",(long)_activityID);
        url = kActivityDetail;
    }
    [WDNetworkClient postRequestWithBaseUrl:url setParameters:param success:^(id responseObject) {
        
        YYLog(@"ActivityInfo == %@",responseObject);
        
        weakSelf.actDetailView.actDetailDict =  responseObject[@"data"];
        NSDictionary *dic = responseObject[@"data"];
        self.clickTo = dic[@"clickTo"];
        
        self.productCode = dic[@"productCode"];
        self.productUrl = dic[@"productUrl"];
        
    } fail:^(NSError *error) {
        
        
    } delegater:self.view];
}


/**
 评论的tableview
 */
- (UITableView *)commentTableView{
    if (!_commentTableView) {
        
//        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.requestType==3?(ScreenHeight-64-50) : (ScreenHeight - 64)) style:UITableViewStylePlain];
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        //进行注册
        [_commentTableView registerNib:[UINib nibWithNibName:@"WDCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WDCommentCell"];
        _commentTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    }
    return _commentTableView;
}

/**
 活动详情上部分是一个webview,后台返回的就是webview的脚本
 */
- (WDActDetailView *)actDetailView{
    if (!_actDetailView) {
        _actDetailView = [WDActDetailView view];
        //设置调用高度的block
        WeakStament(weakSelf);
        _actDetailView.actUpdateFrameBlock = ^(NSInteger newHeight){
            weakSelf.actDetailView.frame = CGRectMake(0, 0, ScreenWidth, newHeight + 245);
            weakSelf.commentTableView.tableHeaderView = weakSelf.actDetailView;
        };
        //webView开启了网址探测，点击探测到的网址后进行跳转
        _actDetailView.openWebViewBlock = ^(NSString *urlStr){
            WDSCWebViewController *scViewController = [[WDSCWebViewController alloc] init];
            scViewController.url = urlStr;
            scViewController.isNotSC = YES;
            [weakSelf.navigationController pushViewController:scViewController animated:YES];
        };
        _actDetailView.commentBlock = ^(NSString *commentStr){
            [weakSelf addComment:commentStr];
        };
    }
    return _actDetailView;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //评论数>15,显示一个加载更多按钮
    if (indexPath.row == _commentList.count && _commentList.count > pageSize) {
        WDTaskButtonCell *taskButtonCell = [WDTaskButtonCell cellWithTableView:tableView];
        [taskButtonCell.doTaskButton addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventTouchUpInside];
        return taskButtonCell;
    }
    WDCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"WDCommentCell"];
    
    //不加这个判断很危险，数组越界会直接崩掉
    if (self.commentList.count>indexPath.row) {
        WDCommentModel *commentModel = _commentList[indexPath.row];
        commentCell.commentModel = commentModel;
        commentCell.contentHeight.constant = [self commentHeight:commentModel.content];
    }
    commentCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return commentCell;
}

- (void)loadMoreData:(UIButton *)button{
    if (self.commentList.count % pageSize == 0) {
        NSInteger toPage = self.commentList.count / pageSize;
        [self prepareCommentList:toPage];
    }else{
        [ToolClass showAlertWithMessage:@"没有更多数据了"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentList.count <= pageSize ? _commentList.count : _commentList.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _commentList.count) {
        return 60;
    }
    return [self commentHeight:((WDCommentModel *)_commentList[indexPath.row]).content] + 78;
}

- (CGFloat)commentHeight:(NSString *)content{
    return [ToolClass getStrHeightWithStr:content andWidth:ScreenWidth - 16 andWithFont:[UIFont systemFontOfSize:15]];
}



/**
 添加评论接口
 
 @param commentStr 添加的评论
 */
- (void)addComment:(NSString *)commentStr{
    WeakStament(weakSelf);
    
    NSDictionary *userInfo = [WDDefaultAccount getUserInfo];
    NSString *memberId = userInfo[@"memberId"];
    if (!memberId) {
        [ToolClass showAlertWithMessage:@"请先登录再进行评论哦～"];
        return;
    }
    NSDictionary *commentDict = @{@"bi.mi":memberId,
                                  @"type":[NSNumber numberWithInteger:_requestType],
                                  @"productId":_activityID,
                                  @"comment":commentStr};
    [WDNetworkClient postRequestWithBaseUrl:kAddCommentUrl setParameters:commentDict success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            
            [ToolClass showAlertWithMessage:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"msg"]]];
            //清空评论
            weakSelf.actDetailView.commentTextView.text = @"";
            //成功了以后更新评论的数量
            NSString * commentNumber = responseObject[@"data"][@"commentCount"];
            weakSelf.actDetailView.commetNumberLabel.text = [NSString stringWithFormat:@"评论(%@)",commentNumber];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf prepareCommentList:0];
            });
        }else{
            [ToolClass showAlertWithMessage:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"msg"]]];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}



/**
 缺省页，当没有评论的时候显示的是缺省页
 */
- (WDNoneData *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [WDNoneData view];
        CGRect frame = _noneDataView.frame;
        frame.size.width = ScreenWidth;
        frame.size.height = 150;
        _noneDataView.frame = frame;
        WeakStament(weakSelf);
        //刷新评论列表
        _noneDataView.noneDataBlock = ^(){
            [weakSelf prepareCommentList:0];
        };
    }
    return _noneDataView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
