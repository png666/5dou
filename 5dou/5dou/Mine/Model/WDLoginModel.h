//
//  WDLoginModel.h
//  5dou
//
//  Created by 黄新 on 16/9/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  登录时后台返回的数据
//
#import "JSONModel.h"


@class ResultModel,DataModel;

@protocol  WDLoginModel<NSObject>
@end

@interface WDLoginModel : JSONModel

@property (nonatomic, strong) ResultModel *result;
@property (nonatomic, strong) DataModel <Optional> *data;

@end


@protocol  ResultModel<NSObject>
@end
@interface ResultModel : JSONModel

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *code;

@end

@protocol  DataModel<NSObject>
@end

@interface DataModel : JSONModel
@property (nonatomic, copy) NSString <Optional>*memberId;
@property (nonatomic, copy) NSString <Optional>*nickName;
@property (nonatomic, copy) NSString <Optional>*headImg;
@property (nonatomic, copy) NSString <Optional>*gender;
@property (nonatomic, copy) NSString <Optional>*mobile;
@property (nonatomic, copy) NSString <Optional>*inviteCode;
@property (nonatomic, copy) NSString <Optional>*userLevel;
@property (nonatomic, copy) NSString <Optional>*resellerLevel;
@property (nonatomic, copy) NSString <Optional>*msg;
@property (nonatomic, copy) NSString <Optional>*walletAmount;
@property (nonatomic, copy) NSString <Optional>*sid;

@end
