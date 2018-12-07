//
//  WDOrderDetailViewController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDOrderDetailViewController.h"
#import "WDFlowOrderListModel.h"
#import "ToolClass.h"
#import "CKAlertViewController.h"
#import "WDOnlinePayViewController.h"
#import "WDFlowOrderModel.h"
@interface WDOrderDetailViewController()

@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTypeHeight;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *payTypeView;

@end

@implementation WDOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    [self.navigationItem setItemWithTitle:@"订单详情" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    
    _cancelButton.layer.cornerRadius = 3;
    _cancelButton.clipsToBounds = YES;
    _submitButton.layer.cornerRadius = 3;
    _submitButton.clipsToBounds = YES;
    
    
    _orderMoneyLabel.text = _orderModel.sellPrice;
    _orderResultLabel.text = [self getOrderState:_orderModel.state];
    _orderNameLabel.text = _orderModel.name;
    _orderNumLabel.text = _orderModel.orderNo;
    _orderDiscountLabel.text =  [NSString stringWithFormat:@"%@逗币",_orderModel.balanceAmount];
    _orderTimeLabel.text = _orderModel.createTime;
    [self.view layoutIfNeeded];
      // Do any additional setup after loading the vi§ew from its nib.
}


- (NSString *)getOrderState:(NSString *)stateCode{
    _bgView.hidden = YES;
    _lineView.hidden = YES;
    _payTypeHeight.constant = 0;
    _payTypeView.hidden = YES;
    _orderResultLabel.textColor = WDColorFrom16RGB(0x666666);
    if ([stateCode isEqualToString:@"0"]) {
        _bgView.hidden = NO;
        _orderResultLabel.textColor = WDColorFrom16RGB(0xFA7829);
        return @"等待付款";
    }else if ([stateCode isEqualToString:@"1"]){
        return @"待充值";
    }else if ([stateCode isEqualToString:@"2"]){
        _lineView.hidden = NO;
        _payTypeHeight.constant = 48;
        _payTypeView.hidden = NO;
//        return [NSString stringWithFormat:@"充值成功,返还%.2f逗币", [_orderModel.packagePrice floatValue] - [_orderModel.discountPrice floatValue]];
        
        return [NSString stringWithFormat:@"充值成功,返还%@逗币", _orderModel.refundBalance];
    }else if ([stateCode isEqualToString:@"3"]){
        return @"充值失败";
    }else if ([stateCode isEqualToString:@"4"]){
        return @"交易关闭,抵扣逗币已退还";
    }else if ([stateCode isEqualToString:@"5"]){
        return @"用户取消";
    }else{
        return @"";
    }
}

- (IBAction)cancelBtnClick:(id)sender {
    NSDictionary *param = @{@"orderNo":_orderModel.orderNo};
    [WDNetworkClient postRequestWithBaseUrl:kFlowCancel setParameters:param success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"订单取消成功" message:@"抵扣逗币已退还回账户"];
            CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertVC addAction:sure];
            [[ToolClass getCurrentVC] presentViewController:alertVC animated:NO completion:nil];
        }
    } fail:^(NSError *error) {
        YYLog(@"error = %@",error);
    } delegater:self.view];
}

- (IBAction)payBtnClick:(id)sender {
    WDOnlinePayViewController *orderDetailVC = [[WDOnlinePayViewController alloc] init];
    WDFlowOrderModel *flowOrderModel = [WDFlowOrderModel new];
    flowOrderModel.data = [WDFlowOrderDataModel new];
    flowOrderModel.data.orderName = _orderModel.name;
    flowOrderModel.data.payAmount = _orderModel.onlinePayAmount;
    flowOrderModel.data.orderNo = _orderModel.orderNo;
    orderDetailVC.orderModel = flowOrderModel;
    orderDetailVC.telephoneStr = _orderModel.mobile;
    orderDetailVC.selectedFlow = _orderModel.packageSize;
    orderDetailVC.deductionMoney = _orderModel.balanceAmount;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
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
