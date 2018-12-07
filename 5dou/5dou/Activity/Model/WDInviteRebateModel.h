//
//  WDInviteRebateModel.h
//  5dou
//
//  Created by 黄新 on 16/12/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//JSONModel 解析时有几层字典{ }就要写几个model,看{ }字典符号写model

#import <JSONModel/JSONModel.h>
@class WDInviteRebateResultModel,WDInviteRebateDataModel,RankingListModel;

@protocol RankingListModel <NSObject>
@end

@interface RankingListModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*mobile;
@property (nonatomic, copy) NSString <Optional>*nickName;
@property (nonatomic, copy) NSString <Optional>*headImg;
@property (nonatomic, copy) NSString <Optional>*walletAmount;

@end



@protocol WDInviteRebateModel <NSObject>
@end

@interface WDInviteRebateModel : JSONModel
@property (nonatomic, strong) WDInviteRebateDataModel <Optional> *data;
@property (nonatomic, strong) WDInviteRebateResultModel <Optional> *result;

@end

@protocol WDInviteRebateResultModel <NSObject>
@end

@interface WDInviteRebateResultModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *code;
@property (nonatomic, copy) NSString <Optional> *msg;

@end

@protocol WDInviteRebateDataModel <NSObject>
@end

@interface WDInviteRebateDataModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*share_title;
@property (nonatomic, copy) NSString <Optional>*qrCodePath;
@property (nonatomic, copy) NSString <Optional>*share_content;
@property (nonatomic, copy) NSString <Optional>*todayRebate;
@property (nonatomic, copy) NSString <Optional>*share_logo_url;
@property (nonatomic, copy) NSString <Optional>*totalRebate;
@property (nonatomic, copy) NSString <Optional>*share_url;
@property (nonatomic, copy) NSString <Optional>*inviteNumber;
@property (nonatomic, copy) NSString <Optional>*share_pyq_content;//朋友圈

@property (nonatomic, strong) NSArray <RankingListModel,Optional> *moneyRankList;


@end
