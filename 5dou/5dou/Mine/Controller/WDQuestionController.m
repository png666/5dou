//
//  WDQuestionController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDQuestionController.h"
#import "ZJScrollPageView.h"
#import "WDNormalQuestionViewController.h"
@interface WDQuestionController ()<ZJScrollPageViewDelegate>
@property (nonatomic,strong) NSArray *titles;
@end

@implementation WDQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"常见问题" textColor:kNavigationTitleColor
                                 fontSize:19 itemType:center];
    [self prepareUI];
    // Do any additional setup after loading the view.
}

- (void)prepareUI{
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
    style.titleFont = [UIFont systemFontOfSize:16];
    
    self.titles = @[@"任务",
                    @"活动",
                    @"逗币",
                    @"返利"];
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64.0) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:scrollPageView];
}

#pragma mark ZJPhotoScrollViewDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        childVc = [[WDNormalQuestionViewController alloc] init];
    }
    return childVc;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
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
