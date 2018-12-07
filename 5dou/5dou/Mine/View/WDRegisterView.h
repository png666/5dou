//
//  WDRegisterView.h
//  5dou
//
//  Created by 黄新 on 16/9/12.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTextField.h"
#import "WDSubmitButton.h"

@interface WDRegisterView : UIView

@property (nonatomic, strong) UIImageView *phoneImage;///<
@property (nonatomic, strong) UIImageView *verifyImage;
@property (nonatomic, strong) UIImageView *captchaImage;
@property (nonatomic, strong) UIImageView *pwdImage;
@property (nonatomic, strong) UIImageView *inviteImage;

@property (nonatomic, strong) UIButton *verifyBtn;///< 图像验证码

@property (nonatomic, strong) WDTextField *phoneTextField;
@property (nonatomic, strong) WDTextField *verifyTextField;
@property (nonatomic, strong) WDTextField *captchaTextField;
@property (nonatomic, strong) WDTextField *pwdTextField;
@property (nonatomic, strong) WDTextField *inviteTextField;

@property (nonatomic, strong) WDSubmitButton *captchaBtn;///< 获取短信验证码

@property (nonatomic, strong) UILabel *phoneSplitLine;
@property (nonatomic, strong) UILabel *vertifySplitLine;
@property (nonatomic, strong) UILabel *captchaSplitLine;

@property (nonatomic, strong) UIView *splitView;///< 邀请码与密码之间的View

@property (nonatomic, strong) NSTimer *codeTimer;

@end
