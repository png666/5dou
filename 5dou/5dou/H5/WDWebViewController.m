


//
//  WDWebViewController.m
//  5dou
//
//  Created by rdyx on 16/9/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDWebViewController.h"
#import "IMYWebView.h"
#import "UMCustomManager.h"
#import "SVProgressHUD.h"
#import "HMScannerController.h"
#import "WDUserInfoModel.h"
@interface WDWebViewController ()<IMYWebViewDelegate>
//加载JS的上下文
@property (strong, nonatomic) JSContext *context;
@property(nonatomic,strong)UIImageView *qrImageView;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)BOOL isShowTip;
@end

@implementation WDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isShowTip = false;
    if (self.navTitle) {
        [self.navigationItem setItemWithTitle:self.navTitle textColor:kNavigationTitleColor fontSize:19 itemType:center];
    }

    self.webView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) usingUIWebView:YES];

    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)getMemberId{
    if ([[WDDefaultAccount getUserInfo] objectForKey:@"memberId"]) {
        self.memberId = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    }else{
        self.memberId = @"";
    }
}

#pragma mark - delegate
- (void)webViewDidStartLoad:(IMYWebView *)webView
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getMemberId];
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(IMYWebView *)webView
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [SVProgressHUD dismiss];
    //屏蔽点击
    NSString *publicParam = [self getPublicPara];
    if (webView.usingUIWebView) {
        YYLog(@"使用了UIWebView");
        NSString *publicParam = [self getPublicPara];
        NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('ios_data','%@')",publicParam];
        [webView.realWebView stringByEvaluatingJavaScriptFromString:jsStr];
        
        NSString *initStr = [NSString stringWithFormat:@"ios_init()"];
        [webView.realWebView stringByEvaluatingJavaScriptFromString:initStr];
    }else{
        YYLog(@"使用了WKWebView");
       NSString *jsStr = [NSString stringWithFormat:@"window.localStorage.setItem('ios_data','%@')",publicParam];
        [webView.realWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
           // NSLog(@"%@ %@",response,error);
        }];
         NSString *initStr = [NSString stringWithFormat:@"ios_init()"];
        [webView.realWebView evaluateJavaScript:initStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            // NSLog(@"%@ %@",response,error);
        }];
    }
    

}

//获取页面的参数信息
- (NSString *)getPublicPara{
    //拼接登录信息
    NSString *memberIdStr = self.memberId;
    NSString *idfaStr = [ToolClass getIDFA];
    if (!memberIdStr) {
        memberIdStr = @"";
    }
    if (!idfaStr) {
        idfaStr = @"";
    }
    return [NSString stringWithFormat:@"bimi:%@,bict:%@,aicc:WUDOU_IOS,aicp:6C07A7D7C49F0E3FE692B5FF66715086,bidv:IOS",memberIdStr,idfaStr];
}

- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //拦截地址，js调用oc方法
    NSString *urlStr = [request.URL absoluteString];
    YYLog(@"%@",urlStr);
    //拦截到约定的协议后调用oc原生方法
    if ([urlStr containsString:@"save.html"]) {
        
        //截屏
//        UIImage *image = [ToolClass captureView:self.view];
//      //截取一部分
//        CGRect rect = CGRectMake(60, 380, 80, 80);
//        UIImageView *contentView = [[UIImageView alloc] initWithFrame:rect];
//        contentView.image=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
        //生成二维码图片
        self.isShowTip = YES;
        
        [self generateQRCode];
        
        return NO;
        
    }else if ([urlStr containsString:@"invite.html"]){
    
        self.isShowTip = NO;
        [self generateQRCode];
        return NO;
        
    }

    return YES;
}

//邀请返利界面
-(void)generateQRCode
{
    WeakStament(ws);
    
    // 二维码链接
    
    NSString *Url = [NSString stringWithFormat:@"http://h5.5dou.cn/login_html/zc.html?inviteCode=%@",[WDUserInfoModel shareInstance].inviteCode];
    [HMScannerController cardImageWithCardName:Url avatar:nil scale:0.2 completion:^(UIImage *image) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        ws.image = imageView.image;
        
        if (self.isShowTip) {
            
        UIImageWriteToSavedPhotosAlbum(image, ws, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            
        }else
        {
//            [UMCustomManager shareWebWithViewController:self ShareTitle:@"5dou" Content:@"邀请好友" ThumbImage:self.image Url:[NSString stringWithFormat:@"http://h5.5dou.cn/login_html/zc.html?inviteCode=%@",[WDUserInfoModel shareInstance].inviteCode]];
            YYLog(@"%@",[WDUserInfoModel shareInstance].inviteCode);
        }
    }];
}
- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - 保存到相册的代理
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    if (self.isShowTip==YES) {
    [ToolClass showAlertWithMessage:msg];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.isShowTip = false;
}

@end
