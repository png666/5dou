//
//  AppDelegate+Bugly.m
//  5dou
//
//  Created by 黄新 on 16/10/11.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  集成Bugly  配置crash日志收集的相关配置
//

#import "AppDelegate+Bugly.h"
#import <Bugly/Bugly.h>

@implementation AppDelegate (Bugly)


#pragma mark - 崩溃监测
-(void)crashMonitor
{
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    [Bugly startWithAppId:BUGLY_APP_ID
     
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
}

@end
