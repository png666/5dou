//
//  WDSetNewPwdView.m
//  5dou
//
//  Created by 黄新 on 16/9/14.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  设置新密码View
//

#import "WDSetNewPwdView.h"
#import "ToolClass.h"

@interface WDSetNewPwdView ()<UITextFieldDelegate>



@end

@implementation WDSetNewPwdView

- (instancetype)init{
    if (self = [super init]) {
        [self initUI];
        self.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return self;
}
- (void)initUI{
    ///密码
    [self addSubview:self.firstPwdImg];
    [self.firstPwdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10.f);
        make.width.mas_equalTo(22.f);
        make.height.mas_equalTo(22.f);
        make.top.mas_equalTo(self.mas_top).offset(15.f);
    }];
    [self addSubview:self.firstTextField];
    [self.firstTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstPwdImg.mas_right).offset(8.f);
        make.right.mas_equalTo(self.mas_right).offset(-20.f);
        make.height.mas_equalTo(30.f);
        make.top.mas_equalTo(self.mas_top).offset(12.f);
    }];
//    self.firstTextField.backgroundColor = [UIColor redColor];
    [self addSubview:self.lineLabel];
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(self.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.mas_left).offset(10.f);
        make.top.mas_equalTo(self.firstPwdImg.mas_bottom).offset(16.f);
    }];
    /// 确认密码
    [self addSubview:self.secondPwdImg];
    [self.secondPwdImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.firstPwdImg);
        make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(15.f);
    }];
    [self addSubview:self.secondTextField];
    [self.secondTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.firstTextField);
        make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(12.f);
    }];
}
#pragma mark --- TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.firstTextField) {
        if ([ToolClass judgePassWord:self.firstTextField.text]) {
            [ToolClass showAlertWithMessage:@"密码为数字和字母"];
            return;
        }
    }
}
#pragma mark --- 约束TextField的输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.firstTextField || textField == self.secondTextField) {
        if (textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}

- (UIImageView *)firstPwdImg{
    if (!_firstPwdImg) {
        _firstPwdImg = [[UIImageView alloc] init];
        _firstPwdImg.image = [UIImage imageNamed:@"register_lock"];
    }
    return _firstPwdImg;
}
- (UIImageView *)secondPwdImg{
    if (!_secondPwdImg) {
        _secondPwdImg = [[UIImageView alloc] init];
        _secondPwdImg.image = [UIImage imageNamed:@"register_lock"];
    }
    return _secondPwdImg;
}
- (UITextField *)firstTextField{
    if (!_firstTextField) {
        _firstTextField = [[WDTextField alloc] init];
        _firstTextField.placeholder = @"请输入密码";
        [_firstTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_firstTextField setSecureTextEntry:YES];
    }
    return _firstTextField;
}
- (UITextField *)secondTextField{
    if (!_secondTextField) {
        _secondTextField = [[WDTextField alloc] init];
        _secondTextField.placeholder = @"请再次输入密码";
        [_secondTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_secondTextField setSecureTextEntry:YES];
    }
    return _secondTextField;
}
- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    
    return _lineLabel;
}

@end
