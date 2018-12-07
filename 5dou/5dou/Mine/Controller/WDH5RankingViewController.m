//
//  WDH5RankingViewController.m
//  5dou
//
//  Created by 黄新 on 16/12/23.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  排行榜H5显示
//

#import "WDH5RankingViewController.h"

@interface WDH5RankingViewController ()

@end

@implementation WDH5RankingViewController

- (void)viewDidLoad {
    
//    [self.navigationItem setItemWithTitle:@"月排行榜" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    //self.url =  @"http://192.168.1.28:8080/#!/Ranking";
    self.url = [NSString stringWithFormat:@"http://%@/#!/Ranking",H5Url];
    [super viewDidLoad];
    
   
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
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
