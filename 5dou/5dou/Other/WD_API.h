//
//  WD_API.h
//  5dou
//
//  Created by rdyx on 16/8/28.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
#ifndef WD_API_h


#define WD_API_h


#define WD_POLICY_URL @"http://ios.5dou.cn/login_html/yhxy.html"
//所有的接口写在此类中

//登录
#define kLoginUrl @"/api/member/login.json"
//退出登录
#define klogoutUrl @"/api/member/logout.json"

//注册时候的图片验证码
#define kPicNumberUrl @"/api/member/checkCode.png"
//获取RSA公钥
#define kRSAPublicKeyUrl @"/api/common/pubkey.json"
//轮播图
#define kBannerUrl @"/api/common/getAdBanner.json"
//轮播图下方四个icon数据
#define kHomeIconUrl  @"/api/common/init.json"
//首页列表数据
#define kHomeTaskList  @"/api/tasks/taskList.json"
//活动列表
#define kActivityList @"/api/common/activity/activityList.json"
//获取活动详情
#define kActivityDetail @"/api/common/activity/findActivityDetail.json"
//获取校园干货详情
#define kFindNewsDetail @"/api/common/news/findNewsDetail.json"
//获取评论列表
#define kCommentList @"/api/member/findMemberComment.json"

//根据名称获取城市码
#define kGetCityCodeWithNameUrl @"/api/common/findCityCodeByName.json"
//获取城市列表
#define kGetCityInfo @"/api/common/findAllCity.json"
//获取学校的列表
#define kGetSchoolInfoUrl @"/api/common/findAllSchool.json"
//获取常见问题列表
#define kGetQuestionListUrl @"/api/common/getFAQ.json"
//校园干货
#define kSchoolNewsUrl @"/api/common/news/newsList.json"
//修改用户信息
#define kUpdateMemeberInfo @"/api/member/updateMemberInfo.json"

////*********任务相关的接口*********///
//提交任务帐号和评论
#define kSubmitTask @"/api/task/submitTask.json"
//提交图片
#define kUploadTaskPicture  @"/api/task/uploadTaskPicture1.json"
//获取任务详情
#define kTaskDetailUrl @"/api/task/taskInfo.json"
//领取任务接口
#define kTaskGetTaskUrl @"/api/task/receiveTask.json"
//是否点击了去做任务按钮
#define kClickTaskUrl @"/api/tasks/isClickedTask.json"
//收藏任务接口
#define kAddMemberCollectionUrl @"/api/member/addMemberCollection.json"
//点击下载按钮，记录用户的信息
#define kDownloadTask @"/api/task/downloadTask.json"
///task/downloadTask.json
//取消收藏接口
#define kCancelMemberCollectionUrl @"/api/member/cancelMemberCollection.json"
//添加评论接口
#define kAddCommentUrl @"/api/member/addMemberComment.json"
//获取任务列表
#define kTaskList @"/api/tasks/taskList.json"
//获取我的任务列表
#define kMyTaskList @"/api/tasks/myTaskList.json"
//获取任务汇总接口
#define kMyTaskCount @"/api/tasks/myTaskCount.json"

////********个人中心********///
//获取我的任务列表
#define kUserCollectList @"/api/member/findAllMemberCollection.json"
//获取我的任务卡汇总列表
#define kMyTaskCardTotal @"/api/tasks/myTaskCardCount.json"
//获取我的任务卡列表
#define kMyTaskCardList @"/api/tasks/myTaskCardList.json"

////********注册相关接口********///
//图片验证码
#define kCheckCodeUrl @"/api/member/checkCode.png"
//发送验证码
#define kSendValidMsgUrl @"/api/member/sendValidMsg.json"
//验证验证码
#define kValidateCaptchaUrl @"/api/member/validateCaptcha.json"
//判断用户是否存在
#define kIsExistUrl @"/api/member/isExist.json"
//注册
#define kRegisterUrl @"/api/member/regForApp.json"
//设置新密码
#define kFindPasswordUrl @"/api/member/findPasswd.json"
//修改密码
#define kUpdatePasswordUrl @"/api/member/updatePassword.json"
//保存用户信息
#define kSaveMemberAccountUrl @"/api/memberAccount/saveMemberAccount.json"

//判断用户是否绑定支付宝账户或者是微信认证用户（和传的参数有关系）
#define kJudgeIsAuthenticationUrl @"/api/memberAccount/judgeIsAuthentication.json"

//保存用户信息
#define kCompleteRegUrl @"/api/member/completeReg.json"


////********消息相关接口********///
//获取会员消息个数
#define kUnReadMssageUrl @"/api/common/message/unReadMssage.json"
//获取会员消息
#define kMemberMessageUrl @"/api/common/message/memberMessage.json"
//获取消息详情
#define kMessageInfoUrl @"/api/common/message/messageInfo.json"
//标记所有消息已读
#define kMarkAsAllReadUrl @"/api/common/message/markAsAllRead.json"
//消息禁用
#define kDisableMessageUrl @"/api/common/message/disableMessage.json"
//删除会员消息
#define kDeleteMessageUrl @"/api/common/message/deleteMessage.json"

//账单列表
#define kBillListUrl @"/api/memberAccountDetail/findPage.json"

//提现
#define kCashUrl @"/api/memberAccountDetail/applyWithdrawals.json"
//意见反馈
#define KFeedBackUrl @"/api/member/saveMemberFeedback.json"
//意见反馈列表
#define kFeedbackListUrl @"/api/member/feedbackList.json"
//邀请返利
#define kInviteRebateUrl @"/api/memberDetail/inviteRebate.json"

//获取用户基本信息

#define kGetUserInfoUrl @"/api/member/getMemberBase.json"

//我的逗币
#define kMyDoubiUrl @"/api/memberAccountDetail/myDouBi.json"

//头像上传
#define kUploadHeadImageUrl @"/api/member/uploadHeadImg2.json"

//获取最新版本 10.29更换成现在的接口
#define kGetNewVersion @"/api/common/getAppVersion.json"

//时间戳获取
#define kGetTimestamp @"/api/common/token.json"


//保存用户设备信息
#define kSaveDeviceInfo @"/api/common/saveMemberPhoneInfo.json"

///********排行榜*******/////

#define kGetMemberRank @"/api/common/getMemberRank.json"


///********任务卡*******/////

#define kGetMemberTaskCard @"/api/tasks/getMemberTaskCard.json"


///********流量相关*******/////
//获取流量充值套餐
#define kFlowPackageList @"/api/flowRecharge/flowPackageList.json"
//流量订单提交
#define kFlowOrderSubmit @"/api/flowRecharge/flowOrderSubmit.json"
//获取订单方式
#define kFlowPayType     @"/api/flowRecharge/payStyleList.json"

#define kFlowOrderList    @"/api/flowRecharge/flowOrderList.json"
#define kFlowOrderPay     @"/api/alipay/gopay.json"
//取消订单
#define kFlowCancel       @"/api/flowRecharge/orderCancel.json"


//保存微信认证用户信息
#define kSaveWechatAuthInfoUrl @"/api/memberAccount/saveWechatAuth.json"

//分享成功后增加抽奖次数
#define kLottoryShareTimeUrl @"/api/lottery/addShareRecord.json"








#endif /* WD_API_h */
