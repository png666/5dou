//
//  WDSCWebViewController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDSCWebViewController.h"
#import "UMCustomManager.h"
#import "WDWebViewController.h"
@interface WDSCWebViewController ()
@property (nonatomic,strong) UIButton *backButton;
@end
@implementation WDSCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    // Do any additional setup after loading the view.
}


- (void)prepareUI{
    if (self.isShowNav) {
        self.navigationController.navigationBarHidden = false;
    }else
    {
        self.navigationController.navigationBarHidden = YES;
    }
    [self.webView setScalesPageToFit:YES];
    self.webView.scrollView.bounces = NO;
    self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"home_goBack"] forState:UIControlStateNormal];
    self.backButton.frame = CGRectMake(10, 10, 49, 49);
    [self.backButton addTarget:self action:@selector(webViewBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isShowNav) {
        self.navigationController.navigationBarHidden = false;
    }else
    {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


#pragma mark 实现代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    WeakStament(weakSelf);
    self.context[@"goback"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            weakSelf.navigationController.navigationBarHidden = NO;
        });
    };
    self.context[@"share"] = ^(NSDictionary *dict){
        YYLog(@"dict = %@",dict);
        YYLog(@"a = %@",dict[@"a"]);
        //分享的图片
        
        NSString *content = dict[@"shareContent"];
        NSString *title = dict[@"shareTitle"];
        NSString *url = dict[@"shareUrl"];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"shareImage"]]]];
//        [UMCustomManager shareWebWithViewController:weakSelf ShareTitle:title Content:content ThumbImage:image Url:url];
    };
    
    self.context[@"submit_ok"] = ^(NSInteger success){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success == 1) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.navigationController.navigationBarHidden = NO;
                if(weakSelf.successblock){
                    weakSelf.successblock();
                }
            }else{
                
            }
        });
    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    {
        NSString *urlStr = [request.URL absoluteString];
        YYLog(@"Str = %@",urlStr);
        //如果是双创的首页 或者是问卷调查的话
        if ((([urlStr containsString:@"5dou.cn/#"] || [urlStr containsString:@"wenjuan.5dou"] ) && !_isNotSC) || _isShowNav || [urlStr containsString:@"5dou.cn"]) {
            
            self.backButton.hidden = YES;
            
        }else if(!_isNotSC){
            
            WDSCWebViewController *scWebViewController = [[WDSCWebViewController alloc] init];
            scWebViewController.url = urlStr;
            scWebViewController.isNotSC = YES;
            scWebViewController.backButton.hidden = NO;
            [self.navigationController pushViewController:scWebViewController animated:YES];
            return NO;
        }
    }
    return YES;
}
- (void)webViewBack{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = NO;
    }
}
@end
