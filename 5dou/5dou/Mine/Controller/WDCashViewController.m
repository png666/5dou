



//
//  WDCashViewController.m
//  5dou
//
//  Created by rdyx on 16/9/26.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDCashViewController.h"
#import "ToolClass.h"
#import "WDUserInfoModel.h"
#import "WDModifyAliPayViewController.h"
#import "WDDoubiViewController.h"
#import "UIControl+recurClick.h"
#import "WDModifyAliPayViewController.h"
@interface WDCashViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstDouBiLabel;


@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubiLabel;
@property (weak, nonatomic) IBOutlet UILabel *tixianjineLabel;
@property (weak, nonatomic) IBOutlet UIButton *tixianBtn;

@property (weak, nonatomic) IBOutlet UILabel *feeCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;

@property (weak, nonatomic) IBOutlet UIView *alipayBgView;
@property (weak, nonatomic) IBOutlet UILabel *modifyAlipayLabel;

@property (weak, nonatomic) IBOutlet UITextField *cashTF;

@property (weak, nonatomic) IBOutlet UILabel *aliPayAccountLabel;

@property (weak, nonatomic) IBOutlet UILabel *weixinOrAliLabel;

@property(nonatomic,strong)UIView *line;

@end

@implementation WDCashViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tixianBtn.backgroundColor = [kMainColor colorWithAlphaComponent:0.3];
    if ([WDUserInfoModel shareInstance].weixinFlag==true) {
        
        self.weixinOrAliLabel.text = @"提现到微信钱包";
//        self.weixinOrAliLabel.font = kFont14;
        self.modifyAlipayLabel.hidden = YES;
//        self.aliPayAccountLabel.text = [WDUserInfoModel shareInstance].nickName;
        self.aliPayAccountLabel.hidden = YES;
        
    }else{
        
        self.weixinOrAliLabel.text = @"支付宝账户";
        self.weixinOrAliLabel.font = kFont14;
        self.modifyAlipayLabel.hidden = false;
//        NSString *ali = [WDUserInfoModel shareInstance].alipayAccount;
//        if (ali) {
//            
//            self.aliPayAccountLabel.text = ali;
//        }
        if (self.aliPayAccountLabel.text) {
            self.aliPayAccountLabel.text = @"";
        }
        [self getAlipayAccout];

    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"提现" textColor:kNavigationTitleColor fontSize:19 itemType:center];
//    self.alipayBgView.backgroundColor = kMainColor;
    self.tixianBtn.backgroundColor = kNavigationBarColor;
    //限制重复点击
    self.tixianBtn.uxy_acceptEventInterval = 3;//3S内禁止点击
    self.tixianBtn.backgroundColor = kLightGrayColor;
    self.tixianBtn.enabled = false;
    [self.tixianBtn setTitleColor:KCoffeeColor forState:UIControlStateNormal];
    [ToolClass setView:self.tixianBtn withRadius:4.f andBorderWidth:0 andBorderColor:kClearColor];
    self.countLabel.textColor = kBlackColor;
//    self.doubiLabel.textColor = kMainColor;

    self.cashTF.delegate = self;
   
    
    //实时监听时添加的UIControlEventEditingChanged
    [self.cashTF addTarget:self action:@selector(cashTFChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modifyAction:)];
    [self.modifyAlipayLabel addGestureRecognizer: tap];
    
    UIView *line = [[UIView alloc]init];
    self.line = line;
    line.backgroundColor = WDColorRGB(221.f, 221.f, 221.f);
    [self.view addSubview:line];
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
    
}

//获取支付宝帐号
-(void)getAlipayAccout
{
    [WDNetworkClient postRequestWithBaseUrl:kGetUserInfoUrl setParameters:nil success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        if (responseObject) {
            NSDictionary *result = responseObject[@"result"];
            if ([result[@"code"]isEqualToString:@"1000"]) {
                
                NSDictionary  *dataDic = responseObject[@"data"];
                
                self.aliPayAccountLabel.text = dataDic[@"memberAccount"][@"alipayAccount"];
                
            }
        }
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:self.view];
    
}

-(void)modifyAction:(UITapGestureRecognizer *)tap
{
    YYLog(@"jkjkjj");
    WDModifyAliPayViewController *modify = [WDModifyAliPayViewController new];
    [self.navigationController pushViewController:modify animated:true];
}
/**
 实时监听

 @param textField
 */
-(void)cashTFChanged:(UITextField *)textField
{
    //限定两位小数
    BOOL isValidate = [ToolClass validateTwoDots:textField.text];
    if (isValidate) {
        
    }else
    {
        if (textField.text.length>4) {
            if ([textField.text isEqualToString:@"."]) {
                return;
            }
        self.cashTF.text = [textField.text substringWithRange:NSMakeRange(0, 4)];
        }
    }
    //按钮置灰
    if (textField.text.length>0) {
        self.tixianBtn.enabled = YES;
        self.tixianBtn.backgroundColor = kMainColor;
    }
    else
    {
        self.tixianBtn.enabled = false;
        self.tixianBtn.backgroundColor = [kMainColor colorWithAlphaComponent:0.3];
    }
    if ([textField.text integerValue]>[self.countLabel.text integerValue]) {
        
        [ToolClass showAlertWithMessage:@"提现金额不能超过账户余额"];
        self.serviceFeeLabel.text = @"手续费0逗币";
        self.cashTF.text = @"";
        return;
    }

    if ([textField.text integerValue]>1000) {
        [ToolClass showAlertWithMessage:@"提现金额不能超过1000"];
        textField.text = @"";
        self.tixianBtn.backgroundColor = [kMainColor colorWithAlphaComponent:0.3];;
        self.tixianBtn.enabled = false;
        return;
    }

    NSInteger fee;
    if ([textField.text integerValue]>=20||textField.text.length==0) {
        fee = 0;
        self.serviceFeeLabel.text = [NSString stringWithFormat:@"手续费%ld逗币",fee];
    }else{
        fee = 1;
        self.serviceFeeLabel.text = [NSString stringWithFormat:@"手续费%ld逗币",fee];;
    }
    
//    NSInteger feecount = [[NSString stringWithFormat:@"%.2f",[self.feeCountLabel.text floatValue]] floatValue];
//    CGFloat cashCount = [[NSString stringWithFormat:@"%.2f",[self.cashTF.text floatValue]] floatValue];
//    CGFloat sum = feecount+cashCount;
//    self.sumCountLabel.text = [NSString stringWithFormat:@"%.2f逗币",sum];

}


/**
 判断是那个页面过来的，从而是否弹出支付宝绑定界面
 */
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [WDUserInfoModel shareInstance].isCashVC = false;
    [WDUserInfoModel shareInstance].weixinFlag = false;
    [WDUserInfoModel shareInstance].aliFlag = false;

}

-(void)loadData
{
    //获取当前可用余额
    [WDNetworkClient postRequestWithBaseUrl:kMyDoubiUrl setParameters:nil success:^(id responseObject) {
        
        YYLog(@"%@",responseObject);
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            
           NSDictionary *data =  responseObject[@"data"];
            NSString *temp = [data[@"walletAmount"] stringValue];
            NSString *wallet;
            if (temp.length>=6) {
               wallet =  [temp substringWithRange:NSMakeRange(0, 6)];
            }
            
            if (temp.length==7) {
                wallet =  [temp substringWithRange:NSMakeRange(0, 7)];
            }else
            {
                wallet  = temp;
            }
            self.countLabel.text = [NSString stringWithFormat:@"%@ 逗币",wallet];
            }
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:self.view];
    
}

-(void)ModifyActivity
{
    WDModifyAliPayViewController *ali = [[WDModifyAliPayViewController alloc]init];
    [self.navigationController pushViewController:ali animated:YES];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (ScreenWidth<375) {
        self.feeCountLabel.frame = CGRectMake(165, 196, 65, 21);
        
    }
    
    self.countLabel.centerX = self.view.centerX;
    self.doubiLabel.frame = CGRectMake(self.countLabel.right, self.countLabel.frame.origin.y, 40, 20);
    self.line.frame = CGRectMake(10, 126, ScreenWidth-20, 0.5);
}

//判断转移至实时监控方法
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text integerValue]>[self.countLabel.text integerValue]) {
        
        [ToolClass showAlertWithMessage:@"提现金额不能超过账户余额"];
//        self.sumCountLabel.text = @"0.00逗币";
        self.feeCountLabel.text = @"0.00逗币";
        self.cashTF.text = @"";
        return;
    }
}
//重写父类方法执行新的动作
-(void)backItemClick
{
    
    NSArray * ctrlArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:ctrlArray[1] animated:YES];
    
}
#pragma mark - 提现
- (IBAction)tixianAction:(UIButton *)sender {

    if (self.cashTF.text.length==0||[self.cashTF.text isEqualToString:@"0"]) {
        [ToolClass showAlertWithMessage:@"请输入正确的提现金额"];
        return;
    }
   BOOL isWeixin =  [WDUserInfoModel shareInstance].weixinFlag;
    NSDictionary *para = @{@"amount":self.cashTF.text,@"counterFee":@1,@"tradeWay":isWeixin?@2:@1};
    [WDNetworkClient postRequestWithBaseUrl:kCashUrl setParameters:para success:^(id responseObject) {
        
        YYLog(@"%@",responseObject);
        if (responseObject) {
            
            if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
                
                [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
                WeakStament(wself);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                [self.navigationController popToViewController:wself.navigationController.viewControllers[1] animated:YES];
                    
                });
                
            }else if ([responseObject[@"result"][@"code"] isEqualToString:@"1014"])
            {
                [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
                return ;
            }
        }
        
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:self.view];
}


@end
