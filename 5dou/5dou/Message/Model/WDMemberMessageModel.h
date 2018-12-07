//
//  WDMemberMessageModel.h
//  5dou
//
//  Created by 黄新 on 16/9/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  消息


#import "JSONModel.h"
@class MemberMessageResultModel,MemberDataModel;


@protocol MemberDataModel <NSObject>

@end

@interface MemberDataModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *id;///< 消息ID
@property (nonatomic, copy) NSString <Optional> *msgTitle;///< 消息的标题
@property (nonatomic, copy) NSString <Optional> *msgDesc;///< 消息的内容
@property (nonatomic, copy) NSString <Optional> *sendBy;///< 消息的发送者
@property (nonatomic, copy) NSString <Optional> *sendTime;///< 消息发送的时间
@property (nonatomic, copy) NSString <Optional> *msgStatus;///< 消息状态表示已读未读
@end

////
@protocol WDMemberMessageModel <NSObject>

@end

@interface WDMemberMessageModel : JSONModel

@property (nonatomic, strong) MemberMessageResultModel *result;///< 返回结果
@property (nonatomic, strong) NSArray <MemberDataModel,Optional> *data;

@end

/////
@protocol MemberMessageResultModel <NSObject>

@end

@interface MemberMessageResultModel : JSONModel

@property (nonatomic, copy) NSString <Optional> *code;///< 请求返回状态吗
@end

