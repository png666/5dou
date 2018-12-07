//
//  WDTaskSearchKeyController.m
//  5dou
//
//  Created by ChunXin Zhou on 16/9/5.
//  Copyright © 2016年 吾逗科技. All rights reserved.
//

#import "WDTaskSearchKeyController.h"
#import "WDTaskKeyCell.h"

#import "ToolClass.h"
#import "UIColor+Hex.h"

#import "WDFilterTaskController.h"

#define kSearchBarTag 201

@interface WDTaskSearchKeyController()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
//@property (nonatomic,strong) UITextField *searchTextField;
@property (nonatomic,strong) UICollectionView *keysCollectionView;
/**
 *  存放关键字的列表
 */
@property (nonatomic,strong) NSMutableArray *keyListArray;
@property(nonatomic,strong)UIView *searchBarView;
@property(nonatomic,strong)WDCustomSearchBar *searchBar;
@end
@implementation WDTaskSearchKeyController
static NSString *keyCellID = @"keyCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self prepareUI];
    // Do any additional setup after loading the view.
}

- (void)prepareUI{
    [self setNavigationSearchBar];
    [self addNavgationRightButtonWithFrame:CGRectMake(0, 0, 49, 49) title:@"确认" Image:nil selectedIMG:nil tartget:self action:@selector(confirmBtnPress:)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = WDColorFrom16RGB(0x666666);
    label.text = @"热门搜索";
    [self.view addSubview:label];
    [self.view addSubview:self.keysCollectionView];
}

- (void)prepareData{
    _keyListArray = [NSMutableArray array];
    NSArray *keys = @[@"游戏",@"工具",@"社交",@"生活",
                      @"商务",@"医疗",@"旅游",@"影视",
                      @"美食",@"美装",@"金融",@"问卷"
                      ];
    _keyListArray = [NSMutableArray arrayWithArray:keys];
}

-(void)setNavigationSearchBar
{
    self.searchBarView = [ToolClass getSearchBarWithPlaceholder:@"欢迎来到吾逗" hasLeftButton:YES];
    self.searchBar = [self.searchBarView viewWithTag:kSearchBarTag];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBarView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark UICollectionViewDataSourse,UICollectionViewDelegate
-  (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.keyListArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WDTaskKeyCell *taskKeyCell = [collectionView dequeueReusableCellWithReuseIdentifier:keyCellID forIndexPath:indexPath];
    [taskKeyCell inverse];
    if (self.keyListArray.count > indexPath.row) {
        [taskKeyCell setKeyTitle:_keyListArray[indexPath.row]];
    }
    return taskKeyCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth - 40) / 4, 45);
}


- (UICollectionView *)keysCollectionView{
    if (!_keysCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        _keysCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 20, ScreenWidth - 10, ScreenHeight - 49) collectionViewLayout:layout];
        [_keysCollectionView registerClass:[WDTaskKeyCell class] forCellWithReuseIdentifier:keyCellID];
        _keysCollectionView.delegate = self;
        _keysCollectionView.dataSource = self;
        _keysCollectionView.backgroundColor = kBackgroundColor;
        [self.view addSubview:_keysCollectionView];
        
    }
    return _keysCollectionView;
}


- (void)confirmBtnPress:(UIButton *)button{
    if (_searchBar.text) {
        NSString *key = [_searchBar.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([key isEqualToString:@""]) {
            [ToolClass showAlertWithMessage:@"搜索内容不能为空"];
            return ;
        }
        
        WDFilterTaskController *filterTaskController = [[WDFilterTaskController alloc] init];
        filterTaskController.key = key;
        [self.navigationController pushViewController:filterTaskController animated:YES];
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *key = [_searchBar.text stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([key isEqualToString:@""]) {
        [ToolClass showAlertWithMessage:@"搜索内容不能为空"];
        return ;
    }
    
    WDFilterTaskController *filterTaskController = [[WDFilterTaskController alloc] init];
    filterTaskController.key = key;
    [self.navigationController pushViewController:filterTaskController animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = _keyListArray[indexPath.row];
    WDFilterTaskController *filterTaskController = [[WDFilterTaskController alloc] init];
    filterTaskController.key = key;
    [self.navigationController pushViewController:filterTaskController animated:YES];
    
}


@end
