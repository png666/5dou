//
//  WDMessageDetailViewController.h
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"
#import "WDMemberMessageModel.h"

@interface WDMessageDetailViewController : WDBaseViewController

@property (nonatomic, copy) NSString *messageId;///< 消息的id
@property (nonatomic, strong) MemberDataModel *dataModel;

@end
