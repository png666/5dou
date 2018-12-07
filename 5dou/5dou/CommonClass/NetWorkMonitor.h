//
//  NetWorkMonitor.h
//  5dou
//
//  Created by rdyx on 16/9/3.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkReachabilityStatus) {
    NetworkReachabilityStatusUnknown          = -1,
    NetworkReachabilityStatusNotReachable     = 0,
    NetworkReachabilityStatusReachableViaWWAN = 1,
    NetworkReachabilityStatusReachableViaWiFi = 2,
};


@interface NetWorkMonitor : NSObject

@property (nonatomic, assign, readonly) BOOL isAvailableNetwork; // 网络是否可用
@property (nonatomic, assign, readonly) NetworkReachabilityStatus networkReachabilityStatus;

+ (instancetype)sharedMonitor;

- (void)startNetworkMonitoring; // 启动网络监控

- (void)stopNetworkMonitoring; // 关闭网络监控


@end

extern NSString *const kSLNetworkMonitorReachabilityDidChangeNotification; // 网络变化通知
extern NSString *const kSLNetworkMonitorReachabilityAvailableNotification; // 网络可用的通知

