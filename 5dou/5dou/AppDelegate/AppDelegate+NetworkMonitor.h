//
//  AppDelegate+NetworkMonitor.h
//  5dou
//
//  Created by 黄新 on 16/10/11.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "AppDelegate.h"



@class Reachability;

@interface AppDelegate (NetworkMonitor)

@property (nonatomic) Reachability *conn;

/**
 网络监测
 */
- (void)networkMonitor;

@end
