//
//  WDSignH5ViewController.m
//  5dou
//
//  Created by 黄新 on 16/11/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  签到
//

#import "WDH5SignViewController.h"
#import "WDHTTPServer.h"

@interface WDH5SignViewController ()

@end

@implementation WDH5SignViewController

- (void)viewDidLoad {
    [self.navigationItem setItemWithTitle:@"签到" textColor:kNavigationTitleColor fontSize:19 itemType:center];
//    self.url = @"http://192.168.1.28:8080/#!/signIn";
    self.url = [NSString stringWithFormat:@"http://%@/#!/signIn",H5Url];
    [super viewDidLoad];
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *skipUrl = navigationAction.request.URL.absoluteString;
    YYLog(@"skipUrl = %@",skipUrl);
    
    if ([skipUrl containsString:@"5dou.cn/#!/login"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        decisionHandler(WKNavigationActionPolicyCancel);
    }

    self.progressView.alpha = 1.0;
    decisionHandler(WKNavigationActionPolicyAllow);
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
