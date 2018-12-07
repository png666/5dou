


//
//  WDRebateH5ViewController.m
//  5dou
//
//  Created by rdyx on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDRebateH5ViewController.h"
#import "WDHTTPServer.h"
@interface WDRebateH5ViewController ()

@end

@implementation WDRebateH5ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

- (void)viewDidLoad {
    //该H5页面已弃用
    super.url = [NSString stringWithFormat:@"http://%@/share_html/yyqhy.html",H5Url];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setItemWithTitle:@"邀请返现" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
}

-(void)webViewDidFinishLoad:(IMYWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    YYLog(@"加载完成");
}

-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlStr = [request.URL absoluteString];
    YYLog(@"%@",urlStr);
//    WeakStament(weakSelf);
    //没有登录,需要进行登录
    if ([urlStr containsString:@""]){
        
        
        return NO;
    }
    return YES;
}
- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error{
    YYLog(@"加载出错-------%@",error);
}


@end
