//
//  WDUserInfoModel.h
//  5dou
//
//  Created by rdyx on 16/9/13.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDUserInfoModel : NSObject
//本单例中除了包含用户信息外，还包含常用的全局变量以及标记位

//***********************用户信息相关*****************************//
@property (nonatomic, copy) NSString *memberId;///< 会员编号
@property (nonatomic, copy) NSString *nickName;//< 昵称
@property (nonatomic, copy) NSString *headImg;//< 头像图片路径
@property (nonatomic, copy) NSString *gender;///< 性别
@property (nonatomic, copy) NSString *mobile;///< 手机号
@property (nonatomic, copy) NSString *inviteCode;///< 邀请码
@property (nonatomic, copy) NSString *userLevel;///< 用户等级
@property (nonatomic, copy) NSString *resellerLevel;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *walletAmount;
@property (nonatomic, copy) NSString *sid;
@property(nonatomic,copy)NSString *alipayAccount;//支付宝账户
@property(nonatomic,assign)BOOL isSign;//签到
@property (nonatomic, copy) NSString *birthday; ///< 生日
@property (nonatomic, copy) NSString *schoolName;///< 学校
@property (nonatomic, copy) NSString *interestTags;///< 兴趣爱好

//是否绑定了支付宝
@property(nonatomic,assign)BOOL isBindAlipay;
//微信认证标记
@property(nonatomic,assign)BOOL isWeixinAuth;
//通过code获取openid  进而再获取用户信息
@property(nonatomic,copy)NSString *openid;
@property(nonatomic,copy)NSString *access_token;

//用于标记在提现页面是显示微信
@property(nonatomic,assign)BOOL  weixinFlag;
//用于标记在提现页面是显示支付宝
@property(nonatomic,assign)BOOL  aliFlag;

//用来标记提现时用微信原生skd进行登录
@property(nonatomic,assign)BOOL weixinNativeSDK;
@property(nonatomic,copy)NSString *lotteryCode;
//*************************************************************//
@property(nonatomic,assign)BOOL isLotShare;//标记是抽奖时候的分享

@property(nonatomic,assign)BOOL isRebateShareToTimeLine;//邀请返利页面分享到朋友圈内容是独自内容
@property(nonatomic,copy)NSString *timeLineContent;///< 分享到朋友圈的内容
@property (nonatomic, assign)BOOL isReachable;
@property(nonatomic,assign)BOOL isUpdateFlag;
@property(nonatomic,copy)NSString *updateUrl;
@property (nonatomic, assign)NSInteger iconCount;
@property(nonatomic,assign)BOOL isCashVC;

//渠道
@property(nonatomic,copy)NSString *channel;

///
+(instancetype)shareInstance;

//存储用户信息
- (void)saveUserInfoWithDic:(NSDictionary *)dic;

//清空头像
-(void)clearHeadImage;

//清空用户信息
- (void)clearUserInfo;

@end
