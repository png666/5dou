//
//  WDIncomeViewController.h
//  5dou
//
//  Created by 黄新 on 16/12/19.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"

@class WDInviteRebateDataModel,RankingListModel;

@interface WDIncomeViewController : WDBaseViewController

@property (nonatomic, strong) NSArray *dataArray;///< 好友收益列表

@property (nonatomic, strong) WDInviteRebateDataModel *inviteModel;///< 传递数据到

@end
