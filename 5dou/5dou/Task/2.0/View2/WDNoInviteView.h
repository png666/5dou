//
//  WDNoInviteView.h
//  5dou
//
//  Created by 黄新 on 17/1/5.
//  Copyright © 2017年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InviteBtnDidClickBlock)();

@interface WDNoInviteView : UIView

@property (nonatomic, copy) InviteBtnDidClickBlock inviteBtnDidClickBlock;

@end
