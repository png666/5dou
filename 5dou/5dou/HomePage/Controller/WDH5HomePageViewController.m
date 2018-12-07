//
//  ViewController.m
//  WKWebViewH5ObjCDemo
//
//  Created by huangyibiao on 16/3/22.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "WDH5HomePageViewController.h"
#import <WebKit/WebKit.h>
#import "WDActivityDetailController.h"
#import "WDGainMoneyViewController.h"
#import "WDDouActivityViewController.h"
#import "WDSchoolNewsViewController.h"
#import "WDRankingViewController.h"
#import "WDTaskDetailController.h"
#import "WDUserInfoModel.h"
#import "WDDefaultAccount.h"
#import "ToolClass.h"
#import "MJRefreshGifHeader+Ext.h"
#import "MJRefresh.h"
#import "WDSCWebViewController.h"
#import "WDLoginViewController.h"
#import "WDFlowRechargeViewController.h"
#import "WDHTTPServer.h"
#import "CKAlertViewController.h"
#import "DQAlertView.h"
#import "WDGuideView.h"
#import "LocateManager.h"
#import "JPUSHService.h"
#import "UMCustomManager.h"
#import "WDLottoryViewController.h"
#import "WDAboutPlatformViewController.h"

@interface WDH5HomePageViewController ()<DQAlertViewDelegate>

@property (nonatomic, strong) WDGuideView *guideView;

@end

@implementation WDH5HomePageViewController

- (void)viewDidLoad {
    
     self.url = [NSString stringWithFormat:@"http://%@/#!/index",H5Url];
    [super viewDidLoad];
//    [self appVersionCheck];
    if ([WDDefaultAccount getUserInfo]) {
        [[WDUserInfoModel shareInstance] saveUserInfoWithDic:[WDDefaultAccount getUserInfo]];
    }
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-49);
    self.webView.scrollView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [ToolClass clearWebViewCache];
        NSString *jsStr = [NSString stringWithFormat:@"upAction()"];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            //TODO
            YYLog(@"%@ %@",response,error);
        }];
        
        [self.webView.scrollView.mj_header endRefreshing];
    }];
    [MJRefreshGifHeader initGifImage:self.webView.scrollView.mj_header];
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49);
    //定位用户当前的位置   设置推送的Tags
    [self getUserLocation];
}
#pragma mark ===== 创建新手指导
- (void)createGuideView{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:GuideKey]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.guideView];
        [self.guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(window);
        }];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    //navigationBar.hidden 就不可以，真是个坑，note
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - WKNavigationDelegate
/**
  代理方法，用于截取wkwebview跳转的URL，根据跳转的URL的不同，实例化不同的页面
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //截获不同的URL进行原生页面的操作
    NSString *skipUrl = navigationAction.request.URL.absoluteString;
    //首页的话,默认加载
    if ([skipUrl containsString:self.url]) {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
        //跳转到活动详情
        //找到对应需要跳转的1id
        NSString *skipId = @"";
        if ([skipUrl containsString:@"?id="]) {
            NSRange rangeId = [skipUrl rangeOfString:@"?id="];
            skipId = [skipUrl substringFromIndex:(rangeId.location + 4)];
        }
        //跳转到活动详情
        if ([skipUrl containsString:@"#!/activDetail"]) {
            WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
            activityDetailController.activityID = skipId;
            activityDetailController.requestType =  ReuqestTypeActivity;
            activityDetailController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activityDetailController animated:YES];
            
        }
        //跳转到新闻页面
        else if([skipUrl containsString:@"#!/newsxwDetail"]){
            WDActivityDetailController *activityDetailController = [[WDActivityDetailController alloc] init];
            activityDetailController.activityID = skipId;
            activityDetailController.requestType =  RequestTypeNews;
            activityDetailController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activityDetailController animated:YES];
        }
        //去赚钱
        else if([skipUrl containsString:@"#!/taskList"]){
            WDGainMoneyViewController *gain = [WDGainMoneyViewController new];
            gain.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:gain animated:true];
        }
        //逗活动
        else if([skipUrl containsString:@"#!/activity"]){
            WDDouActivityViewController *dou = [WDDouActivityViewController new];
            dou.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dou animated:YES];
        }
        //逗新闻  http://192.168.1.28:8080/#!/newsxw
        else if([skipUrl containsString:@"#!/newsxw"]){
            WDSchoolNewsViewController *newsController = [[WDSchoolNewsViewController alloc] init];
            newsController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsController animated:YES];
        }
        //排行榜 http://192.168.1.28:8080/#!/Ranking
        else if([skipUrl containsString:@"#!/Ranking"]){
            WDH5BaseController *rankingVC = [[WDH5BaseController alloc] init];
            rankingVC.title = @"排行榜";
            rankingVC.url = skipUrl;
            rankingVC.hidesBottomBarWhenPushed = YES;
            rankingVC.webViewHeight = ScreenHeight - 64;
            [self.navigationController pushViewController:rankingVC animated:YES];
           
        }
        //流量充值 http://192.168.1.28:8080/#!/rechange
        else if([skipUrl containsString:@"#!/rechange"]){
            if (![WDUserInfoModel shareInstance].memberId) {
                [self callLoginVC];
            }else{
                WDFlowRechargeViewController *flowRechargeVC = [[WDFlowRechargeViewController alloc] init];
                flowRechargeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:flowRechargeVC animated:YES];
            }
        }

        //任务详情
        else if([skipUrl containsString:@"#!/taskInfo"]){
            [self prepareDataDetail:skipId];
        }
        
        else if ([skipUrl containsString:@"#!/luckyDraw"]){
            //幸运抽奖转盘，情人节礼盒活动
            if (![WDUserInfoModel shareInstance].memberId) {
                
                [self callLoginVC];
                
            }else{
            WDLottoryViewController *lot = [WDLottoryViewController new];
            lot.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lot animated:YES];
            }
        }
        //双创，后期基本处于废弃状态
        else if([skipUrl containsString:@"sc.5dou.cn/#!/index"]){
            
            if (![WDUserInfoModel shareInstance].memberId) {
                
                [self callLoginVC];
                
            }else{
                
                WDSCWebViewController *webViewController = [[WDSCWebViewController alloc] init];
                webViewController.url = [NSString stringWithFormat:@"%@?ios=1&mi=%@",skipUrl,[WDUserInfoModel shareInstance].memberId];
                webViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webViewController animated:YES];
            }
        }
//        跳转到外部的链接
        else{
            if ([skipUrl containsString:@"?mt"]) {
                
                [self appVersionCheck];
                
            }else{

                
                WDAboutPlatformViewController *outLink = [WDAboutPlatformViewController new];
                outLink.productUrl = skipUrl;
                outLink.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:outLink animated:YES];

//                WDSCWebViewController *webViewController = [[WDSCWebViewController alloc] init];
//                webViewController.isNotSC = YES;
//                webViewController.url = skipUrl;
//                webViewController.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:webViewController animated:YES];
            }
            
        }
        //不进行H5的自身web跳转，也就是我们对他的跳转进行拦截，然后换成了自己的原生跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}
//页面加载完毕判断是否显示新手指导
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [super webView:webView didFinishNavigation:navigation];
    [self createGuideView];
}

#pragma mark 跳转登录
-(void)callLoginVC{
    
    WDLoginViewController *login = [[WDLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nav animated:YES completion:^{
        }];
    });
}

- (void)getUserLocation{
    WeakStament(wself);
    [[LocateManager shareInstance] locateWithSuccessBlock:^(NSString *cityName) {
        //获取推送的是城市code
        [wself locationCity:cityName];
    } failBlock:^(NSError *error) {
        //定位失败时默认 0000
        NSSet *setTags = [NSSet setWithObjects:@"0000", nil];
        [wself setJpushTags:setTags];
    }];
}
#pragma mark ===== 根据城市名获取城市的Code
- (void)locationCity:(NSString *)cityName{
    NSDictionary *param = @{@"cityName":cityName};
    WeakStament(wself);
    [WDNetworkClient postRequestWithBaseUrl:kGetCityCodeWithNameUrl setParameters:param success:^(id responseObject) {
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
            [wself setJpushTags:setTags];
            [WDDefaultAccount setCityId:cityCode];
        }
    } fail:^(NSError *error) {
    } delegater:nil];
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
//进入任务详情页面
- (void)prepareDataDetail:(NSString *)taskId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:taskId forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kTaskDetailUrl setParameters:param success:^(id responseObject) {
        if (![responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"该任务已经下架了"];
            return ;
        }
        NSDictionary *dict = responseObject[@"data"];
        WDTaskDetailModel *taskDetailModel = [[WDTaskDetailModel alloc] initWithDictionary:dict error:nil];
        WDTaskDetailController *detailController = [WDTaskDetailController new];
         detailController.taskDetailModel = taskDetailModel;
        [detailController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailController animated:YES];
       
    } fail:^(NSError *error) {
    } delegater:self.view];
}


/**
 版本检查,选择更新，强制更新在appdelegate中
 */
-(void)appVersionCheck
{
    
    [WDNetworkClient postRequestWithBaseUrl:kGetNewVersion setParameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            //服务器存的version号 forceUpdate needUpdate
            NSString *versionFromServer =  responseObject[@"data"][@"version"];
            NSNumber *needUpdate =  responseObject[@"data"][@"needUpdate"];
            NSNumber *forceUpdate =  responseObject[@"data"][@"forceUpdate"];
            //字符串比较 A compare B 相当于 A-B NSOrderedAscending表示为正
            if ([[ToolClass getAPPVersion] compare:versionFromServer]==NSOrderedAscending) {
                //更新但不是强制更新,强制更新移动到了 Appdelegate
                if ([needUpdate isEqualToNumber:@(1)]&&[forceUpdate isEqualToNumber:@(0)]) {
                    //                    WeakStament(ws);
                    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"发现新版本"];
                    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                        YYLog(@"ca");
                        
                    }];
                    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
                        YYLog(@"sur");
//                        NSString *appid = Apple_ID;
//                        NSString *url =  [NSString stringWithFormat:
//                                          @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
                        [[UIApplication sharedApplication] openURL:WDURL([WDUserInfoModel shareInstance].updateUrl)];

                    }];
                    [alertVC addAction:cancel];
                    [alertVC addAction:sure];
                }
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


#pragma mark - DQAlertdelegate
-(void)otherButtonClickedOnAlertView:(DQAlertView *)alertView
{
    if ([alertView.otherButton.currentTitle isEqualToString:@"更新"]) {
//        NSString *appid = Apple_ID;
//        NSString *url =  [NSString stringWithFormat:
//                          @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
        [[UIApplication sharedApplication] openURL:WDURL([WDUserInfoModel shareInstance].updateUrl)];
    }
}

- (WDGuideView *)guideView{
    WeakStament(wself);
    if (!_guideView) {
        _guideView = [[WDGuideView alloc] init];
        _guideView.dismissGuideView = ^(){
            //修改plist里面的值
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey: GuideKey];
            [wself.guideView removeFromSuperview];
            
        };
    }
    return _guideView;
}


@end
