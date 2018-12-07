//
//  WDActivityDetailController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/8/30.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskCommentController.h"
#import "WDCommentCell.h"
#import "WDActDetailView.h"
#import "MJRefresh.h"
#import "WDCommentModel.h"
#import "InputView.h"

#import "WDNoneData.h"
#import "WDDefaultAccount.h"
#import "ToolClass.h"
#import "IQKeyboardManager.h"
#define pageSize 15
@interface WDTaskCommentController()<UITableViewDelegate,UITableViewDataSource,InputViewDelegate>
@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic,strong) NSMutableArray *commentList;
@property (nonatomic,strong) InputView *inputView;
//键盘高度
@property (nonatomic, assign) CGFloat keyboardHeight;
//蒙罩
@property (nonatomic, strong) UIView *layView;
@property (nonatomic, strong) WDNoneData *noneDataView;
@end
@implementation WDTaskCommentController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
    [self prepareCommentList:0];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}


- (void)prepareUI{
    [self.navigationItem setItemWithTitle:@"评论" textColor:[UIColor whiteColor] fontSize:19 itemType:center];
    [self.view addSubview:self.commentTableView];
    [self.view addSubview:self.noneDataView];
    [self.view addSubview:self.inputView];
   
    
    
    self.layView = [[UIView alloc]initWithFrame:self.view.frame];
    self.layView.backgroundColor = [UIColor blackColor];
    self.layView.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLayView)];
    [self.layView addGestureRecognizer:tap];
    [self.view insertSubview:self.layView belowSubview:self.inputView];
    
    _commentList = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)prepareCommentList:(NSInteger)toPage{
    WeakStament(weakSelf);
    NSDictionary *param = @{@"productId":_taskId,@"type":[NSString stringWithFormat:@"%d",2],@"pageInfo.pageSize":[NSNumber numberWithInteger:pageSize],@"pageInfo.toPage":[NSNumber numberWithInteger:toPage]};
    [WDNetworkClient postRequestWithBaseUrl:kCommentList setParameters:param success:^(id responseObject) {
        if (toPage == 0) {
            [weakSelf.commentList removeAllObjects];
        }
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        //如果有数据的情况下
        if (newArray.count != 0) {
            for (NSDictionary *commentDic in newArray) {
                WDCommentModel *model = [[WDCommentModel alloc] init];
                [model setValuesForKeysWithDictionary:commentDic];
                [weakSelf.commentList addObject:model];
            }
            [weakSelf.commentTableView.mj_footer endRefreshing];
        }else{
            [weakSelf.commentTableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (_commentList.count == 0) {
            _noneDataView.alpha = 1;
        }else{
            _noneDataView.alpha = 0;
        }
        [weakSelf.commentTableView reloadData];
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}


#pragma mark 进行页面的布局
- (UITableView *)commentTableView{
    
    if (!_commentTableView) {
        WeakStament(weakSelf);
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44) style:UITableViewStylePlain];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        //进行注册
        [_commentTableView registerNib:[UINib nibWithNibName:@"WDCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WDCommentCell"];
        _commentTableView.separatorColor = kWhiteColor;
        _commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.commentList.count % pageSize == 0) {
                NSInteger toPage = weakSelf.commentList.count / pageSize;
                [weakSelf prepareCommentList:toPage];
            }else{
                [weakSelf.commentTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _commentTableView;

}

- (WDNoneData *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [WDNoneData view];
        _noneDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        WeakStament(weakSelf);
        _noneDataView.noneDataBlock = ^(){
            [weakSelf prepareCommentList:0];
        };
    }
    return _noneDataView;
}

- (InputView *)inputView{
    if (!_inputView) {
        _inputView = [[[NSBundle mainBundle]loadNibNamed:@"InputView" owner:self options:nil]lastObject];
        _inputView.frame = CGRectMake(0, ScreenHeight - 44,ScreenWidth , 44);
        _inputView.delegate = self;

    }
    return _inputView;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"WDCommentCell"];
    WDCommentModel *commentModel = _commentList[indexPath.row];
    commentCell.commentModel = commentModel;
    commentCell.contentHeight.constant = [self commentHeight:commentModel.content];
    commentCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return commentCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self commentHeight:((WDCommentModel *)_commentList[indexPath.row]).content] + 75;
}

- (CGFloat)commentHeight:(NSString *)content{
    return [ToolClass getStrHeightWithStr:content andWidth:ScreenWidth - 16 andWithFont:[UIFont systemFontOfSize:15]];
}


#pragma mark InputViewDelegate 
- (void)textViewHeightDidChange:(CGFloat)height{
    self.inputView.height = height + 10;
    self.inputView.bottom = ScreenHeight - self.keyboardHeight - 64;
}

//键盘将要隐藏的时候
- (void)keyboardWillHide:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve{
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        self.inputView.bottom = ScreenHeight - 64;
        self.layView.alpha = 0.0;
        self.inputView.inputTextView.text = @"";
    } completion:^(BOOL finished) {
        //消失的时候
        self.layView.hidden = YES;
        //恢复成原来的高度
        [self.inputView resetInputView];
        //清空文件夹内容
       
    }];
}

- (void)keyboardWillShow:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve{
    //获取键盘的高度
    self.keyboardHeight = keyboardHeight;
    //动画弹出键盘和输入框
    self.layView.hidden = NO;
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        //输入框紧贴键盘
        self.inputView.bottom = ScreenHeight - keyboardHeight - 64;
        self.layView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
    
}
//点击屏幕，键盘消失

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [ self.inputView.inputTextView resignFirstResponder];
}
- (void)tapLayView{
    [ self.inputView.inputTextView resignFirstResponder];
    
}
//点击了发送按钮
- (void)publishButtonDidClick:(UIButton *)button{
    [self addComment];
    self.inputView.height = 44;
    [self.inputView.inputTextView resignFirstResponder];
}

- (void)addComment{
    WeakStament(weakSelf);
    if (_inputView.inputTextView.text.length == 0) {
        [ToolClass showAlertWithMessage:@"评论内容不能为空!"];
        return ;
    }
    NSDictionary *userInfo = [WDDefaultAccount getUserInfo];
    NSString *memberId = userInfo[@"memberId"];
    NSString *commentTrim = [_inputView.inputTextView.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *commentDict = @{@"bi.mi":memberId,
                                  @"type":@2,
                                  @"productId":_taskId,
                                  @"comment":commentTrim};
    [WDNetworkClient postRequestWithBaseUrl:kAddCommentUrl setParameters:commentDict success:^(id responseObject) {
        
        if ([responseObject[@"result"][@"code"] isEqualToString:@"1000"]) {
            [ToolClass showAlertWithMessage:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"msg"]]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf prepareCommentList:0];
            });
        }else{
            [ToolClass showAlertWithMessage:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"msg"]]];
        }

        
    } fail:^(NSError *error) {
        
    } delegater:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
