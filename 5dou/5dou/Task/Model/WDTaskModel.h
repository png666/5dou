//
//  WDTaskModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDTaskModel : NSObject
/**
 *  任务ID
 */
@property (nonatomic,copy) NSString *taskId;
/**
 *  任务名称
 */
@property (nonatomic,copy) NSString *taskName;
/**
 *  任务LOGO图片
 */
@property (nonatomic,copy) NSString *imgUrl;
/**
 *  任务分类(1:应用试客 2: 观影体验; 3: 市场调研; 4:营销推广)
 */
@property (nonatomic,copy) NSString *category;
/**
 *  任务开始时间(格式：yyyy-MM-dd HH:mm:ss)
 */
@property (nonatomic,copy) NSString *startTime;
/**
 *  任务结束时间(格式：yyyy-MM-dd HH:mm:ss)
 */
@property (nonatomic,copy) NSString *endTime;
/**
 *  参与条件(不限)
 */
@property (nonatomic,copy) NSString *joinCondition;
/**
 *  任务奖励(单位:逗币)
 */
@property (nonatomic,copy) NSString *reward;
/**
 *  任务标签
 */
@property (nonatomic,copy) NSString *taskLabel;
/**
 *  推荐任务主页列表长图
 */
@property (nonatomic,copy) NSString *recommendListImg;
/**
 *  任务已参与人数
 */
@property (nonatomic,copy) NSString *joinMemberCount;
/**
 *  任务设定参与总数
 */
@property (nonatomic,copy) NSString *joinMemerLimit;
/**
 *  结算方式(1:即时结算;2:日结;3:分享结算)
 */
@property (nonatomic,copy) NSString *settleType;

@property (nonatomic,copy) NSString *taskSubmitLeftSec;
//0:未使用;1:进行中;2:已完成;3:已放弃;4:待审核;5:审核不通过;6:已失效
@property (nonatomic    ,copy) NSString *state;
/**
 * 追加字段，审核拒绝原因
 */
@property (nonatomic,copy) NSString *refuseReason;

@property (nonatomic,copy) NSString *taskCardId;

/**是否为倒计时任务(0 否 1 是)*/
@property (nonatomic,copy) NSString *isCountDownTask;
/**任务开抢时间(必须是在任务开始时间和任务结束时间之间)*/
@property (nonatomic,copy) NSString *countDownStartTime;
/**任务步骤*/
@property (nonatomic,copy) NSString *stepName;
/**专属任务中，任务剩余的份数*/
@property (nonatomic,copy) NSString *leftJoinNumber;
/**限时任务时间*/
@property (nonatomic,copy) NSString *countDownReceiveLeftSec;
@end
