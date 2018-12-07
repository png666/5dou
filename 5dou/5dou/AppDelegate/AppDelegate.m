//
//  AppDelegate.m
//  5dou
//
//  Created by rdyx on 16/8/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "AppDelegate.h"
#import "WDMainTabBarController.h"
#import "IQKeyboardManager.h"
#import "WDIntroViewController.h"
#import "CoverTomato.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+JPush.h"
#import "AppDelegate+Bugly.h"
#import "AppDelegate+NetworkMonitor.h"
#import "DQAlertView.h"
#import "ToolClass.h"
//#import "WXApi.h"
#import "WDWeixinLogin.h"
#import "WDUserInfoModel.h"
#import "AvoidCrash.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LocateManager.h"

//#import "UMSocialSnsService.h"

#define LaunchKEY  @"firstlaunch"
#define kDianruKey @"00005F3F28000016"



//#import "RNCachingURLProtocol.h"

@interface AppDelegate ()<DQAlertViewDelegate>
@property(nonatomic,strong)DQAlertView *alertView;
@property(nonatomic,copy) NSString *updateUrl;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    YYLog(@"9.22测试");
    YYLog(@"沙盒---------%@",NSHomeDirectory());
    
//    ///后台定位测试
//    [[LocateManager shareInstance] locateWithSuccessBlock:^(NSString *cityName) {
//        //获取推送的是城市code
//        YYLog(@"%@",cityName);
//        [AFToast showText:cityName];
//
//    } failBlock:^(NSError *error) {
//        
//        YYLog(@"%@",error);
//        
//    }];

    
    
    //友盟
    [self UMengApplication:application didFinishLaunchingWithOptions:launchOptions];
    //极光推送
    [self jPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    //设置输入框被键盘挡住的情况
    [self setIQKeyboard];
    //网络监控
    [self networkMonitor];
    //崩溃监测
    [self crashMonitor];
    //
//    [WXApi registerApp:WX_APPID withDescription:@"weixinauth"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //引导页
    [self setMainWindow];
    [self.window makeKeyAndVisible];
    
//    //加入容错处理，并且接受信息
    [AvoidCrash becomeEffective];
    //注册监听，获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealWithCrashMessage:)  name:AvoidCrashNotification object:nil];
    
    
    UN_SWIZZ_IT
    return YES;
}


- (void)dealWithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    YYLog(@">>>>>>>(*_*)发生崩溃了<<<<<<<<,看看下面的信息")
    YYLog(@"%@",note.userInfo);
}

#pragma mark - ios9之前
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [self UMengApplication:application handleOpenURL:url];
}
#pragma mark - ios9之前
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    else{
        
        if ([WDUserInfoModel shareInstance].weixinNativeSDK) {
            //微信认证
//            return [WXApi handleOpenURL:url delegate:self];
            
        }else{
            //友盟
            return [self UMengApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }

        
    }
    return YES;
}

#pragma mark - ios9之后
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                //支付成功
                 [[NSNotificationCenter defaultCenter]postNotificationName:kAlipaySucceedInfo object:nil];
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"])
            {
                //支付失败
                 [[NSNotificationCenter defaultCenter]postNotificationName:kAlipayFailedInfo object:nil];
                
            }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
                //用户取消
                 [[NSNotificationCenter defaultCenter]postNotificationName:kAlipayCancelInfo object:nil];
            }
            YYLog(@"result = %@",resultDic);
            
        }];
    }
    else{
       
        
        if ([WDUserInfoModel shareInstance].weixinNativeSDK) {
            
//            return [WXApi handleOpenURL:url delegate:self];
            
        }else{
             //友盟
             return [self UMengApplication:app openURL:url options:options];
        }
       
    }
    return YES;
}


#pragma mark =================== 第一次启动添加引导页
- (void)setMainWindow{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:LaunchKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LaunchKEY];
        WDIntroViewController *intro = [[WDIntroViewController alloc]init];
        self.window.rootViewController = intro;
    }else{
        WDMainTabBarController * tabbarVC = [[WDMainTabBarController alloc] init];
        self.window.rootViewController = tabbarVC;
#if DEBUG
//        [[JPFPSStatus sharedInstance] open];
#endif
    }
}


#pragma mark =================== 设置键盘被输入框挡住的情况
- (void)setIQKeyboard{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}
#pragma mark =================== Jpush
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
}

#pragma mark =================== iOS7及以上系统接收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    completionHandler(UIBackgroundFetchResultNewData);
    YYLog(@"iOS7及以上系统，收到通知");
    //极光推送 接收推送信息
    [self jPushApplication:application didReceiveRemoteNotification:userInfo];
    
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //接收到本地通知
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //极光推送获取deviceToken
    [self jPushApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    YYLog(@"%@",error);
    [self jPushApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark ==================== UMeng
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self appLoveUpdate];
    
    //发送通知，进行刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTaskDetial" object:self];
}


/**
  版本检查-强制更新
 */
-(void)appLoveUpdate
{
    if (_alertView) {
        if (_alertView.tag==9999) {
        [_alertView removeFromSuperview];
        }
    }
    
    [WDNetworkClient postRequestWithBaseUrl:kGetNewVersion setParameters:nil success:^(id responseObject) {
    
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            //服务器存的version号 forceUpdate needUpdate
            NSString *versionFromServer =  responseObject[@"data"][@"version"];
            NSNumber *needUpdate =  responseObject[@"data"][@"needUpdate"];
            NSNumber *forceUpdate =  responseObject[@"data"][@"forceUpdate"];
            self.updateUrl = responseObject[@"data"][@"url"];

            [WDUserInfoModel shareInstance].updateUrl = self.updateUrl;
            if ([[ToolClass getAPPVersion] compare:versionFromServer]==NSOrderedAscending) {
            
                if ([needUpdate isEqualToNumber:@(1)]&&[forceUpdate isEqualToNumber:@(1)])
                    {
                        DQAlertView *alertView = [[DQAlertView alloc]initWithTitle:@"温馨提示" message:@"发现新版本，新功能更好用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新"];
                        _alertView = alertView;
                        alertView.tag = 9999;
                        [alertView show];
                    }
            }
        }
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:nil];
}


#pragma mark - DQAlertdelegate
-(void)otherButtonClickedOnAlertView:(DQAlertView *)alertView
{
    
    if ([alertView.otherButton.currentTitle isEqualToString:@"更新"]) {
        
        NSString *appid = Apple_ID;
//        NSString *url =  [NSString stringWithFormat:
//                          @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
    }
}

#pragma mark - WXApiDelegate
//- (void)onResp:(BaseResp*)resp
//{
//    
//    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
//        // 分享的逻辑
//        
//    }else if([resp isKindOfClass:[SendAuthResp class]]){
//        // 登录的逻辑
//        SendAuthResp *temp = (SendAuthResp *)resp;
//        //如果点击了取消，这里的temp.code 就是空值
//        if (temp.code != nil) {
//            
//            [WDWeixinLogin wechatAuth:temp.code];
//
//        }else{
//            //点击了取消回来重新开始
//            [WDUserInfoModel shareInstance].weixinNativeSDK = false;
//        }
//    }
//}



@end
