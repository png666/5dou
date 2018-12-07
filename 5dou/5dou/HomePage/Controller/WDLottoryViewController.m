//
//  WDLottoryViewController.m
//  5dou
//
//  Created by rdyx on 17/1/22.
//  Copyright © 2017年 吾逗科技. All rights reserved.
//

#import "WDLottoryViewController.h"
#import "UMCustomManager.h"
#import "WDUserInfoModel.h"
#import "ToolClass.h"
#import "IPhoneTypeModel.h"
@interface WDLottoryViewController ()

@end

@implementation WDLottoryViewController



- (void)viewDidLoad {
    
    self.url = [NSString stringWithFormat:@"http://%@/#!/luckyDraw",H5Url];
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
//    self.webView.frame = CGRectMake(0, 10.f, ScreenWidth, ScreenHeight);
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLottery) name:@"shareLottery" object:nil];
    
}

-(void)refreshLottery{
    
    NSString *jsStr = [NSString stringWithFormat:@"shareCallback()"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        YYLog(@"%@ %@",response,error);
    }];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

//js交互这个方法是js通知native的代理
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    YYLog(@"%@",message.body);
    NSDictionary *body = (NSDictionary *)message.body;
    
//    if ([message.name isEqualToString:@"Share"]){
//        //umeng 6.1开始所有的网络url要是https否则加载失败
////        UIImage *shareImg = [UIImage imageNamed:@"iicon"];
//        [WDUserInfoModel shareInstance].isLotShare = YES;
//        [WDUserInfoModel shareInstance].lotteryCode = body[@"lotteryCode"];
////        [UMCustomManager shareWebWithViewController:self
//                                         ShareTitle:body[@"title"]
//                                            Content:body[@"desc"]
//                                         ThumbImage:body[@"imgUrl"]
//                                                Url:body[@"link"]];
//    }else if ([message.name isEqualToString:@"goBack"]){
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
