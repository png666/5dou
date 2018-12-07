//
//  WDModifyAlipayView.h
//  5dou
//
//  Created by 黄新 on 16/9/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDTextField.h"
#import "WDSubmitButton.h"

@interface WDModifyAlipayView : UIView

@property (nonatomic, strong) UIImageView *phoneImage;///<
@property (nonatomic, strong) UIImageView *verifyImage;
@property (nonatomic, strong) UIImageView *captchaImage;
@property (nonatomic, strong) UIImageView *nameImage;
@property (nonatomic, strong) UIImageView *alipayImage;


@property (nonatomic, strong) UIButton *verifyBtn;///< 图像验证码

@property (nonatomic, strong) WDTextField *phoneTextField;
@property (nonatomic, strong) WDTextField *alipayTextField;
@property (nonatomic, strong) WDTextField *nameTextField;
@property (nonatomic, strong) WDTextField *verifyTextField;
@property (nonatomic, strong) WDTextField *captchaTextField;



@property (nonatomic, strong) WDSubmitButton *captchaBtn;///< 获取验证码

@property (nonatomic, strong) UILabel *phoneSplitLine;
@property (nonatomic, strong) UILabel *alipaySplitLine;
@property (nonatomic, strong) UILabel *nameSplitLine;
@property (nonatomic, strong) UILabel *verifySplitLine;



- (instancetype)initWithSMSType:(NSString *)type;
@end
