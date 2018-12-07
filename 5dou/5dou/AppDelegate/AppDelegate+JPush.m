//
//  AppDelegate+JPush.m
//  5dou
//
//  Created by 黄新 on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  极光推送的初始化和相关配置
//
#import "AppDelegate+JPush.h"
#import "WDAPNSModel.h"

#import "JPUSHService.h"


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate (JPush)

#ifdef DEBUG
static BOOL const apsForProducation = FALSE;
#else
static BOOL const apsForProducation = TRUE;
#endif
//*********** 5dou *********//
//static NSString *jPushAppKey = @"8ef709d90ad8b2a6b7a4bbea";
//*********** 5逗 *********//
static NSString *jPushAppKey = @"03b79336ddd1376aa4a5ec63";

static NSString *channel = @"App Store";

- (void)jPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [JPUSHService setDebugMode];
    //极光推送
    //    [self jPushWithOptions:launchOptions];
//    [self pushWithOptions:launchOptions];
    [self jPushWithOptions:launchOptions];
}

//- (void)pushWithOptions:(NSDictionary *)launchOptions{
//    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                      UIUserNotificationTypeSound |
//                                                      UIUserNotificationTypeAlert)
//                                          categories:nil];
//
//
//    //如不需要使用IDFA，advertisingIdentifier 可为nil
//    [JPUSHService setupWithOption:launchOptions appKey:jPushAppKey
//                          channel:channel
//                 apsForProduction:apsForProducation
//            advertisingIdentifier:nil];
//
//
//    //对于WebView进行内存管理
//    int cacheSizeMemory = 4*1024*1024; // 4MB
//    int cacheSizeDisk = 32*1024*1024; // 32MB
//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
//    [NSURLCache setSharedURLCache:sharedCache];
//
//}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

//初始化相关的配置
- (void)jPushWithOptions:(NSDictionary *)launchOptions{
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if (iOS8OrLater) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:jPushAppKey
                          channel:channel
                 apsForProduction:apsForProducation
            advertisingIdentifier:advertisingId];
#if DEBUG
    //设置推送日志
    [JPUSHService setDebugMode];
#endif
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        if(resCode == 0){
            YYLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            YYLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

- (void)jPushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jPushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    //注册APNS失败
    YYLog(@"%@",error);
}

#pragma mark ========== iOS7以上收到通知
- (void)jPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    //修复通知数字叠加显示
    int badge =[userInfo[@"aps"][@"badge"] intValue];
    badge--;
    [JPUSHService setBadge:badge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    [JPUSHService resetBadge];

    WDAPNSModel *apnsModel = [[WDAPNSModel alloc] initWithDictionary:userInfo error:nil];
    
    YYLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    }
    
    /**
     *  iOS的应用程序分为3种状态
     *      1、前台运行的状态UIApplicationStateActive；
     *      2、后台运行的状态UIApplicationStateInactive；
     *      3、app关闭状态UIApplicationStateBackground。
     */
    
    //从后台点击消息进入
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive ){
        //发送页面跳转的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:WD_JUMP_TO_VIEWCONTROLLER object:nil userInfo:@{@"event":apnsModel}];
    }
    //程序在后台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ){
    }
    //程序活跃的时候接收到推送消息
    if (application.applicationState == UIApplicationStateActive) {
        
        [self showNotificationAlert:apnsModel];
    }
    
    // badge清零
    [application setApplicationIconBadgeNumber:0];
    //重置服务器端徽章
    [JPUSHService resetBadge];
}

#pragma mark- JPUSHRegisterDelegate


#pragma mark ===== 去除警告Category is implementing a method which will also be implemented by its primary class
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate --- iOS10
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService resetBadge];
        [JPUSHService handleRemoteNotification:userInfo];
//        WDAPNSModel *apnsModel = [[WDAPNSModel alloc] initWithDictionary:userInfo error:nil];
        
        YYLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        //从后台点击消息进入
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive ){
            // 发送跳转通知
            
        }
        //程序活跃的时候接收到推送消息
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            
        }
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            
           
        }
    }
    else {
        // 判断为本地通知
        YYLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        WDAPNSModel *apnsModel = [[WDAPNSModel alloc] initWithDictionary:userInfo error:nil];
        //发送页面跳转的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:WD_JUMP_TO_VIEWCONTROLLER object:nil userInfo:@{@"event":apnsModel}];

        YYLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        YYLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}
#pragma clang diagnostic pop

#endif

#pragma mark ================== 打印推送的信息
/**
 打印接受到的推送信息

 @param dic

 @return 返回通知内容
 */
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark ==============程序前台的时候显示推送信息的样式
- (void)showNotificationAlert:(WDAPNSModel *)apnsModel {
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"收到推送消息" message:apnsModel.aps.alert preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self clearBadge];
    }];
    UIAlertAction * otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        //发送页面跳转的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:WD_JUMP_TO_VIEWCONTROLLER object:nil userInfo:@{@"event":apnsModel}];
        [self clearBadge];
    }];
    [alertVc addAction:cancelAction];
    [alertVc addAction:otherAction];
    [self.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
}

- (void)clearBadge
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


@end
