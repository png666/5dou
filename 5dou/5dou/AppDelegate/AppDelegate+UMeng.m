//
//  AppDelegate+UMeng.m
//  5dou
//
//  Created by 黄新 on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  配置友盟统计和友盟分享相关
//

#import "AppDelegate+UMeng.h"
#import <UMMobClick/MobClick.h>
#import "WDUserInfoModel.h"
//#import <UMSocialCore/UMSocialCore.h>

@interface  AppDelegate()

@end

@implementation AppDelegate (UMeng)

- (void)UMengApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self UmengTrack];
    [self setUMHandler];
    ///UMeng调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
}
//umeng 统计
//umeng statistics
- (void)UmengTrack {
    
    //[MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //a3cd1e43a1ff28ef0fc66866782dc6406d63b6b5
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UmengAPPKey;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.bCrashReportEnabled = false;
    UMConfigInstance.ePolicy = 1;
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)setUMHandler{
    //关闭UMeng分享完成时"弹窗"
    //    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
//    [[UMSocialManager defaultManager] openLog:YES];
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UmengAPPKey];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPID appSecret:QQ_APPKEY redirectURL:UMeng_RedirectURL];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:QQ_APPID appSecret:QQ_APPKEY redirectURL:UMeng_RedirectURL];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPID appSecret:WX_APPSECRET redirectURL:UMeng_RedirectURL];
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WX_APPID appSecret:WX_APPSECRET redirectURL:UMeng_RedirectURL];

}

#pragma mark - umeng  iOS9之前
-(BOOL)UMengApplication:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return YES;
//    return [[UMSocialManager defaultManager] handleOpenURL:url];
}
-(BOOL)UMengApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return YES;
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//
//    }
//    return result;
}
#pragma mark - 9.0 or later
//9.0之后
- (BOOL)UMengApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return YES;
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//
//    }
//    return result;
}

@end
