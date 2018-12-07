//
//  WDSetNewPwdView.h
//  5dou
//
//  Created by 黄新 on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTextField.h"

@interface WDSetNewPwdView : UIView

@property (nonatomic, strong) UIImageView *firstPwdImg;
@property (nonatomic, strong) UIImageView *secondPwdImg;

@property (nonatomic, strong) WDTextField *firstTextField;///< 新密码
@property (nonatomic, strong) WDTextField *secondTextField;///< 确认密码

@property (nonatomic, strong) UILabel *lineLabel;///< 分割线


@end
