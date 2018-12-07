//
//  WDOrderDetailViewController.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"

@class WDFlowOrderModel;

/**
 在线支付页面  ->2.0
 */
@interface WDOnlinePayViewController : WDBaseViewController

@property (nonatomic, strong) WDFlowOrderModel *orderModel;
@property (nonatomic, copy) NSString *deductionMoney;
@property (nonatomic, copy) NSString *telephoneStr;
@property (nonatomic, copy) NSString *selectedFlow;
@end
