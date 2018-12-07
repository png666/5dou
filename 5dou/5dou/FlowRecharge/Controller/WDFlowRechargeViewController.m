//
//  WDFlowRechargeViewController.m
//  5dou
//
//  Created by 黄新 on 16/12/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  流量充值
//

#import "WDFlowRechargeViewController.h"
#import "WDRecordViewController.h"
#import "WDDoubiView.h"
#import "WDFlowCollectionView.h"
#import "WDNetworkClient.h"
#import "WDFlowPackageModel.h"
#import "WDDefaultAccount.h"
#import "ToolClass.h"
#import "WDBuyCell.h"
#import "ContactsManager.h"
#import "CKAlertViewController.h"
#import "WDOnlinePayViewController.h"
#import "WDFlowOrderModel.h"
#import "WDBuyCell.h"
#import "CKAlertViewController.h"
#import "WDPayResultController.h"
#import "UIButton+EnlargeTouchArea.h"
#import "WDNoneData.h"


@interface WDFlowRechargeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) WDDoubiView *doubiView; ///<  当前剩余逗币
@property (nonatomic, strong) UILabel *operationType;///< 手机运营商
@property (nonatomic, strong) WDFlowCollectionView *flowCollectionView;///< 流量包
@property (nonatomic, strong) WDFlowPackageModel *packageModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contactBgView;///<
@property (nonatomic, strong) UITextField *mobileTextField;///< 手机号
@property (nonatomic, strong) UIButton *contactBtn;///< 获取联系人
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) NSString *selectedFlow; ///< 选中的流量包

@property (nonatomic, strong) WDNoneData *noDataView;///< 请求无数据时呈现的View

@property (nonatomic, assign) CGFloat bgViewH;

@end

@implementation WDFlowRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"流量充值" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 20, 20) title:nil Image:@"record_icon" selectedIMG:nil tartget:self action:@selector(rechargeRecordAction:)];
    [self initUI];
//    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
//    [self.flowCollectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
}
- (void)viewWillAppear:(BOOL)animated{
    NSString *mobile = [[WDDefaultAccount getUserInfo] objectForKey:@"mobile"];
    if ([self.mobileTextField hasText] && self.mobileTextField.text.length>=7) {
        mobile = self.mobileTextField.text;
    }
    [self requestDataWithMobile:mobile];
}

- (void)initUI{

    [self.view addSubview:self.bgScrollView];
    //剩余逗币
    [self.bgScrollView addSubview:self.doubiView];
    [self.doubiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.bgScrollView);
        make.height.mas_equalTo(75);
    }];
    [self.bgScrollView addSubview:self.contactBgView];
    [self.contactBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.doubiView);
        make.top.mas_equalTo(self.doubiView.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
    [self.contactBgView addSubview:self.mobileTextField];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
        make.centerY.mas_equalTo(self.contactBgView);
        make.left.mas_equalTo(self.contactBgView.mas_left).offset(15);
    }];
    [self.contactBgView addSubview:self.contactBtn];
    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contactBgView.mas_right).offset(-20);
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self.contactBgView);
    }];
    //增加button的可点击区域
    [self.contactBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    //运营商类型
    [self.bgScrollView addSubview:self.operationType];
    [self.operationType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(70);
        make.height.mas_offset(15);
        make.top.mas_equalTo(self.contactBgView.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(13);
    }];
    [self.bgScrollView addSubview:self.flowCollectionView];
    [self.flowCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.operationType.mas_bottom).offset(10);
        make.height.mas_equalTo(200);
        make.left.width.mas_equalTo(self.doubiView);
    }];
    [self.bgScrollView addSubview:self.tableView];
    //展示无数据时候的View
    [self.view addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contactBgView.mas_bottom);
        make.right.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

}

- (void)configValues:(WDFlowPackageModel *)model{
    WeakStament(wself);

    [self.doubiView config:model];
    self.operationType.text = [self getOperationType:model];
    CGFloat flowCollectionViewH = ((model.data.flowList.count-1)/3+1)*((ScreenWidth-60)/6.0+10);
    //重新布局计算高度
    [self.flowCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.operationType.mas_bottom).offset(10);
        make.height.mas_equalTo(flowCollectionViewH);
        make.left.width.mas_equalTo(self.view);
    }];
    [self.flowCollectionView reloadData];
    //默认选中第一个
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.flowCollectionView configValue:model.data];
    [self.flowCollectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    //根据选择的流量套餐 来计算要要显示的本地和全国流量
    self.flowCollectionView.setBuyViewBlock = ^(WDFlowListModel *flowListModel){
        wself.selectedFlow = flowListModel.flow;
        WDFlowListModel *listModel = flowListModel;
        CGFloat flowBuyViewH = 0;
        if (listModel.localKey == nil && listModel.wholeKey == nil) {
            flowBuyViewH = 0;
            
        }else if (listModel.localKey == nil || listModel.wholeKey == nil){
            flowBuyViewH = 100;
        }else{
            flowBuyViewH = 200;
        }
        CGFloat bgViewH = 180 + 64 + 200 + flowCollectionViewH;
        wself.bgScrollView.contentSize = CGSizeMake(ScreenWidth, bgViewH);
        [wself.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(wself.flowCollectionView.mas_bottom);
            make.height.mas_equalTo(flowBuyViewH);
            make.width.left.mas_equalTo(wself.view);
        }];
        wself.tableArray = [wself getTableDataSource:listModel];
        [wself.tableView reloadData];
    };
}

// 获得流量类型
- (NSMutableArray *)getTableDataSource:(WDFlowListModel *)model{
    NSMutableArray *array = [NSMutableArray array];
    if (!(model.localKey == nil || [model.localKey isKindOfClass:[NSNull class]])) {
        [array addObject:model.localKey];
    }
    if (!(model.wholeKey == nil || [model.wholeKey isKindOfClass:[NSNull class]])){
        WDFlowLocalKeyModel *localModel = (id)model.wholeKey;
        [array addObject:localModel];
    }
    return array;
}
//获取运营商种类
- (NSString *)getOperationType:(WDFlowPackageModel *)model{
    if ([model.data.operator isEqualToString:@"1"]) {
        return @"中国移动";
    }else if ([model.data.operator isEqualToString:@"2"]){
        return @"中国联通";
    }else if ([model.data.operator isEqualToString:@"3"]){
        return @"中国电信";
    }
    return nil;
}
#pragma mark ======== 获取流量充值套餐
- (void)requestDataWithMobile:(NSString *)mobile{
    WeakStament(wself);
    NSDictionary *param = @{@"mobile":mobile};
    [WDNetworkClient postRequestWithBaseUrl:kFlowPackageList setParameters:param success:^(id responseObject) {
        WDFlowPackageModel *model = [[WDFlowPackageModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1000"]) {
            wself.packageModel = model;
            [wself configValues:model];
        }else{
            [ToolClass showAlertWithMessage:responseObject[@"result"][@"msg"]];
        }
        //显示或隐藏无数据时的View
        if (model.data.flowList.count>0) {
            self.noDataView.hidden = YES;
        }else{
            self.noDataView.hidden = NO;
        }
        
    } fail:^(NSError *error) {
        self.noDataView.hidden = NO;
        [ToolClass showAlertWithMessage:@"网路请求失败"];
    } delegater:self.view];
}

#pragma mark ======== 跳转到充值记录页面
- (void)rechargeRecordAction:(UIButton *)sender{
    WDRecordViewController *recordVC = [[WDRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}
#pragma mark -UITextFiledDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    //输入电话的长度为7位时自动请求数据
    if (textField.text.length == 7) {
        [self requestDataWithMobile:textField.text];
//        if ([ToolClass validateMobile:textField.text]) {
//            
//        }else{
//            [ToolClass showAlertWithMessage:@"输入的手机号有错"];
//        }
    }
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    YYLog(@"长度---------%ld",textField.text.length);
}
#pragma mark ====== 获取手机联系人
- (void)contactBtnDidClick:(UIButton *)sender{
    WeakStament(wself);
    [[ContactsManager sharedInstace] checkAddressBookAuthorization:^(NSInteger authorizationStatus) {
        if (authorizationStatus == 3) {
            // 已授权
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ContactsManager sharedInstace] openContactsFromViewController:wself successBlock:^(WDContactsInfo *info) {
                    YYLog(@"name is %@,phone is %@",info.contactName,info.contactPhoneNumber);
                    wself.mobileTextField.text = info.contactPhoneNumber;
                    [wself requestDataWithMobile:wself.mobileTextField.text];
                }];
            });
        }else {
            // 授权失败
            NSString *msg = [NSString stringWithFormat:@"%@无法访问您的通讯录。请在系统设置 - 隐私 - 通讯录里允许%@访问您的通讯录",app_Name,app_Name];
            dispatch_async(dispatch_get_main_queue(), ^{
                CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:msg];
                CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertVC addAction:cancel];
                [alertVC addAction:sure];
                [self presentViewController:alertVC animated:NO completion:nil];
            });
        }
    }];
}
#pragma mark ==== 购买流量
//最后支付的价格+折扣价=原价(price)
- (void)submitFlowOrder:(UIButton *)sender Model:(WDFlowWholeKeyModel *)model DiscountBtnSelected:(BOOL)btnSelected{
    NSString *onlinePayAmount = @"";
    NSString *balanceAmount = @"";
    NSString *mobile = self.mobileTextField.text;
    if (!btnSelected) {
        onlinePayAmount = [NSString stringWithFormat:@"%.2f",[model.sellPrice floatValue]];
        balanceAmount = @"0";
    }else{
        CGFloat payNum = [self.packageModel.data.walletAmount floatValue] - [model.sellPrice floatValue];
        if (payNum >= 0) {
            onlinePayAmount = @"0";
            balanceAmount = [NSString stringWithFormat:@"%.2f",[model.sellPrice floatValue]];
        }else{
            onlinePayAmount = [NSString stringWithFormat:@"%.2f",fabs(payNum)];
            balanceAmount = [NSString stringWithFormat:@"%.2f",[self.packageModel.data.walletAmount floatValue]];
        }
    }
    if (mobile.length != 11) {
        [ToolClass showAlertWithMessage:@"您输入的手机号有误"];
        return;
    }
    NSDictionary *param = @{@"mobile":mobile,
                            @"nameKey":model.nameKey,
                            @"balanceAmount":balanceAmount,
                            @"onlinePayAmount":onlinePayAmount
                            };
    //无需现金支付的时候弹窗
    if ([onlinePayAmount isEqualToString:@"0"]) {
        [self showAlertModel:model Param:param];
    }else{
        [self checkOrderWithModel:model Param:param];
    }
}
#pragma mark ======= 无需支付宝支付的时候-----确认订单
- (void)checkOrderWithModel:(WDFlowWholeKeyModel *)model Param:(NSDictionary *)param{
    WeakStament(wself);
    [WDNetworkClient postRequestWithBaseUrl:kFlowOrderSubmit setParameters:param success:^(id responseObject) {
        WDFlowOrderModel *model = [[WDFlowOrderModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1000"]) {
            WDOnlinePayViewController *orderDetailVC = [[WDOnlinePayViewController alloc] init];
            [wself.navigationController pushViewController:orderDetailVC animated:YES];
            orderDetailVC.orderModel = model;
            orderDetailVC.deductionMoney = [param objectForKey:@"balanceAmount"];
            orderDetailVC.telephoneStr = param[@"mobile"];
            orderDetailVC.selectedFlow = self.selectedFlow;
            //            [ToolClass showAlertWithMessage:model.result.msg];
        }else if([model.result.code isEqualToString:@"1027"]){
            //[ToolClass showAlertWithMessage:model.result.msg];
            WDPayResultController *resultController = [[WDPayResultController alloc] init];
            resultController.isSuccess = YES;
//            resultController.selectedFlow = [NSString stringWithFormat:@"%@M",self.selectedFlow];
            resultController.selectedFlow = self.selectedFlow;
            resultController.money = [param[@"balanceAmount"] floatValue];
            resultController.telephoneStr = param[@"mobile"];
            [self.navigationController pushViewController:resultController animated:YES];
        }else{
            [ToolClass showAlertWithMessage:model.result.msg];
        }
    } fail:^(NSError *error) {
    } delegater:self.view];
}

#pragma mark ======= 无需支付宝支付的时候弹窗
- (void)showAlertModel:(WDFlowWholeKeyModel *)model Param:(NSDictionary *)param{
    WeakStament(wself);
    CKAlertViewController *alertView = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"确定要支付吗"];
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确认" handler:^(CKAlertAction *action) {
        [wself checkOrderWithModel:model Param:param];
    }];
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        
    }];
   
    [alertView addAction:cancel];
    [alertView addAction:sure];
    [self presentViewController:alertView animated:NO completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ====== TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierID = @"buyCellID";
    WDBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (!cell) {
        cell = [[WDBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierID];
    }
    if (self.tableArray.count) {
        WDFlowWholeKeyModel *model = (WDFlowWholeKeyModel *)self.tableArray[indexPath.row];
        NSString *walletAmount = [NSString stringWithFormat:@"%.2f",[self.packageModel.data.walletAmount floatValue]];
        [cell configValuesWith:model WalletAmount:walletAmount IndexPath:indexPath];
    }
    WeakStament(wself);
    //点击购买按钮
    cell.buyBtnDidClickBlock = ^(UIButton *sender, WDFlowWholeKeyModel *model, BOOL discountBtnSelected){
        [wself submitFlowOrder:sender Model:model DiscountBtnSelected:discountBtnSelected];
    };
    //点击逗币抵扣按钮
    cell.reloadPriceCountBlock = ^(UIButton *sender, WDFlowWholeKeyModel *model){
        [wself reloadPriceWithBtn:sender Model:model IndexPath:indexPath];
    };
    return cell;
}
//点击逗币抵扣按钮 刷新流量的购买价格
- (void)reloadPriceWithBtn:(UIButton *)sender Model:(WDFlowWholeKeyModel *)model IndexPath:(NSIndexPath *)indexPath{
    WDBuyCell * cell = (WDBuyCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSString *price = @"";
    NSString *balanceAmount = @"";
    if (sender.selected) {
        if ([self.packageModel.data.walletAmount isEqualToString:@"0"]) {
            price = [NSString stringWithFormat:@"%.2f", [model.sellPrice floatValue]];
            balanceAmount = @"0.00";
        }else{
            if ([self.packageModel.data.walletAmount floatValue] >= [model.sellPrice floatValue]) {
                price = @"0.00";
                balanceAmount = [NSString stringWithFormat:@"%.2f",[model.sellPrice floatValue]];
            }else{
                price = [NSString stringWithFormat:@"%.2f",[model.sellPrice floatValue] - [self.packageModel.data.walletAmount floatValue]];
                balanceAmount = [NSString stringWithFormat:@"%.2f",[self.packageModel.data.walletAmount floatValue]];
            }
        }
    }else{
        price = [NSString stringWithFormat:@"%.2f", [model.sellPrice floatValue]];
        balanceAmount = @"0.00";
    }
    NSString *priceString = [NSString stringWithFormat:@"%@元",price];
    NSMutableAttributedString *priceAttribute = [[NSMutableAttributedString alloc] initWithString:priceString];
    NSRange rang = [priceString rangeOfString:price];
    [priceAttribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINCondensed-Bold" size:24] range:rang];
    [priceAttribute addAttribute:NSForegroundColorAttributeName value:WDColorFrom16RGB(0x8b572a) range:rang];
    cell.priceLabel.attributedText = priceAttribute;
//    cell.discountLabel.text = [NSString stringWithFormat:@"逗币抵扣：%@",balanceAmount];
}

#pragma mark ======== 懒加载

- (WDNoneData *)noDataView{
    if (!_noDataView) {
        _noDataView = [WDNoneData view];
        _noDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _noDataView.hidden = NO;
        WeakStament(weakSelf);
        _noDataView.noneDataBlock = ^(){
            //无数据的时候点击刷新数据
            NSString *mobile = [[WDDefaultAccount getUserInfo] objectForKey:@"mobile"];
            if ([weakSelf.mobileTextField hasText] && self.mobileTextField.text.length>=7) {
                mobile = self.mobileTextField.text;
            }
            [weakSelf requestDataWithMobile:mobile];
        };
    }
    return _noDataView;
}

- (WDDoubiView *)doubiView{
    if (!_doubiView) {
        _doubiView = [[WDDoubiView alloc] init];
    }
    return _doubiView;
}

- (UIView *)contactBgView{
    if (!_contactBgView) {
        _contactBgView = [[UIView alloc] init];
        _contactBgView.backgroundColor = WDColorFrom16RGB(0xffffff);
    }
    return _contactBgView;
}
- (UITextField *)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = [[UITextField alloc] init];
        _mobileTextField.placeholder = @"请输入手机号";
        _mobileTextField.text = [[WDDefaultAccount getUserInfo] objectForKey:@"mobile"];
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_mobileTextField setValue:WDColorFrom16RGB(0xf7e6af) forKeyPath:@"_placeholderLabel.textColor"];
        [_mobileTextField setValue:kFont15 forKeyPath:@"_placeholderLabel.font"];
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileTextField;
}
- (UIButton *)contactBtn{
    if (!_contactBtn) {
        _contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactBtn setBackgroundImage:[UIImage imageNamed:@"contacts_icon"] forState:UIControlStateNormal];
        [_contactBtn addTarget:self action:@selector(contactBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactBtn;
}

- (UILabel *)operationType{
    if (!_operationType) {
        _operationType = [[UILabel alloc] init];
        _operationType.font = kFont13;
        _operationType.textColor = WDColorFrom16RGB(0x666666);
        _operationType.textAlignment = NSTextAlignmentLeft;
//        NSString *mobile = [[WDDefaultAccount getUserInfo] objectForKey:@"mobile"];
//        _operationType.text = [ToolClass mobileOperator:mobile];
    }
    return _operationType;
}

- (WDFlowCollectionView *)flowCollectionView{
    if (!_flowCollectionView) {
        _flowCollectionView = [[WDFlowCollectionView alloc] init];
        _flowCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _flowCollectionView.backgroundColor = WDColorFrom16RGB(0xf4f4f4);

    }
    return _flowCollectionView;
}

//- (WDBuyView *)flowBuyView{
//    if (!_flowBuyView) {
//        _flowBuyView = [[WDBuyView alloc] init];
//        _flowBuyView.backgroundColor = WDColorFrom16RGB(0xf4f4f4);
//        WeakStament(wself);
//        _flowBuyView.buyBtnDidClickBlock = ^(UIButton *sender){
//            ////
//            [wself submitFlowOrder:sender];
//        };
//    }
//    return _flowBuyView;
//}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = WDColorFrom16RGB(0xffffff);
        _tableView.rowHeight = 100;
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgScrollView.backgroundColor = WDColorFrom16RGB(0xf4f4f4);
        [_bgScrollView setScrollEnabled:YES];
        [_bgScrollView setShowsVerticalScrollIndicator:NO];
        [_bgScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    }
    return _bgScrollView;
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
