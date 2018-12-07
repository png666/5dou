//
//  WDWithDrawViewController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/26.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDWithDrawViewController.h"

@interface WDWithDrawViewController ()

@end

@implementation WDWithDrawViewController

- (void)viewDidLoad {
    [self.navigationItem setItemWithTitle:@"提现" textColor:kWhiteColor fontSize:19 itemType:center];
    [super viewDidLoad];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //拦截地址，js调用oc方法
    NSString *urlStr = [request.URL absoluteString];
    if ([urlStr containsString:@"doubi_html/my_doubi.html"]) {
        [self.navigationController popViewControllerAnimated:YES];
        if (_successBlock) {
            _successBlock();
        }
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
