//
//  WDBillListModel.h
//  5dou
//
//  Created by rdyx on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <Foundation/Foundation.h>
//账单列表
@interface WDBillListModel : NSObject
//交易金额
@property(nonatomic,assign)CGFloat amount;
/**
 *  交易类型(交易类型:0:收入,1:支出,2:提现)
 */
@property (nonatomic,copy) NSString *tradeType;
/**
 *  审核拒绝原因，不是所有拒绝都有，得判断是否为空
 */
@property (nonatomic,copy) NSString *refuseReason;
/**
 *  创建时间
 */
@property (nonatomic,copy) NSString *createDate;
/**
 *  产品名称
 */
@property (nonatomic,copy) NSString *productName;
/**
 *  提现才会有该属性，提现手续费
 */
@property (nonatomic,copy) NSString *counterFee;
/**
 *  提现才会有该属性，提现状态(1.申请中 2.提现成功 3.审核拒绝 )
 */
@property (nonatomic,copy) NSString *withdrawalsStatus;
/**
 *   该类型所在的年月
 */
@property (nonatomic,copy) NSString *typeYearMonth;

@end
