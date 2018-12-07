//
//  WDBaseWebViewController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseWebViewController.h"
#import "SVProgressHUD.h"
#import "WDUserInfoModel.h"
#import "ToolClass.h"
#import "IPhoneTypeModel.h"

@interface WDBaseWebViewController ()<UIWebViewDelegate>
@end

@implementation WDBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navTitle) {
        [self.navigationItem setItemWithTitle:self.navTitle textColor:kNavigationTitleColor fontSize:19 itemType:center];
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

/**
 *  获取会员号
 */
- (void)getMemberId{
    if ([[WDDefaultAccount getUserInfo] objectForKey:@"memberId"]) {
        self.memberId = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    }else{
        self.memberId = @"";
    }
}

/**
 *  获取参数变量
 */
- (NSString *)getPublicPara{
    //拼接登录信息
    NSString *memberIdStr = [WDUserInfoModel shareInstance].memberId?[WDUserInfoModel shareInstance].memberId:@"";
    NSString *idfaStr = [ToolClass getIDFA];
    NSString *systemVersion = [NSString stringWithFormat:@"%.2f",[ToolClass currentSystemVersion]];
    return [NSString stringWithFormat:@"bimi:%@,bict:%@,aicc:%@,aicp:6C07A7D7C49F0E3FE692B5FF66715086,bidv:IOS,biav:%@,bidm:%@,biov:%@,bict:%@,sid:%@,bidn:%@",memberIdStr,idfaStr,[WDUserInfoModel shareInstance].channel,[ToolClass getAPPVersion],[IPhoneTypeModel iphoneType],systemVersion,[ToolClass getIDFA],[WDUserInfoModel shareInstance].sid?[WDUserInfoModel shareInstance].sid:@"",[IPhoneTypeModel iphoneName]];
}


#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self getMemberId];
    //[SVProgressHUD show];
    
    //初始化与JS的交互环境
    self.context = [[JSContext alloc] initWithVirtualMachine:[[JSVirtualMachine alloc] init]];
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //[SVProgressHUD dismiss];
    // new for memory cleaning
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSString *publicParam = [self getPublicPara];
    NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('ios_data','%@')",publicParam];
    [webView stringByEvaluatingJavaScriptFromString:jsStr];
    
    NSString *initStr = [NSString stringWithFormat:@"ios_init()"];
    [webView stringByEvaluatingJavaScriptFromString:initStr];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    YYLog(@"error = %@",error);
}


- (void)dealloc{
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
