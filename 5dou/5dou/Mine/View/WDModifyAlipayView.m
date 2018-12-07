//
//  WDModifyAlipayView.m
//  5dou
//
//  Created by 黄新 on 16/9/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  修改支护宝账号
//
#import "WDModifyAlipayView.h"
#import "ToolClass.h"
#import "WDHTTPServer.h"
#import "UIButton+WebCache.h"

@interface WDModifyAlipayView ()

@property (nonatomic, copy) NSString *smsType;///< 手机验证码类型

@property (nonatomic, assign) int resetCount;///<
@property (nonatomic, strong) NSTimer *codeTimer;///< 计时器

@end
@implementation WDModifyAlipayView

- (instancetype)initWithSMSType:(NSString *)type{
    if (self = [super init]) {
        [self initUI];
        self.smsType = type;
        self.userInteractionEnabled = YES;
        self.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return self;
}
- (void)initUI{
    /// 手机号
    [self addSubview:self.phoneImage];
    [self.phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10.f);
        make.width.mas_equalTo(22.f);
        make.height.mas_equalTo(22.f);
        make.top.mas_equalTo(self).offset(17.f);
    }];
    [self addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneImage.mas_right).offset(10.f);
        make.right.mas_equalTo(self.mas_right).offset(-20.f);
        make.height.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.phoneImage);
    }];
    [self addSubview:self.phoneSplitLine];
    [self.phoneSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-10.f);
        make.left.mas_equalTo(self.phoneImage);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.phoneImage.mas_bottom).offset(16.f);
    }];
    /// 支付宝
    [self addSubview:self.alipayImage];
    [self.alipayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.phoneImage);
        make.top.mas_equalTo(self.phoneSplitLine.mas_bottom).offset(17.f);
    }];
    [self addSubview:self.alipayTextField];
    [self.alipayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.alipayImage);
        make.right.left.height.mas_equalTo(self.phoneTextField);
    }];
    [self addSubview:self.alipaySplitLine];
    [self.alipaySplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.left.mas_equalTo(self.phoneSplitLine);
        make.top.mas_equalTo(self.alipayImage.mas_bottom).offset(16.f);
    }];
    /// 真实姓名
    [self addSubview:self.nameImage];
    [self.nameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alipaySplitLine.mas_bottom).offset(16.f);
        make.left.height.width.mas_equalTo(self.phoneImage);
    }];
    [self addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameImage);
        make.right.left.height.mas_equalTo(self.phoneTextField);
    }];
    [self addSubview:self.nameSplitLine];
    [self.nameSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameImage.mas_bottom).offset(16.f);
        make.right.left.height.mas_equalTo(self.phoneSplitLine);
    }];
    /// 图像验证码
    [self addSubview:self.verifyImage];
    [self.verifyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.phoneImage);
        make.top.mas_equalTo(self.nameSplitLine.mas_bottom).offset(16.f);
    }];
    [self addSubview:self.verifyBtn];
    [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(42);
        make.right.mas_equalTo(self.mas_right).offset(-10.f);
        make.centerY.mas_equalTo(self.verifyImage);
    }];
    [self addSubview:self.verifyTextField];
    [self.verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.verifyImage.mas_right).offset(10.f);
        make.right.mas_equalTo(self.verifyBtn.mas_left).offset(-10.f);
        make.height.mas_equalTo(self.phoneTextField);
        make.centerY.mas_equalTo(self.verifyImage);
    }];
    [self addSubview:self.verifySplitLine];
    [self.verifySplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.left.mas_equalTo(self.phoneSplitLine);
        make.top.mas_equalTo(self.verifyImage.mas_bottom).offset(17);
    }];
    /// 验证码
    [self addSubview:self.captchaImage];
    [self.captchaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.left.mas_equalTo(self.phoneImage);
        make.top.mas_equalTo(self.verifySplitLine.mas_bottom).offset(17);
    }];
    [self addSubview:self.captchaBtn];
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(42);
        make.right.mas_equalTo(self.mas_right).offset(-10.f);
        make.centerY.mas_equalTo(self.captchaImage);
    }];
    
    [self addSubview:self.captchaTextField];
    [self.captchaTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.phoneTextField);
        make.centerY.mas_equalTo(self.captchaImage);
        make.left.mas_equalTo(self.phoneTextField);
        make.right.mas_equalTo(self.captchaBtn.mas_left).offset(-5);
    }];

}

#pragma mark --- 点击事件
//发送验证码
- (void)sendValidMsgDidClickEvent:(UIButton *)sender{
    WeakStament(wself);
    if (![self.phoneTextField hasText]) {
        [ToolClass showAlertWithMessage:@"手机号不能为空"];
        return;
    }else{
        if (![self.verifyTextField hasText]) {
            [ToolClass showAlertWithMessage:@"图形验证码不能为空"];
            return;
        }else{
            if ([ToolClass validateMobile:self.phoneTextField.text]) {
                ///数据请求
                NSDictionary *dic = @{@"mobile":self.phoneTextField.text,
                                      @"smsType":self.smsType,
                                      @"checkCode":self.verifyTextField.text,
                                      @"t":[ToolClass getIDFA]
                                      };
                
                [WDNetworkClient postRequestWithBaseUrl:kSendValidMsgUrl setParameters:dic success:^(id responseObject) {
                    NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
                    NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
                    if ([code isEqualToString:@"1000"]) {
                        [wself startTimer];
                    }
                    [ToolClass showAlertWithMessage:msg];
                } fail:^(NSError *error) {
                    
                    YYLog(@"%@",error);
                    
                } delegater:nil];
            }else{
                [ToolClass showAlertWithMessage:@"手机号格式有错"];
            }
        }
    }
    
    
}
#pragma mark ==== 刷新图片验证码
- (void)checkCodeBtnClick:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"%@%@?_t=%@",HTTP_BASE,kCheckCodeUrl,[ToolClass getIDFA]];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    [self.verifyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"null_default"]];
}
#pragma mark ==== 开始倒计时
- (void)startTimer{
    //开启计时器
    [_codeTimer setFireDate:[NSDate distantPast]];
    self.verifyBtn.backgroundColor = kBackgroundColor;
    [self resetCode];//倒计时
}

#pragma mark --- 倒计时代码
-(void) resetCode
{
    _resetCount = 60;
    if (_codeTimer == nil) {
        _codeTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCode) userInfo:nil repeats:YES];
    }
    _captchaBtn.backgroundColor = WDColorFrom16RGB(0xDBD8D8);
    [_captchaBtn setTitle:[NSString stringWithFormat:@"倒计时：%ds",_resetCount] forState:UIControlStateNormal];
    _captchaBtn.enabled = NO;
}

-(void) updateCode
{
    if(_resetCount == 1)
    {
        [_codeTimer invalidate];
        _codeTimer = nil;
        _captchaBtn.enabled = YES;
        [_captchaBtn setTitle:@"获取验验证" forState:UIControlStateNormal];
        _captchaBtn.backgroundColor = WDColorFrom16RGB(0xffc200);
    }else{
        _resetCount--;
        _captchaBtn.backgroundColor = WDColorFrom16RGB(0xDBD8D8);
        [_captchaBtn setTitle:[NSString stringWithFormat:@"倒计时：%ds",_resetCount] forState:UIControlStateNormal];
        //        YYLog(@"%@",[NSString stringWithFormat:@"%ds",_resetCount]);
    }
}

#pragma mark --*****懒加载*****--

#pragma mark --- ImageView
- (UIImageView *)phoneImage{
    if (!_phoneImage) {
        _phoneImage = [[UIImageView alloc] init];
        [_phoneImage setImage:[UIImage imageNamed:@"register_iphone"]];
    }
    return _phoneImage;
}
- (UIImageView *)verifyImage{
    if (!_verifyImage) {
        _verifyImage = [[UIImageView alloc] init];
        [_verifyImage setImage:[UIImage imageNamed:@"register_image"]];
    }
    return _verifyImage;
}
- (UIImageView *)captchaImage{
    if (!_captchaImage) {
        _captchaImage = [[UIImageView alloc] init];
        [_captchaImage setImage:[UIImage imageNamed:@"register_sms"]];
    }
    return _captchaImage;
}
//- (UIImageView *)pwdImage{
//    if (!_pwdImage) {
//        _pwdImage = [[UIImageView alloc] init];
//        [_pwdImage setImage:[UIImage imageNamed:@"lock"]];
//    }
//    return _pwdImage;
//}
- (UIImageView *)nameImage{
    if (!_nameImage) {
        _nameImage = [[UIImageView alloc] init];
        [_nameImage setImage:[UIImage imageNamed:@"alipay_realName"]];
    }
    return _nameImage;
}

- (UIImageView *)alipayImage{
    if (!_alipayImage) {
        _alipayImage = [[UIImageView alloc] init];
        [_alipayImage setImage:[UIImage imageNamed:@"alipay_icon"]];
    }
    return _alipayImage;
}


#pragma mark --- TextField

- (WDTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[WDTextField alloc] init];
        _phoneTextField.placeholder = @"请输入您的手机号";
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneTextField;
}
- (WDTextField *)verifyTextField{
    if (!_verifyTextField) {
        _verifyTextField = [[WDTextField alloc] init];
        _verifyTextField.placeholder = @"请输入图像验证码";
    }
    return _verifyTextField;
}
- (WDTextField *)captchaTextField{
    if (!_captchaTextField) {
        _captchaTextField = [[WDTextField alloc] init];
        _captchaTextField.placeholder = @"请输入验证码";
        _captchaTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _captchaTextField;
}
- (WDTextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[WDTextField alloc] init];
        _nameTextField.placeholder = @"请输入您的真实姓名";
    }
    return _nameTextField;
}
- (WDTextField *)alipayTextField{
    if (!_alipayTextField) {
        _alipayTextField = [[WDTextField alloc] init];
        _alipayTextField.placeholder = @"请输入您的支付宝账号";
    }
    return _alipayTextField;
}

#pragma mark --- Button
- (UIButton *)verifyBtn{
    if (!_verifyBtn) {
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn.backgroundColor = self.backgroundColor;
        [_verifyBtn addTarget:self action:@selector(checkCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyBtn;
}
- (WDSubmitButton *)captchaBtn{
    if (!_captchaBtn) {
        _captchaBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _captchaBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _captchaBtn.titleLabel.font = kFont13;
//        [_captchaBtn setTitleColor:WDColorFrom16RGB(0xffffff) forState:UIControlStateNormal];
        _captchaBtn.layer.cornerRadius = 5;
        _captchaBtn.layer.masksToBounds = YES;
        [_captchaBtn addTarget:self action:@selector(sendValidMsgDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captchaBtn;
}

#pragma mark --- SplitLine

- (UILabel *)phoneSplitLine{
    if (!_phoneSplitLine) {
        _phoneSplitLine = [[UILabel alloc] init];
        _phoneSplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _phoneSplitLine;
}
- (UILabel *)verifySplitLine{
    if (!_verifySplitLine) {
        _verifySplitLine = [[UILabel alloc] init];
        _verifySplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _verifySplitLine;
}
- (UILabel *)alipaySplitLine{
    if (!_alipaySplitLine) {
        _alipaySplitLine = [[UILabel alloc] init];
        _alipaySplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _alipaySplitLine;
}
- (UILabel *)nameSplitLine{
    if (!_nameSplitLine) {
        _nameSplitLine = [[UILabel alloc] init];
        _nameSplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _nameSplitLine;
}


- (void)dealloc{
    [self.codeTimer invalidate];
}


@end
