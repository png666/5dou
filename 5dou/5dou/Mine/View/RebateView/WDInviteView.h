//
//  WDInviteView.h
//  5dou
//
//  Created by 黄新 on 16/11/25.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InviteBtnDidClickBlock)(UIButton *sender);

@class WDInviteRebateDataModel,WDInviteRebateModel;

@interface WDInviteView : UIView

@property (nonatomic, copy) InviteBtnDidClickBlock inviteBtnDidClickBlock;///< 邀请好友

- (void)configValue:(WDInviteRebateDataModel *)model;

@end
