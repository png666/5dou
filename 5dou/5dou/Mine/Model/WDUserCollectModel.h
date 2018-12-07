//
//  WDUserCollectModel.h
//  5dou
//
//  Created by 黄新 on 16/9/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  用户收藏
//

#import "JSONModel.h"

@class productBeanModel,productModel,UserCollectResultModel;

//productBeanModel
@protocol  productBeanModel <NSObject>
@end
@interface productBeanModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;
@property (nonatomic, copy) NSString <Optional> *category;
@property (nonatomic, assign) NSNumber <Optional> *joinMemberCount;
@property (nonatomic, copy) NSString <Optional> *state;
@property (nonatomic, copy) NSString <Optional> *joinCondition;
@property (nonatomic, copy) NSString <Optional> *imgUrl;
@property (nonatomic, copy) NSString <Optional> *taskLabel;
@property (nonatomic, copy) NSString <Optional> *settleType;
@property (nonatomic, assign) NSNumber <Optional> *joinMemerLimit;
@property (nonatomic, assign) NSNumber <Optional> *countdownTime;
@property (nonatomic, copy) NSString <Optional> *reward;
@property (nonatomic, copy) NSString <Optional> *endTime;
@property (nonatomic, copy) NSString <Optional> *taskId;
@property (nonatomic, copy) NSString <Optional> *taskName;
@property (nonatomic, copy) NSString <Optional> *startTime;

@end

///productModel
@protocol  productModel <NSObject>
@end

@interface productModel : JSONModel

@property (nonatomic, copy)   NSString <Optional> *status;
@property (nonatomic, assign) NSNumber <Optional> *id;
@property (nonatomic, copy)   NSString <Optional> *type;
@property (nonatomic, strong) productBeanModel <Optional> *productBean;

@end
///WDUserCollectModel
@protocol  WDUserCollectModel<NSObject>
@end
@interface WDUserCollectModel : JSONModel
@property (nonatomic, strong) UserCollectResultModel *result;
@property (nonatomic, strong) NSArray <productModel,Optional> *data;
@end
///UserCollectResultModel
@protocol  UserCollectResultModel<NSObject>
@end
@interface UserCollectResultModel : JSONModel
@property (nonatomic, copy) NSString <Optional>*code;
@end










