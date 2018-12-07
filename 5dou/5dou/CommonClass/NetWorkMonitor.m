
//
//  NetWorkMonitor.m
//  5dou
//
//  Created by rdyx on 16/9/3.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "NetWorkMonitor.h"
#import "AFNetworkReachabilityManager.h"
@interface NetWorkMonitor()

@property (nonatomic, assign, getter = isLastNotificationNetworkStatus) BOOL lastNotificationNetworkStatus; // 最后一次网络变化通知的状态
@property (nonatomic, assign, getter = isFirstNetworkStatusChangeNotification) BOOL firstNetworkStatusChangeNotification; // 是否第一次网络变化的通知


@end

@implementation NetWorkMonitor


+ (instancetype)sharedMonitor{
    static NetWorkMonitor *_networkMonitor = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        _networkMonitor = [[self alloc] init];
        // 默认为第一次网络状态变化的通知
        _networkMonitor.firstNetworkStatusChangeNotification = YES;
    });
    return _networkMonitor;
}

- (void)startNetworkMonitoring{
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager startMonitoring];
    
    // 网络状态变化的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)stopNetworkMonitoring{
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager stopMonitoring];
}

- (void)networkingReachabilityDidChangeNotification:(NSNotification *)notification{
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    // 网络是否可用的判断
    _isAvailableNetwork = networkReachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN || networkReachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
    
    // 网络状态
    _networkReachabilityStatus = (NetworkReachabilityStatus)networkReachabilityManager.networkReachabilityStatus;
    // 如果是第一次网络状态变化或者当前这次的网络状态（可用或者不可用）和上一次的网络状态不一样，则发送通知
    // 拦截发送两次网络状态一样的通知（第一次发送，第二次拦截）
    if(self.isFirstNetworkStatusChangeNotification || self.isLastNotificationNetworkStatus != _isAvailableNetwork){
        // 如果收到过一次通知，则以后的都不是第一次通知了
        self.firstNetworkStatusChangeNotification = NO;
        // 当前网络的可用状态
        self.lastNotificationNetworkStatus = _isAvailableNetwork;
        // 发送网络的通知通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kSLNetworkMonitorReachabilityDidChangeNotification object:self];
        
        // 发送网络可用的通知
        if(_isAvailableNetwork){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSLNetworkMonitorReachabilityAvailableNotification object:self];
        }
    }
}


@end

NSString *const kSLNetworkMonitorReachabilityDidChangeNotification = @"kSLNetworkMonitorReachabilityDidChangeNotification";
NSString *const kSLNetworkMonitorReachabilityAvailableNotification = @"kSLNetworkMonitorReachabilityAvailableNotification";
NSString *const kSLNetworkMonitorAutoLoginSuccessNotification = @"kSLNetworkMonitorAutoLoginSuccessNotification";