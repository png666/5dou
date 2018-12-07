//
//  AppDelegate+UMeng.h
//  5dou
//
//  Created by 黄新 on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (UMeng)

- (void)UMengApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)UMengApplication:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)UMengApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)UMengApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


@end
