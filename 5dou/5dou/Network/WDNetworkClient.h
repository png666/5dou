//
//  WDNetworkClient.h
//  5dou
//
//  Created by rdyx on 16/8/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface WDNetworkClient : NSObject

+(AFHTTPSessionManager *)sharedManager;

//get请求
+(void)getRequestWithBaseUrl:(NSString *)url setParameters:(NSDictionary *)paraDic success:(void(^)(id responseObject))success fail:(void(^)(NSError *error))fail delegater:(UIView *)view;


///Post请求
+(void)postRequestWithBaseUrl:(NSString *)url setParameters:(NSDictionary *)paraDic success:(void(^)(id responseObject))success fail:(void(^)(NSError *error))fail delegater:(UIView *)view;

//图片上传
+(void)uploadImage:(UIImage *)image url:(NSString *)urlString;

//下载
- (void)downFileFromServerFromURl:(NSString *)urlString;

//逻辑转移
//+(void)wechatAuth:(NSString *)code;
//
//+(void)wechatGetUserInfoAfterAuth;

@end
