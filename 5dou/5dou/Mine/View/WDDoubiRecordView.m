

//
//  WDDoubiRecordView.m
//  5dou
//
//  Created by rdyx on 16/10/10.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDDoubiRecordView.h"
#import "WDNoneData.h"
#import "MJRefresh.h"
#import "WDNetworkClient.h"
#import "WDBillListCell.h"
#import "WDBillListModel.h"
#import "UITableViewCell+Ext.h"
#import "WDMessageViewController.h"
@interface WDDoubiRecordView()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL  initRefresh;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) WDNoneData *noneDataView;
@property(nonatomic,assign)NSInteger currentPage;



@end
#define pageSize 15
@implementation WDDoubiRecordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 0;
        [self makeUI];
    }
    return self;
}



- (UITableView *)recordTableView{
    WeakStament(weakSelf);
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height) style:UITableViewStyleGrouped];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.rowHeight = 60;
        _recordTableView.backgroundColor = kBackgroundColor;
        _recordTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithPage:weakSelf.currentPage];
        }];
        
        _recordTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //计算所有元素的个数
            int count = 0;
            for (NSMutableArray *array in _dataArray) {
                count += array.count;
            }
            //直到没数据（直到余为0）
            if (count % pageSize == 0) {
                YYLog(@"%d",count%pageSize);
                NSInteger toPage = count / pageSize;
                [weakSelf loadDataWithPage:toPage];
            }else{
                [weakSelf.recordTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _recordTableView;
}


- (void)makeUI{
    
    _dataArray = [NSMutableArray array];
    [self addSubview:self.recordTableView];
    _noneDataView = [WDNoneData view];
    _noneDataView.frame = CGRectMake(0, 0, ScreenWidth, self.height);
    _noneDataView.alpha = 1;
    [self addSubview:_noneDataView];
    //[self loadDataWithPage:_currentPage];
    
}


-(void)loadDataWithPage:(NSInteger)page
{
    
    NSDictionary *para;
    if (!self.tradeType) {
        
        para =@{@"pageInfo.toPage":@(page),@"pageInfo.pageSize":@pageSize};
    }else{
        
        para =@{@"tradeType":self.tradeType,@"pageInfo.toPage":@(page),@"pageInfo.pageSize":@pageSize};
        
    }
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kBillListUrl setParameters:para success:^(id responseObject) {
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            YYLog(@"responseObject == %@" ,responseObject);
            if (page == 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSDictionary *dic = responseObject[@"data"];
            
            for (NSInteger i = 0; i < dic.allKeys.count; i++) {
                
                NSArray *array = dic[dic.allKeys[i]];
                NSMutableArray *newArray = [NSMutableArray array];
                for (NSDictionary *billDict in array) {
                    WDBillListModel *model = [WDBillListModel new];
                    [model setValuesForKeysWithDictionary:billDict];
                    [newArray addObject:model];
                }
                //*************
                //判断  去重
//                BOOL isSame = NO;
//                for (NSMutableArray *array in weakSelf.dataArray) {
//                    WDBillListModel *oldModel = [array firstObject];
//                    WDBillListModel *newModel = [newArray firstObject];
//                    if ([oldModel.typeYearMonth isEqualToString:newModel.typeYearMonth]) {
//                        [array addObjectsFromArray:newArray];
//                        isSame = YES;
//                        break;
//                    }
//                }
//                if (!isSame) {
                    [weakSelf.dataArray addObject:newArray];
//                }
            }
            
            //进行bubble排序 后台返回的数据月份是从小到大排列的，要让最近的月份显示在最前面
            for (int i = 0; i < [weakSelf.dataArray count] - 1;i++){
                for(int j = i + 1 ; j < [weakSelf.dataArray count];j++){
                    WDBillListModel *firstModel = [weakSelf.dataArray[i] firstObject];
                    WDBillListModel *secondModel = [weakSelf.dataArray[j] firstObject];
                     //获取年
                    if ([firstModel.createDate compare: secondModel.createDate] == -1) {
                        [weakSelf.dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                        continue;
                    }
                }
            }
            
            if (weakSelf.dataArray.count != 0) {
                weakSelf.noneDataView.alpha = 0;
            }else{
                weakSelf.noneDataView.alpha = 1;
            }
            [weakSelf.recordTableView.mj_footer endRefreshing];
            [weakSelf.recordTableView.mj_header endRefreshing];
            [weakSelf.recordTableView reloadData];
        }
        else if([responseObject[@"result"][@"code"] isEqualToString:@"1002"]){
            [weakSelf.recordTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //设置符号位 防止重复加载
    if (!initRefresh) {
        [self loadDataWithPage:_currentPage];
        initRefresh = !initRefresh;
//        YYLog(@"%ld",initRefresh);
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = _dataArray[indexPath.section];
    
    WDBillListModel *billModel = array[indexPath.row];
    
    if ([billModel.withdrawalsStatus isEqualToString:@"3"]) {
        //审核拒绝时可点击查看原因
        if ([_delegate respondsToSelector:@selector(doubiRecordView:atIndexPath:)]) {
            [_delegate doubiRecordView:self atIndexPath:indexPath];
        }

    }
    
}
#pragma mark - tableView datasource

//分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSMutableArray *)_dataArray[section]).count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = _dataArray[indexPath.section];
    WDBillListModel *billModel = array[indexPath.row];
    WDBillListCell *cell = [WDBillListCell cellWithTableView:tableView];
    cell.billListModel = billModel;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

//返回Section组的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableArray *array = _dataArray[section];
    return ((WDBillListModel *)[array lastObject]).typeYearMonth;
}




@end
