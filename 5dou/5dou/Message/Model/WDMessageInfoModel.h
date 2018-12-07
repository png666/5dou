//
//  WDMessageInfoModel.h
//  5dou
//
//  Created by 黄新 on 16/9/27.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  消息的基本信息
//

#import "JSONModel.h"
@class WDMessageInfoResultModel,WDMessageInfoDataModel;

@protocol WDMessageInfoModel <NSObject>
@end
@interface WDMessageInfoModel : JSONModel

@property (nonatomic, strong) WDMessageInfoResultModel *result;
@property (nonatomic, strong) WDMessageInfoDataModel *data;

@end


@protocol WDMessageInfoResultModel <NSObject>
@end
@interface WDMessageInfoResultModel : JSONModel

@property (nonatomic, copy) NSString *code;///< 请求返回状态码


@end


@protocol WDMessageInfoDataModel <NSObject>
@end
@interface WDMessageInfoDataModel : JSONModel

@property (nonatomic, copy) NSString *msgTitle;///< 消息标题
@property (nonatomic, copy) NSString *msgDesc;///< 消息内容
@property (nonatomic, copy) NSString *msgStatus;///< 消息状态 1-已读 0-未读
@property (nonatomic, copy) NSString *sendBy;///< 消息发送者
@property (nonatomic, copy) NSString *sendTime;///< 消息发送的时间




@end
