//
//  WDH5QuestionController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/11/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5QuestionController.h"

@interface WDH5QuestionController ()

@end

@implementation WDH5QuestionController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@""];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@""];
}

- (void)viewDidLoad {
    
//    self.url = [NSString stringWithFormat:@"http://192.168.1.28:8080/#!/wtitemsList?ios=true"];
    self.url = [NSString stringWithFormat:@"http://%@/#!/wtitemsList?ios=true",H5Url];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setItemWithTitle:@"常见问题" textColor:kBlackColor fontSize:19 itemType:center];
}

@end
