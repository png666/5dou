//
//  WDMessageViewController.m
//  5dou
//
//  Created by 黄新 on 16/9/20.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//
//  消息
//

#import "WDMessageViewController.h"
#import "WDDefaultAccount.h"
#import "WDMemberMessageModel.h"
#import "WDNoneData.h"
#import "ToolClass.h"
#import "WDMessageCell.h"
#import "WDMessageDetailViewController.h"
#import "MJRefresh.h"
#import "ZFActionSheet.h"
#import "MJRefreshGifHeader+Ext.h"

@interface WDMessageViewController ()<UITableViewDataSource,UITableViewDelegate,ZFActionSheetDelegate>

@property (nonatomic, strong) WDNoneData *noDataView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *messageTableView;///<
@property (nonatomic, assign) int page;///< 请求的消息页数
@property (nonatomic, strong) NSIndexPath *index;//

@end

@implementation WDMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.messageTableView];
    [self.view addSubview:self.noDataView];
    [self.navigationItem setItemWithTitle:@"消息" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    self.dataArray = [NSMutableArray array];//初始化数组
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 36, 25) title:@"编辑" Image:nil selectedIMG:nil tartget:self action:@selector(leftBarButtonItemClick:)];
    [self refreshData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取会员消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissBadgeValues) name:DISMISS_MESSAGE_BADGE object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //关闭编辑状态
    self.messageTableView.editing = NO;
}


#pragma mark --- 获取消息类型
- (NSString *)getRedirectTypeWithTitleString:(NSString *)title{
    if ([title isEqualToString:@"系统消息"]) {
        return @"1";
    }else if ([title isEqualToString:@"任务消息"]){
        return @"2";
    }else{
        return @"3";
    }
}
#pragma mark ========编辑按钮点击事件
- (void)leftBarButtonItemClick:(UIButton *)sender{
    
    ZFActionSheet *actionSheet = [ZFActionSheet actionSheetWithTitle:nil confirms:@[@"标记全部已读"] cancel:@"取消" style:ZFActionSheetStyleDestructive];
    actionSheet.delegate = self;
    [actionSheet show];
//    [self markMessageAlreadyRead];
}
#pragma mark ========ZFActionSheetDelegate
- (void)clickAction:(ZFActionSheet *)actionSheet atIndex:(NSUInteger)index{
    [self markMessageAlreadyRead];
}

#pragma mark ==== 刷新数据
///刷新数据
- (void)refreshData{
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self requestMessageWithRedirectType:@"1" ToPage:self.page];
}
#pragma mark ==== 加载更多数据
/**
 *加载更多数据
 */
- (void)loadMoreData{
    self.page++;
    [self requestMessageWithRedirectType:@"1" ToPage:self.page];
}

#pragma mark --- 请求消息
- (void)requestMessageWithRedirectType:(NSString *)redirectType ToPage:(NSInteger)toPage{
    WeakStament(weakSelf);
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"mi":mi,
                          @"redirectType":redirectType,
                          @"pageInfo.toPage":[NSString stringWithFormat:@"%ld",(long)toPage]
                          };
    [WDNetworkClient postRequestWithBaseUrl:kMemberMessageUrl setParameters:dic success:^(id responseObject) {
        WDMemberMessageModel *model = [[WDMemberMessageModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.result.code isEqualToString:@"1000"]) {
            
            for (MemberDataModel *item in model.data) {
                [weakSelf.dataArray addObject:item];
            }
            [weakSelf.messageTableView reloadData];
        }else if ([model.result.code isEqualToString:@"1002"]){
            
        }else{
            [ToolClass showAlertWithMessage:@"请求数据失败"];
        }
        if (weakSelf.dataArray.count) {
            self.noDataView.alpha = 0;
        }else{
            self.noDataView.alpha = 1;
        }
        [weakSelf.messageTableView.mj_header endRefreshing];
        [weakSelf.messageTableView.mj_footer endRefreshing];
    } fail:^(NSError *error) {
        self.noDataView.alpha = 1;
        [weakSelf.messageTableView.mj_header endRefreshing];
        [weakSelf.messageTableView.mj_footer endRefreshing];
        YYLog(@"%@",error);
        
    } delegater:self.view];
}
#pragma mark --- 标记所有的消息为已读
- (void)markMessageAlreadyRead{
    WeakStament(weakSelf);
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"mi":mi};
    [WDNetworkClient postRequestWithBaseUrl:kMarkAsAllReadUrl setParameters:dic success:^(id responseObject) {
        NSString *msg  = responseObject[@"result"][@"msg"];
        NSString *code = responseObject[@"result"][@"code"];
        if ([code isEqualToString:@"1000"]) {
            [weakSelf refreshData];//刷新数据
            [ToolClass showAlertWithMessage:msg];
        }else{
            [ToolClass showAlertWithMessage:msg];
        }
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
    } delegater:self.view];
}
#pragma mark --- 删除消息
- (void)deleteMessageWithMessageId:(NSString *)messageId IndexPath:(NSIndexPath *)indexPath{
    WeakStament(weakSelf);
    NSString *mi = [[WDDefaultAccount getUserInfo] objectForKey:@"memberId"];
    NSDictionary *dic = @{@"mi":mi,
                          @"messageId":messageId
                          };
    [WDNetworkClient postRequestWithBaseUrl:kDeleteMessageUrl setParameters:dic success:^(id responseObject)
    {
        NSString *code = responseObject[@"result"][@"code"];
        NSString *msg = responseObject[@"result"][@"msg"];
        if ([code isEqualToString:@"1000"]) {
            //删除本地数据
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
            [ToolClass showAlertWithMessage:msg];
            [weakSelf.messageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            YYLog(@"删除成功");
        }else{
            [ToolClass showAlertWithMessage:msg];
            YYLog(@"删除失败");
        }
    } fail:^(NSError *error) {
        YYLog(@"%@",error);
        
    } delegater:nil];
}


#pragma mark --- TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"messageCell";
    WDMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WDMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MemberDataModel *dataModel = self.dataArray[indexPath.row];
    [cell configWithMemberModel:dataModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDMessageDetailViewController *messageDetailVC = [[WDMessageDetailViewController alloc] init];
    MemberDataModel *model = self.dataArray[indexPath.row];
    messageDetailVC.messageId = model.id;
    messageDetailVC.dataModel = model;
    self.index = indexPath;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}

//移除消息小红点
- (void)dismissBadgeValues{
    MemberDataModel *dataModel = self.dataArray[self.index.row];
    dataModel.msgStatus = @"1";
    [self.messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.index.row inSection:self.index.section], nil] withRowAnimation:UITableViewRowAnimationNone];
}






#pragma mark --- 滑动删除

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    YYLog(@"删除cell");
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除消息
        NSString *messageId = [self.dataArray[indexPath.row] id];
        [self deleteMessageWithMessageId:messageId IndexPath:indexPath];
    }
}


#pragma mark --- 懒加载

- (WDNoneData *)noDataView{
    if (!_noDataView) {
        _noDataView = [WDNoneData view];
        _noDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _noDataView.alpha = 0;
        WeakStament(weakSelf);
        _noDataView.noneDataBlock = ^(){
            [weakSelf refreshData];
        };
    }
    return _noDataView;
}
- (UITableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
        _messageTableView.rowHeight = 82;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
//        _messageTableView.bounces = NO;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.backgroundColor = kBackgroundColor;
//        _messageTableView.backgroundColor = [UIColor blackColor];
        WeakStament(weakSelf);
        //带GIF刷新
        _messageTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refreshData];
        }];
        [MJRefreshGifHeader initGifImage:_messageTableView.mj_header];
        
//        _messageTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
//            [weakSelf refreshData];
//        }];
        _messageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //还有信息
            if (weakSelf.dataArray.count % 15 == 0
                &&weakSelf.dataArray.count != 0) {
                [weakSelf loadMoreData];
            }else{
                [weakSelf.messageTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }];
    }
    return _messageTableView;
}


#pragma mark --- 移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
