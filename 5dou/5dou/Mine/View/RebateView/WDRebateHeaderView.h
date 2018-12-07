//
//  WDRebateHeaderView.h
//  5dou
//
//  Created by 黄新 on 16/11/25.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDInviteRebateDataModel,WDInviteRebateModel;

typedef void(^InviteNumBtnDidClickBlock)(UIButton *sender);

@interface WDRebateHeaderView : UIView

@property (nonatomic, copy) InviteNumBtnDidClickBlock inviteNumBtnDidClickBlock;

- (void)configValue:(WDInviteRebateDataModel *)model;

@end
