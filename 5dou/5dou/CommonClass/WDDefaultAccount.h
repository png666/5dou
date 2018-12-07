//
//  WDDefaultAccount.h
//  5dou
//
//  Created by ChunXin Zhou on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  存储用户的公共信息，主要是对NSUserDefault进行操作
 */
@interface WDDefaultAccount : NSObject
/**
 *  获取城市列表
 */
+ (NSMutableArray *)cityList;
/**
 *  存储城市列表
 *
 *  @param cityList  城市列表
 *  @param indexList 检索值列表
 */
+ (void)setCityList:(NSMutableArray *)cityList;
/**
 *  获取城市Id
 */
+ (NSString *)cityId;
/**
 *  存储定位城市Id
 */
+ (void)setCityId:(NSString *)cityId;
/**
 *  获取定位的城市名
 */
+ (NSString *)cityName;
/**
 *  存储定位的城市
 */
+ (void)setCityName:(NSString *)cityName;

/**
 *  存储省份Id
 */
+ (NSString *)provinceId;
+ (void)setProvinceId:(NSString *)provinceId;
/**
 * 存储用户信息
 * memberId
 * sid
 * nickName;
 * headImg;
 * gender;
 * mobile;
 * inviteCode;
 * userLevel;
 * resellerLevel;
 * msg;
 * walletAmount;
 */
+ (void)setUserInfoWithDic:(NSDictionary *)infoDic;

/**
 *  获取用户的基本信息
 */
+ (NSDictionary *)getUserInfo;
/**
 * 销毁信息
 */
+ (void)cleanAccountCache;

@end
