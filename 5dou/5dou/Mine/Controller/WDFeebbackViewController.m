
//
//  WDFeebbackViewController.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDFeebbackViewController.h"
#import "ToolClass.h"
#import "UIControl+recurClick.h"
//#import "YYModel.h"
#import "MJRefreshGifHeader+Ext.h"
#import "MJRefresh.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "WDFeedbackCell.h"
#import "WDFeedbackModel.h"
@interface WDFeebbackViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,strong)UILabel *placeholderLabel;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger currentPage;
@end

static NSString *cellId = @"cellId";

@implementation WDFeebbackViewController

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 193.f, ScreenWidth, ScreenHeight-193.f-64.f) style:UITableViewStylePlain];
        _table.delegate =self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = false;
        [_table registerClass:[WDFeedbackCell class] forCellReuseIdentifier:cellId];
        WeakStament(wself);
        _table.mj_header = [MJRefreshGifHeader
                                headerWithRefreshingBlock:^{
                                    [wself refreshData];
                                }];
        [MJRefreshGifHeader initGifImage:_table.mj_header];
        _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [wself loadMoreData];
        }];

    }
    return _table;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"意见反馈"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"意见反馈"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setItemWithTitle:@"意见反馈" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    _dataArray = [NSMutableArray array];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.showsVerticalScrollIndicator = false;
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+30);
    
    _currentPage = 0;
//    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self loadData];
    [self makeUI];
    
    [self.view addSubview:self.table];
    
    // Do any additional setup after loading the view.
}


-(void)refreshData
{
    _currentPage = 0;
    [self loadData];
}

-(void)loadMoreData
{
    _currentPage++;
    [self loadData];
}

//意见列表
-(void)loadData
{
    NSDictionary *para = @{@"pageInfo.pageSize":@15,@"pageInfo.toPage":@(_currentPage)};
    [WDNetworkClient postRequestWithBaseUrl:kFeedbackListUrl setParameters:para success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            NSArray *data = responseObject[@"data"];
            if (_currentPage==0) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in data) {
                WDFeedbackModel *model = [WDFeedbackModel new];
//                [model yy_modelSetWithDictionary:dict];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.table reloadData];
            [self.table.mj_footer endRefreshing];
            [self.table.mj_header endRefreshing];
        }else if ([responseObject[@"result"][@"code"] isEqualToString:@"1002"]){
            [self.table reloadData];
            [self.table.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^(NSError *error) {
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    } delegater:self.view];
    
}

-(void)makeUI
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 185.f)];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(25.f, 10.f, ScreenWidth-50.f, 130.f)];
    textView.delegate = self;
    textView.backgroundColor = [WDColorRGB(221.f, 221.f, 221.f) colorWithAlphaComponent:0.3];
    textView.layer.cornerRadius = 5.f;
    textView.layer.masksToBounds = true;
    [bgView addSubview:textView];
    self.textView = textView;
    
    UILabel *placehoderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    placehoderLabel.enabled = NO;
    placehoderLabel.text = @"吾逗君，我有话要说~";
    placehoderLabel.font =  kFont12;
    placehoderLabel.textColor = kLightGrayColor;
    self.placeholderLabel = placehoderLabel;
    [textView addSubview:placehoderLabel];
    
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-70.f,textView.height-20.f, 60.f, kButtonHeight)];
    countLabel.font = kFont12;
    countLabel.text = @"0/200";
    countLabel.textColor = kLightGrayColor;
    self.countLabel = countLabel;
//    [bgView addSubview:countLabel];
    
    
    //添加工具条
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320,  ScreenWidth>375?40:30)];
    [topView setBarStyle:0];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
    helloButton.tintColor = kBlackColor;
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyBoard)];
    doneButton.tintColor = kBlackColor;
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    
    [topView setItems:buttonsArray];
    //添加工具条的关键代码
    [self.textView setInputAccessoryView:topView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //限制重复点击3秒内不允许重复点击
    btn.uxy_acceptEventInterval = 3;
    btn.frame = CGRectMake(0, self.textView.bottom+6.f, 165, kButtonHeight);
    btn.centerX = ScreenWidth/2;
//    [ToolClass setView:btn withRadius:4.f andBorderWidth:.5f andBorderColor:kNavigationBarColor];
    [btn setBackgroundImage:WDImgName(@"feedbackbutton") forState:UIControlStateNormal];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:KCoffeeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
}

-(void)dismissKeyBoard
{
    [_textView resignFirstResponder];
}
#pragma mark - table delegate 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 100.f;
    WDFeedbackModel *model = nil;
    if (indexPath.row < self.dataArray.count) {
        model = [self.dataArray objectAtIndex:indexPath.row];
    }
    
    NSString *stateKey = nil;
    if (model.isExpand) {
        stateKey = @"expanded";
    } else {
        stateKey = @"unexpanded";
    }
    
    return [WDFeedbackCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        WDFeedbackCell *cell = (WDFeedbackCell *)sourceCell;
        // 配置数据
        [cell configCellWithModel:model];
    } cache:^NSDictionary *{
        return @{kHYBCacheUniqueKey: [NSString stringWithFormat:@"%@", model.uid],
                 kHYBCacheStateKey : stateKey,
                 // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 // 主要是对社交这种有动态评论等不同状态，高度也会不同的情况的处理
                 kHYBRecalculateForStateKey : @(NO) // 标识不用重新更新
                 };
    }];

}
#pragma mark - table datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    WDFeedbackModel *model = self.dataArray[indexPath.row];
    [cell configCellWithModel:model];
//    cell.textLabel.text = model.message;
    return cell;
}
#pragma mark - textView delegate
//限制字数
-(void)textViewDidChange:(UITextView *)textView{
    
    self.number = [textView.text length];
    if (self.number>=200) {
        
        [ToolClass showAlertWithMessage:@"输入不能多于200"];
        textView.text = [textView.text substringToIndex:199];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld/200",(long)self.number];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    //如果要求再次输入时候之前的不被清空，可以将之前写的存起来，在这里再给赋值就可以了目前这个先写成每次都清空
    self.placeholderLabel.text = @"";
    if ([textView.text isEqualToString:@"吾逗君，我有话要说~"]) {
        textView.text = @"";
    }
//    textView.text = @"";
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length==0) {
        
        textView.text = @"吾逗君，我有话要说~";
        textView.textColor = kLightGrayColor;
    }
    
}



//按回车键可退出键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



/**
 意见提交

 @param btn
 */
-(void)submitBtn:(UIButton *)btn
{
    
    if (self.textView.text.length==0||[self.textView.text isEqualToString:@"吾逗君，我有话要说~"]) {
        [ToolClass showAlertWithMessage:@"请填写您的反馈"];
        return;
    }
    NSDictionary *para = @{@"description":self.textView.text};
    [WDNetworkClient postRequestWithBaseUrl:KFeedBackUrl setParameters:para success:^(id responseObject) {
        
        NSDictionary *result = responseObject[@"result"];
        
        if ([result[@"code"]isEqualToString:@"1000"]) {
            
            [ToolClass showAlertWithMessage:result[@"msg"]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            
            [ToolClass showAlertWithMessage:result[@"msg"]];
        
        }
        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}


@end
