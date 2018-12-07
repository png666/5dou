
//
//  WDModifyAliPayViewController.m
//  5dou
//
//  Created by rdyx on 16/9/6.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  修改绑定的支付宝账号
//

#import "WDModifyAliPayViewController.h"
#import "WDModifyAlipayView.h"
#import "WDSubmitButton.h"
#import "ToolClass.h"
#import "WDHTTPServer.h"
#import "UIButton+WebCache.h"
#import "WDDefaultAccount.h"

@interface WDModifyAliPayViewController ()

@property (nonatomic, strong) WDModifyAlipayView *modifyAlipayView;///<
@property (nonatomic, strong) UILabel *captchaLine;///<
@property (nonatomic, strong) WDSubmitButton *submitBtn;

@property (nonatomic, strong) NSString *userMobile;///< 用户手机号



@end

@implementation WDModifyAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"修改支付宝账号" textColor : kNavigationTitleColor fontSize:19 itemType:center];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getPicCode];
    self.userMobile = [[WDDefaultAccount getUserInfo] objectForKey:@"mobile"];
    self.modifyAlipayView.phoneTextField.text = self.userMobile;
    
}

- (void)initUI{
    [self.view addSubview:self.modifyAlipayView];
    [self.modifyAlipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10.f);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(277.f);
        
    }];
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10.f);
        make.left.mas_equalTo(self.view.mas_left).offset(10.f);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(self.modifyAlipayView.mas_bottom).offset(49.f);
    }];
}
//获取图片验证码
- (void)getPicCode{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *url = [NSString stringWithFormat:@"%@%@?_t=%@",HTTP_BASE,kCheckCodeUrl,[ToolClass getIDFA]];
    [self.modifyAlipayView.verifyBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"null_default"]];
   
}

#pragma mark --- 点击事件
- (void)submitBtnDidClickEvent:(UIButton *)sender{
    if ([self isEmpty]) {
        if ([ToolClass validateMail:self.modifyAlipayView.alipayTextField.text]||
              [ToolClass validateMobile:self.modifyAlipayView.alipayTextField.text]) {
            //修改支付宝账号操作
            [self changeAlipayAccount];
        }else{
            [ToolClass showAlertWithMessage:@"您输入的支付宝账号不合法"];
        }
    }
}
#pragma mark ==== 判断输入框是不是空
- (BOOL)isEmpty{
    if ([self.modifyAlipayView.phoneTextField hasText]) {
        if ([self.modifyAlipayView.verifyTextField hasText]) {
            if ([self.modifyAlipayView.captchaTextField hasText]) {
                if ([self.modifyAlipayView.nameTextField hasText]) {
                    if ([self.modifyAlipayView.alipayTextField hasText]) {
                        if (self.modifyAlipayView.nameTextField.text.length<=10) {
                            return YES;
                        }else{
                            [ToolClass showAlertWithMessage:@"姓名长度大于10位"];
                            return NO;
                        }
                    }else{
                        [ToolClass showAlertWithMessage:@"支付宝账号不能为空"];
                        return NO;
                    }
                }else{
                    [ToolClass showAlertWithMessage:@"姓名不能为空"];
                    return NO;
                }
            }else{
                [ToolClass showAlertWithMessage:@"短信验证码不能为空"];
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
//修改支付宝账号
- (void)changeAlipayAccount{
    NSDictionary *dic = @{@"mobile":self.modifyAlipayView.phoneTextField.text,
                          @"smsType":@"6",
                          @"checkCode":self.modifyAlipayView.verifyTextField.text,
                          @"captcha":self.modifyAlipayView.captchaTextField.text,
                          @"t":[ToolClass getIDFA]
                          };
    [WDNetworkClient postRequestWithBaseUrl:kValidateCaptchaUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            /// 验证码正确，保存用户信息
            [self updataAlipayAccount];
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)updataAlipayAccount{
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"name":self.modifyAlipayView.nameTextField.text,
                          @"mi":mi,
                          @"alipayAccount":self.modifyAlipayView.alipayTextField.text,
                          @"type":@"1",
                          @"captcha":self.modifyAlipayView.captchaTextField.text
                          };
    [WDNetworkClient postRequestWithBaseUrl:kSaveMemberAccountUrl setParameters:dic success:^(id responseObject) {
        NSString *code = [[responseObject objectForKey:@"result"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"result"] objectForKey:@"msg"];
        if ([code isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"恭喜您修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ---- 懒加载

- (WDModifyAlipayView *)modifyAlipayView{
    if (!_modifyAlipayView) {
        _modifyAlipayView = [[WDModifyAlipayView alloc] initWithSMSType:@"6"];
    }
    return _modifyAlipayView;
}
- (WDSubmitButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [WDSubmitButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnDidClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


@end
