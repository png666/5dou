//
//  WDBaseViewController.m
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
#import "ToolClass.h"
#import "WDTaskDetailController.h"
#import "WDUserInfoModel.h"
#import "WDDefaultAccount.h"
#import "LocateManager.h"
@interface WDBaseViewController ()
@property(nonatomic,strong)UIButton *leftBarButton;

@end

@implementation WDBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self setupNavigationBar];
    
    
    
    //定位测试
    ///后台定位测试
//    [[LocateManager shareInstance] locateWithSuccessBlock:^(NSString *cityName) {
//        //获取推送的是城市code
//        YYLog(@"%@",cityName);
//        [AFToast showText:cityName];
//
//    } failBlock:^(NSError *error) {
//
//        YYLog(@"%@",error);
//
//    }];

    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}



- (void)setupNavigationBar
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 26, 45);
    
    //文字
    //    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //如果文字喝图片同时存在就把这个调整距离的打开
    //    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //图像
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backBtn addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    //    self.navigationItem.leftBarButtonItem.title = @"返回";
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barTintColor = kNavigationBarGrayColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"下外发光"];
    
}

-(UIButton *)addNavigationLeftButtonFrame:(CGRect)frame Image:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage AndText:(NSString *)text Target:(id)target Action:(SEL)action
{
    
    UIButton *leftBtn                        = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame                  = frame;
    leftBtn.titleLabel.font        = kFont14;
    [leftBtn setImage:normalImage forState:UIControlStateNormal];
    [leftBtn setImage:highLightImage forState:UIControlStateHighlighted];
    [leftBtn setTitle:text forState:UIControlStateNormal];
    [leftBtn setTitle:text forState:UIControlStateHighlighted];
    [leftBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftButtonItem       = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    //    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    space.width = -4;
    //    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftButtonItem, nil];
    
    self.leftBarButton = leftBtn;
    
    return leftBtn;
}

-(UIButton *)addNavgationRightButtonWithFrame:(CGRect)frame
                                        title:(NSString*)title
                                        Image:(NSString*)image
                                  selectedIMG:(NSString*)imsel
                                      tartget:(id)target
                                       action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = kFont15;
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:kNavigationTitleColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    if (imsel) {
        [button setImage:[UIImage imageNamed:imsel] forState:UIControlStateSelected];
    }
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    //button.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    return button;
}


- (void)backItemClick
{
    //解决视图上移直接点返回造成的view上移下不来的情况
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    
    if (viewcontrollers.count>1) {
        
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)prepareDataDetail:(NSString *)taskId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:taskId forKey:@"taskId"];
    if (!taskId) {
        [ToolClass showAlertWithMessage:@"productId = nil"];
        return;
    }
    [WDNetworkClient postRequestWithBaseUrl:kTaskDetailUrl setParameters:param success:^(id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        if (!dict) {
            //后台返回的数据字典为空时的判断
            [ToolClass showAlertWithMessage:@"参与失败，详情请联系5dou客服"];
            return ;
        }
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            
            WDTaskDetailModel *taskDetailModel = [[WDTaskDetailModel alloc] initWithDictionary:dict error:nil];
            WDTaskDetailController *detailController = [WDTaskDetailController new];
            [detailController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailController animated:YES];
            detailController.taskDetailModel = taskDetailModel;
            
        }else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [ToolClass showAlertWithMessage:dict[@"result"][@"msg"]];

            });
                   }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

//支付宝绑定判断
- (void)judgeIsAuthentication{
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    if (mi) {
        NSDictionary *dic = @{@"mi":mi,@"authType":@"alipay"};
        [WDNetworkClient postRequestWithBaseUrl:kJudgeIsAuthenticationUrl setParameters:dic success:^(id responseObject) {
            NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
            if ([code isEqualToString:@"1017"]) {
                //1017表示已绑定
                [WDUserInfoModel shareInstance].isBindAlipay = YES;
            }
        } fail:^(NSError *error) {
            YYLog(@"%@",error);
        } delegater:nil];
    }
}
//微信认证
-(void)weixinAuth{
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    if (mi) {
        NSDictionary *dic = @{@"mi":mi,@"authType":@"wx"};
        [WDNetworkClient postRequestWithBaseUrl:kJudgeIsAuthenticationUrl setParameters:dic success:^(id responseObject) {
            NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
            if ([code isEqualToString:@"1017"]) {
                //1017表示已经实名认证从后台code判断微信是否已经认证
                [WDUserInfoModel shareInstance].isWeixinAuth = YES;
            }else{
                YYLog(@"noauth");
            }
        } fail:^(NSError *error) {
            YYLog(@"%@",error);
        } delegater:nil];
    }
    
}

#pragma mark - 动态隐藏tabbar
float lastContentOffset;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if (!self.isShowTabbar)return;
    
    if (lastContentOffset < scrollView.contentOffset.y) {
        self.mainCollectionView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [UIView animateWithDuration:1.f animations:^{
            self.navigationController.tabBarController.tabBar.frame= CGRectMake(0, ScreenHeight, ScreenWidth, 49);
        }];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            self.navigationController.tabBarController.tabBar.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
        }];
    }
}


@end
