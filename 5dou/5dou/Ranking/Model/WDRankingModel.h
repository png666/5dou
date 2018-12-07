//
//  WDRankingModel.h
//  5dou
//
//  Created by 黄新 on 16/11/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"

@class RankingDataModel,RankingResultModel;

@protocol RankingDataModel <NSObject>

@end

@interface RankingDataModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *mobile;
@property (nonatomic, copy) NSString <Optional> *nickName;
@property (nonatomic, copy) NSString <Optional> *headImg;
@property (nonatomic, copy) NSString <Optional> *totalDoubi;

@end

@protocol WDRankingModel <NSObject>
@end

@interface WDRankingModel  : JSONModel

@property (nonatomic, strong) RankingResultModel *result;
@property (nonatomic, strong) NSArray <RankingDataModel,Optional> *data;

@end


@protocol RankingResultModel <NSObject>

@end
@interface RankingResultModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *msg;
@property (nonatomic, copy) NSString <Optional> *code;
@end





