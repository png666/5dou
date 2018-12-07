
//
//  WDWeixinLogin.m
//  5dou
//
//  Created by rdyx on 16/12/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDWeixinLogin.h"
#import "WDUserInfoModel.h"

@implementation WDWeixinLogin

//1从微信回调中拿到授权码code
//2用授权码获取token令牌
//3通过token获取用户信息

+(void)wechatAuth:(NSString *)code{
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_BASE_URL, WX_APPID, WX_APPSECRET, code];
    WeakStament(ws);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:accessUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        YYLog(@"%@",responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        [WDUserInfoModel shareInstance].openid = dic[@"openid"];
        [WDUserInfoModel shareInstance].access_token = dic[@"access_token"];
        [ws getUserInfoAfterAuth];
        //o4T-NxFss_Nms2nc1llbziTRiHTQ
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YYLog(@"%@",error);
    }];

}


///微信登录第二步：根据access_token和openid获取用户信息
+(void)getUserInfoAfterAuth{
    
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/userinfo?access_token=%@&openid=%@", WX_BASE_URL, [WDUserInfoModel shareInstance].access_token, [WDUserInfoModel shareInstance].openid];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager GET:accessUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        [WDUserInfoModel shareInstance].nickName = dic[@"nickname"];
        [WDUserInfoModel shareInstance].headImg = dic[@"headimgurl"];
        //和微信服务器交互后拿到用户信息，然后通知和自己的服务器交互，将用户信息存储
        [[NSNotificationCenter defaultCenter]postNotificationName:kSaveWechatUserInfo object:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YYLog(@"%@",error);
    }];
    
}


@end
