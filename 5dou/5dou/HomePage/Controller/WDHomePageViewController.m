
//
//  WDHomePageViewController.m
//  5dou
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
#import "WDHomePageViewController.h"
#import "WDDouActivityViewController.h"
#import "WDTaskViewController.h"
#import "WDHomeListCell.h"
#import "WDTopView.h"
#import "WDHomeListModel.h"
#import "WDBannerModel.h"
#import "WDFourIconModel.h"
#import "WDSchoolNewsViewController.h"

#import "CKAlertViewController.h"
#import "WDMessageTypeViewController.h"
#import "ToolClass.h"
#import "UIColor+Hex.h"
#import "WDLocationViewController.h"
#import "WDDefaultAccount.h"
#import "WDCommanData.h"
#import "WDBannerModel.h"
#import "WDWebViewController.h"
#import "WDUserInfoModel.h"
#import "MJRefresh.h"
#import "DDSaveDataToCache.h"
#import "DQAlertView.h"
#import "WDLoginViewController.h"
#import "WDTaskSearchKeyController.h"
#import "WDCustomSearchBar.h"
#import "WDH5TaskViewController.h"
#import "WDActivityDetailController.h"
#import "CoverTomato.h"
#import "WDUnReadMessageModel.h"
#import "WDSCWebViewController.h"
#import "LocateManager.h"
#import "WDTaskModel.h"
#import "UIBarButtonItem+Badge.h"
#import "MJRefreshGifHeader+Ext.h"
#import <CoreLocation/CoreLocation.h>
#import "JPUSHService.h"
#import "WDTaskDetailViewController.h"
#import "WDTaskDetailController.h"
#import "WDTaskDescribeCell.h"
#import "WDActivityViewController.h"
#import "WDGainMoneyViewController.h"
#import "WDRankingViewController.h"
@interface WDHomePageViewController ()<UITextFieldDelegate,UISearchBarDelegate,DQAlertViewDelegate>
{
    UIButton *_cityBtn;
}
//@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
//@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)WDTopView *headerTopView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *bannerDataArray;
@property(nonatomic,strong)NSMutableArray *fourIconDataArray;
@property(nonatomic,strong)NSArray *fourIconsArray;
@property(nonatomic,copy)NSString *schoolImageUrl;
@property(nonatomic,strong)UITextField * searchTextField;
@property(nonatomic,strong)MJRefreshNormalHeader *MjHeader;
@property(nonatomic,strong)MJRefreshAutoNormalFooter *MJFooter;
@property(nonatomic,strong)UIView *badgeView;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)WDBannerModel *bannerModel;
@property(nonatomic,strong)UIView *searchBarView;
@property(nonatomic,strong)WDCustomSearchBar *searchBar;
@property (nonatomic, strong) WDUnReadMessageModel *messageModel;///< 未读消息数组
@property(nonatomic,assign)BOOL isReachable;
@end

static NSString *HomeCellID = @"HomeCell";
static NSString *headerID = @"header";
#define KListDataCache @"KListDataCache"
#define kSearchBarTag 201
//#define kVersionCheckKey @"versionCheck"
@implementation WDHomePageViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"%@",self.tabBarController.tabBar.selectedItem);
    
    self.dataArray = [NSMutableArray array];
    _bannerDataArray = [NSMutableArray array];
    _fourIconDataArray = [NSMutableArray array];
    [self.navigationItem setItemWithTitle:@"" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.navigationItem.leftBarButtonItem = nil;
//    self.isShowTabbar = true;
#pragma mark - 版本检测
    [self appVersionCheck];
    _currentPage = 0;
    [self loadData];
    self.headerTopView = [[WDTopView alloc]initWithFrame:CGRectZero];
    [self makeCollectionView];
    //判断是否登录状态
    if ([WDDefaultAccount getUserInfo]) {
        [[WDUserInfoModel shareInstance] saveUserInfoWithDic:[WDDefaultAccount getUserInfo]];
    }
    [self getUserLocation];
}

- (void)getUserLocation{
    [[LocateManager shareInstance] locateWithSuccessBlock:^(NSString *cityName) {
        if (cityName.length == 2) {
            _cityBtn.titleLabel.font = kFont14;
        }else if(cityName.length == 3){
            _cityBtn.titleLabel.font = kFont12;
        }else{
            _cityBtn.titleLabel.font = kFont9;
        }
        [_cityBtn setTitle:cityName forState:UIControlStateNormal];
        [self locationCity:cityName];
    } failBlock:^(NSError *error) {
        [_cityBtn setTitle:@"上海" forState:UIControlStateNormal];
        //根据城市名获取provinceid、cityCode
        [self locationCity:_cityBtn.currentTitle];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
      [MobClick beginLogPageView:@"首页"];

    self.navigationController.navigationBarHidden = true;
    
    if ([WDDefaultAccount cityName] && [WDDefaultAccount cityId]) {
        NSString *cityName = [WDDefaultAccount cityName];
        if (cityName.length == 2) {
            _cityBtn.titleLabel.font = kFont14;
        }else if(cityName.length == 3){
            _cityBtn.titleLabel.font = kFont12;
        }else{
            _cityBtn.titleLabel.font = kFont9;
        }
        [_cityBtn setTitle:[WDDefaultAccount cityName] forState:UIControlStateNormal];
        //设置标签推送的Tag  城市名、省份编码
        NSString *cityCode = [WDDefaultAccount cityId];
        NSString *provinceId = [WDDefaultAccount provinceId];
        NSSet *setTags = [NSSet setWithObjects:cityName,cityCode,provinceId, nil];
        [self setJpushTags:setTags];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.badgeView.hidden = YES;
    [self.badgeView removeFromSuperview];
    [MobClick endLogPageView:@"首页"];
     self.navigationController.navigationBarHidden = false;
    
}
- (void)locationCity:(NSString *)cityName{
    NSDictionary *param = @{@"cityName":cityName};
    [WDNetworkClient postRequestWithBaseUrl:kGetCityCodeWithNameUrl setParameters:param success:^(id responseObject) {
//        YYLog(@"---%@---",responseObject);
//        WeakStament(weakSelf);
        //如果正确的情况下
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            NSString *cityCode = responseObject[@"data"][@"cityCode"];
            NSString *provinceId = nil;
            if ([responseObject[@"data"][@"cityCode"] isKindOfClass:[NSString class]]) {
                provinceId = responseObject[@"data"][@"provinceId"];
            }else{
                provinceId = @"";
            }
            //设置标签推送的Tag  城市名、城市编码
            NSSet *setTags = [NSSet setWithObjects:cityName,cityCode,provinceId, nil];
            [self setJpushTags:setTags];
            [WDDefaultAccount setCityId:cityCode];
        }else{
            [ToolClass showAlertWithMessage:@"定位失败"];
        }
    } fail:^(NSError *error) {
    } delegater:nil];
}

#pragma mark - 数据请求
-(void)loadData
{
    [self loadBannerData];
    [self loadListData];
}
#pragma mark - 数据刷新
-(void)refreshData
{
    _currentPage = 0;
    [self loadData];
}

/**
 版本检查,选择更新，强制更新在appdelegate中
 */
-(void)appVersionCheck
{
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"发现新版本"];
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        YYLog(@"ca");
        
    }];
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
        YYLog(@"sur");
        NSString *appid = Apple_ID;
        NSString *url =  [NSString stringWithFormat:
                          @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
        [[UIApplication sharedApplication] openURL:WDURL(url)];
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    
    [WDNetworkClient postRequestWithBaseUrl:kGetNewVersion setParameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            //服务器存的version号 forceUpdate needUpdate
            NSString *versionFromServer =  responseObject[@"data"][@"version"];
            NSNumber *needUpdate =  responseObject[@"data"][@"needUpdate"];
            NSNumber *forceUpdate =  responseObject[@"data"][@"forceUpdate"];
            
            //字符串比较 A compare B 相当于 A-B NSOrderedAscending表示为正
            if ([[ToolClass getAPPVersion] compare:versionFromServer]==NSOrderedAscending) {
                
                //更新但不是强制更新,强制更新移动到了 Appdelegate
//                if ([needUpdate isEqualToNumber:@(1)]&&[forceUpdate isEqualToNumber:@(0)]) {
                
//                    WeakStament(ws);
                    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"发现新版本"];
                    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                        YYLog(@"ca");
                        
                    }];
                    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
                        YYLog(@"sur");
                        NSString *appid = Apple_ID;
                        NSString *url =  [NSString stringWithFormat:
                                          @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
                        [[UIApplication sharedApplication] openURL:WDURL(url)];
                        
                    }];
                    [alertVC addAction:cancel];
                    [alertVC addAction:sure];

                    
//                }
            }
            else if ([needUpdate isEqualToNumber:@(0)])
            {
                
                NSString *tip =  responseObject[@"data"][@"alert"];
                if (tip.length>0) {
                    DQAlertView *alert = [[DQAlertView alloc]initWithTitle:@"温馨提示" message:tip delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定"];
                    [alert show];
                }
            }
        }
    } fail:^(NSError *error) {
    } delegater:nil];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //轮播图点击
    WDWebViewController *web = [[WDWebViewController alloc]init];
    WeakStament(wself);
#pragma mark - 轮播图传值点击
    self.headerTopView.bannerBlock = ^(NSInteger bannerIndex){
        
        WDBannerModel *model;
        switch (bannerIndex) {
            case 0:
            {
                
                //轮播图跳转分两种内部跳转和外部跳转
                
                model = wself.bannerDataArray[0];
                if ([model.clickTo isEqualToString:@"1"]) {
                    //1   表示要跳转到h5页面
                     web.url = model.productUrl;
                    web.navTitle = @"5dou";
                    web.hidesBottomBarWhenPushed = YES;
                    [wself.navigationController pushViewController:web animated:YES];
                }
                else
                {
                    //model.clickTo  0(内部跳)  1(外部跳转)
                    //这就是跳转到应用内的某个页面
                    //分三种情况 0:任务，1：干货 2：活动 根据bannerType字段进行判断
                    
                     WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
                    
                    //任务
                    if ([model.bannerType isEqualToString:@"0"]) {
                        
                        //本页面请求任务详情数据
                        [wself prepareDataDetail:model.productCode];
                        
                    }
                    //干货
                    else if ([model.bannerType isEqualToString:@"1"])
                    {
                        
                        activityDetailController.requestType = RequestTypeNews;
                        activityDetailController.activityID = model.productCode;
                        activityDetailController.hidesBottomBarWhenPushed = YES;
                        [wself.navigationController pushViewController:activityDetailController animated:YES];
                    }
                    //活动
                    else
                    {
                        
                        activityDetailController.requestType = ReuqestTypeActivity;
                        activityDetailController.activityID = model.productCode;
                        activityDetailController.hidesBottomBarWhenPushed = YES;
                        [wself.navigationController pushViewController:activityDetailController animated:YES];
                    }
                }
               
            }
                break;
            case 1:
            {
                model = wself.bannerDataArray[1];
                if ([model.clickTo isEqualToString:@"1"]) {
                    //1   表示要跳转到h5页面
                    web.url = model.productUrl;
                }
                else
                {
                    //这就是跳转到应用内的某个页面
                    //分三种情况 0:任务，1：干货 2：活动 根据bannerType字段进行判断
                    
                    WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
                    if ([model.bannerType isEqualToString:@"0"]) {
                        
                        //本页面请求任务详情数据
                        [wself prepareDataDetail:model.productCode];
                    }
                    else if ([model.bannerType isEqualToString:@"1"])
                    {
                        
                        activityDetailController.requestType = RequestTypeNews;
                        activityDetailController.activityID = model.productCode;
                        activityDetailController.hidesBottomBarWhenPushed = YES;
                        [wself.navigationController pushViewController:activityDetailController animated:YES];
                    }
                    else
                    {
                        
                        activityDetailController.requestType = ReuqestTypeActivity;
                        activityDetailController.activityID = model.productCode;
                        activityDetailController.hidesBottomBarWhenPushed = YES;
                        [wself.navigationController pushViewController:activityDetailController animated:YES];
                    }
                }

            }
                break;
            case 2:
            {
                model = wself.bannerDataArray[2];
                if ([model.clickTo isEqualToString:@"1"]) {
                web.url = model.productUrl;
                    web.navTitle = @"5dou";
                    web.hidesBottomBarWhenPushed = YES;
                    [wself.navigationController pushViewController:web animated:YES];
                }
                else
                {
                    //这就是跳转到应用内的某个页面
                    //分三种情况 0:任务，1：干货 2：活动 根据bannerType字段进行判断
                    
                    WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
                    if ([model.bannerType isEqualToString:@"0"]) {
                        //本页面请求任务详情数据
                        [wself prepareDataDetail:model.productCode];
                        
                    }
                    else if ([model.bannerType isEqualToString:@"1"])
                    {
                        
                        activityDetailController.requestType = RequestTypeNews;
                        activityDetailController.activityID = model.productCode;
                        activityDetailController.hidesBottomBarWhenPushed = YES;
                        [wself.navigationController pushViewController:activityDetailController animated:YES];
                    }
                    else
                    {
                        
                        activityDetailController.requestType = ReuqestTypeActivity;
                        activityDetailController.activityID = model.productCode;
                        activityDetailController.hidesBottomBarWhenPushed = YES;
                        [wself.navigationController pushViewController:activityDetailController animated:YES];
                    }
                }
            }
                break;
            case 3:
            {
                model = wself.bannerDataArray[3];
                if ([model.clickTo isEqualToString:@"1"]) {
                web.url = model.productUrl;
                    web.navTitle = @"5dou";
                    web.hidesBottomBarWhenPushed = YES;
                    [wself.navigationController pushViewController:web animated:YES];
                }
                else
                {
                    //这就是跳转到应用内的某个页面
                    //分三种情况 0:任务，1：干货 2：活动 根据bannerType字段进行判断
                    
                    WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
                    if ([model.bannerType isEqualToString:@"0"]) {
                        
                        activityDetailController.requestType = RequestTypeTask;
                        activityDetailController.activityID = model.productCode;
                        
                        
                    }
                    else if ([model.bannerType isEqualToString:@"1"])
                    {
                        
                        activityDetailController.requestType = RequestTypeNews;
                        activityDetailController.activityID = model.productCode;
                        
                    }
                    else
                    {
                        
                        activityDetailController.requestType = ReuqestTypeActivity;
                        activityDetailController.activityID = model.productCode;
                        
                    }
                    
                    activityDetailController.hidesBottomBarWhenPushed = YES;
                    [wself.navigationController pushViewController:activityDetailController animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    };
#pragma mark - 4个icon
    //icon
    self.headerTopView.topViewBlock = ^(NSInteger indexNum,WDFourIconModel *model){
        NSString *userId = [WDUserInfoModel shareInstance].memberId;
        switch (indexNum) {
            case 0:
            {
                if (userId) {
                    WDGainMoneyViewController *gain = [WDGainMoneyViewController new];
                    gain.hidesBottomBarWhenPushed = true;
                    [wself.navigationController pushViewController:gain animated:true];
                }else{
                    [wself callLoginVC];
                }
            }
                break;
            //进入逗活动
            case 1:
            {
                WDDouActivityViewController *dou = [WDDouActivityViewController new];
                dou.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:dou animated:YES];
                
            }
                break;
            //进入新闻
            case 2:
            {
                WDSchoolNewsViewController *newsController = [[WDSchoolNewsViewController alloc] init];
                newsController.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:newsController animated:YES];
            }
                break;
            case 3:
            {
                WDRankingViewController *rankingVC = [[WDRankingViewController alloc] init];
                rankingVC.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:rankingVC animated:YES];
            }
                break;
            default:
                break;
        }
    };
}
#pragma mark - 点入点击获取设备信息
/**
 点击点入时候获取设备信息
 */
-(void)getMemeberDeviceInfo
{
    [WDNetworkClient postRequestWithBaseUrl:kSaveDeviceInfo setParameters:nil success:^(id responseObject) {
        if (responseObject) {
            if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
                
             }
        }
        
    } fail:^(NSError *error) {
    } delegater:self.view];
}
#pragma mark - 创建collectionView
-(void)makeCollectionView{
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    //设置itemSize
    self.layout.itemSize = CGSizeMake(ScreenWidth, ScreenWidth>320?100:90);
    //设置边距
    self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.layout.headerReferenceSize = CGSizeMake(320,ScreenWidth>320?330:280);
    //2.初始化collectionView
    if (!self.mainCollectionView) {
        
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) collectionViewLayout:self.layout];
        //颜色设置
        self.mainCollectionView.backgroundColor = kClearColor;
        self.mainCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.mainCollectionView registerClass:[WDHomeListCell class] forCellWithReuseIdentifier:HomeCellID];
#pragma mark - 高度调整节点
        _headerTopView = [[WDTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth>320?330:280)];
        [self.mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
//        self.mainCollectionView.showsVerticalScrollIndicator = false;
        //4.设置代理
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.dataSource = self;
        [self.view addSubview:self.mainCollectionView];
        
        //刷新
        WeakStament(wself);
        self.mainCollectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [wself refreshData];
        }];
        [MJRefreshGifHeader initGifImage:self.mainCollectionView.mj_header];
        
    }
}

#pragma mark -- 跳转登录
-(void)callLoginVC{
    
    WDLoginViewController *login = [[WDLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    });
}
//轮播图数据
-(void)loadBannerData
{
    NSDictionary *para = @{@"location":@1};
    [WDNetworkClient postRequestWithBaseUrl:kBannerUrl setParameters:para success:^(id responseObject) {
        if (responseObject) {
            NSDictionary *result = responseObject[@"result"];
            NSString *code = result[@"code"];
            if ([code isEqualToString:@"1000"]){
                NSArray *array =(NSArray *) responseObject[@"data"];
                [self.bannerDataArray removeAllObjects];
                for (NSDictionary *subDic in array) {
                    WDBannerModel *model = [WDBannerModel new];
                    [model setValuesForKeysWithDictionary:subDic];
                    [self.bannerDataArray addObject:model];
                }
                [self.mainCollectionView reloadData];
                [self.mainCollectionView.mj_header endRefreshing];
                _headerTopView.bannerArray = [self.bannerDataArray copy];
            }
        }
    } fail:^(NSError *error) {
        
        [self.mainCollectionView.mj_header endRefreshing];
        
    } delegater:self.view];
    
}
//下部数据加载
-(void)loadListData
{
    NSDictionary *para = @{@"queryCategory":@0,@"queryOrderType":@0,@"queryOrderSort":@1,@"cityCode":@0,@"queryHot":@0,@"queryAppType":@2,@"keyword":@"",@"pageInfo.pageSize":@15,@"pageInfo.toPage":@(_currentPage)};
    [WDNetworkClient postRequestWithBaseUrl:kTaskList setParameters:para success:^(id responseObject) {
        if (responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            [DDSaveDataToCache writeDateForPath:dic forPathName:KListDataCache];
            if ([dic[@"result"][@"code"] isEqualToString:@"1000"]) {
                NSArray *ListArray =(NSArray *) responseObject[@"data"];
                [self.dataArray removeAllObjects];
                for (NSDictionary *subDic in ListArray) {
                    WDTaskModel *model = [WDTaskModel new];
                    [model setValuesForKeysWithDictionary:subDic];
                    [self.dataArray addObject:model];
                }
                [self.mainCollectionView reloadData];
                [self.mainCollectionView.mj_header endRefreshing];
            }
        }
    } fail:^(NSError *error) {
        [self.mainCollectionView.mj_header endRefreshing];
        [DDSaveDataToCache readFilePath:KListDataCache];
        [self.mainCollectionView.mj_header endRefreshing];
    } delegater:self.view];
}

#pragma mark - datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WDHomeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCellID forIndexPath:indexPath];
    if (self.dataArray.count>indexPath.row) {
        WDTaskModel *model = self.dataArray[indexPath.row];
        cell.taskModel = model;
    }
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    [headView addSubview:_headerTopView];
    return headView;
    
}
#pragma mark - delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    WDTaskModel *taskModel = self.dataArray[indexPath.row];
    [self prepareDataDetail:taskModel.taskId];
    
}
#pragma mark ======== 设置极光推送别名
- (void)setJpushTags:(NSSet *)tags{
    //解决极光没有初始化完成的时候 设置不成功的情况
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setTags:tags alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            if (iResCode == 0) {
                YYLog(@"设置标签成功");
            }else{
                YYLog(@"设置标签失败:%d",iResCode);
            }
        }];
    });
}
#pragma mark - DQAlertdelegate
-(void)otherButtonClickedOnAlertView:(DQAlertView *)alertView
{
    if ([alertView.otherButton.currentTitle isEqualToString:@"更新"]) {
        NSString *appid = Apple_ID;
        NSString *url =  [NSString stringWithFormat:
                          @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
        [[UIApplication sharedApplication] openURL:WDURL(url)];
    }   
}

//冒泡排序
-(void)bubble
{
    int i, j, t;
    int a[10] = {2, 5, 8, 1, 3, 4, 7, 9, 0, 6}; // 共10个数据
    // 双重for循环排序
       for(i=0; i<9; i++) // 从第1个到第9个
        {
                    for(j=i+1; j<10; j++) // 将a[i]和后面的所有数进行比较
                         {
                                 if(a[i]>a[j]) // 如果a[i]大于后面的数则进行交换
                                    {
                                             t=a[i];
                                            a[i]=a[j];
                                             a[j]=t;
                                        }
                            }
                 }
         printf("排序后：\n");
         for(i=0; i<10; i++)
            {
                
                printf("%d ", a[i]);
                
                 }
    
}

@end
