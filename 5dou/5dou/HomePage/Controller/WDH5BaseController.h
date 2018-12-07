//
//  WDH5BaseController.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/12.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
#import <WebKit/WebKit.h>
#import "WDHTTPServer.h"

/**
 加载H5的父类，由于使用WKWebView,如果需要JS<->OC交互的情况下，需要实现WKScriptMessageHandler代理方法
 */
@interface WDH5BaseController : WDBaseViewController <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>


@property(nonatomic,strong)WKWebViewConfiguration *config;

/**
 页面加载的WkWebView
 */
@property (nonatomic,strong) WKWebView *webView;

/**
 加载的URL
 */
@property (nonatomic,strong) NSString *url;

/**
 加载URL工程中的进度条
 */
@property (nonatomic, strong) UIProgressView *progressView;

/**
 wkwebview的高度，如果不赋值的情况下的话，高度和子视图的一样
 */
@property (nonatomic,assign) CGFloat webViewHeight;
@end
