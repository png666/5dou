//
//  WDBindingAlipayViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/18.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  绑定支付宝账号
//

#import "WDBindingAlipayViewController.h"
#import "WDTextField.h"
#import "WDSubmitButton.h"
#import "ToolClass.h"
#import "WDDefaultAccount.h"
#import "WDUserInfoModel.h"
#import "WDCashViewController.h"
@interface WDBindingAlipayViewController ()

@property (nonatomic, strong) UIView *bgView;///< 背景图片

@property (nonatomic, strong) UIImageView *nameImage;///<
@property (nonatomic, strong) UIImageView *idCardImage;
@property (nonatomic, strong) UIImageView *alipayAccountImage;

@property (nonatomic, strong) WDTextField *nameTextField;
@property (nonatomic, strong) WDTextField *idCardTextField;
@property (nonatomic, strong) WDTextField *alipayTextField;

@property (nonatomic, strong) UILabel *nameSplitLine;
@property (nonatomic, strong) UILabel *idCardSplitLine;

@property (nonatomic, strong) UILabel *attentionLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) WDSubmitButton *submintBtn;

@end

@implementation WDBindingAlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"绑定支付宝账号" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
}
- (void)initUI{
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.height.mas_equalTo(164.f);
        make.top.mas_equalTo(self.view.mas_top).offset(17.f);
    }];
    /// 姓名
    [self.bgView addSubview:self.nameImage];
    [self.nameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(10.f);
        make.width.mas_equalTo(22.f);
        make.height.mas_equalTo(22.f);
        make.top.mas_equalTo(self.bgView).offset(16.f);
    }];
    [self.bgView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameImage.mas_right).offset(10.f);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20.f);
        make.height.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.nameImage);
    }];
//    self.nameTextField.backgroundColor = [UIColor redColor];
    
    [self.bgView addSubview:self.nameSplitLine];
    [self.nameSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.nameImage);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.nameImage.mas_bottom).offset(14.f);
    }];
    /// 身份证
    [self.bgView addSubview:self.idCardImage];
    [self.idCardImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.mas_equalTo(self.nameImage);
        make.top.mas_equalTo(self.nameSplitLine.mas_bottom).offset(16.f);
    }];
    
    [self.bgView addSubview:self.idCardTextField];
    [self.idCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.nameTextField);
        make.centerY.mas_equalTo(self.idCardImage);
    }];
//    self.idCardTextField.backgroundColor = [UIColor redColor];
    [self.bgView addSubview:self.idCardSplitLine];
    [self.idCardSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.bgView.mas_left).offset(10.f);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.idCardImage.mas_bottom).offset(14.f);
    }];
    /// 支付宝账号
    [self.bgView addSubview:self.alipayAccountImage];
    [self.alipayAccountImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.left.mas_equalTo(self.nameImage);
        make.top.mas_equalTo(self.idCardSplitLine.mas_bottom).offset(16.f);
    }];
    [self.bgView addSubview:self.alipayTextField];
    [self.alipayTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.height.mas_equalTo(self.nameTextField);
        make.centerY.mas_equalTo(self.alipayAccountImage);
    }];
//    self.alipayTextField.backgroundColor = [UIColor redColor];
    //温馨提示
    [self.view addSubview:self.attentionLabel];
    [self.attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.height.mas_equalTo(20.f);
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(30.f);
        make.width.mas_equalTo(100.f);
    }];
    [self.view addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.attentionLabel.mas_bottom).offset(16.f);
        make.left.mas_equalTo(self.attentionLabel.mas_left).offset(16.f);
        make.height.mas_equalTo(40.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-20.f);
    }];
    //确认提交
    [self.view addSubview:self.submintBtn];
    [self.submintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(49.f);
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.height.mas_equalTo(44.f);
    }];
    
}

#pragma mark --- 点击事件
- (void)submitBtnDidClickEvent:(UIButton *)sender{
    if ([self isEmpty]) {
        if (self.nameTextField.text.length<=10) {
            if ([ToolClass validateIdCard:self.idCardTextField.text]) {
                if ([ToolClass validateMobile:self.alipayTextField.text]||
                    [ToolClass validateMail:self.alipayTextField.text]) {
                    //绑定支付宝
                    [self bindingAlipayAccount];
                }else{
                    [ToolClass showAlertWithMessage:@"支付宝账号不合法"];
                    return;
                }
            }else{
                [ToolClass showAlertWithMessage:@"身份证账号不合法"];
                return;
            }
        }else{
            [ToolClass showAlertWithMessage:@"姓名长度大于10位"];
            return;
        }
    }
    
    
}
- (BOOL)isEmpty{
    if ([self.nameTextField hasText]) {
        if ([self.idCardTextField hasText]) {
            if ([self.alipayTextField hasText]) {
                return YES;
            }else{
                [ToolClass showAlertWithMessage:@"支付宝账号不能为空"];
                return NO;
            }
        }else{
            [ToolClass showAlertWithMessage:@"身份证号不能为空"];
            return NO;
        }
    }else{
        [ToolClass showAlertWithMessage:@"姓名不能为空"];
        return NO;
    }
}
#pragma mark ======== 网络请求

#pragma mark --- 绑定支付宝账号
- (void)bindingAlipayAccount{
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    if (mi == nil) {
        mi = @"";
    }
    NSDictionary *dic = @{@"name":self.nameTextField.text,
                          @"mi":mi,
                          @"alipayAccount":self.alipayTextField.text,
                          @"idNo":self.idCardTextField.text,
                          @"type":@"0",
                          };
    WeakStament(wself);
    [WDNetworkClient postRequestWithBaseUrl:kSaveMemberAccountUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"恭喜您绑定支付宝成功"];
            [WDUserInfoModel shareInstance].isBindAlipay = YES;
            
            if ([WDUserInfoModel shareInstance].isCashVC) {
                
                WDCashViewController *cash = [[WDCashViewController alloc]init];
                [wself.navigationController pushViewController:cash animated:YES];
                
            }else{
                
                [wself.navigationController popViewControllerAnimated:YES];
                
            }
            
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

#pragma mark --- 约束TextField的输入长度
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.idCardTextField) {
        if (textField.text.length >= 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
    if (textField == self.nameTextField) {
        if (textField.text.length>= 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}
#pragma mark --- 懒加载

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return _bgView;
}

- (UIImageView *)nameImage{
    if (!_nameImage) {
        _nameImage = [[UIImageView alloc] init];
        _nameImage.image = [UIImage imageNamed:@"alipay_realName"];
    }
    return _nameImage;
}
- (UIImageView *)idCardImage{
    if (!_idCardImage) {
        _idCardImage = [[UIImageView alloc] init];
        _idCardImage.image = [UIImage imageNamed:@"alipay_idCard"];
    }
    return _idCardImage;
}
- (UIImageView *)alipayAccountImage{
    if (!_alipayAccountImage) {
        _alipayAccountImage = [[UIImageView alloc] init];
        _alipayAccountImage.image = [UIImage imageNamed:@"alipay_icon"];
    }
    return _alipayAccountImage;
}

- (WDTextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[WDTextField alloc] init];
        _nameTextField.placeholder = @"请输入您的姓名";
        [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTextField;
}
- (WDTextField *)idCardTextField{
    if (!_idCardTextField) {
        _idCardTextField = [[WDTextField alloc] init];
        _idCardTextField.placeholder = @"请输入您的身份证号";
        [_idCardTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _idCardTextField;
}
- (WDTextField *)alipayTextField{
    if (!_alipayTextField) {
        _alipayTextField = [[WDTextField alloc] init];
        _alipayTextField.placeholder = @"请输入要提现的支付宝账号";
    }
    return _alipayTextField;
}

- (UILabel *)nameSplitLine{
    if (!_nameSplitLine) {
        _nameSplitLine = [[UILabel alloc] init];
        _nameSplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _nameSplitLine;
}
- (UILabel *)idCardSplitLine{
    if (!_idCardSplitLine) {
        _idCardSplitLine = [[UILabel alloc] init];
        _idCardSplitLine.backgroundColor = WDColorFrom16RGB(0xdddddd);
    }
    return _idCardSplitLine;
}
- (UILabel *)attentionLabel{
    if (!_attentionLabel) {
        _attentionLabel = [[UILabel alloc] init];
        _attentionLabel.textColor = WDColorFrom16RGB(0x999999);
        _attentionLabel.textAlignment = NSTextAlignmentLeft;
        _attentionLabel.text = @"温馨提示：";
        _attentionLabel.font = kFont14;
    }
    return _attentionLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = WDColorFrom16RGB(0x999999);
        _attentionLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.text = @"请您谨慎填写实名认证资料，以免影响提现打款";
        _contentLabel.numberOfLines = 2;
        _contentLabel.font = [UIFont systemFontOfSize:13.f];
    }
    return _contentLabel;
}
- (WDSubmitButton *)submintBtn{
    if (!_submintBtn) {
        _submintBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_submintBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_submintBtn addTarget:self action:@selector(submitBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submintBtn;
}



@end
