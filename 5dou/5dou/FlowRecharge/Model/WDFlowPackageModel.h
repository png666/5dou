//
//  WDFlowPageModel.h
//  5dou
//
//  Created by 黄新 on 16/12/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值的model
//

#import <JSONModel/JSONModel.h>

@class WDFlowLocalKeyModel,WDFlowWholeKeyModel,WDFlowListModel,WDFlowPackageDataModel,WDFlowPackageResultModel;

@protocol WDFlowLocalKeyModel <NSObject>
@end

@interface WDFlowLocalKeyModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *startDataTime;
@property (nonatomic, copy) NSString <Optional> *refundBalance;///< 返还逗币
@property (nonatomic, copy) NSString <Optional> *sellPrice;///< 售价
@property (nonatomic, copy) NSString <Optional> *validityPeriod;
@property (nonatomic, copy) NSString <Optional> *flow;///< 流量包大小
@property (nonatomic, copy) NSString <Optional> *nameKey;///< 流量类型标识
@property (nonatomic, copy) NSString <Optional> *key;



@end

@protocol WDFlowWholeKeyModel <NSObject>
@end

@interface WDFlowWholeKeyModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *startDataTime;
@property (nonatomic, copy) NSString <Optional> *refundBalance;///< 返还逗币
@property (nonatomic, copy) NSString <Optional> *sellPrice;///< 售价
@property (nonatomic, copy) NSString <Optional> *validityPeriod;
@property (nonatomic, copy) NSString <Optional> *flow;///< 流量包大小
@property (nonatomic, copy) NSString <Optional> *nameKey;///< 流量类型标识
@property (nonatomic, copy) NSString <Optional> *key;

@end

@protocol WDFlowListModel <NSObject>
@end

@interface WDFlowListModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *flow;
@property (nonatomic, strong) WDFlowLocalKeyModel <Optional> *localKey;
@property (nonatomic, strong) WDFlowWholeKeyModel <Optional> *wholeKey;

@end

@protocol WDFlowPackageModel <NSObject>
@end

@interface WDFlowPackageModel : JSONModel

@property (nonatomic, strong) WDFlowPackageDataModel <Optional> *data;
@property (nonatomic, strong) WDFlowPackageResultModel <Optional> *result;


@end


@protocol WDFlowPackageDataModel <NSObject>
@end

@interface WDFlowPackageDataModel : JSONModel
@property (nonatomic, copy) NSString <Optional> *walletAmount;
//@property (nonatomic, assign) double walletAmount;
@property (nonatomic, copy) NSString <Optional> *operator;
@property (nonatomic, strong) NSArray<WDFlowListModel> *flowList;
@end
@protocol WDFlowPackageResultModel <NSObject>
@end

@interface WDFlowPackageResultModel : JSONModel
@property (nonatomic, copy) NSString *code;
@end

