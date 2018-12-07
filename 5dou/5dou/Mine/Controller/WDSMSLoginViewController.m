//
//  WDSMSLoginViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  短信验证码登录
//

#import "WDSMSLoginViewController.h"
#import "WDGetBackPwdView.h"
#import "WDSubmitButton.h"
#import "UIButton+WebCache.h"
#import "WDHTTPServer.h"
#import "ToolClass.h"
#import "UIButton+WebCache.h"
#import "WDLoginModel.h"
#import "WDUserInfoModel.h"
#import "WDDefaultAccount.h"
#import "JPUSHService.h"

@interface WDSMSLoginViewController ()

@property (nonatomic, strong) WDGetBackPwdView *smsLoginView;///< 短信验证码登录
@property (nonatomic, strong) WDSubmitButton *submitBtn;///< 登录按钮

@end

@implementation WDSMSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"短信验证码登录" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 注册键盘出现与隐藏时候的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    [self getPicCode];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.smsLoginView.codeTimer invalidate];
    self.smsLoginView.codeTimer = nil;
}

- (void)initUI{
    [self.view addSubview:self.smsLoginView];
    [self.smsLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(145.f);
    }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_equalTo(-10.f);
        make.left.mas_equalTo(self.view).mas_equalTo(10.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.smsLoginView.mas_bottom).offset(49.f);
    }];
    
}
#pragma mark --- 登录

- (void)submitBtnDidClickEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self.smsLoginView.phoneTextField hasText]) {
        if ([self.smsLoginView.verifyTextField hasText]) {
            if ([self.smsLoginView.captchaTextField hasText]) {
                [self validateCheckCode];
            }else{
                [ToolClass showAlertWithMessage:@"验证码不能为空"];
                return;
            }
        }else{
            [ToolClass showAlertWithMessage:@"图像验证码不能为空"];
            return;
        }
    }else{
        [ToolClass showAlertWithMessage:@"手机号不能为空"];
        return;
    }
}


- (void)validateCheckCode{
    NSDictionary *dic = @{@"mobile":self.smsLoginView.phoneTextField.text,
                          @"smsType":@"1",
                          @"checkCode":self.smsLoginView.verifyTextField.text,
                          @"captcha":self.smsLoginView.captchaTextField.text,
                          @"t":[ToolClass getIDFA]
                          };
    [WDNetworkClient postRequestWithBaseUrl:kValidateCaptchaUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            [self loginRequest];
            
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}
- (void)loginRequest{
    WeakStament(weakSelf);
    ///登录成功跳转到个人中心
    NSDictionary *dic = @{@"loginName":self.smsLoginView.phoneTextField.text,
                          @"password":self.smsLoginView.captchaTextField.text,
                          @"loginType":@"1"
                          };
    [WDNetworkClient postRequestWithBaseUrl:kLoginUrl setParameters:dic success:^(id responseObject) {
        
        WDLoginModel *loginModel = [[WDLoginModel alloc] initWithDictionary:responseObject error:nil];
        if ([loginModel.result.code isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:loginModel.result.msg];
            NSDictionary *infoDic = [responseObject objectForKey:@"data"];
            [WDDefaultAccount setUserInfoWithDic:infoDic];//存储用户的基本信息
            //添加用户信息model,方便整个工程读取使用
            [[WDUserInfoModel shareInstance]saveUserInfoWithDic:infoDic];
            NSString *inviteCode = [WDUserInfoModel shareInstance].inviteCode;
            if (inviteCode == nil) {
                //极光官方文档要求
                inviteCode = @"";
            }
            //设置极光推送的别名
            [self setJpushAliasWithString:inviteCode];
            UIViewController *rootVC = weakSelf.presentingViewController;
            while (rootVC.presentingViewController) {
                rootVC = rootVC.presentingViewController;
            }
            [rootVC dismissViewControllerAnimated:YES completion:nil];
        }else{
            [ToolClass showAlertWithMessage:loginModel.result.msg];
        }
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:weakSelf.view];
}

//获取图片验证码
- (void)getPicCode{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *url = [NSString stringWithFormat:@"%@%@?_t=%@",HTTP_BASE,kCheckCodeUrl,[ToolClass getIDFA]];
    [self.smsLoginView.verifyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"null_default"]];
}
#pragma mark --- 键盘监听事件
/**
 *  键盘将出现时的处理
 *
 *  @param note
 */
- (void)keyboardWillShow: (NSNotification *)note {
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat offsetY = (ScreenHeight - self.smsLoginView.bottom) - keyboardSize.height;
    
    // 如果键盘将遮挡输入框 主视图动画上移
    if (offsetY <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(ScreenWidth/2, ScreenHeight/2 + offsetY);
        }];
    }
}
/**
 *  键盘将隐藏时的处理
 *
 *  @param note
 */
- (void)keyboardWillHide: (NSNotification *)note {
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
        self.view.transform = CGAffineTransformIdentity;
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ------- 极光推送设置别名
- (void)setJpushAliasWithString:(NSString *)aliasString{
    [JPUSHService setTags:nil alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if (iResCode == 0) {
            YYLog(@"设置别名成功--设置的别名为：%@",iAlias);
        }else{
            YYLog(@"设置别名失败:%d",iResCode);
        }
        
    }];
}

#pragma mark  --- 懒加载

- (WDGetBackPwdView *)smsLoginView{
    if (!_smsLoginView) {
        _smsLoginView = [[WDGetBackPwdView alloc] initWithSMSType:@"1"];
    }
    return _smsLoginView;
}
- (WDSubmitButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}










@end
