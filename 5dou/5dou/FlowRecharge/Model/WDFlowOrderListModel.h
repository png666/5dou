//
//  WDFlowOrderListModel.h
//  5dou
//
//  Created by 黄新 on 16/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值记录
//


#import <JSONModel/JSONModel.h>

@class WDFlowOrderListDataModel,WDFlowOrderListResultModel,WDFlowDataListModel,WDFlowOrderListPageInfoModel;


@protocol WDFlowDataListModel <NSObject>
@end
@interface WDFlowDataListModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *orderNo;              ///< 订单号
@property (nonatomic, copy) NSString <Optional> *mobile;               ///< 充值的手机号码
@property (nonatomic, copy) NSString <Optional> *state;                ///< 订单状态
@property (nonatomic, copy) NSString <Optional> *createTime;           ///< 订单创建时间
@property (nonatomic, copy) NSString <Optional> *name;                 ///< 订单名称
@property (nonatomic, copy) NSString <Optional> *operator;             ///< 手机运营商
@property (nonatomic, copy) NSString <Optional> *packageSize;          ///< 充值的流量(单位M)
@property (nonatomic, copy) NSString <Optional> *refundBalance;        ///< 返还豆币
@property (nonatomic, copy) NSString <Optional> *discountPrice;        ///< 流量包折扣价格
@property (nonatomic, copy) NSString <Optional> *payType;              ///< 支付方式
@property (nonatomic, copy) NSString <Optional> *sellPrice;            ///< 售卖价格
@property (nonatomic, copy) NSString <Optional> *balanceAmount;        ///< 逗币支付数量
@property (nonatomic, copy) NSString <Optional> *onlinePayAmount;      ///< 在线支付金额


@end

@protocol WDFlowOrderListDataModel <NSObject>
@end
@interface WDFlowOrderListDataModel : JSONModel

@property (nonatomic, strong) NSArray <WDFlowDataListModel> *list;

@end

@protocol WDFlowOrderListModel <NSObject>
@end
@interface WDFlowOrderListModel : JSONModel

@property (nonatomic, strong) WDFlowOrderListDataModel     <Optional>*data;
@property (nonatomic, strong) WDFlowOrderListResultModel   <Optional>*result;
@property (nonatomic, strong) WDFlowOrderListPageInfoModel <Optional>*pageInfo;


@end



@protocol WDFlowOrderListResultModel <NSObject>
@end
@interface WDFlowOrderListResultModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *code;
@property (nonatomic, copy) NSString <Optional> *msg;

@end

@protocol WDFlowOrderListPageInfoModel <NSObject>
@end
@interface WDFlowOrderListPageInfoModel : JSONModel

@property (nonatomic, assign) long curPage;
@property (nonatomic, assign) long toPage;
@property (nonatomic, assign) long pageSize;
@property (nonatomic, assign) long totalRecord;
@property (nonatomic, assign) long totalPage;

@end
