



//
//  WDModifyNickNameViewController.m
//  5dou
//
//  Created by rdyx on 16/9/2.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDModifyNickNameViewController.h"
#import "ToolClass.h"
#import "WDUserInfoModel.h"
@interface WDModifyNickNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;



@end

@implementation WDModifyNickNameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"修改昵称" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.view.backgroundColor = kBackgroundColor;
    [self setupTextFiled];
    [self makeConfirmBtn];
    _nameTextField.text = self.nickName;
}


-(void)setupTextFiled
{
    [ToolClass setView:self.nameTextField withRadius:4.f andBorderWidth:1.0f andBorderColor:kWhiteColor];
}

-(void)makeConfirmBtn
{
    self.confirmBtn.backgroundColor = kNavigationBarColor;
    [ToolClass setView:self.confirmBtn withRadius:5.f andBorderWidth:0.5 andBorderColor:kNavigationBarColor];
    [self.confirmBtn setTitleColor:WDColorFrom16RGB(0x8b572a) forState:UIControlStateNormal];
    
}

- (IBAction)pressConfirmBtn:(UIButton *)sender {
    
    if (self.nameTextField.text.length==0) {
        
        [ToolClass showAlertWithMessage:@"请正确填写昵称"];
        return;
        
    }
    
    if (self.nameTextField.text.length > 10) {
        [ToolClass showAlertWithMessage:@"昵称不能超过10个字"];
        return;
    }
    
    WeakStament(wself);
    NSDictionary *para = @{@"nickName":self.nameTextField.text,@"updateType":@1};
    [WDNetworkClient postRequestWithBaseUrl:kUpdateMemeberInfo setParameters:para success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        NSDictionary *result = responseObject[@"result"];
        if ([result[@"code"] isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:@"修改成功"];
            [WDUserInfoModel shareInstance].nickName = self.nameTextField.text;
            [wself.navigationController popViewControllerAnimated:YES];
        }else{
            
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:self.view];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
@end
