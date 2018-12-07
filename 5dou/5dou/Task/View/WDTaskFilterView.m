//
//  WDTaskFilterView.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskFilterView.h"
#import "WDUserInfoModel.h"
#define optionCellHeight 35
@interface WDTaskFilterView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *optionArray;
@property (nonatomic,strong) UITableView *optionTableView;
@end
@implementation WDTaskFilterView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}



- (void)prepareUI{
    _optionArray = [NSMutableArray array];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:self.optionTableView];
}

- (void)setTaskFilterType:(TaskFilterType )taskFilterType{
    _taskFilterType = taskFilterType;
    if (_taskFilterType == TaskFilterTypeSort) {
        _optionArray = @[@"智能排序",
                         @"酬劳最高",
                         @"最新发布",
                         @"优质推荐",
                         @"最快结算",
                         @"最火任务"];
    }else{
      
            _optionArray = @[@"全部分类",
                             @"应用试客",
                             @"观影体验",
                             @"市场调研",
                             @"营销推广"];
        
    }
    
    _optionTableView.frame = CGRectMake(0, 0, ScreenWidth, optionCellHeight * _optionArray.count);
    [self.optionTableView reloadData];
}

- (UITableView *)optionTableView{
    if (!_optionTableView) {
        _optionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20 * _optionArray.count)];
        _optionTableView.delegate = self;
        _optionTableView.dataSource = self;
        _optionTableView.rowHeight = optionCellHeight;
        _optionTableView.showsVerticalScrollIndicator = NO;
        _optionTableView.showsHorizontalScrollIndicator = NO;
        _optionTableView.scrollEnabled = NO;
    }
    return _optionTableView;
}

#pragma mark UITableViewDelegate,UITableViewDataSource

//选项卡比较少,所以Cell不进行复用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.textColor = WDColorFrom16RGB(0x666666);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text  = _optionArray[indexPath.row];
    //让分割线左右靠齐
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进行调用
    if (_taskFilterBlock) {
        _taskFilterBlock(indexPath.row,_taskFilterType);
    }
}


//重置分割线,实现左右置顶
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)layoutSubviews
{
    if ([self.optionTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.optionTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.optionTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.optionTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _optionArray.count;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (_taskFilterBlock) {
        _taskFilterBlock(0,TaskFilterRemove);
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
