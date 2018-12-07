

//
//  WDTaskCardViewController.m
//  5dou
//
//  Created by rdyx on 16/9/4.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  我的任务卡 已替换成H5
//

#import "WDTaskCardViewController.h"
#import "ToolClass.h"
#import "WDTaskCardCollectionView.h"
#import "WDTaskCardHeader.h"

@interface WDTaskCardViewController ()

@property (nonatomic, strong) WDTaskCardCollectionView *taskCardCollectionView;///< 任务卡
@property (nonatomic, strong) WDTaskCardHeader *headerView;
@property (nonatomic, assign) CGFloat headerHeight;///< 表头的高度
@property (nonatomic, strong) UIScrollView *bgScrollView;

@end

@implementation WDTaskCardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self prepareUI];
    [self.navigationItem setItemWithTitle:@"我的任务卡" textColor: kNavigationTitleColor fontSize:19 itemType:center];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"任务卡"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"任务卡"];
}

- (void)prepareData{
    NSDictionary *param = [NSDictionary dictionary];
    [WDNetworkClient postRequestWithBaseUrl:kMyTaskCardTotal setParameters:param success:^(id responseObject) {
    } fail:^(NSError *error) {
        
    } delegater:self.view];

}


- (void)prepareUI{
    self.bgScrollView  = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.bgScrollView.contentSize = CGSizeMake(ScreenWidth, 660);
    self.bgScrollView.scrollEnabled = YES;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.bgScrollView];
    
    [self.bgScrollView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth);
        make.top.mas_equalTo(self.bgScrollView.mas_top).offset(10);
        make.height.mas_equalTo(193);
        make.left.mas_equalTo(self.bgScrollView);
    }];
    [self.bgScrollView addSubview:self.taskCardCollectionView];
    [self.taskCardCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(10);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(400);
        make.left.mas_equalTo(self.view);
    }];
}


#pragma mark ====== 懒加载

- (WDTaskCardCollectionView *)taskCardCollectionView{
    if (!_taskCardCollectionView) {
        _taskCardCollectionView = [[WDTaskCardCollectionView alloc] init];
        _taskCardCollectionView.backgroundColor = kBackgroundColor;
        if (device_is_iphone_5 || device_is_iphone_4) {
            _taskCardCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        }else if (device_is_iphone_6) {
            _taskCardCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        }else if (device_is_iphone_6p){
             _taskCardCollectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30);
        }
        
    }
    return _taskCardCollectionView;
}

#pragma mark ==== HeaderView

- (WDTaskCardHeader *)headerView{
    if (!_headerView) {
        _headerView = [[WDTaskCardHeader alloc] init];
    }
    return _headerView;
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
