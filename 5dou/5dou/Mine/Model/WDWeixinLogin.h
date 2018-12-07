//
//  WDWeixinLogin.h
//  5dou
//
//  Created by rdyx on 16/12/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//本类是微信认证

@interface WDWeixinLogin : NSObject
//微信三方登录
+(void)wechatAuth:(NSString *)code;

+(void)getUserInfoAfterAuth;

@end
