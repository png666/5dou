//
//  WDTaskRequestModel.h
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "JSONModel.h"
/**
 *  任务请求类
 */
@interface WDTaskRequestModel : JSONModel
/**
 *  查询任务分类(0:全部;1:APP试用;2: 院线观影; 3: 问卷调查;4:营销推广)
 */
@property (nonatomic,copy) NSNumber *queryCategory;
/**
 *  排序类型(0:智能排序;1:酬劳;2:发布时间;3:优质推荐 4：最快结算 5 最火任务)
 */
@property (nonatomic,copy) NSNumber *queryOrderType;
/**
 *  升降排序(1:升序(默认);2:降序)
 */
@property (nonatomic,copy) NSNumber *queryOrderSort;
/**
 *  地区码
 */
@property (nonatomic,copy) NSString *cityCode;
/**
 *  商家号
 */
@property (nonatomic,copy) NSString<Optional> *businessId;
/**
 *  请求的手机内核:1:Android,2:IOS
 */
@property (nonatomic,copy) NSNumber *queryAppType;
/**
 *  是否热门推荐(1:是热门推荐;0:不是热门推荐)
 */
@property (nonatomic,copy) NSString<Optional> *queryHot;
/**
 *  任务名字关键字
 */
@property (nonatomic,copy) NSString<Optional> *keyword;
@end
