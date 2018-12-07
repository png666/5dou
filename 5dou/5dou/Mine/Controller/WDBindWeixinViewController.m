


//
//  WDBindWeixinViewController.m
//  5dou
//
//  Created by rdyx on 16/12/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBindWeixinViewController.h"
//#import "WXApi.h"
#import "ToolClass.h"
#import "WDUserInfoModel.h"
#import "WDCashViewController.h"
@interface WDBindWeixinViewController ()

@end

@implementation WDBindWeixinViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveWeixinAuthInfo) name:kSaveWechatUserInfo object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setItemWithTitle:@"绑定微信号" textColor:kBlackColor fontSize:19 itemType:center];
    [self makeUI];
    // Do any additional setup after loading the view.
}

-(void)makeUI{
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth-40,ScreenWidth>375?400:(ScreenWidth>320?360:300))];
    img.image = [UIImage imageNamed:@"wxbg"];
    [self.view addSubview:img];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, img.bottom+35, ScreenWidth-60, 45);
    btn.centerX = self.view.centerX;
    btn.layer.cornerRadius = 22.5f;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"微信认证" forState:UIControlStateNormal];
    [btn setTitleColor:KCoffeeColor forState:UIControlStateNormal];
    [btn setBackgroundColor:kMainColor];
    [btn addTarget:self action:@selector(wexinOAuthAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

//微信认证登录
-(void)wexinOAuthAction{
    
     [WDUserInfoModel shareInstance].weixinNativeSDK = true;
//    if ([WXApi isWXAppInstalled]) {
//
//        SendAuthReq* req = [[SendAuthReq alloc] init];
//        req.scope = @"snsapi_userinfo" ;
//        req.state = @"weixinauth" ;
//        //第三方向微信终端发送一个SendAuthReq消息结构
//        [WXApi sendReq:req];
//
//    }else{
//        [ToolClass showAlertWithMessage:@"请安装微信客户端"];
//    }
}

#pragma mark - 微信登录后同后台交互将微信用户信息保存到远端
-(void)saveWeixinAuthInfo{

    NSDictionary *dic = @{@"wechartAccount":[WDUserInfoModel shareInstance].openid,@"wechartAccountName":[WDUserInfoModel shareInstance].nickName,@"wechartHeadImg":[WDUserInfoModel shareInstance].headImg};
    [WDNetworkClient postRequestWithBaseUrl:kSaveWechatAuthInfoUrl setParameters:dic success:^(id responseObject) {
        
        if (responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([dic[@"result"][@"code"] isEqualToString:@"1017"]) {
                //1017 已经关联其他帐号
                [ToolClass showAlertWithMessage:dic[@"result"][@"msg"]];
                
            }else if ([dic[@"result"][@"code"] isEqualToString:@"1000"]){
                
                [ToolClass showAlertWithMessage:@"绑定成功"];
                //标识微信已经认证成功
                 [WDUserInfoModel shareInstance].isWeixinAuth = YES;
                //绑定成功后走了个闭环，就把这个标记位置空
                [WDUserInfoModel shareInstance].weixinNativeSDK = false;
                WDCashViewController *cash = [WDCashViewController new];
                [self.navigationController pushViewController:cash animated:YES];
            }else{
                //系统异常或其他
                [ToolClass showAlertWithMessage:dic[@"result"][@"msg"]];
                return;
            }
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
    
}
-(void)dealloc{
    //在VC销毁时移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
