//
//  WDFlowOrderModel.h
//  5dou
//
//  Created by 黄新 on 16/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class WDFlowOrderResultModel,WDFlowOrderDataModel;

@protocol WDFlowOrderModel <NSObject>
@end

@interface WDFlowOrderModel : JSONModel

@property (nonatomic, strong) WDFlowOrderResultModel <Optional> *result;
@property (nonatomic, strong) WDFlowOrderDataModel <Optional> *data;


@end

@protocol WDFlowOrderResultModel <NSObject>
@end

@interface WDFlowOrderResultModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *code;
@property (nonatomic, copy) NSString <Optional> *msg;


@end

@protocol WDFlowOrderDataModel <NSObject>
@end

@interface WDFlowOrderDataModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *orderName;
@property (nonatomic, copy) NSString <Optional> *orderNo;
@property (nonatomic, copy) NSString <Optional> *payAmount;


@end
