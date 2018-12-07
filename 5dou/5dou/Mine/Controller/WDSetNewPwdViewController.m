//
//  WDNewPasswordViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  设置新密码
//


#import "WDSetNewPwdViewController.h"
#import "WDSubmitButton.h"
#import "WDSetNewPwdView.h"
#import "ToolClass.h"

@interface WDSetNewPwdViewController ()

@property (nonatomic, strong) WDSetNewPwdView *setNewPwdView;

@property (nonatomic, strong) WDSubmitButton *submitBtn;///<

@end

@implementation WDSetNewPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"设置新密码" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
}

- (void)initUI{

    [self.view addSubview:self.setNewPwdView];
    [self.setNewPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(110.f);
        make.top.mas_equalTo(self.view).offset(10.f);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    //确定按钮
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.setNewPwdView.mas_bottom).offset(49.f);
    }];
    
}
#pragma  mark --- 点击事件
- (void)submitBtnDidClick:(UIButton *)sender{
    NSString *firstPwd = self.setNewPwdView.firstTextField.text;
    NSString *secondPwd = self.setNewPwdView.secondTextField.text;
    if (firstPwd.length) {
        if (secondPwd.length) {
            if ([ToolClass judgePassWord:firstPwd] && [ToolClass judgePassWord:secondPwd]) {
                if ([firstPwd isEqualToString:secondPwd]) {
                    if (firstPwd.length < 6||secondPwd.length < 6) {
                        [ToolClass showAlertWithMessage:@"请输入6~20位密码"];
                        return;
                    }else{
                        [self setUserPassword];
                    }
                }else{
                    [ToolClass showAlertWithMessage:@"两次输入的密码不一致"];
                    return;
                }
            }else{
                [ToolClass showAlertWithMessage:@"密码只能是字母和数字"];
                return;
            }
        }else{
            [ToolClass showAlertWithMessage:@"确认密码不能为空"];
        }
    }else{
        [ToolClass showAlertWithMessage:@"密码不能为空"];
    }
}
- (void)setUserPassword{
    NSDictionary *dic = @{@"mobile":self.mobileString,
                          @"captcha":self.captcha,
                          @"password":self.setNewPwdView.firstTextField.text,
                          };
    
    [WDNetworkClient postRequestWithBaseUrl:kFindPasswordUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:msg];
            //页面跳转 跳转到登录页面
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}


#pragma  mark --- 懒加载

- (WDSetNewPwdView *)setNewPwdView{
    if (!_setNewPwdView) {
        _setNewPwdView = [[WDSetNewPwdView alloc] init];
    }
    return _setNewPwdView;
}

- (WDSubmitButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}




@end
