
//
//  WDNormalQuestionViewController.m
//  5dou
//
//  Created by rdyx on 16/8/31.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDNormalQuestionViewController.h"
#import "WDQuestionModel.h"
#import "WDQuestionCell.h"
#import "UITableViewCell+Ext.h"
@interface WDNormalQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *questionArray;
@property (nonatomic,strong) UITableView *questionTableView;
@property (nonatomic,strong) NSMutableArray *isCloseArray;
@property (nonatomic,strong) NSMutableArray *answerHeightArray;

@end

@implementation WDNormalQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareUI{
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.questionTableView];
}

#pragma mark ZJScrollPageViewChildVcDelegate
- (void)zj_viewWillAppearForIndex:(NSInteger)index{
    
}
- (void)zj_viewDidAppearForIndex:(NSInteger)index{
    
}
- (void)zj_viewWillDisappearForIndex:(NSInteger)index{
    
}
- (void)zj_viewDidDisappearForIndex:(NSInteger)index{
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index{
    self.questionType = index + 1;
    [self prepareUI];
    [self prepareData];
}


- (void)prepareData{
    _questionArray = [NSMutableArray array];
    _answerHeightArray = [NSMutableArray array];
    WeakStament(weakSelf);
    [WDNetworkClient postRequestWithBaseUrl:kGetQuestionListUrl setParameters:nil success:^(id responseObject) {
        YYLog(@"%@",responseObject);
        NSArray *questionArray = responseObject[@"data"];
        weakSelf.isCloseArray = [NSMutableArray arrayWithCapacity:questionArray.count];
        for (NSDictionary *questionDict in questionArray) {
            WDQuestionModel *model = [WDQuestionModel new];
             [model setValuesForKeysWithDictionary:questionDict];
            if (self.questionType == [model.type intValue]) {
                [weakSelf.questionArray addObject:model];
                //默认是关闭的
                [weakSelf.isCloseArray addObject:@1];
                //计算高度
                [weakSelf.answerHeightArray addObject:[model getAnswerHeight:model.answer]];
            }else{
                continue;
            }
        }
        [weakSelf.questionTableView reloadData];
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

#pragma mark UITableViewDelegate,UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _questionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_isCloseArray[section] intValue] == 1) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDQuestionModel *questionModel = _questionArray[indexPath.section];
    WDQuestionCell *questionCell = [WDQuestionCell cellWithTableView:tableView];
    questionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    questionCell.answerLabel.text = questionModel.answer;
    return questionCell;
}


- (UITableView *)questionTableView{
    if (!_questionTableView) {
        _questionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenHeight - 49 - 10 - 44) style:UITableViewStylePlain];
        _questionTableView.delegate = self;
        _questionTableView.dataSource = self;
        _questionTableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
        _questionTableView.showsVerticalScrollIndicator = false;
    }
    return _questionTableView;
}

//组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  ceil([_answerHeightArray[indexPath.section] intValue]);
}

//创建组头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat viewHeight = 50;
    UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, viewHeight)];
    view.tag = 1000 + section;
    view.backgroundColor = kWhiteColor;
    [view addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = kFont14;
    WDQuestionModel *questionModel = _questionArray[section];
    label.text = [NSString stringWithFormat:@"%ld. %@",section + 1,questionModel.question];
    [view addSubview:label];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 1, ScreenWidth, 0.5)];
    lineView.backgroundColor = WDColorRGB(221, 221, 221);
    [view addSubview:lineView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    
    CGFloat buttonWidth = 14;
    CGFloat buttonHeight = 14;
    UIImageView *arrawImageView = [[UIImageView alloc] init];
    arrawImageView.image = [UIImage imageNamed:@"arrow"];
    arrawImageView.frame = CGRectMake(ScreenWidth - 10 - buttonWidth , (viewHeight - buttonWidth) * 0.5, buttonWidth, buttonHeight);
    [view addSubview:arrawImageView];
    //如果是打开的
    if ([_isCloseArray[section] intValue] == 1) {
        arrawImageView.image = [UIImage imageNamed:@"arrow"];
    }else{
        
        arrawImageView.image = [UIImage imageNamed:@"arrow_down"];
    }
    return view;
    
}

//进行旋转
- (void)rotateWithView:(UIView *)view withAngle:(long long)angle{
    [UIView animateWithDuration:0.25 animations:^{
        view.transform = CGAffineTransformMakeRotation(angle);
    }];
}


-(void)sectionClick:(UIControl *)view{
    
    //获取点击的组
    NSInteger i = view.tag - 1000;
    //取反
    if ([_isCloseArray[i] intValue] == 1) {
        _isCloseArray[i] = @0;
    }else{
        _isCloseArray[i] = @1;
    }
    //刷新列表
    NSIndexSet * index = [NSIndexSet indexSetWithIndex:i];
    [_questionTableView reloadSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
