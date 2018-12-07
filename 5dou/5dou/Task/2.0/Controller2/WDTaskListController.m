//
//  WDTaskListController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskListController.h"
#import "WDTaskChildController.h"
#import "ZJScrollPageView.h"
#import "WDAbout5douViewController.h"
@interface WDTaskListController ()<ZJScrollPageViewDelegate>

/**
 页面分栏的标题
 */
@property (strong,nonatomic) NSArray<NSString *>*titles;

/**
 实现活动的第三方组建
 */
@property (strong,nonatomic) ZJScrollPageView *scrollPageView;
@end

@implementation WDTaskListController

//- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = NO;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"我的任务" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.navigationItem.leftBarButtonItem = nil;
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.scrollTitle = NO;
    style.scrollLineColor = kNavigationBarColor;
    style.selectedTitleColor = kNavigationBarColor;
    style.segmentViewBounces = YES;
    style.titleFont = [UIFont systemFontOfSize:15];
    style.adjustCoverOrLineWidth = YES;
    style.autoAdjustTitlesWidth = NO;
    style.segmentHeight = 30;
    self.titles = @[@"进行中",
                    @"已完成",
                    @"未审批"];
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height - 20.0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:_scrollPageView];
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
}

#pragma mark ZJPhotoScrollViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}


- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    
//    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    WDTaskChildController *childVc =  (WDTaskChildController *)reuseViewController;
    
    if (!childVc) {
        childVc = [[WDTaskChildController alloc] init];
    }
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
