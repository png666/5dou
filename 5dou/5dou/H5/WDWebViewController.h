//
//  WDWebViewController.h
//  5dou
//
//  Created by rdyx on 16/9/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
#import "IMYWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WDDefaultAccount.h"
#import "ToolClass.h"
@interface WDWebViewController : WDBaseViewController

@property(nonatomic,copy)NSString *navTitle;
@property(nonatomic,strong) NSString *memberId;
/**
 *  进行页面加载的webview
 */
@property(strong,nonatomic)IMYWebView* webView;
/**
 *  webview导入的url
 */
@property(nonatomic,copy)NSString *url;
/**
 *  开始进行加载URL
 */
- (void)webViewDidStartLoad:(IMYWebView *)webView;
/**
 *
 *  加载完URL
 */
- (void)webViewDidFinishLoad:(IMYWebView *)webView;
/**
 *  进行交互使用
 */
- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
/**
 *  加载失败报错
 */
- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)getMemberId;

- (NSString *)getPublicPara;
@end
