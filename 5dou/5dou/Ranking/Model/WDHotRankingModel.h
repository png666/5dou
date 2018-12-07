//
//  WDHotRankingModel.h
//  5dou
//
//  Created by 黄新 on 16/11/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"

@class HotRankingDataModel,HotRankingResultModel;

@protocol HotRankingDataModel <NSObject>

@end

@interface HotRankingDataModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *mobile;
@property (nonatomic, copy) NSString <Optional> *nickName;
@property (nonatomic, copy) NSString <Optional> *inviteNumber;

@end

@protocol HotRankingResultModel <NSObject>

@end
@interface HotRankingResultModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *msg;
@property (nonatomic, copy) NSString <Optional> *code;
@end


@protocol WDHotRankingModel <NSObject>
@end

@interface WDHotRankingModel  : JSONModel

@property (nonatomic, strong) HotRankingResultModel *result;
@property (nonatomic, strong) NSArray <HotRankingDataModel,Optional> *data;

@end







