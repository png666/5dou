//
//  WDH5MyDouBiController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5MyDouBiController.h"
#import "WDWithDrawViewController.h"
#import "WDUserInfoModel.h"
#import "WDBindingAlipayViewController.h"
#import "ToolClass.h"
#import "WDHTTPServer.h"
#import "WDMessageViewController.h"
@interface WDH5MyDouBiController ()

@end

@implementation WDH5MyDouBiController
- (void)viewDidLoad {
    
    [self.navigationItem setItemWithTitle:@"我的逗币" textColor:kWhiteColor fontSize:19 itemType:center];
     self.url = [NSString stringWithFormat:@"http://%@/doubi_html/my_doubi.html",H5Url];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView{
    [super webViewDidFinishLoad:webView];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:^(id obj, NSError *error) {
        
    }];
}

- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //拦截地址，js调用oc方法
    NSString *urlStr = [request.URL absoluteString];
    YYLog(@"%@",urlStr);
    
    if([urlStr containsString:@"login_html"]){
        [webView reload];
        return NO;
    }else if([urlStr containsString:@"/doubi_html/smrz.html"]){
        
        if (![WDUserInfoModel shareInstance].isBindAlipay) {
            
            WDBindingAlipayViewController *bind = [[WDBindingAlipayViewController alloc]init];
            [self.navigationController pushViewController:bind animated:YES];
            
        }else{
            
            WDWithDrawViewController *withDrawCV = [WDWithDrawViewController new];
            withDrawCV.url = urlStr;
            WeakStament(weakSelf);
            withDrawCV.successBlock = ^(){
                [weakSelf.webView reload];
                [ToolClass showAlertWithMessage:@"申请提现成功"];
            };
            [self.navigationController pushViewController:withDrawCV animated:YES];
        }
        
        return NO;
    }else if([urlStr containsString:@"main_html/news.html"]){
        WDMessageViewController *messageVC = [[WDMessageViewController alloc] init];
        messageVC.titleString = @"系统消息";
        [self.navigationController pushViewController:messageVC animated:YES];
        return NO;
    }
      return YES;
};



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
