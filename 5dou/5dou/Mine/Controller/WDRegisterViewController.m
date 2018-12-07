//
//  WDRegisterViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/12.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  注册页面
//

#import "WDRegisterViewController.h"
#import "WDRegisterView.h"
#import "YYText.h"
#import "ToolClass.h"
#import "UIButton+WebCache.h"
#import "WDHTTPServer.h"
#import "WDSubmitButton.h"
#import "WDAgreementViewController.h"
#import "WDMemberCenterViewController.h"
#import "WDDefaultAccount.h"
#import "WDUserInfoModel.h"
#import "JPUSHService.h"

@interface WDRegisterViewController ()

@property (nonatomic, strong) WDRegisterView *registerView;///< 注册的View
@property (nonatomic, strong) WDSubmitButton *registerBtn;///< 注册按钮

@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, strong) YYLabel *protocolLable;///< 用户协议

@property (nonatomic, strong) UIImageView *policyImgView;///< 协议选中图标

@end

@implementation WDRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"注册" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *url = [NSString stringWithFormat:@"%@%@?_t=%@",HTTP_BASE,kCheckCodeUrl,[ToolClass getIDFA]];
    [self.registerView.verifyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"null_default"]];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.registerView.codeTimer invalidate];
    self.registerView.codeTimer = nil;
}

- (void)initUI{
    [self.view addSubview:self.registerView];
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(255.f);
    }];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-9.5);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.registerView.mas_bottom).offset(48.5);
    }];
    //用户协议选中图标
    [self.view addSubview:self.policyImgView];
    [self.policyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(12);
        make.top.mas_equalTo(self.registerBtn.mas_bottom).offset(12.f);
        make.left.mas_equalTo(self.registerBtn);
    }];
    //用户协议
    [self.view addSubview:self.protocolLable];
    [self.protocolLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth-20-16);
        make.height.mas_equalTo(15.f);
        make.top.mas_equalTo(self.registerBtn.mas_bottom).offset(10.f);
//        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.policyImgView.mas_right).offset(3);
    }];
}

#pragma mark --- 点击事件
- (void)registerBtnDidClickEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self isEmpty]) {
        if ([ToolClass validateMobile:self.registerView.phoneTextField.text]) {
            //密码只能是字母和数字
            if ([ToolClass judgePassWord:self.registerView.pwdTextField.text]) {
                //密码长度6-20
                if (self.registerView.pwdTextField.text.length >= 6 && self.registerView.pwdTextField.text.length<=20) {
                    //注册
                    [self registerUser];
                }else{
                    [ToolClass showAlertWithMessage:@"请输入6~20位密码"];
                }
            }else{
                [ToolClass showAlertWithMessage:@"密码位数字或字母"];
                return;
            }
        }else{
            [ToolClass showAlertWithMessage:@"手机号格式不正确"];
            return;
        }
    }
}
//判断输入框是否有未输入信息
- (BOOL)isEmpty{
    if (![self.registerView.phoneTextField hasText]) {
        [ToolClass showAlertWithMessage:@"手机号不能为空"];
        return NO;
    }else{
        if (![self.registerView.verifyTextField hasText]) {
            [ToolClass showAlertWithMessage:@"图像验证码不能为空"];
            return NO;
        }else{
            if (![self.registerView.captchaTextField hasText]) {
                [ToolClass showAlertWithMessage:@"验证码不能为空"];
                return NO;
            }else{
                if (![self.registerView.pwdTextField hasText]) {
                    [ToolClass showAlertWithMessage:@"密码不能为空"];
                    return NO;
                }else{
                    return YES;
                }
            }
        }
    }
}

#pragma mark --- 网络请求
//注册方法
- (void)registerUser{
    NSDictionary *dic = @{@"mobile":self.registerView.phoneTextField.text,
                          @"smsType":@"0",
                          @"checkCode":self.registerView.verifyTextField.text,
                          @"captcha":self.registerView.captchaTextField.text,
                          @"t":[ToolClass getIDFA]
                          };
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kValidateCaptchaUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            [weakSelf isExistUser];
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}
//判断该用户是否存在
- (void)isExistUser{
    WeakStament(wself);
    NSDictionary *dic = @{@"data":self.registerView.phoneTextField.text};
    [WDNetworkClient postRequestWithBaseUrl:kIsExistUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            [wself registerMethod];
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}
- (void)registerMethod{
    NSDictionary *dic = @{@"mobile":self.registerView.phoneTextField.text,
                          @"checkCode":self.registerView.verifyTextField.text,
                          @"captcha":self.registerView.captchaTextField.text,
                          @"password":self.registerView.pwdTextField.text,
                          @"inviteCode":self.registerView.inviteTextField.text
                          };
    WeakStament(wself);
    [WDNetworkClient postRequestWithBaseUrl:kRegisterUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:msg];
            //注册成功之后切换到个人中心
            NSDictionary *infoDic = [responseObject objectForKey:@"data"];
            [WDDefaultAccount setUserInfoWithDic:infoDic];//存储用户的基本信息
            
            //添加用户信息model,方便整个工程读取使用
            [[WDUserInfoModel shareInstance]saveUserInfoWithDic:infoDic];
            NSString *inviteCode = [WDUserInfoModel shareInstance].inviteCode;
            if (inviteCode == nil) {
                //极光官方文档要求
                inviteCode = @"";
            }
            //设置极光推送别名
            [wself setJpushAliasWithString:inviteCode];
            WDMemberCenterViewController *memberCenterVC = [[WDMemberCenterViewController alloc] init];
            memberCenterVC.isBindMobile = YES;
            [wself.navigationController pushViewController:memberCenterVC animated:YES];
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
#pragma mark --- 极光推送设置别名
- (void)setJpushAliasWithString:(NSString *)aliasString{
    [JPUSHService setTags:nil alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if (iResCode == 0) {
            YYLog(@"设置别名成功--设置的别名为：%@",iAlias);
        }else{
            YYLog(@"设置别名失败:%d",iResCode);
        }    
    }];
}


#pragma mark --- 懒加载

- (WDRegisterView*)registerView{
    if (!_registerView) {
        _registerView = [[WDRegisterView alloc] init];
    }
    return _registerView;
}

- (WDSubmitButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
- (UIButton *)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreementBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _agreementBtn;
}
- (UIImageView *)policyImgView{
    if (!_policyImgView) {
        _policyImgView = [[UIImageView alloc] init];
        _policyImgView.image = [UIImage imageNamed:@"register_policy_selected"];
    }
    return _policyImgView;
}

- (YYLabel *)protocolLable{
    if (!_protocolLable) {
        _protocolLable = [[YYLabel alloc] init];
        NSString *text = @"注册即表示同意 《吾逗用户服务协议》";
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setAlignment:NSTextAlignmentLeft];
        NSDictionary *attribs = @{NSFontAttributeName:kFont10,NSForegroundColorAttributeName:WDColorFrom16RGB(0x999999),NSParagraphStyleAttributeName:ps};
        NSMutableAttributedString *textAttributed = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        NSRange range = [text rangeOfString:@"《吾逗用户服务协议》"];
//        [textAttributed addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        WeakStament(weakSelf);
        [textAttributed yy_setTextHighlightRange:range color:WDColorFrom16RGB(0x8b572a) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {

            //页面跳转到用户协议
            WDAgreementViewController *agreementVC = [[WDAgreementViewController alloc] init];
            [weakSelf.navigationController pushViewController:agreementVC animated:YES];
            
        }];
        _protocolLable.attributedText = textAttributed;
        
    }
    return _protocolLable;
}


- (void)dealloc{
      YYLog(@"注册页面销毁");
}


@end
