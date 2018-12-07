//
//  WDSetPwdViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  修改密码
//


#import "WDChangePwdViewController.h"
#import "WDSubmitButton.h"
#import "WDTextField.h"
#import "WDSubmitButton.h"
#import "ToolClass.h"
#import "WDGetBackPwdViewController.h"

@interface WDChangePwdViewController ()


@property (nonatomic, strong) UILabel *oldPwdLabel;///< 原密码
@property (nonatomic, strong) UILabel *nowPwdLabel;///< 新密码
@property (nonatomic, strong) UILabel *surePwdLabel;///< 确认密码

@property (nonatomic, strong) UILabel *oldPwdLine;///< 原密码分割线
@property (nonatomic, strong) UILabel *nowPwdLine;///< 新密码分割线

@property (nonatomic, strong) UIView *bgView;///< 背景View



@property (nonatomic, strong) WDTextField *oldTextField;
@property (nonatomic, strong) WDTextField *nowTextField;
@property (nonatomic, strong) WDTextField *sureTextField;

@property (nonatomic, strong) WDSubmitButton *submitBtn;///< 确认修改
@property (nonatomic, strong) UIButton *forgotPwd;///< 忘记原密码


@end

@implementation WDChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"修改登录密码" textColor: kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)initUI{
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_equalTo(10.f);
        make.height.mas_equalTo(163.f);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    ///旧密码
    [self.bgView addSubview:self.oldPwdLabel];
    [self.oldPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(10.f);
        make.width.mas_equalTo(80.f);
        make.height.mas_equalTo(16.f);
        make.top.mas_equalTo(self.bgView.mas_top).offset(17.f);
    }];
    [self.bgView addSubview:self.oldTextField];
    [self.oldTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oldPwdLabel.mas_right).offset(8.f);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20.f);
        make.height.mas_equalTo(30.f);
        make.top.mas_equalTo(self.bgView.mas_top).offset(12.f);
    }];
    
    [self.bgView addSubview:self.oldPwdLine];
    [self.oldPwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.oldPwdLabel.mas_bottom).offset(21.f);
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
    }];
    
    /// 新密码
    [self.bgView addSubview:self.nowPwdLabel];
    [self.nowPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.oldPwdLabel);
        make.top.mas_equalTo(self.oldPwdLine.mas_bottom).offset(16.f);
    }];
    [self.bgView addSubview:self.nowTextField];
    [self.nowTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.oldTextField);
        make.top.mas_equalTo(self.oldPwdLine.mas_bottom).offset(12.f);
    }];
    [self.bgView addSubview:self.nowPwdLine];
    [self.nowPwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nowPwdLabel.mas_bottom).offset(22.f);
        make.height.right.left.mas_equalTo(self.oldPwdLine);
    }];
    ///确认密码
    [self.bgView addSubview:self.surePwdLabel];
    [self.surePwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.left.mas_equalTo(self.nowPwdLabel);
        make.top.mas_equalTo(self.nowPwdLine.mas_bottom).offset(16.f);
    }];
    [self.bgView addSubview:self.sureTextField];
    [self.sureTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.height.mas_equalTo(self.nowTextField);
        make.top.mas_equalTo(self.nowPwdLine.mas_bottom).offset(12.f);
    }];
    ///确认修改按钮
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(49.f);
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
        make.height.mas_equalTo(44.f);
    }];
    //忘记原密码
    [self.view addSubview:self.forgotPwd];
    [self.forgotPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17.f);
        make.width.mas_equalTo(110.f);
        make.top.mas_equalTo(self.submitBtn.mas_bottom).offset(15.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
    }];
}
#pragma mark ---- 点击事件
- (void)submintBtnDidClickEvent:(UIButton *)sender{
    //判断不为空的情况
    if ([self isEmpty]) {
        NSString *firstPwd = self.nowTextField.text;
        NSString *secondPwd = self.sureTextField.text;
        if ([ToolClass judgePassWord:firstPwd] &&
            [ToolClass judgePassWord:secondPwd] &&
            [ToolClass judgePassWord:self.oldTextField.text]) {
            if (![firstPwd isEqualToString:secondPwd]) {
                [ToolClass showAlertWithMessage:@"两次输入的密码不一致"];
                return;
            }else{
                if (self.oldTextField.text.length<6 ||self.nowTextField.text.length<6 ||self.sureTextField.text.length<6) {
                    [ToolClass showAlertWithMessage:@"请输入6~20位密码"];
                    return;
                }else{
                    [self submintData];
                }
            }
        }else{
            [ToolClass showAlertWithMessage:@"密码只能是字母和数字"];
            return;
        }
    }
}

- (BOOL)isEmpty{
    if ([self.oldTextField hasText]) {
        if ([self.nowTextField hasText]) {
            if ([self.sureTextField hasText]) {
                return YES;
            }else{
                [ToolClass showAlertWithMessage:@"确认密码不能为空"];
                return NO;
            }
        }else{
            [ToolClass showAlertWithMessage:@"新密码不能为空"];
            return NO;
        }
    }else{
        [ToolClass showAlertWithMessage:@"原密码不能为空"];
        return NO;
    }
}

- (void)submintData{
    NSString *firstPwd = self.nowTextField.text;
    NSString *secondPwd = self.sureTextField.text;
    if (![firstPwd isEqualToString:secondPwd]) {
        [ToolClass showAlertWithMessage:@"两次输入的密码不一致"];
        return;
    }else{
        NSDictionary *dic = @{@"oldPasswd":self.oldTextField.text,
                              @"password":firstPwd,
                              };
        [WDNetworkClient postRequestWithBaseUrl:kUpdatePasswordUrl setParameters:dic success:^(id responseObject) {
            NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
            NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
            if ([code isEqualToString:@"1000"]) {
                [ToolClass showAlertWithMessage:msg];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToolClass showAlertWithMessage:msg];
            }
            
        } fail:^(NSError *error) {
            
        } delegater:self.view];
    }
}

- (void)forgotBtnDidClickEvent:(UIButton *)sender{
    WDGetBackPwdViewController *getBackPwdVC = [[WDGetBackPwdViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:getBackPwdVC];
    [self.navigationController pushViewController:getBackPwdVC animated:YES];
}

#pragma mark --- 约束TextField的输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
   
    if (textField.text.length >= 20) {
        textField.text = [textField.text substringToIndex:20];
    }
 
}
#pragma mark ----- 懒加载

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return _bgView;
}

#pragma mark --- Label
- (UILabel *)oldPwdLabel{
    if (!_oldPwdLabel) {
        _oldPwdLabel = [[UILabel alloc] init];
        _oldPwdLabel.text = @"原密码：";
        _oldPwdLabel.textAlignment = NSTextAlignmentLeft;
        _oldPwdLabel.font = kFont15;
        _oldPwdLabel.textColor = WDColorFrom16RGB(0x666666);
    }
    return _oldPwdLabel;
}
- (UILabel *)nowPwdLabel{
    if (!_nowPwdLabel) {
        _nowPwdLabel = [[UILabel alloc] init];
        _nowPwdLabel.text = @"新密码：";
        _nowPwdLabel.textAlignment = NSTextAlignmentLeft;
        _nowPwdLabel.font = kFont15;
        _nowPwdLabel.textColor = WDColorFrom16RGB(0x666666);
        
    }
    return _nowPwdLabel;
}
- (UILabel *)surePwdLabel{
    if (!_surePwdLabel) {
        _surePwdLabel = [[UILabel alloc] init];
        _surePwdLabel.text = @"再次输入：";
        _surePwdLabel.textAlignment = NSTextAlignmentLeft;
        _surePwdLabel.font = kFont15;
        _surePwdLabel.textColor = WDColorFrom16RGB(0x666666);
    }
    return _surePwdLabel;
}
#pragma mark --- 分割线
- (UILabel *)oldPwdLine{
    if (!_oldPwdLine) {
        _oldPwdLine = [[UILabel alloc] init];
        _oldPwdLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _oldPwdLine;
}
- (UILabel *)nowPwdLine{
    if (!_nowPwdLine) {
        _nowPwdLine = [[UILabel alloc] init];
        _nowPwdLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _nowPwdLine;
}

- (WDTextField *)oldTextField{
    if (!_oldTextField) {
        _oldTextField = [[WDTextField alloc] init];
        _oldTextField.placeholder = @"请输入您的原始密码";
        [_oldTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_oldTextField setSecureTextEntry:YES];
    }
    return _oldTextField;
}
- (WDTextField *)nowTextField{
    if (!_nowTextField) {
        _nowTextField = [[WDTextField alloc] init];
        _nowTextField.placeholder = @"6~20位字母与数字结合";
        [_nowTextField setSecureTextEntry:YES];
        [_nowTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nowTextField;
}
- (WDTextField *)sureTextField{
    if (!_sureTextField) {
        _sureTextField = [[WDTextField alloc] init];
        _sureTextField.placeholder = @"确认新密码";
        [_sureTextField setSecureTextEntry:YES];
        [_sureTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _sureTextField;
}
- (UIButton *)forgotPwd{
    if (!_forgotPwd) {
        _forgotPwd = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgotPwd setTitle:@"忘记原密码？" forState:UIControlStateNormal];
        [_forgotPwd setTitleColor:WDColorFrom16RGB(0x999999) forState:UIControlStateNormal];
        _forgotPwd.titleLabel.textAlignment = NSTextAlignmentRight;
        _forgotPwd.titleLabel.font = kFont16;
        [_forgotPwd addTarget:self action:@selector(forgotBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPwd;
}
- (WDSubmitButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submintBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


@end
