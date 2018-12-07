//
//  AppDelegate+NetworkMonitor.m
//  5dou
//
//  Created by 黄新 on 16/10/11.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  网络检测
//

#import "AppDelegate+NetworkMonitor.h"
#import "ToolClass.h"
#import "WDUserInfoModel.h"
#import <objc/runtime.h>
#import "Reachability.h"
@implementation AppDelegate (NetworkMonitor)

@dynamic conn;

NSString const  *NetworkMonitor_ConnKey = @"NetworkMonitor_ConnKey";
static NSString *NetHost = @"www.baidu.com";
static NSString *NetAlert = @"亲，您的网络开小差了";


//网络检测
-(void)networkMonitor
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    self.conn = [Reachability reachabilityWithHostName:NetHost];
    [self.conn startNotifier];
    
}

- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) {
        
        [ToolClass showAlertWithMessage:NetAlert];
        [WDUserInfoModel shareInstance].isReachable = false;
    }else
    {
        [WDUserInfoModel shareInstance].isReachable = YES;
    }
    
}

#pragma mark ------ Getter/Setter
- (Reachability *)conn{
    return objc_getAssociatedObject(self, &NetworkMonitor_ConnKey);
}

- (void)setConn:(Reachability *)conn{
    objc_setAssociatedObject(self, &NetworkMonitor_ConnKey, conn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
