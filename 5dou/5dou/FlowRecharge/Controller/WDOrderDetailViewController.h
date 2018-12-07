//
//  WDOrderDetailViewController.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
@class WDFlowDataListModel;


/**
 支付订单详情页面
 */
@interface WDOrderDetailViewController : WDBaseViewController

@property (nonatomic, strong) WDFlowDataListModel *orderModel;///< 订单数据

@end
