//
//  WDMessageCountModel.h
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"
@class MessageCountDataModel,MessageResultModel;


@protocol WDMessageCountModel <NSObject>

@end

@interface WDMessageCountModel : JSONModel

@property (nonatomic, strong) MessageCountDataModel <Optional>*data;
@property (nonatomic, strong) MessageResultModel <Optional>*result;


@end

@protocol MessageResultModel <NSObject>
@end

@interface MessageResultModel : JSONModel

@property (nonatomic, copy) NSString *code;///< 请求返回状态码


@end

@protocol MessageCountDataModel <NSObject>
@end

@interface MessageCountDataModel : JSONModel

@property (nonatomic, copy) NSString *count;///< 消息的数量
@property (nonatomic, copy) NSString *content;///< 消息的内容
@property (nonatomic, copy) NSString *title;///< 消息的标题

@end

