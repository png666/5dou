

//
//  WDAboutPlatformViewController.m
//  5dou
//
//  Created by rdyx on 16/12/16.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDAboutPlatformViewController.h"

@interface WDAboutPlatformViewController ()



@end

@implementation WDAboutPlatformViewController

- (void)viewDidLoad {
    
    if (self.productUrl) {
        //这个是公共url
        self.url = self.productUrl;
        
    }else if(self.isAbout5dou){
        //关于我们
        self.url = [NSString stringWithFormat:@"http://%@/#!/guanyuwm",H5Url];
       

    }
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setItemWithTitle:self.productUrl?@"":@"平台说明" textColor:kBlackColor fontSize:19 itemType:center];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.withHead||self.isAbout5dou) {
        
        self.navigationController.navigationBarHidden = false;
        self.isAbout5dou = false;
    }else
    {
        self.navigationController.navigationBarHidden = true;
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

-(void)backItemClick
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [super backItemClick];
    }
}

#pragma mark - wkwebview delegte
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    YYLog(@"%@",message.body);
    NSDictionary *body = (NSDictionary *)message.body;
    if ([message.name isEqualToString:@"goBack"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
