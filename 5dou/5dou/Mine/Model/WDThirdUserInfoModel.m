//
//  WDThirdUserInfoModel.m
//  5dou
//
//  Created by 黄新 on 16/9/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  存贮第三方登录返回的数据
//

#import "WDThirdUserInfoModel.h"

@implementation WDThirdUserInfoModel

+(instancetype)shareInstance{
    
    static WDThirdUserInfoModel *_thirdUserModel = nil;
    static dispatch_once_t t;
    dispatch_once(&t,^{
        
        _thirdUserModel = [[WDThirdUserInfoModel alloc]init];
        
        
    });
    return _thirdUserModel;
}

-(void)saveUserInfoWithDic:(NSDictionary *)dic
{
    self.memberId = dic[@"memberId"];
    self.gender = dic[@"gender"];
    self.mobile = dic[@"mobile"];
    self.inviteCode = dic[@"inviteCode"];
    self.nickName = dic[@"nickName"];
    self.resellerLevel = dic[@"resellerLevel"];
    
}

- (void)clearUserInfo{
    
    self.memberId = nil;
    self.nickName = nil;
    self.headImg = nil;
    self.gender = nil;
    self.mobile = nil;
    self.inviteCode = nil;
    
    self.userLevel = nil;
    self.resellerLevel = nil;
    self.msg = nil;
    self.walletAmount = nil;
}
@end
