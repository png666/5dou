//
//  WDNewPasswordViewController.h
//  5dou
//
//  Created by 黄新 on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDBaseViewController.h"

@interface WDSetNewPwdViewController : WDBaseViewController

@property (nonatomic, strong) NSString *captcha;///< 手机验证码
@property (nonatomic, strong) NSString *mobileString;///< 手机号码

@end
