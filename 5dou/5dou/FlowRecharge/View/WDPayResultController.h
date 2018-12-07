//
//  WDPayResultController.h
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/16.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
@class WDFlowOrderDataModel;

/**
 支付结果的页面
 */
@interface WDPayResultController : WDBaseViewController
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,strong) WDFlowOrderDataModel *orderDataModel;
@property (nonatomic,copy) NSString *errorStr;
@property (nonatomic,copy) NSString *selectedFlow;
@property (nonatomic,copy) NSString *telephoneStr;
@property (nonatomic,assign) CGFloat money;
@end
