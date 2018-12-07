

//
//  WDDoubiViewController.m
//  5dou
//
//  Created by rdyx on 16/9/4.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDDoubiViewController.h"
#import "WDMyDoubiBarView.h"
#import "WDDoubiRecordView.h"
#import "WDCashViewController.h"
#import "ToolClass.h"
#import "WDNetworkClient.h"
#import "WDUserInfoModel.h"
#import "WDBindingAlipayViewController.h"
#import "WDMessageViewController.h"
#import "WDDoubiBarView.h"
#import "PayWayView.h"
#import "UMCustomManager.h"
//#import "UMSocialWechatHandler.h"
//#import <WXApi.h>
//#import <TencentOpenAPI/QQApiInterface.h>
#import "WDBindingMobileViewController.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "WDBindWeixinViewController.h"

@interface WDDoubiViewController ()<UIScrollViewDelegate,UITableViewDelegate,WDDoubiRecordViewDelegate>
{
    UIView *_movingLine;
    //记录初始化的位置
    NSInteger _index;
    UIView *_bottomLine;
}
@property(nonatomic,strong)UIScrollView *bgScrollView;
@property(nonatomic,strong)WDMyDoubiBarView *allItem;
@property(nonatomic,strong)WDMyDoubiBarView *incomeItem;
@property(nonatomic,strong)WDMyDoubiBarView *cashItem;

@property(nonatomic,strong)WDDoubiRecordView *allTableView;
@property(nonatomic,strong)WDDoubiRecordView *incomeTableView;
@property(nonatomic,strong)WDDoubiRecordView *cashTableView;
@property(nonatomic,strong)UIView *scrollBar;

@property(nonatomic,strong)UILabel *left;
@property(nonatomic,strong)UILabel *mid;
@property(nonatomic,strong)UILabel *right;
@property(nonatomic,strong)PayWayView *payView;
@property(nonatomic,strong)UIView *coverView;

@property(nonatomic,assign)CGFloat tableScrollHeight;
@property(nonatomic,strong)UISegmentedControl *segment;
@property(nonatomic,strong)WDMyDoubiBarView *doubiBarView;

@property(nonatomic,assign)CGFloat scrollBarY;//滚动条Y值

@end

#define barItemNumber 3
#define all    1000
#define income 1001
#define cash   1002

#define lineY 5

@implementation WDDoubiViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [MobClick beginLogPageView:@"我的逗币"];
    if (self.payView) {
        [self.payView removeFromSuperview];
    }
    if (self.coverView) {
        [self.coverView removeFromSuperview];
    }

    _allTableView = [[WDDoubiRecordView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, _tableScrollHeight)];
    _allTableView.delegate = self;
    [_bgScrollView addSubview:_allTableView];
    _segment.selectedSegmentIndex = 0;
    [self loadData];
    [self clearWeixinOrAliFlag];
}

-(void)clearWeixinOrAliFlag
{
    [WDUserInfoModel shareInstance].weixinFlag = false;
    [WDUserInfoModel shareInstance].aliFlag = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"我的逗币" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self makeUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的逗币"];
}

-(void)makeUI
{
    
    [self makeHeaderBar];
    [self makeBgScrollView];
    
    WDDoubiBarView *doubiBar = [[WDDoubiBarView alloc]initWithFrame:CGRectMake(0, 15, ScreenWidth, 60)];
    [self.view addSubview:doubiBar];

    
}
#pragma mark - 分段
-(void)makeSegment
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, ScreenWidth, 50.f)];
    bgView.backgroundColor = kWhiteColor;
    NSArray *titles = @[@"账单明细",@"去提现"];
    _segment = [[UISegmentedControl alloc]initWithItems:titles];
    _segment.frame = CGRectMake(40, 8, ScreenWidth-80, 36);
    _segment.centerX = bgView.centerX;
//    _segment.centerY = bgView.centerY;
    _segment.tintColor = kNavigationBarColor;
    
    //设置segment字体颜色
//    NSDictionary *colorAttr = [NSDictionary dictionaryWithObject:KCoffeeColor forKey:NSForegroundColorAttributeName];
//    NSDictionary *fontAttr = [NSDictionary dictionaryWithObject:kFont14 forKey:NSFontAttributeName];
    NSDictionary *attrDic = @{NSFontAttributeName:kFont14,NSForegroundColorAttributeName:KCoffeeColor};
    [_segment setTitleTextAttributes:attrDic forState:UIControlStateSelected];
    [_segment setTitleTextAttributes:attrDic forState:UIControlStateNormal];
    _segment.selectedSegmentIndex = 0;
    _segment.momentary = NO;
    [_segment addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:_segment];
    [self.view addSubview:bgView];
    
    
}
#pragma mark - WDDoubiRecordViewDelegate
-(void)doubiRecordView:(WDDoubiRecordView *)view atIndexPath:(NSIndexPath *)indexPath
{
    WDMessageViewController *mes = [[WDMessageViewController alloc]init];
    mes.titleString = @"系统消息";
    [self.navigationController pushViewController:mes animated:YES];
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            
            
        }
            break;
        case 1:
        {
            [self show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 显示提现方式
-(void)show
{
    UIView *coverView= [[UIView alloc]initWithFrame:self.view.bounds];
    coverView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.6];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    
    PayWayView *pay = [[[NSBundle mainBundle] loadNibNamed:@"PayWayView" owner:self options:nil]lastObject];
    self.payView = pay;
    pay.frame = CGRectMake(0, 0, 281, 255);
    pay.centerX = self.view.centerX;
    pay.centerY = self.view.centerY-70.f;
    [self.view addSubview:pay];
    WeakStament(ws);
    pay.block = ^(NSInteger index){
        [ws payWayWithIndex:index];
    };
    
}

-(void)payWayWithIndex:(NSInteger)index
{
    switch (index) {
        case 1001:
        {
            YYLog(@"weixin");
             [WDUserInfoModel shareInstance].weixinFlag = true;
            if ([WDUserInfoModel shareInstance].isWeixinAuth==false) {
               
                WDBindWeixinViewController *weixinAuth = [WDBindWeixinViewController new];
                [self.navigationController pushViewController:weixinAuth animated:YES];
                
                
            }else{
                
                WDCashViewController *cashvc = [[WDCashViewController alloc]init];
                cashvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController: cashvc animated:YES];
            }
         }
            break;
        case 1002:
        {
            
            BOOL isBind = [WDUserInfoModel shareInstance].isBindAlipay;
            if (!isBind) {
                [WDUserInfoModel shareInstance].isCashVC = YES;
                WDBindingAlipayViewController *bind = [[WDBindingAlipayViewController alloc]init];
                [self.navigationController pushViewController:bind animated:YES];
            }else{
                 [WDUserInfoModel shareInstance].aliFlag = true;
                WDCashViewController *cashvc = [[WDCashViewController alloc]init];
                cashvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController: cashvc animated:YES];
            }
        }
            break;
        case 1003:
        {
            YYLog(@"cancel");
            _segment.selectedSegmentIndex = 0;
            [self hide];
        }
            break;
        default:
            break;
    }
}
-(void)hide{
    
       [UIView animateWithDuration:0.5 animations:^{
        self.payView.alpha = 0;
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.payView removeFromSuperview];
        [self.coverView removeFromSuperview];

    }];
   
}
- (void)makeHeaderBar{
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,ScreenWidth>375?(-10): 0, ScreenWidth,ScreenWidth>320?130:105)];
    backImageView.image  = [UIImage imageNamed:@"wave"];
    [self.view addSubview:backImageView];
    
    //添加数字显示label
    CGFloat labelWidth = 60.f;
    UILabel *leftLabel = [ToolClass labelWithFrame:CGRectMake(ScreenWidth>375?40:(ScreenWidth>320?35:23),ScreenWidth>375? 30: 20, labelWidth, 28) andTitle:@"0.0" andTitleColor:WDColorRGB(138, 87, 47) andTextAlignment:NSTextAlignmentCenter andFont:kFont16];
    _left = leftLabel;
    [backImageView addSubview:leftLabel];
    
    UILabel *midLabel = [ToolClass labelWithFrame:CGRectMake(0, ScreenWidth>375? 30: 20, labelWidth+10, 28) andTitle:@"0.0" andTitleColor:WDColorRGB(138, 87, 47) andTextAlignment:NSTextAlignmentCenter andFont:[UIFont systemFontOfSize:24]];
    _mid = midLabel;
    midLabel.centerX = backImageView.centerX;
    [backImageView addSubview:midLabel];
    
    UILabel *rightLabel = [ToolClass labelWithFrame:CGRectMake(ScreenWidth>375?315:(ScreenWidth>320?283:236), ScreenWidth>375? 30: 20, labelWidth, 28) andTitle:@"0.0" andTitleColor:WDColorRGB(138, 87, 47) andTextAlignment:NSTextAlignmentCenter andFont:kFont16];
    _right = rightLabel;
    [backImageView addSubview:rightLabel];
    
    //添加segment
    [self makeSegment];
    CGFloat scrollBarY = 155.f;
    self.scrollBarY = scrollBarY;
    _scrollBar = [[UIView alloc] initWithFrame:CGRectMake(0, scrollBarY, ScreenWidth, 40)];
    _scrollBar.backgroundColor = kWhiteColor;
    [self.view addSubview:_scrollBar];
    
    CGFloat ControlBarWidth = ScreenWidth / barItemNumber;
    CGFloat ControlBarHeight = 25;
    CGFloat ControlBarY = 5;
    CGSize barSize = CGSizeMake(ControlBarWidth, ControlBarHeight);
    
    //所有
    _allItem = [[WDMyDoubiBarView alloc] initWithTitle:@"所有" withSize:barSize];
    [_allItem addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _allItem.tag = all;
    _allItem.titleLabel.textColor = KCoffeeColor;
    [_allItem setOrigin:CGPointMake(0, ControlBarY)];
    [_scrollBar addSubview:_allItem];
    
    //收入
    _incomeItem = [[WDMyDoubiBarView alloc] initWithTitle:@"收入" withSize:barSize];
    [_incomeItem addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _incomeItem.tag = income;
    _incomeItem.titleLabel.textColor = WDColorFrom16RGB(0x484848);
    [_incomeItem setOrigin:CGPointMake(ControlBarWidth, ControlBarY)];
    [_scrollBar addSubview:_incomeItem];
    
    //提现
    _cashItem = [[WDMyDoubiBarView alloc] initWithTitle:@"提现" withSize:barSize];
    [_cashItem addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    _cashItem.tag = cash;
    _cashItem.titleLabel.textColor = WDColorFrom16RGB(0x484848);
    [_cashItem setOrigin:CGPointMake(ControlBarWidth*2, ControlBarY)];
    [_scrollBar addSubview:_cashItem];
    
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [_bottomLine setOrigin:CGPointMake(0, _scrollBar.height - 2)];
    [_scrollBar addSubview:_bottomLine];
    
    _movingLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ControlBarWidth - 80, 1.5)];
    _movingLine.center = CGPointMake(_allItem.centerX, - lineY);
    _movingLine.backgroundColor =KCoffeeColor;
    [_bottomLine addSubview:_movingLine];
    

}


-(void)makeBgScrollView
{
    CGFloat tableScrollX = 0;
    CGFloat tableScrollY = 195.f;
    CGFloat tableScrollWidth = ScreenWidth;
    CGFloat tableScrollHeight = ScreenHeight - tableScrollY - 64;
    _tableScrollHeight = tableScrollHeight;
    UIScrollView *tableScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(tableScrollX, tableScrollY, tableScrollWidth, tableScrollHeight)];
    tableScrollView.showsVerticalScrollIndicator = NO;
    tableScrollView.showsHorizontalScrollIndicator = NO;
    tableScrollView.delegate = self;
    tableScrollView.pagingEnabled = YES;
    tableScrollView.contentSize = CGSizeMake(barItemNumber * ScreenWidth, tableScrollHeight);
    _bgScrollView = tableScrollView;
    [self.view addSubview:_bgScrollView];
    
   
//    _allTableView = [[WDDoubiRecordView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, tableScrollHeight)];
//    
//    [_bgScrollView addSubview:_allTableView];
    
    _incomeTableView = [[WDDoubiRecordView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, tableScrollHeight)];
     _incomeTableView.tradeType = @"0";//收入
    _incomeTableView.delegate = self;
    [_bgScrollView addSubview:_incomeTableView];
    
    _cashTableView = [[WDDoubiRecordView alloc]initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, tableScrollHeight)];
    _cashTableView.delegate = self;
    _cashTableView.tradeType = @"2";//提现
    [_bgScrollView addSubview:_cashTableView];

}

//点击上面的选项卡
- (void)changeView:(WDMyDoubiBarView *)sender{
    
    _index = sender.tag - 1000;
    
    [self moveLine:_index];
    
    if ([_allItem isEqual:sender]) {
        
        [self changeItemTintColor:sender];
        
    }else if([_incomeItem isEqual:sender]){
        
        [self changeItemTintColor:sender];
        
    }else if([_cashItem isEqual:sender]){
        
        [self changeItemTintColor:sender];
        
    }
    sender.titleLabel.textColor = KCoffeeColor;
    [_bgScrollView setContentOffset:CGPointMake(ScreenWidth * _index, 0) animated:NO];
    
}

//进行相应的改变
- (void)changeItemTintColor:(WDMyDoubiBarView *)sender{
    if (![_allItem isEqual:sender]) {
        _allItem.titleLabel.textColor = WDColorFrom16RGB(0x484848);
    }
    if (![_incomeItem isEqual:sender]) {
        _incomeItem.titleLabel.textColor = WDColorFrom16RGB(0x484848);
    }
    if (![_cashItem isEqual:sender]) {
        _cashItem.titleLabel.textColor = WDColorFrom16RGB(0x484848);
    }
}
- (void)moveLine:(NSInteger)sender{
    
    CGFloat lineX;
    
    if (sender == 0) {
        
        lineX = _allItem.centerX;
        
    }else if(sender == 1){
        
        lineX = _incomeItem.centerX;
        
    }else if(sender == 2){
        
        lineX = _cashItem.centerX;
    }
    [UIView animateWithDuration:0.2 animations:^{
        _movingLine.center = CGPointMake(lineX, - lineY);
    }];
}


#pragma mark ScrollViewDelegate
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:_bgScrollView]) {
        
        _index = _bgScrollView.bounds.origin.x / _bgScrollView.width;
        
        [self moveLine:_index];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_bgScrollView]) {
        if (_index == 0) {
            [self changeView:_allItem];
        }else if (_index == 1){
            [self changeView:_incomeItem];
        }else if (_index == 2){
            [self changeView:_cashItem];
        }
    }
}

-(void)loadData
{
    [WDNetworkClient postRequestWithBaseUrl:kMyDoubiUrl setParameters:nil success:^(id responseObject) {
        
        YYLog(@"%@",responseObject);
        
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            
            NSDictionary *data =  responseObject[@"data"];
            _left.text = [data[@"incomeTotal"] stringValue];
            NSString *temp = [data[@"walletAmount"] stringValue];
            NSString *wallet;
            if (temp.length>=6) {
               wallet =  [temp substringWithRange:NSMakeRange(0, 6)];
            }
            if (temp.length==7) {
                 wallet =  [temp substringWithRange:NSMakeRange(0, 7)];
            }else{
                wallet = temp;
            }
            _mid.text = wallet;
            _right.text = [data[@"total_withdrawals"] stringValue];
            
        }
        
        
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:self.view];
    
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    if (self.payView) {
//    [self.payView removeFromSuperview];
//    }
//    if (self.coverView) {
//        [self.coverView removeFromSuperview];
//    }
}

@end
