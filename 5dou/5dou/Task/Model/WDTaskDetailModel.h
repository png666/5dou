//
//  WDTaskDetailModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"
#import "WDTaskMaterialModel.h"
#import "WDTaskStepModel.h"
@interface WDTaskDetailModel : JSONModel
/**
 *  任务ID
 */
@property (nonatomic,copy) NSString<Optional> *taskId;
/**
 *  任务名称
 */
@property (nonatomic,copy) NSString<Optional> *taskName;
/**
 *  任务简介
 */
@property (nonatomic,copy) NSString<Optional> *taskInfo;
/**
 *  参与人数
 */
@property (nonatomic,copy) NSString<Optional> *joinMemberCount;
/**
 *  任务参与人数上限
 */
@property (nonatomic,copy) NSString<Optional> *memberCountLimit;
/**
 *  结算方式(1:即时结算;2:日结;3:分享结算)
 */
@property (nonatomic,copy) NSString<Optional> *settleType;
/**
 *  任务图片链接
 */
@property (nonatomic,copy) NSString<Optional> *imgUrl;
/**
 *  任务超时时间(单位秒)
 */
@property (nonatomic,copy) NSString<Optional> *countdownTime;
/**
 *  任务奖励
 */
@property (nonatomic,copy) NSString<Optional> *reward;
/**
 *   app下载地址
 */
@property (nonatomic,copy) NSString<Optional> *downloadUrl;
/**
 *  任务开始时间
 */
@property (nonatomic,copy) NSString<Optional> *startTime;
/**
 *  任务结束时间
 */
@property (nonatomic,copy) NSString<Optional> *endTime;
/**
 *  提交任务截止时间(单位秒)
 */
@property (nonatomic,copy) NSString<Optional> *taskSubmitLeftSec;
/**
 *  [需要登录] : 是否收藏(0 否 1是)
 */
@property (nonatomic,copy) NSString<Optional> *isCollected;
/**
 *  是否有素材 (0 否 1是)
 */
@property (nonatomic,copy) NSString<Optional> *isMaterial;
/**
 *  跳转第三方应用URL也有可能是apk下载地址 如果为空 则为""
 */
@property (nonatomic,copy) NSString<Optional> *jumpUrl;
/**
 *  素材详情
 */
@property (nonatomic,strong) WDTaskMaterialModel <Optional> *material;
/**
 *  任务种类任务分类(1:APP试用;2: 院线观影; 3: 问卷调查;4:营销推广)
 */
@property (nonatomic,copy) NSString<Optional> *taskType;
/**
 *  [需要登录] :用户任务卡状态 -1:用户没有领取该任务 0:未使用;1:进行中;2:已完成;3:已放弃;4:待审核;5:审核不通过;6:已失效;
 */
@property (nonatomic,copy) NSString<Optional> *taskStatus;


/**
 *  按钮显示的文字,例如“领取任务”、“提交任务”、“审核中”、“审核不通过”、“已完成”、“已放弃”、“重新领取”
 */
@property (nonatomic,copy) NSString<Optional> *taskStatusText;
/**
 *  是否热门推荐(1:是热门推荐;0:不是热门推荐)
 */
@property (nonatomic,copy) NSString<Optional> *isHot;
/**
 *  推荐任务背景大图（当isHot为1时展示）
 */
@property (nonatomic,copy) NSString<Optional> *recommendBgImg;
/**
 *  是否弹窗(1是 0否)
 */
@property (nonatomic,copy) NSString<Optional> *isPopup;
/**
 *  弹窗文字(当isPopup为1时显示)
 */
@property (nonatomic,copy) NSString<Optional> *popupWord;
/**
 *  调转第三方复制的搜索内容
 */
@property (nonatomic,copy) NSString<Optional> *textSearch;
/**
 *  打开应用的唯一标识
 */
@property (nonatomic,copy) NSString<Optional> *openAppMark;
/**
 *  打开应用倒计时
 */
@property (nonatomic,copy) NSString<Optional> *openAppCountDown;
/**
 *  提交任务是否需要图片
 */
@property (nonatomic,copy) NSString<Optional> *isNeedPic;
/**
 *  提交任务是否需要留言
 */
@property (nonatomic,copy) NSString<Optional> *isNeedCommet;
/**
 *  提交任务是否需要试玩账号
 */
@property (nonatomic,copy) NSString<Optional> *isNeedUserAccount;
/**
 *  分享时的URL
 */
@property (nonatomic,copy) NSString<Optional> *shareUrl;
/**
 *  任务步骤
 */
@property (nonatomic,strong) NSArray<WDTaskStepModel *><Optional> *steps;
//********************新增字段********************/
/**
 *  是否是倒计时任务
 */
@property (nonatomic,copy) NSString<Optional> *isCountDownTask;
/**
 *  任务领取时间
 */
@property (nonatomic,copy) NSString<Optional> *countDownStartTime;
@property (nonatomic,copy) NSString <Optional> *countDownReceiveLeftSec;
@property (nonatomic,copy) NSString <Optional> *taskCardId;
@end
