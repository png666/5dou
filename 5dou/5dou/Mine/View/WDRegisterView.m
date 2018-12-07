//
//  WDRegisterView.m
//  5dou
//
//  Created by 黄新 on 16/9/12.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  注册View
//
//

#import "WDRegisterView.h"
#import "ToolClass.h"
#import "WDHTTPServer.h"
#import "UIButton+WebCache.h"



@interface WDRegisterView ()<UITextFieldDelegate>

@property (nonatomic, assign) int resetCount;


@end

@implementation WDRegisterView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
        self.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return self;
}
- (void)initUI{
    /// 手机号
    [self addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20.f);
        make.right.mas_equalTo(self.mas_right).offset(-20.f);
        make.height.mas_equalTo(30.f);
        make.top.mas_equalTo(self.mas_top).offset(9);
    }];
    [self addSubview:self.phoneSplitLine];
    [self.phoneSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).offset(9);
    }];
    /// 图像验证码

    //验证码图片
    [self addSubview:self.verifyBtn];
    [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(42);
        make.right.mas_equalTo(self.mas_right).offset(-10.f);
        make.top.mas_equalTo(self.phoneSplitLine.mas_bottom).offset(3);
    }];
    
    [self addSubview:self.verifyTextField];
    [self.verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.left).offset(20.f);
        make.right.mas_equalTo(self.verifyBtn.mas_left).offset(-10.f);
        make.height.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.verifyBtn);
    }];
    //分割线
    [self addSubview:self.vertifySplitLine];
    [self.vertifySplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.left.mas_equalTo(self.phoneSplitLine);
        make.top.mas_equalTo(self.verifyTextField.mas_bottom).offset(9);
    }];

    /// 验证码
    [self addSubview:self.captchaBtn];
    [self.captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(42);
        make.right.mas_equalTo(self.mas_right).offset(-10.f);
        make.top.mas_equalTo(self.vertifySplitLine.mas_bottom).offset(3.f);
    }];
    
    [self addSubview:self.captchaTextField];
    [self.captchaTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(94);
        make.height.mas_equalTo(34);
        make.centerY.mas_equalTo(self.captchaBtn);
        make.left.mas_equalTo(self.phoneTextField);
        
    }];
    [self addSubview:self.captchaSplitLine];
    [self.captchaSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.height.mas_equalTo(self.phoneSplitLine);
        make.top.mas_equalTo(self.captchaBtn.mas_bottom).offset(3.f);
    }];
    ///密码
    [self addSubview:self.pwdTextField];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneTextField);
        make.top.mas_equalTo(self.captchaSplitLine.mas_bottom).offset(9);
    }];
    ///密码与邀请码的中间的View
    [self addSubview:self.splitView];
    [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self);
        make.height.mas_equalTo(11);
        make.top.mas_equalTo(self.pwdTextField.mas_bottom).offset(9);
    }];
    //邀请码
    [self addSubview:self.inviteTextField];
    [self.inviteTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneTextField);
        make.top.mas_equalTo(self.splitView.mas_bottom).offset(9);
    }];
}
#pragma mark --- 点击事件
#pragma mark --*********--发送短信验证码
- (void)sendValidMsgDidClickEvent:(UIButton *)sender{
    if (![self.phoneTextField hasText]) {
        [ToolClass showAlertWithMessage:@"手机号不能为空"];
        return;
    }else{
        if (![self.verifyTextField hasText]) {
            [ToolClass showAlertWithMessage:@"图形验证码不能为空"];
            return;
        }else{
            WeakStament(wself);
            if ([ToolClass validateMobile:self.phoneTextField.text]) {
                NSDictionary *dic = @{@"mobile":self.phoneTextField.text,
                                      @"smsType":@"0",
                                      @"checkCode":self.verifyTextField.text,
                                      @"t":[ToolClass getIDFA]
                                      };
                
                [WDNetworkClient postRequestWithBaseUrl:kSendValidMsgUrl setParameters:dic success:^(id responseObject) {
                    NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
                    NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
                    if ([code isEqualToString:@"1000"]) {
                        [wself startTimer];//倒计时
                        [ToolClass showAlertWithMessage:msg];
                    }else if ([code isEqualToString:@"1005"]){
                        //该账号已注册
                        [ToolClass showAlertWithMessage:msg];
                        return ;
                    }
                    else{
//                        [wself resetCode];//倒计时
                        [ToolClass showAlertWithMessage:msg];
                    }
                    
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
    [_captchaBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
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
        [_captchaBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
        _captchaBtn.backgroundColor = WDColorFrom16RGB(0xDBD8D8);
        [_captchaBtn setTitle:[NSString stringWithFormat:@"倒计时：%ds",_resetCount] forState:UIControlStateNormal];
//        YYLog(@"%@",[NSString stringWithFormat:@"%ds",_resetCount]);
    }
}

#pragma mark --- 约束TextField的输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (textField == self.pwdTextField) {
        if (textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.pwdTextField) {
        if ([textField hasText]) {
            if (![ToolClass judgePassWord:self.pwdTextField.text]) {
                [ToolClass showAlertWithMessage:@"密码只能是数字或字母"];
                return;
            }
        }
    }
}


#pragma mark ----- 懒加载

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
- (UIImageView *)pwdImage{
    if (!_pwdImage) {
        _pwdImage = [[UIImageView alloc] init];
        [_pwdImage setImage:[UIImage imageNamed:@"register_lock"]];
    }
    return _pwdImage;
}
- (UIImageView *)inviteImage{
    if (!_inviteImage) {
        _inviteImage = [[UIImageView alloc] init];
        [_inviteImage setImage:[UIImage imageNamed:@"register_invite"]];
    }
    return _inviteImage;
}

#pragma mark --- TextField

- (WDTextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[WDTextField alloc] init];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.placeholder = @"请输入您的手机号";
        [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
- (WDTextField *)pwdTextField{
    if (!_pwdTextField) {
        _pwdTextField = [[WDTextField alloc] init];
        [_pwdTextField setSecureTextEntry:YES];
        _pwdTextField.placeholder = @"设置密码为6~20位的数字或字母";
        _pwdTextField.delegate = self;
        [_pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdTextField;
}
- (WDTextField *)inviteTextField{
    if (!_inviteTextField) {
        _inviteTextField = [[WDTextField alloc] init];
        _inviteTextField.placeholder = @"请输入邀请码（可不填）";
    }
    return _inviteTextField;
}
#pragma mark --- Button
- (UIButton *)verifyBtn{
    if (!_verifyBtn) {
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _verifyBtn.backgroundColor = WDColorFrom16RGB(0xd8d8d8);
        _verifyBtn.backgroundColor = self.backgroundColor;
        [_verifyBtn addTarget:self action:@selector(checkCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _verifyBtn;
}
- (WDSubmitButton *)captchaBtn{
    if (!_captchaBtn) {
        _captchaBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
//        _captchaBtn.backgroundColor = [UIColor grayColor];
        [_captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _captchaBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _captchaBtn.titleLabel.font = kFont12;
        [_captchaBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
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
- (UILabel *)vertifySplitLine{
    if (!_vertifySplitLine) {
        _vertifySplitLine = [[UILabel alloc] init];
        _vertifySplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _vertifySplitLine;
}
- (UILabel *)captchaSplitLine{
    if (!_captchaSplitLine) {
        _captchaSplitLine = [[UILabel alloc] init];
        _captchaSplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _captchaSplitLine;
}
#pragma mark --- SplitView
- (UIView *)splitView{
    if (!_splitView) {
        _splitView = [[UIView alloc] init];
        _splitView.backgroundColor = WDColorFrom16RGB(0xf2f2f2);
    }
    return _splitView;
}

- (void)dealloc{
    [self.codeTimer invalidate];
    self.codeTimer = nil;
}


@end
