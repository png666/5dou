//
//  WDBaseWebViewController.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
#import "WDDefaultAccount.h"
#import "ToolClass.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface WDBaseWebViewController : WDBaseViewController

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic,strong) JSContext *  context;
@property (nonatomic,copy,nullable) NSString *memberId;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *navTitle;

- (void)getMemberId;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;

NS_ASSUME_NONNULL_END

@end
