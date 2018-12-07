
//
//  WDMainTabBarController.m
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDMainTabBarController.h"
#import "WDHomePageViewController.h"
#import "WDTaskViewController.h"
#import "WDActivityViewController.h"
#import "WDMineViewController.h"
#import "ScrollTabBarDelegate.h"
#import "WDAPNSModel.h"
#import "WDRebateViewController.h"
//通知跳转
#import "WDMemberCenterViewController.h"
#import "WDDoubiViewController.h"
#import "WDMyTaskViewController.h"
#import "WDH5MyTaskCardController.h"
#import "WDTaskListController.h"
#import "WDDouActivityViewController.h"
#import "WDH5MyTaskCardController.h"

#import "WDLoginViewController.h"
#import "WDUserInfoModel.h"
#import "WDRebateH5ViewController.h"
#import "WDH5HomePageViewController.h"


@interface WDMainTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, assign) NSInteger subViewControllerCount;
@property (nonatomic, strong) ScrollTabBarDelegate *tabBarDelegate;
@property (nonatomic,assign) NSInteger indexFlag;
@end

@implementation WDMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.subViewControllerCount = self.viewControllers ? self.viewControllers.count : 0;

    // 代理

    self.tabBarDelegate = [[ScrollTabBarDelegate alloc] init];
    self.delegate = self.tabBarDelegate;


    [self configTabBarVC];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToViewController:) name:WD_JUMP_TO_VIEWCONTROLLER object:nil];


//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTabbarSubView) name:@"tabb" object:nil];

}


#define TabbarItemNums 4
- (void)addTabbarSubView {
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    CGRect tabFram = self.tabBar.frame;
    float percentX = (1+0.6)/TabbarItemNums;
    CGFloat x = ceilf(percentX*tabFram.size.width);
    CGFloat y = ceilf(0.1*tabFram.size.height);
    view.frame = CGRectMake(x, y, 8, 8);
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    [self.tabBar addSubview:view];
    [self.tabBar bringSubviewToFront:view];
    
}

-(void)configTabBarVC{
    
      WDHomePageViewController* homePageVC = [[WDHomePageViewController alloc] init];
//     WDH5HomePageViewController *homePageVC = [[WDH5HomePageViewController alloc] init];

    //WDTaskViewController * taskVC = [[WDTaskViewController alloc] init];
    WDTaskListController *taskVC = [[WDTaskListController alloc] init];
    
//    WDActivityViewController * activityVC = [[WDActivityViewController alloc] init];
    
    WDRebateViewController *rebateVC = [WDRebateViewController new];
    
    
    WDMineViewController * mineVC = [[WDMineViewController alloc] init];
    
//    NSArray *array = @[homePageVC,taskVC,rebateVC,mineVC];
//
//    NSMutableArray *navArray;
//
//    for (int i=0; i<array.count; i++) {
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:array[i]];
//        [navArray addObject:nav];
//    }
    
    UINavigationController * nav0 = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:taskVC];
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:rebateVC];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    
//    self.viewControllers = navArray;
    
    self.viewControllers = @[nav0,nav1,nav2,nav3];
    
    NSArray * titleArray = @[@"首页",
                             @"我的任务",
                             @"邀请返利",
                             @"我的"];
    
    NSArray * unSelectImageArray = @[@"home",
                                     @"renwu",
                                     @"huodong",
                                     @"mine"];
    
//    NSArray * selectImageArray = @[@"home1",@"renwu1",@"huodong1",@"mine1"];
    //带描边的
    NSArray * selectImageArray = @[@"home_h",
                                   @"renwu_h",
                                   @"huodong_h",
                                   @"mine_h"];

    
    for (int i=0; i < unSelectImageArray.count; i++) {
        
        NSString * titel = titleArray[i];
        
        UIImage * normal_image = [UIImage imageNamed:unSelectImageArray[i]];
        normal_image = [normal_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage * selected_image = [UIImage imageNamed:selectImageArray[i]];
        //取消系统对于选中 item 的渲染
        selected_image = [selected_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //获取每一个 item
        UITabBarItem *item=[self.tabBar.items objectAtIndex:i];
        
        item = [item initWithTitle:titel
                             image:normal_image
                     selectedImage:selected_image];
        
        //        item.imageInsets = UIEdgeInsetsMake(5, 5, -5, -5);
        [item setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        
    }
    
    //设置 tabbar 字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.099 alpha:1.000], NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:WDColorRGB(248.f, 213.f, 90.f), NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarBackground"];
    
    self.selectedIndex = 0;

}

#pragma mark - /*** 接收到推送消息跳转控制器 ***/
- (void)jumpToViewController:(NSNotification *)notication{
    NSString *memberId = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    //接收传过来的参数model
    WDAPNSModel *apnsModel = [notication.userInfo objectForKey:@"event"];
    if ([apnsModel.openTo isEqualToString:@"index"]) {
        //首页
        self.selectedIndex = 0;
    }else if ([apnsModel.openTo isEqualToString:@"taskList"]){
        //任务列表
        self.selectedIndex = 1;
    }else if ([apnsModel.openTo isEqualToString:@"activityList"]){
        //活动列表
        WDDouActivityViewController *douVC = [[WDDouActivityViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:douVC];
        //去掉导航上面的黑线
        nav.navigationBar.shadowImage = [[UIImage alloc] init];
        [nav.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                forBarMetrics:UIBarMetricsDefault];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if ([apnsModel.openTo isEqualToString:@"memberInfo"]){
        //个人中心
        if (memberId) {
            WDMemberCenterViewController *memberCenterVC = [[WDMemberCenterViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:memberCenterVC];
            //去掉导航上面的黑线
            nav.navigationBar.shadowImage = [[UIImage alloc] init];
            [nav.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                    forBarMetrics:UIBarMetricsDefault];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self callLoginVC];
        }
        
    }else if ([apnsModel.openTo isEqualToString:@"account"]){
        //我的逗币
        if (memberId) {
            WDDoubiViewController *doubiVC = [[WDDoubiViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:doubiVC];
            //去掉导航上面的黑线
            nav.navigationBar.shadowImage = [[UIImage alloc] init];
            [nav.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                          forBarMetrics:UIBarMetricsDefault];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self callLoginVC];
        }
    }else if ([apnsModel.openTo isEqualToString:@"taskCard"]){
        //我的任务卡
        if (memberId) {
            WDH5MyTaskCardController *taskCardVC = [[WDH5MyTaskCardController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:taskCardVC];
            //去掉导航上面的黑线
            nav.navigationBar.shadowImage = [[UIImage alloc] init];
            [nav.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                    forBarMetrics:UIBarMetricsDefault];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self callLoginVC];
        }
    }else if ([apnsModel.openTo isEqualToString:@"myTask"]){
        //我的任务
        if (memberId) {
//            WDMyTaskViewController *myTaskVC = [[WDMyTaskViewController alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:myTaskVC];
//            //去掉导航上面的黑线
//            nav.navigationBar.shadowImage = [[UIImage alloc] init];
//            [nav.navigationBar setBackgroundImage:[[UIImage alloc] init]
//                                    forBarMetrics:UIBarMetricsDefault];
//            [self presentViewController:nav animated:YES completion:nil];
            self.selectedIndex = 1;
            
        }else{
            [self callLoginVC];
        }
    }else if ([apnsModel.openTo isEqualToString:@"invite_1"]||
              [apnsModel.openTo isEqualToString:@"invite_2"]){
//        //邀请返利-逗财排行 ** 邀请返利-邀请好友
//        if ([WDUserInfoModel shareInstance].memberId) {
//            WDRebateH5ViewController *rebateVC = [[WDRebateH5ViewController alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rebateVC];
//            //去掉导航上面的黑线
//            nav.navigationBar.shadowImage = [[UIImage alloc] init];
//            [nav.navigationBar setBackgroundImage:[[UIImage alloc] init]
//                                    forBarMetrics:UIBarMetricsDefault];
//            [self presentViewController:nav animated:YES completion:nil];
//        }else{
//            [self callLoginVC];
//        }
        self.selectedIndex = 2;
    }
    //双创
}

#pragma mark - login
-(void)callLoginVC{
    
    WDLoginViewController *login = [[WDLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    //解决present延迟弹出
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nav animated:YES completion:^{
        }];
    });
}
#pragma mark  ===== 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
    
}

#pragma mark =====底部tabBar动画
// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }

    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.35;
//    pulse.repeatCount= 0;
    pulse.autoreverses= false;
    pulse.fromValue= [NSNumber numberWithFloat:0.95];
    pulse.toValue= [NSNumber numberWithFloat:1.05];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    
    self.indexFlag = index;

}

@end
