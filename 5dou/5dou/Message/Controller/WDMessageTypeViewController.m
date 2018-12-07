//
//  WDMessageTypeViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  消息种类  1.0版本  2.0版本已废弃
//

#import "WDMessageTypeViewController.h"
#import "WDMessageTypeCell.h"
#import "WDDefaultAccount.h"
#import "WDMessageCountModel.h"
#import "ToolClass.h"
#import "WDMessageViewController.h"
#import "WDMemberMessageModel.h"

@interface WDMessageTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *messageTableView;///< 消息
@property (nonatomic, strong) NSMutableArray *systemMessageArr;
@property (nonatomic, strong) NSMutableArray *pushMessageArr;
@property (nonatomic, strong) NSMutableArray *taskMessageArr;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WDMessageTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    //没有数据的时候会崩溃
//    if (self.unReadMessageModel) {
//        [self.dataArray addObject:self.unReadMessageModel];
//    }
    
    [self createTableView];
    [self.navigationItem setItemWithTitle:@"消息" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    [self requestMessageWithRedirectType:@"1"];
}
- (void)createTableView{
    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 17, ScreenWidth, 165) style:UITableViewStylePlain];
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.bounces = NO;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.rowHeight = 55.f;
    [self.view addSubview:self.messageTableView];
}
- (void)dismissMessageBadges{
    
}
#pragma mark --- 请求消息

//获取会员消息个数
- (void)requestMessageWithRedirectType:(NSString *)redirectType{
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"mi":mi,
                          @"redirectType":redirectType,
                          @"status":@"0"
                          };
    [WDNetworkClient postRequestWithBaseUrl:kUnReadMssageUrl setParameters:dic success:^(id responseObject) {
        
        WDUnReadMessageModel *model = [[WDUnReadMessageModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1000"]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:model];
            [self.messageTableView reloadData];
        }else if ([model.result.code isEqualToString:@"1002"]){
            //未查询到消息
        }else{
            [ToolClass showAlertWithMessage:@"请求数据失败"];
        }
    } fail:^(NSError *error) {
        
        YYLog(@"%@",error);
        
    } delegater:self.view];
}


#pragma TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"messageTypeCell";
    WDMessageTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WDMessageTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray * messageArray = @[@"systemMessage",@"pushMessage",@"taskMessage"];
    NSArray *titleArray = @[@"系统消息",@"推送消息",@"任务消息"];
    cell.messageImg.image = [UIImage imageNamed:messageArray[indexPath.row]];
    cell.titleLabe.text = titleArray[indexPath.row];
    
    if (self.dataArray.count) {
        if (indexPath.row == 0) {
            [cell configWithMemberModel:self.dataArray[indexPath.row]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //系统消息
            WDMessageViewController *messageVC = [[WDMessageViewController alloc] init];
            messageVC.titleString = @"系统消息";
            [self.navigationController pushViewController:messageVC animated:YES];
            
        }
            break;
        case 1:
        {
            //推送消息
            WDMessageViewController *messageVC = [[WDMessageViewController alloc] init];
            messageVC.titleString = @"推送消息";
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 2:
        {
            //任务消息
            WDMessageViewController *messageVC = [[WDMessageViewController alloc] init];
            messageVC.titleString = @"任务消息";
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        default:
            break;
    }}






#pragma mark --- 懒加载
//- (UITableView *)messageTableView{
//    if (!_messageTableView) {
//        
//    }
//    return _messageTableView;
//}

@end
