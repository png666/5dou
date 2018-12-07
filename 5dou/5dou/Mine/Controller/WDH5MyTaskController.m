//
//  WDH5MyTaskController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5MyTaskController.h"
#import "WDH5TaskViewController.h"
#import "WDHTTPServer.h"
@interface WDH5MyTaskController ()

@end

@implementation WDH5MyTaskController

- (void)viewDidLoad {
    [self.navigationItem setItemWithTitle:@"我的任务" textColor:kWhiteColor fontSize:19 itemType:center];
    self.url = [NSString stringWithFormat:@"http://%@/my_work_html/jxz.html",H5Url];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //每次出现的时候从新刷新一下
    [self.webView reload];
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
    //进行页面的跳转
    if ([urlStr containsString:@"worklist_html"]) {
        //获取taskId
        NSRange taskIdRange = [urlStr rangeOfString:@"taskId="];
        NSString *taskId = [urlStr substringFromIndex:taskIdRange.location + taskIdRange.length];
        WDH5TaskViewController *h5TaskDetailController = [[WDH5TaskViewController alloc] init];
        h5TaskDetailController.taskId = taskId;
        [self.navigationController pushViewController:h5TaskDetailController animated:YES];
        return NO;
    }else if([urlStr containsString:@"login_html"]){
        [webView reload];
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
