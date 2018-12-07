//
//  WDH5MyTaskCardController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5MyTaskCardController.h"
#import "WDHTTPServer.h"
#import "WDH5TaskViewController.h"
#import "WDGainMoneyViewController.h"
#import "WDH5DeepCardController.h"
@interface WDH5MyTaskCardController ()

@end

@implementation WDH5MyTaskCardController

- (void)viewDidLoad {
    //self.url = @"http://192.168.1.28:8080/#!/taskCard";
    self.url = [NSString stringWithFormat:@"http://%@/#!/taskCard",H5Url];
    [self.navigationItem setItemWithTitle:@"我的任务卡" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [super viewDidLoad];
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
   
}



//进行拦截处理
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //截获不同的URL进行原生页面的操作
    NSString *skipUrl = navigationAction.request.URL.absoluteString;
    //首页的话,默认加载
    if ([skipUrl containsString:self.url]) {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
    if([skipUrl containsString:@"#!/taskList"]){
            WDGainMoneyViewController *gain = [WDGainMoneyViewController new];
            gain.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:gain animated:true];
        }
    //进入专属任务卡页面
        if ([skipUrl containsString:@"#!/deepCard"]) {
            WDH5DeepCardController *deepController = [WDH5DeepCardController new];
            deepController.url = skipUrl;
            [self.navigationController pushViewController:deepController animated:YES];
        }
    //不进行跳转
     decisionHandler(WKNavigationActionPolicyCancel);
    }
    
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
