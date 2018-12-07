//
//  WDOrderDetailViewController.m
//  5dou
//
//  Created by ChunXin Zhou on 2016/12/15.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDOnlinePayViewController.h"
#import "UITableViewCell+Ext.h"
#import "WDPayCell.h"
#import "WDPayModel.h"
#import "WDFlowOrderModel.h"
#import "ToolClass.h"
#import "WDPayResultController.h"
#import "WDRecordViewController.h"
#import <AlipaySDK/AlipaySDK.h>


@interface WDOnlinePayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@property (nonatomic,strong) NSMutableArray *payTypeArray;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *deductionDoubi;


@end

@implementation WDOnlinePayViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(succeedAction) name:kAlipaySucceedInfo object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"在线支付" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    
//    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 35, 35) title:@"账单" Image:nil  selectedIMG:nil tartget:self action:@selector(goToRecord)];
    _payButton.layer.cornerRadius = 3.0f;
    _payButton.clipsToBounds = YES;
    //[self prepareData];
    
    self.orderName.text = _orderModel.data.orderName;
    self.orderNumber.text = _orderModel.data.orderNo;
    self.orderMoney.text = [NSString stringWithFormat:@"￥%.2f",[_orderModel.data.payAmount floatValue]];
    self.deductionDoubi.text = [NSString stringWithFormat:@"%.2f逗币",[self.deductionMoney floatValue]];
    
    // Do any additional setup after loading the view from its nib.
    
}
//支付成功跳转到成功页面
-(void)succeedAction
{
    //支付成功
    WDPayResultController *resultController = [[WDPayResultController alloc] init];
    resultController.isSuccess = NO;
    //                9000 订单支付成功
    //                8000 正在处理中
    //                4000 订单支付失败
    //                6001 用户中途取消
    //                6002 网络连接出错
  
        resultController.isSuccess = YES;
        resultController.telephoneStr = self.telephoneStr;
        resultController.selectedFlow = self.selectedFlow;
        CGFloat pay = [self.orderModel.data.payAmount floatValue] + [self.deductionMoney floatValue];
        resultController.money =  pay;
    
    [self.navigationController pushViewController:resultController animated:YES];

}

- (void)goToRecord{
    WDRecordViewController *recordViewController = [[WDRecordViewController alloc] init];
    [self.navigationController pushViewController:recordViewController animated:YES];
}

//- (void)prepareData{
//    _payTypeArray = [NSMutableArray arrayWithCapacity:0];
//    WeakStament(weakSelf);
//    [WDNetworkClient postRequestWithBaseUrl:kFlowPayType setParameters:nil success:^(id responseObject) {
//        if ([responseObject[@"result"][@"code"] intValue] == 1000) {
//            YYLog(@"success");
//            for (NSDictionary *payDic in responseObject[@"data"]) {
//                WDPayModel *model = [[WDPayModel alloc] init];
//                [model setValuesForKeysWithDictionary:payDic];
//                [weakSelf.payTypeArray addObject:model];
//            }
//            //默认初始化第一个
//            ((WDPayModel *)[weakSelf.payTypeArray firstObject]).select = YES;
//            [weakSelf.payTypeTableView reloadData];
//        }
//        YYLog(@"responseObject = %@",responseObject);
//    } fail:^(NSError *error) {
//        
//    } delegater:self.view];
//   
//}

//#pragma mark UITableViewDelegate,UITableViewDataSource
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 57.0f;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WDPayCell *payCell = [WDPayCell cellWithTableView:tableView];
//    if (indexPath.row < _payTypeArray.count) {
//        payCell.payModel = _payTypeArray[indexPath.row];
//    }
//    return payCell;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _payTypeArray.count;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //修改
//    for (int index = 0; index < _payTypeArray.count ; index++) {
//        if (indexPath.row == index) {
//              ((WDPayModel *)[self.payTypeArray objectAtIndex:index]).select = YES;
//        }else{
//               ((WDPayModel *)[self.payTypeArray objectAtIndex:index]).select = NO;
//        }
//        [self.payTypeTableView reloadData];
//    }
//}

- (IBAction)payButtonClick:(id)sender {
    //进行修改
    NSDictionary *param = @{@"orderNum":_orderModel.data.orderNo};
    [WDNetworkClient postRequestWithBaseUrl:kFlowOrderPay setParameters:param success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] intValue] == 1000) {
//            [PayModel aliPay:responseObject[@"data"][@"payInfo"] finishBlock:^(NSDictionary *resultDic) {
//                YYLog(@"resultDic = %@",resultDic);
//            }];//CZ1701171649519850
            
            [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"payInfo"] fromScheme:@"wudou" callback:^(NSDictionary *resultDic) {
                //支付成功
                //APP 这里不走，但是web就走这个方法，很奇怪
                WDPayResultController *resultController = [[WDPayResultController alloc] init];
                resultController.isSuccess = NO;
//                9000 订单支付成功
//                8000 正在处理中
//                4000 订单支付失败
//                6001 用户中途取消
//                6002 网络连接出错
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    resultController.isSuccess = YES;
                    resultController.telephoneStr = self.telephoneStr;
                    resultController.selectedFlow = self.selectedFlow;
                    CGFloat pay = [self.orderModel.data.payAmount floatValue] + [self.deductionMoney floatValue];
                    resultController.money =  pay;
                }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
                   resultController.errorStr = @"失败原因:订单取消";
                }else if([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
                    resultController.errorStr = @"失败原因:网络异常";
                }else if([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
                   resultController.errorStr = @"失败原因:订单支付失败";
                }
                
                [self.navigationController pushViewController:resultController animated:YES];
                YYLog(@"resultDic = %@",resultDic);
            }];
        }else {
            [ToolClass showAlertWithMessage:@"订单生成失败，请从新选择～"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
