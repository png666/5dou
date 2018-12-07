//
//  AppDelegate+JPush.h
//  5dou
//
//  Created by 黄新 on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//




#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate (JPush)


- (void)jPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 *  @brief 注册APNS
 *
 *  @param application 当前应用
 *  @param deviceToken 设备标识
 */
- (void)jPushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
/**
 *  @brief APNS服务注册失败
 *
 *  @param application 当前应用
 *  @param error       错误信息
 */
- (void)jPushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;


//iOS7及以上接收到通知
- (void)jPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;


//适配iOS10
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler;

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler;
#endif



@end
