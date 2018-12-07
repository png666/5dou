//
//  WDUserInfoModel.m
//  5dou
//
//  Created by rdyx on 16/9/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDUserInfoModel.h"


//static WDUserInfoModel *_userModel;

@implementation WDUserInfoModel

//+(instancetype)shareInstance{
//    
//    if (!_userModel) {
//        _userModel = [[self allocWithZone:NULL] init];
//    }
//    return _userModel;
//}
//

+(instancetype)shareInstance{
    static WDUserInfoModel *_userModel = nil;
    static dispatch_once_t t;
    dispatch_once(&t,^{
        _userModel = [[WDUserInfoModel alloc]init];
    });
    return _userModel;
}

-(void)saveUserInfoWithDic:(NSDictionary *)dic
{
    self.memberId = dic[@"memberId"];
    self.nickName = dic[@"nickName"];
    self.headImg = dic[@"headImg"];
    self.gender = dic[@"gender"];
    self.mobile = dic[@"mobile"];
    self.sid = dic[@"sid"];
    self.inviteCode = dic[@"inviteCode"];
    self.userLevel = dic[@"userLevel"];
    self.resellerLevel = dic[@"resellerLevel"];
    self.walletAmount = dic[@"walletAmount"];
    self.alipayAccount = dic[@"alipayAccount"];
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
    self.isBindAlipay = NO;
    self.isWeixinAuth = NO;
    self.birthday = nil;
    self.schoolName = nil;
    self.interestTags = nil;
    self.sid = nil;
    self.alipayAccount = nil;
    self.isSign = false;
    self.isRebateShareToTimeLine = false;
}

-(void)clearHeadImage
{
    self.headImg = @"";
    self.headImg = nil;
}

@end
