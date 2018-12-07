//
//  WDH5BaseController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/12.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5BaseController.h"
#import "ToolClass.h"
#import "IPhoneTypeModel.h"
#import "WDUserInfoModel.h"
#import "PTSProgressHUD.h"
#import "WKWebViewJavascriptBridge.h"
@interface WDH5BaseController ()

@property WKWebViewJavascriptBridge *webViewBridge;

@end

@implementation WDH5BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKUserContentController *userContentController = [WKUserContentController new];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时,我们可以在WKScriptMessageHandler代理中接收到 name可有多个，来区分不同的方法
//    [userContentController addScriptMessageHandler:self name:@"AppModel"];
    [userContentController addScriptMessageHandler:self name:@"Share"];
    [userContentController addScriptMessageHandler:self name:@"goBack"];

    //这个方法用来替换jsbridge,以后这种可以作为交互的通用方法，注入js方法，等待js端调用，调用的时候直接将参数获取到
    // WKUserScriptInjectionTimeAtDocumentStart：js加载前执行
    NSString *javaScriptSource = [NSString stringWithFormat:@"function getPublicData(){return \"%@\";}",[self getPublicPara]] ;
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];// forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
    [userContentController addUserScript:userScript];
    
    //Config配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 12;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];

    // 通过JS与webview内容交互容器
    config.userContentController = userContentController;

    if (_webViewHeight != 0) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,_webViewHeight) configuration:config];
    }else{
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                          configuration:config];
    }
    
    NSURL *path = [NSURL URLWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
    [self.view addSubview:self.webView];
    
    // 导航代理在webViewbridge中设置了代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    
    // 添加KVO监听获取进度
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    // 添加进度条
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.frame = self.view.bounds;
    self.progressView.progressTintColor = WDColorFrom16RGB(0xfdc000);
    [self.view addSubview:self.progressView];
    
    //获取标题
//    [self.webView addObserver:self
//                   forKeyPath:@"title"
//                      options:NSKeyValueObservingOptionNew
//                      context:NULL];
   
    
    //bridge初始化找到了一个新的替代方案
//    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
//    [_webViewBridge setWebViewDelegate:self];
//    
//    //注册的原生方法
//    [self registLocationFunction];
}

#pragma mrak - 这个方法是webBridge需要的注册*******目前这个已经不用了，wk自己的js注入方法替代
- (void)registLocationFunction
{
    //getPublicData 和js约定的方法
    [_webViewBridge registerHandler:@"getPublicData" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 拿到公共参数
        NSString *publicData = [self getPublicPara];;
        // 将结果返回给js
        responseCallback(publicData);
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
//localstorage方法被废弃被js注入方法替代解决了js无法取到公共参数的问题
#if 0
    if ([message.name isEqualToString:@"AppModel"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull类型
        //清除web缓存
//         [ToolClass clearWebViewCache];
        //需要将公共参数放入localStage
        NSString *publicParam = [self getPublicPara];
        //进行
        NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('native_data','%@')",publicParam];
        [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        YYLog(@"%@ %@",response,error);
        }];
    }
#endif
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



#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        //获取标题
        super.navigationItem.title = self.webView.title;
        YYLog(@"%@",self.webView.title);
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading) {
        // 手动调用JS代码
        // 每次页面完成都弹出来，可以在测试时再打开
        
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        }];
    }
}
//内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    YYLog(@"开始返回数据");
}

//页面加载完成后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [PTSProgressHUD hide];
}

//加载失败调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [PTSProgressHUD hide];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}


//开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
 
    [PTSProgressHUD showWithGifImagePath:@"doubiHUD.gif" withTitle:@"" toView:self.view];
    UIImageView *imageView = [PTSProgressHUD shareView].gifImageView;
    
    imageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    imageView.layer.cornerRadius = 8.0;
    imageView.clipsToBounds = YES;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [PTSProgressHUD setTitleMargin:15];
    [PTSProgressHUD setBgColor:[UIColor clearColor]];
    [PTSProgressHUD show];

}

#pragma mark - WKUIDelegate重写这个方法弹出alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"loading"];
    
}

@end
