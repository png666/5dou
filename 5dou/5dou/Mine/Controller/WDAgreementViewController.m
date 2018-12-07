//
//  WDAgreementViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/26.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  隐私协议
//

#import "WDAgreementViewController.h"
#import <WebKit/WebKit.h>
#import "SVProgressHUD.h"

@interface WDAgreementViewController ()
//<WKNavigationDelegate>

//@property (nonatomic, strong) WKWebView *webView;///<网页视图

@end

@implementation WDAgreementViewController

- (void)viewDidLoad {
//    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"《软件许可及隐私协议》" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.url = WD_POLICY_URL;
    [super viewDidLoad];
    
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
//    [self.view addSubview:self.webView];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
}
//
//- (WKWebView *)webView {
//    if (!_webView) {
//        _webView = [[WKWebView alloc]init];
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: WD_POLICY_URL]]];
//        _webView.navigationDelegate = self;
//    }
//    return _webView;
//}
//
//#pragma mark WebViewDelegate
//
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    YYLog(@"开始加载时回调");
//    [SVProgressHUD show];
//}
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    YYLog(@"加载结束时回调");
//    [SVProgressHUD dismiss];
//}
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//    YYLog(@"加载失败时回调");
//    YYLog(@"%@",error);
//    [SVProgressHUD dismiss];
//}

@end
