//
//  WDUnReadMessageModel.h
//  5dou
//
//  Created by 黄新 on 16/9/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  未读消息
//

#import "JSONModel.h"
@class WDUnReadMessageResultModel,WDUnReadMessageDataModel;

@protocol WDUnReadMessageModel <NSObject>

@end
@interface WDUnReadMessageModel : JSONModel

@property (nonatomic, strong) WDUnReadMessageResultModel <Optional>*result;///< 状态码
@property (nonatomic, strong) WDUnReadMessageDataModel <Optional>*data;///< 数据

@end

@protocol WDUnReadMessageResultModel <NSObject>

@end
@interface WDUnReadMessageResultModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*code;

@end

@protocol WDUnReadMessageDataModel <NSObject>

@end
@interface WDUnReadMessageDataModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*count;
@property (nonatomic, strong) NSString <Optional>*time;
@property (nonatomic, strong) NSString <Optional>*title;
@property (nonatomic, strong) NSString <Optional>*content;

@end

