//
//  WDLoginViewController.m
//  5dou
//
//  Created by rdyx on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  登录页面
//

#import "WDLoginViewController.h"
#import "ToolClass.h"
#import "RSA.h"
#import "WDLoginModel.h"
#import "WDRegisterViewController.h"
#import "WDDefaultAccount.h"
#import "WDMineViewController.h"
#import "WDUserInfoModel.h"
#import "WDGetBackPwdViewController.h"
#import "WDSMSLoginViewController.h"
#import "WDSetNewPwdViewController.h"
#import "WDLoginCutOffLabeView.h"
#import "UMCustomManager.h"
//#import <WXApi.h>
//#import <TencentOpenAPI/QQApiInterface.h>
#import "WDBindingMobileViewController.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "WDBindingMobileViewController.h"
#import "WDThirdUserInfoModel.h"
#import "JPUSHService.h"

@interface WDLoginViewController ()<UITextFieldDelegate>

@property(nonatomic,copy)NSString *RSAPublicKey;

@property (nonatomic, strong) UIView *bgView;///< 背景View
@property (strong, nonatomic) UIButton *mobileBtn;
@property (strong, nonatomic) UITextField *mobileTextField;

@property (strong, nonatomic) UIButton *passwordBtn;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UILabel *splitLine;///< 分割线

@property (strong, nonatomic) UIButton *forgetPwdBtn;///< 忘记密码
@property (strong, nonatomic) UIButton *loginBtn;///< 登录
@property (strong, nonatomic) UIButton *registerBtn;///< 注册
@property (strong, nonatomic) UIButton *messageBtn;///< 短信验证码登录


//***三方登录****//
@property (strong, nonatomic) UIButton *weixinLoginBtn;
@property (strong, nonatomic) UIButton *qqLoginBtn;
@property (strong, nonatomic) WDLoginCutOffLabeView *cutOffView;
@property (strong, nonatomic) UILabel *lineLabel;///三方登录中间的一条线用来做约束用的


@end

static NSString *loginTips = @"请输入正确的用户名和密码";

@implementation WDLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"登录" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.view.backgroundColor = kBackgroundColor;
    [self getRSAPublicKey];
    [self initUI];
    [ToolClass setView:self.loginBtn withRadius:4.f andBorderWidth:.5f andBorderColor:kNavigationBarColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMinViewController) name:DISMISS_VIEWCONTROLLER object:nil];
}



- (void)initUI{
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(10.f);
        make.height.mas_equalTo(96.f);
    }];
    
    //手机号
//    [self.bgView addSubview:self.mobileBtn];
//    [self.mobileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(22.f);
//        make.height.mas_equalTo(22.f);
//        make.left.mas_equalTo(self.bgView.mas_left).offset(10.f);
//        make.top.mas_equalTo(self.bgView.mas_top).offset(17.f);
//    }];

    [self.bgView addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(20.f);
        make.top.mas_equalTo(self.bgView.mas_top).offset(9);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20.f);
        make.height.mas_equalTo(30.f);
    }];
//    self.mobileTextField.backgroundColor = [UIColor redColor];
    //分割线
    [self.bgView addSubview:self.splitLine];
    [self.splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(10.f);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-10.f);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(9.f);
    }];
    //密码
//    [self.bgView addSubview:self.passwordBtn];
//    [self.passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.left.mas_equalTo(self.mobileBtn);
//        make.top.mas_equalTo(self.splitLine.mas_bottom).offset(16.5);
//    }];
//    self.passwordTextField.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.splitLine.mas_bottom).offset(9);
        make.left.width.height.mas_equalTo(self.mobileTextField);
    }];
    //忘记密码
    [self.view addSubview:self.forgetPwdBtn];
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
        make.width.mas_equalTo(85.f);
    }];
    ///登录按钮
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(80.f);
    }];
    //短信验证登录
    [self.view addSubview:self.messageBtn];
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12.f);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(15.f);
        make.width.mas_equalTo(120.f);
        make.height.mas_equalTo(17.f);
    }];
    //立即注册
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-9.5);
        make.top.mas_equalTo(self.messageBtn);
        make.width.mas_equalTo(70.f);
        make.height.mas_equalTo(17.f);
    }];
    
    
    
//    [self createThridLoginView];
    
    
    
}
//- (void)createThridLoginView{
//    //**********三方登录***********//
//    //    分割线
//    [self.view addSubview:self.cutOffView];
//    [self.cutOffView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.view.mas_bottom).offset(-90.f);
//    }];
//    if ([WXApi isWXAppInstalled]) {
//        if ([QQApiInterface isQQInstalled]) {
//            //QQ微信都有安装
//            [self.view addSubview:self.lineLabel];
//            [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(0.5);
//                make.centerX.mas_equalTo(self.view);
//                make.bottom.mas_equalTo(self.view.mas_bottom);
//            }];
//            //微信按钮
//            [self.view addSubview:self.weixinLoginBtn];
//            [self.weixinLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.mas_equalTo(50.f);
//                make.top.mas_equalTo(self.cutOffView.mas_bottom).offset(15.f);
//                make.right.mas_equalTo(self.lineLabel.mas_left).offset(-40.f);
//            }];
//            //QQ
//            [self.view addSubview:self.qqLoginBtn];
//            [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.top.height.mas_equalTo(self.weixinLoginBtn);
//                make.left.mas_equalTo(self.lineLabel.mas_left).offset(40.f);
//            }];
//        }else{
//            //只能装微信
//            [self.view addSubview:self.weixinLoginBtn];
//            [self.weixinLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.mas_equalTo(50.f);
//                make.top.mas_equalTo(self.cutOffView.mas_bottom).offset(15.f);
//                make.centerX.mas_equalTo(self.view);
//            }];
//
//        }
//    }else{
//        if ([QQApiInterface isQQInstalled]) {
//            //只安装QQ
//            [self.view addSubview:self.qqLoginBtn];
//            [self.qqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.mas_equalTo(50.f);
//                make.top.mas_equalTo(self.cutOffView.mas_bottom).offset(15.f);
//                make.centerX.mas_equalTo(self.view);
//            }];
//        }else{
//            //都没有安装
//            self.cutOffView.hidden = YES;
//        }
//    }
//}

#pragma mark ----- 通知返回到我的页面
- (void)backToMinViewController{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)getRSAPublicKey
{
    [WDNetworkClient postRequestWithBaseUrl:kRSAPublicKeyUrl setParameters:nil success:^(id responseObject) {
        if (responseObject) {
            NSDictionary *subDic = responseObject[@"result"];
            NSString *code = subDic[@"code"];
            if ([code isEqualToString:@"1000"]) {
                NSDictionary *data = responseObject[@"data"];
                self.RSAPublicKey = data[@"pubkey"];
            }
        }
        
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:nil];
}

#pragma mark --- 点击事件
//登录按钮点击事件
- (void)loginBtnDidClickEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self.mobileTextField hasText]&&[self.passwordTextField hasText]) {
        if ([ToolClass validateMobile:self.mobileTextField.text]) {
            if ([ToolClass judgePassWord:self.passwordTextField.text]) {
                [self loginRequest];
            }else{
                [ToolClass showAlertWithMessage:@"密码只能是字母和数字"];
                return; 
            }
        }else{
            [ToolClass showAlertWithMessage:@"用户名输入有错"];
            return;
        }
    }else{
        [ToolClass showAlertWithMessage:loginTips];
        return;
    }
}
//注册按钮点击事件
- (void)registerBtnDidClickEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    WDRegisterViewController *registerVC = [[WDRegisterViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:registerVC];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}
//忘记密码点击事件
- (void)forgotBtnDidClickEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    WDGetBackPwdViewController *getBackPwdVC = [[WDGetBackPwdViewController alloc] init];
    getBackPwdVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:getBackPwdVC animated:YES];
}
// 短信验证码点击事件
- (void)smsLoginBtnDidClickEvent:(UIButton *)sender{
    WDSMSLoginViewController *smsLoginVC = [[WDSMSLoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:smsLoginVC];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:smsLoginVC animated:YES];
}

#pragma mark ======================== 三方登录 =============================

#pragma mark --- 微信登录
- (void)wxLoginBtnDidClickEvent:(UIButton *)sender{
    WeakStament(wself);
//    [UMCustomManager loginWithWXWithController:self Success:^(id response) {
//        UMSocialUserInfoResponse *resp = response;
//        [wself thirdLoginWithName:resp.name LoginAuthType:@"wx" LoginAuthId:resp.uid AuthNickName:resp.name AuthHeadImg:resp.iconurl];
//    } Failure:^(id error) {
//        [ToolClass showAlertWithMessage:@"授权失败"];
//        YYLog(@"%@",error);
//    }];
}

#pragma mark --- QQ登录

- (void)qqLoginBtnDidClickEvent:(UIButton *)sender{
    WeakStament(wself);
//    [UMCustomManager loginWithQQWithController:self Success:^(id response) {
//        UMSocialUserInfoResponse *resp = response;
//        [wself thirdLoginWithName:resp.name LoginAuthType:@"qq" LoginAuthId:resp.uid AuthNickName:resp.name AuthHeadImg:resp.iconurl];
//    } Failure:^(id error) {
//        [ToolClass showAlertWithMessage:@"授权失败"];
//        YYLog(@"%@",error);
//    }];
}

#pragma mark --- 三方登录
- (void)thirdLoginWithName:(NSString *)name LoginAuthType:(NSString *)loginAuthType
               LoginAuthId:(NSString *)loginAuthId AuthNickName:(NSString *)authNickName
               AuthHeadImg:(NSString *)headImg{
    NSDictionary *dic = @{
                          @"loginType":@"2",
                          @"loginAuthType":loginAuthType,
                          @"loginAuthId":loginAuthId,
                          @"authNickName":authNickName,
                          @"authHeadImg":headImg
                          };
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kLoginUrl setParameters:dic success:^(id responseObject) {
        WDLoginModel *loginModel = [[WDLoginModel alloc] initWithDictionary:responseObject error:nil];
        if ([loginModel.result.code isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"登录成功"];
            NSDictionary *infoDic = [responseObject objectForKey:@"data"];
            //存储用户的基本信息
            [WDDefaultAccount setUserInfoWithDic:infoDic];
            //添加用户信息model,方便整个工程读取使用
            [[WDUserInfoModel shareInstance]saveUserInfoWithDic:infoDic];
            //登录成功后界面dismiss
            NSString *inviteCode = [WDUserInfoModel shareInstance].inviteCode;
            if (inviteCode == nil) {
                //极光官方文档要求
                inviteCode = @"";
            }
            [self setJpushAliasWithString:inviteCode];
            [super backItemClick];
            if (weakSelf.successLoginBlock) {
                weakSelf.successLoginBlock();
            }
        }else if ([loginModel.result.code isEqualToString:@"1006"]){
            
            NSDictionary *infoDic = [responseObject objectForKey:@"data"];
            NSString *mi = infoDic[@"memberId"];
            if (mi== nil||[mi isEqualToString:@""]) {
                [ToolClass showAlertWithMessage:@"登录失败，请重新尝试"];
                return ;
            }
            [[WDThirdUserInfoModel shareInstance] saveUserInfoWithDic:infoDic];
            NSString *inviteCode = [WDThirdUserInfoModel shareInstance].inviteCode;
            if (inviteCode == nil) {
                //极光官方文档要求
                inviteCode = @"";
            }
            [self setJpushAliasWithString:inviteCode];
            //添加用户信息model,方便整个工程读取使用
//            [WDDefaultAccount setUserInfoWithDic:infoDic];
//            [[WDUserInfoModel shareInstance]saveUserInfoWithDic:infoDic];
            //三方登录绑定手机号
            WDBindingMobileViewController *bindingMobileVC = [[WDBindingMobileViewController alloc] init];
            bindingMobileVC.hidesBottomBarWhenPushed = YES;
            bindingMobileVC.loginAuthId = loginAuthId;
            bindingMobileVC.loginAuthType = loginAuthType;
//            bindingMobileVC.authHeadImg = headImg;///< 三方登录头像
            [weakSelf.navigationController pushViewController:bindingMobileVC animated:YES];
        }
        else{
            [ToolClass showAlertWithMessage:loginModel.result.msg];
        }
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:self.view];
}

#pragma mark --- 数据访问
- (void)loginRequest{
//    NSString *encrypedPassword;
//    if (self.RSAPublicKey) {
//        //加密后的密码
//        encrypedPassword =  [RSA encryptString:self.passwordTextField.text publicKey:self.RSAPublicKey];
//    }
    NSDictionary *dic = @{@"loginName":self.mobileTextField.text,
                          @"password":self.passwordTextField.text,
//                          @"password":encrypedPassword,
                          @"loginType":@"0"
                          };
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kLoginUrl setParameters:dic success:^(id responseObject) {
        
        WDLoginModel *loginModel = [[WDLoginModel alloc] initWithDictionary:responseObject error:nil];
        if ([loginModel.result.code isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"登录成功"];
            NSDictionary *infoDic = [responseObject objectForKey:@"data"];
            [WDDefaultAccount setUserInfoWithDic:infoDic];//存储用户的基本信息
            //添加用户信息model,方便整个工程读取使用
            [[WDUserInfoModel shareInstance]saveUserInfoWithDic:infoDic];
            //设置推送的别名
            NSString *inviteCode = [WDUserInfoModel shareInstance].inviteCode;
            if (inviteCode == nil) {
                //极光官方文档要求
                inviteCode = @"";
            }
            //设置极光推送别名
            [weakSelf setJpushAliasWithString:inviteCode];
            //登录成功后界面dismiss
            [super backItemClick];
            if (weakSelf.successLoginBlock) {
                weakSelf.successLoginBlock();
            }
//            WDMineViewController * mineVC = [[WDMineViewController alloc] init];
//            [self.navigationController pushViewController:mineVC animated:YES];
        }else{
            [ToolClass showAlertWithMessage:loginModel.result.msg];
        }
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:self.view];
}
#pragma mark ======== 设置极光推送别名
- (void)setJpushAliasWithString:(NSString *)aliasString{
    [JPUSHService setTags:nil alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if (iResCode == 0) {
            YYLog(@"设置别名成功--设置的别名为：%@",iAlias);
        }else{
            YYLog(@"设置别名失败:%d",iResCode);
        }
    }];
}

#pragma mark --- 约束TextField的输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.mobileTextField) {
        if (textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (textField == self.passwordTextField) {
        if (textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark --- 懒加载
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor= WDColorFrom16RGB(0xffffff);
    }
    return _bgView;
}

- (UIButton *)mobileBtn{
    if (!_mobileBtn) {
        _mobileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _mobileBtn.backgroundColor = [UIColor redColor];
//        [_mobileBtn setBackgroundImage:[UIImage imageNamed:@"register_iphone"] forState:UIControlStateNormal];
        
    }
    return _mobileBtn;
}
- (UIButton *)passwordBtn{
    if (!_passwordBtn) {
        _passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_passwordBtn setBackgroundImage:[UIImage imageNamed:@"register_lock"] forState:UIControlStateNormal];
    }
    return _passwordBtn;
}
- (UITextField *)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.delegate = self;
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.placeholder = @"请输入手机号";
        _mobileTextField.textColor = WDColorFrom16RGB(0x333333);
        _mobileTextField.font = [UIFont systemFontOfSize:15.f];
        _mobileTextField.delegate = self;
        [_mobileTextField setValue:WDColorFrom16RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [_mobileTextField setValue:[UIFont systemFontOfSize:15.f] forKeyPath:@"_placeholderLabel.font"];
    
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileTextField;
}
- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _mobileTextField.delegate = self;
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.textColor = WDColorFrom16RGB(0x333333);
        _passwordTextField.font = [UIFont systemFontOfSize:15.f];
        [_passwordTextField setSecureTextEntry:YES];
        [_passwordTextField setValue:WDColorFrom16RGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [_passwordTextField setValue:[UIFont systemFontOfSize:15.f] forKeyPath:@"_placeholderLabel.font"];
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}
- (UIButton *)forgetPwdBtn{
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPwdBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
        [_forgetPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:WDColorFrom16RGB(0x999999) forState:UIControlStateNormal];
        [_forgetPwdBtn addTarget:self action:@selector(forgotBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}
- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _loginBtn.backgroundColor = kNavigationBarColor;
        _loginBtn.layer.cornerRadius = 10.f;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = kFont16;
        [_loginBtn addTarget:self action:@selector(loginBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBtn;
}
- (UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _registerBtn.titleLabel.font = kFont16;
        _registerBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
        _registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//        [_registerBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
- (UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _messageBtn.titleLabel.font = kFont16;
        _messageBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        [_messageBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
        [_messageBtn setTitle:@"短信验证码登录" forState:UIControlStateNormal];
        _messageBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [_messageBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(smsLoginBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}

- (UILabel *)splitLine{
    if (!_splitLine) {
        _splitLine = [[UILabel alloc] init];
        _splitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _splitLine;
}
//**********第三方登录**************//
- (UIButton *)weixinLoginBtn{
    if (!_weixinLoginBtn) {
        _weixinLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weixinLoginBtn setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_weixinLoginBtn addTarget:self action:@selector(wxLoginBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinLoginBtn;
}
- (UIButton *)qqLoginBtn{
    if (!_qqLoginBtn) {
        _qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_qqLoginBtn addTarget:self action:@selector(qqLoginBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqLoginBtn;
}
- (WDLoginCutOffLabeView *)cutOffView{
    if(!_cutOffView){
        _cutOffView = [[WDLoginCutOffLabeView alloc] init];
        _cutOffView.text = @"第三方登录";
    }
    return _cutOffView;
}
- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = kBackgroundColor;
    }
    return _lineLabel;
}



#pragma mark **********dealloc***********

- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreat
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
