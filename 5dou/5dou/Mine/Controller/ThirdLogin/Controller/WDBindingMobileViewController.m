//
//  WDBindingMobileViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/21.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  第一次三方登录之后绑定手机号
//

#import "WDBindingMobileViewController.h"
#import "WDGetBackPwdView.h"
#import "WDSubmitButton.h"
#import "UIButton+WebCache.h"
#import "ToolClass.h"
#import "WDHTTPServer.h"
#import "WDUserInfoModel.h"
#import "WDMemberCenterViewController.h"
#import "WDLoginModel.h"
#import "WDDefaultAccount.h"
#import "WDThirdUserInfoModel.h"

@interface WDBindingMobileViewController ()

@property (nonatomic, strong) WDGetBackPwdView *bindingMobileView;
@property (nonatomic, strong) WDSubmitButton *submitBtn;


@end

@implementation WDBindingMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"绑定手机号" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.view.backgroundColor = kBackgroundColor;
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPicCode];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.bindingMobileView.codeTimer invalidate];
    self.bindingMobileView.codeTimer = nil;
}


- (void)initUI{
    [self.view addSubview:self.bindingMobileView];
    [self.bindingMobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(146.f);
    }];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_equalTo(-10.f);
        make.left.mas_equalTo(self.view).mas_equalTo(10.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.bindingMobileView.mas_bottom).offset(49.f);
    }];
}
//获取图片验证码
- (void)getPicCode{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *url = [NSString stringWithFormat:@"%@%@?_t=%@",HTTP_BASE,kCheckCodeUrl,[ToolClass getIDFA]];
    [self.bindingMobileView.verifyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"null_default"]];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark --- 点击事件
- (void)submitBtnDidClickEvent:(UIButton *)sender{
    if ([self.bindingMobileView.phoneTextField hasText]) {
        if ([self.bindingMobileView.verifyTextField hasText]) {
            if ([self.bindingMobileView.captchaTextField hasText]) {
                if ([ToolClass validateMobile:self.bindingMobileView.phoneTextField.text]) {
                    [self bindingMobile];
                }else{
                    [ToolClass showAlertWithMessage:@"手机号格式不正确"];
                    return;
                }
            }else{
                [ToolClass showAlertWithMessage:@"短信验证码不能为空"];
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
#pragma mark ======== 网络请求
#pragma mark --- 绑定注册信息
- (void)bindingMobile{
    
    NSString *mi = [WDThirdUserInfoModel shareInstance].memberId;
    if (mi == nil) {
        //避免发生崩溃
        mi = @"";
    }
    NSDictionary *dic = @{@"mi":mi,
                          @"mobile":self.bindingMobileView.phoneTextField.text,
                          @"captcha":self.bindingMobileView.captchaTextField.text,
                          @"loginAuthType":self.loginAuthType,
                          @"loginAuthId":self.loginAuthId,
                          };
    [WDNetworkClient postRequestWithBaseUrl:kCompleteRegUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            NSDictionary *infoDic = [responseObject objectForKey:@"data"];
            //存储用户的基本信息
            [WDDefaultAccount setUserInfoWithDic:infoDic];
            //添加用户信息model,方便整个工程读取使用
            [[WDUserInfoModel shareInstance]saveUserInfoWithDic:infoDic];
//            [WDUserInfoModel shareInstance].headImg = self.authHeadImg;
            WDMemberCenterViewController *memberCenterVC = [[WDMemberCenterViewController alloc] init];
            memberCenterVC.isBindMobile = YES;
            [self.navigationController pushViewController:memberCenterVC animated:YES];
        }else{
            //清除缓存的代码
//            [WDDefaultAccount cleanAccountCache];
//            [[WDUserInfoModel shareInstance] clearUserInfo];//清除用户数据
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        //清除缓存的代码
        [WDDefaultAccount cleanAccountCache];
        //清除用户数据
        [[WDUserInfoModel shareInstance] clearUserInfo];
    } delegater:self.view];
}


#pragma mark  --- 懒加载

- (WDGetBackPwdView *)bindingMobileView{
    if (!_bindingMobileView) {
        _bindingMobileView = [[WDGetBackPwdView alloc] initWithSMSType:@"-1"];
    }
    return _bindingMobileView;
}

- (WDSubmitButton *)submitButton{
    if (!_submitBtn) {
        _submitBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"验证并绑定" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
