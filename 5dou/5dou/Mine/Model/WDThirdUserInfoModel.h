//
//  WDThirdUserInfoModel.h
//  5dou
//
//  Created by 黄新 on 16/9/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDThirdUserInfoModel : NSObject

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *inviteCode;
@property (nonatomic, copy) NSString *userLevel;
@property (nonatomic, copy) NSString *resellerLevel;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *walletAmount;

@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *schoolName;
@property(nonatomic,copy)NSString *interestTags;

+(instancetype)shareInstance;

- (void)saveUserInfoWithDic:(NSDictionary *)dic;


//清空单例信息

- (void)clearUserInfo;

@end
