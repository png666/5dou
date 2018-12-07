


//
//  WDInterestViewController.m
//  5dou
//
//  Created by rdyx on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDInterestViewController.h"
#import "ToolClass.h"
#import "WDTaskKeyCell.h"
#define keyCellID @"keyCellID"
@interface WDInterestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *interestArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation WDInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self prepareUI];
    
    // Do any additional setup after loading the view.
}


- (void)prepareData{
    _interestArray = @[@"逛街",@"美食",@"观影",
                       @"美妆",@"自拍",@"搭配",
                       @"直播",@"微商",@"网购",
                       @"动漫",@"健身",@"创意",
                       @"旅游",@"游戏",@"理财"];
}


- (void)setSelectedStr:(NSString *)selectedStr{
    _selectedStr = selectedStr;
    self.selectButtonList = [NSMutableArray array];
    //拼接成数组装入数组
    //    _selectButtonList = [NSMutableArray arrayWithCapacity:0];
    //清空数组每次选的都不一样
    [self.selectButtonList removeAllObjects];
    _selectButtonList =[NSMutableArray arrayWithArray:[_selectedStr componentsSeparatedByString:@","]];
}
- (void)prepareUI{
    [self.navigationItem setItemWithTitle:@"兴趣列表" textColor:kNavigationTitleColor fontSize:19 itemType:center];
    [self.view addSubview:self.collectionView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(20, 300, ScreenWidth - 40, 40);
    confirmButton.backgroundColor = kNavigationBarColor;
    [confirmButton setTitle:@"保存" forState:UIControlStateNormal];
    [confirmButton setTitleColor:WDColorFrom16RGB(0x8B572A) forState:UIControlStateNormal];
    [ToolClass setView:confirmButton withRadius:8.0f andBorderWidth:.25f andBorderColor:kNavigationBarColor];
    
    [confirmButton addTarget:self action:@selector(saveInterest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}


#pragma mark UICollectionViewDataSourse,UICollectionViewDelegate
-  (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.interestArray.count;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WDTaskKeyCell *taskKeyCell = [collectionView dequeueReusableCellWithReuseIdentifier:keyCellID forIndexPath:indexPath];
    [taskKeyCell setKeyTitle:_interestArray[indexPath.row]];
    //判断是否有
    BOOL select =[_selectButtonList containsObject:_interestArray[indexPath.row]];
    if (select) {
        [taskKeyCell select];
    }else{
        [taskKeyCell inverse];
    }
    return taskKeyCell;
}



- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 40, 250) collectionViewLayout:layout];
        [_collectionView registerClass:[WDTaskKeyCell class] forCellWithReuseIdentifier:keyCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kBackgroundColor;
        [self.view addSubview:_collectionView];
        
    }
    return _collectionView;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth - 40 - 60) / 3, 250 / 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = _interestArray[indexPath.row];
    if ([_selectButtonList containsObject:title]) {
        [_selectButtonList removeObject:title];
    }else{
        [_selectButtonList addObject:title];
    }
    [_collectionView reloadData];
}


- (void)saveInterest{
    NSMutableString *interestStr = [NSMutableString string];
    if ([[_selectButtonList firstObject] isEqualToString:@""]) {
        [_selectButtonList removeObjectAtIndex:0];
    }
    for (NSString *title in _selectButtonList) {
        [interestStr appendString:title];
        [interestStr appendString:@","];
    }
    NSString *str;
    if (interestStr.length == 0) {
        str = nil;
    }else{
        str = [interestStr substringToIndex:interestStr.length - 1];
    }
    
    if (_interestBlock) {
        if (!str) {
            str = @"";
        }
        _interestBlock(str);
        NSDictionary *para = @{@"updateType":@5,@"tagListStr":str};
        [WDNetworkClient postRequestWithBaseUrl:kUpdateMemeberInfo setParameters:para success:^(id responseObject) {
            YYLog(@"%@",responseObject);
            NSDictionary *result = responseObject[@"result"];
            if ([result[@"code"] isEqualToString:@"1000"]) {
                [ToolClass showAlertWithMessage:@"兴趣修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } fail:^(NSError *error) {
            
        } delegater:nil];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
