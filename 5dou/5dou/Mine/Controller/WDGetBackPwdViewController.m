//
//  WDGetBackPwdViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  找回密码
//

#import "WDGetBackPwdViewController.h"
#import "WDGetBackPwdView.h"
#import "WDHTTPServer.h"
#import "UIButton+WebCache.h"
#import "WDSubmitButton.h"
#import "ToolClass.h"
#import "WDSetNewPwdViewController.h"

@interface WDGetBackPwdViewController ()

@property (nonatomic, strong) WDGetBackPwdView *getBackPwdView;///< 找回密码
@property (nonatomic, strong) WDSubmitButton *submitButton;///< 找回密码按钮

@end

@implementation WDGetBackPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"找回密码" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.view.backgroundColor = kBackgroundColor;
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPicCode];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.getBackPwdView.codeTimer invalidate];
    self.getBackPwdView.codeTimer = nil;
}

- (void)initUI{
    [self.view addSubview:self.getBackPwdView];
    [self.getBackPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(145.f);
    }];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_equalTo(-10.f);
        make.left.mas_equalTo(self.view).mas_equalTo(10.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.getBackPwdView.mas_bottom).offset(49.f);
    }];
}
//获取图片验证码
- (void)getPicCode{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *url = [NSString stringWithFormat:@"%@%@?_t=%@",HTTP_BASE,kCheckCodeUrl,[ToolClass getIDFA]];
    [self.getBackPwdView.verifyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"null_default"]];
}

#pragma mark ---- 点击事件
- (void)submitBtnDidClickEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    if ([self isEmpty]) {
        // 验证验证码
        [self validateVertify];
    }
}
#pragma mark --- 判断是否为空
- (BOOL)isEmpty{
    if ([self.getBackPwdView.phoneTextField hasText]) {
        if ([self.getBackPwdView.verifyTextField hasText]) {
            if ([self.getBackPwdView.captchaTextField hasText]) {
                return YES;
            }else{
                [ToolClass showAlertWithMessage:@"验证码不能为空"];
                return NO;
            }
        }else{
            [ToolClass showAlertWithMessage:@"图像验证码不能为空"];
            return NO;
        }
    }else{
        [ToolClass showAlertWithMessage:@"手机号不能为空"];
        return NO;
    }
}
- (void)validateVertify{
    NSDictionary *dic = @{@"mobile":self.getBackPwdView.phoneTextField.text,
                          @"smsType":@"2",
                          @"checkCode":self.getBackPwdView.verifyTextField.text,
                          @"captcha":self.getBackPwdView.captchaTextField.text,
                          @"t":[ToolClass getIDFA]
                          };
    [WDNetworkClient postRequestWithBaseUrl:kValidateCaptchaUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            
            WDSetNewPwdViewController *setPasswordVC= [[WDSetNewPwdViewController alloc] init];
            setPasswordVC.captcha = self.getBackPwdView.captchaTextField.text;
            setPasswordVC.mobileString = self.getBackPwdView.phoneTextField.text;
            [self.navigationController pushViewController:setPasswordVC animated:YES];
            
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark  --- 懒加载

- (WDGetBackPwdView *)getBackPwdView{
    if (!_getBackPwdView) {
        _getBackPwdView = [[WDGetBackPwdView alloc] initWithSMSType:@"2"];
    }
    return _getBackPwdView;
}

- (WDSubmitButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"验证并提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
