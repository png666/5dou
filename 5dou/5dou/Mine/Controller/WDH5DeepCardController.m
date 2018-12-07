//
//  WDH5DeepCardController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/22.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDH5DeepCardController.h"
#import "WDTaskDetailController.h"
#import "ToolClass.h"

@interface WDH5DeepCardController ()

@end

@implementation WDH5DeepCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"专属任务卡" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    // Do any additional setup after loading the view.
}


//进行拦截处理
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //截获不同的URL进行原生页面的操作
    NSString *skipUrl = navigationAction.request.URL.absoluteString;
    //首页的话,默认加载
    if ([skipUrl containsString:self.url]) {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
        if([skipUrl containsString:@"#!/taskInfo"]){
            NSString *skipId = @"";
            if ([skipUrl containsString:@"?id="]) {
                NSRange rangeId = [skipUrl rangeOfString:@"?id="];
                skipId = [skipUrl substringFromIndex:(rangeId.location + 4)];
                [self prepareDataDetail:skipId];
            }
        }
      
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}


//进入任务详情页面
- (void)prepareDataDetail:(NSString *)taskId{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:taskId forKey:@"taskId"];
    [WDNetworkClient postRequestWithBaseUrl:kTaskDetailUrl setParameters:param success:^(id responseObject) {
        if (![responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"该任务已经下架了"];
            return ;
        }
        NSDictionary *dict = responseObject[@"data"];
        WDTaskDetailModel *taskDetailModel = [[WDTaskDetailModel alloc] initWithDictionary:dict error:nil];
        WDTaskDetailController *detailController = [WDTaskDetailController new];
        [detailController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailController animated:YES];
        detailController.taskDetailModel = taskDetailModel;
    } fail:^(NSError *error) {
    } delegater:self.view];
}




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
