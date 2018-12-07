//
//  WDTaskShareModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"
/**
 *  任务分享的数据模型
 */
@interface WDTaskShareModel : JSONModel
/**
 *  微信分享对应的appId
 */
@property (nonatomic,copy) NSString *appId;
/**
 *  微信分享对应的时间戳
 */
@property (nonatomic,copy) NSString *timestamp;

/**
 *  微信分享对应的指定长度的随机字符串
 */
@property (nonatomic,copy) NSString *nonceStr;
/**
 *  微信分享对应的
 */
@property (nonatomic,copy) NSString *signature;
/**
 *  微信分享对应的标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  微信分享对应的描述
 */
@property (nonatomic,copy) NSString *desc;
/**
 *  微信分享对应的分享链接地址
 */
@property (nonatomic,copy) NSString *link;
/**
 *  微信分享对应的logo图标
 */
@property (nonatomic,copy) NSString *imgUrl;
@end
